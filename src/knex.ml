open BsCallback

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

module type Config_t = sig
  val client : client
end

module type QueryOps_t = sig
  type t
  val where : t -> 'a Js.t -> t
  val returning : t -> string -> t
  val first : t -> from:string -> 'a Js.t option BsCallback.t
  val select : t -> ?columns:string array -> from:string -> 'a Js.t array BsCallback.t
  val update : t -> table:string -> 'a Js.t -> int BsCallback.t
  val insert : t -> into:string -> 'a Js.t -> int array BsCallback.t
end

module type OpsConfig_t = sig
  type t
end

module QueryOps(Config:OpsConfig_t) = struct
  include Config
  external where : t -> 'a Js.t -> t = "where" [@@bs.send]
  external returning : t -> string -> t = "returning" [@@bs.send]

  external from_ : t -> string -> t = "from" [@@bs.send]

  external first : t -> 'a Js.t Js.Nullable.t Js.Promise.t = "first" [@@bs.send]
  let first t ~from =
    BsCallback.from_promise (from_ t from |. first) >> fun ret ->
      BsCallback.return (Js.toOption ret)

  (* [@@bs.splice] needs syntactic arrays, i.e. fixed at compile time.. 💩*)
  let select : t -> string array -> string -> 'a Js.Promise.t [@bs] = [%bs.raw{|function (knex, args, from) {
    return knex.select.apply(knex, args).from(from);
  }|}]
  let select t ?(columns=[||]) ~from =
    BsCallback.from_promise (select t columns from [@bs])

  external into_ : t -> string -> t = "into" [@@bs.send]

  external update : t -> 'a Js.t -> int Js.Promise.t = "update" [@@bs.send]
  let update t ~table args =
    BsCallback.from_promise (from_ t table |. update args)

  external insert : t -> 'a Js.t -> int array Js.Promise.t = "insert" [@@bs.send]
  let insert t ~into args =
    BsCallback.from_promise (into_ t into |. insert args)
end

module Config = struct
  type t = client
end
include QueryOps(Config) 

module Transaction = struct
  type transaction

  external transaction : client -> (transaction -> 'a Js.Promise.t [@bs]) -> 'a Js.Promise.t = "" [@@bs.send]

  let execute client cb =
    BsCallback.from_promise
      (transaction client (fun [@bs] t ->
        BsCallback.to_promise (cb t)))

  module QueryOpsConfig = struct
    type t = transaction
  end
  include QueryOps(QueryOpsConfig)
end
