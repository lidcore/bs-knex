type client

type config = [
  | `Pg of Pg.config
]

external init : 'a Js.t -> client = "knex" [@@bs.module]

external add_client : 'a Js.t -> string -> unit = "client" [@@bs.set]

let init = function
  | `Pg config ->
      add_client config "pg";
      init config

module type QueryOps_t = sig
  type t
  type 'a async
  val raw : t -> string -> unit async
  val where : t -> 'a Js.t -> t
  val returning : t -> string -> t
  val first : t -> from:string -> 'a Js.t option async
  val select : t -> ?columns:string array -> from:string -> 'a Js.t array async
  val update : t -> table:string -> 'a Js.t -> int async
  val insert : t -> into:string -> 'a Js.t -> int array async
end

module type Transaction_t = sig
  include QueryOps_t
  val execute : client -> (t -> 'a async) -> 'a async
end

module type Query_t = sig
  include QueryOps_t with type t := client

  module Transaction : Transaction_t with type 'a async := 'a async
end

module type AsyncMonad_t = sig
  type 'a t
  val from_promise : 'a Js.Promise.t -> 'a t
  val to_promise : 'a t -> 'a Js.Promise.t
  val compose : 'a t -> ('a -> 'b t) -> 'b t
  val return : 'a -> 'a t
end

module type QueryOpsConfig_t = sig
  type t
  module Async : AsyncMonad_t
end

module QueryOps(Config:QueryOpsConfig_t) = struct
  type t = Config.t
  type 'a async = 'a Config.Async.t

  external raw : t -> string -> unit Js.Promise.t = "" [@@bs.send]
  let raw t sql =
      Config.Async.from_promise (raw t sql)

  external where : t -> 'a Js.t -> t = "" [@@bs.send]
  external returning : t -> string -> t = "" [@@bs.send]

  external from_ : t -> string -> t = "from" [@@bs.send]

  external first : t -> 'a Js.t Js.Nullable.t Js.Promise.t = "" [@@bs.send]
  let first t ~from =
    Config.Async.compose (Config.Async.from_promise (from_ t from |. first))
                         (fun ret -> Config.Async.return (Js.toOption ret))

  (* [@@bs.splice] needs syntactic arrays, i.e. fixed at compile time.. 💩*)
  let select : t -> string array -> string -> 'a Js.Promise.t [@bs] = [%bs.raw{|function (knex, args, from) {
    return knex.select.apply(knex, args).from(from);
  }|}]
  let select t ?(columns=[||]) ~from =
    Config.Async.from_promise (select t columns from [@bs])

  external into_ : t -> string -> t = "into" [@@bs.send]

  external update : t -> 'a Js.t -> int Js.Promise.t = "" [@@bs.send]
  let update t ~table args =
    Config.Async.from_promise (from_ t table |. update args)

  external insert : t -> 'a Js.t -> int array Js.Promise.t = "" [@@bs.send]
  let insert t ~into args =
    Config.Async.from_promise (into_ t into |. insert args)
end

module Make(Async:AsyncMonad_t) = struct
  include QueryOps(struct
    type t = client
    module Async = Async
  end)

  module Transaction = struct
    type transaction

    external transaction : client -> (transaction -> 'a Js.Promise.t [@bs]) -> 'a Js.Promise.t = "" [@@bs.send]

    let execute client cb =
      Async.from_promise (transaction client (fun [@bs] t ->
        Async.to_promise (cb t)))

    include QueryOps(struct
      type t = transaction
      module Async = Async
    end)
  end
end

module Promise = Make(struct
  type 'a t = 'a Js.Promise.t
  let from_promise p = p
  let to_promise p = p
  let compose p fn =
    Js.Promise.then_ fn p
  let return = Js.Promise.resolve
end)

module Callback = Make(struct
  include BsCallback
 
  (* Use utility provided by the API. Might enhance JS
   * compatibility by carriying some of the API methods
   * on the object, i.e. for composing with update statements. *)
  external asCallback : 'a Js.Promise.t -> 'a BsCallback.callback -> unit = "asCallback" [@@bs.send]
  let from_promise t = fun (cb) ->
    asCallback t cb
 
  let compose a b = a >> b
end)
