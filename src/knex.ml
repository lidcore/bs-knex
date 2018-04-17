type instance
type client = string -> instance [@bs]

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

module type Query_t = sig
  type t
  val knex : string -> t
  val where : 'a Js.t -> t -> t
  val returning : string -> t -> t
  val first : t -> 'a Js.t Js.Nullable.t Callback.t
  val select : ?columns:string array -> t -> 'a Js.t array Callback.t
  val update : 'a Js.t -> t -> 'b Js.t array Callback.t
  val insert : 'a Js.t -> t -> 'b Js.t array Callback.t
end

module BuildQuery(Config:Config_t) = struct
  type t = instance
  let knex table =
    Config.client table [@bs]

  external where : t -> 'a Js.t -> t = "where" [@@bs.send]
  let where args t = where t args

  external returning : t -> string -> t = "returning" [@@bs.send]
  let returning args t = returning t args

  external first : t -> 'a Js.t Js.Nullable.t Js.Promise.t = "first" [@@bs.send]
  let first t =
    Callback.from_promise (first t)

  (* [@@bs.splice] needs syntactic arrays, i.e. fixed at compile time.. 💩*)
  let select : t -> string array -> 'a Js.Promise.t [@bs] = [%bs.raw{|function (knex, args) {
    return knex.select.apply(knex, args);
  }|}]
  let select ?(columns=[||]) t =
    Callback.from_promise (select t columns [@bs])

  external update : t -> 'a Js.t -> 'b Js.t array Callback.t = "update" [@@bs.send]
  let update args t = update t args

  external insert : t -> 'a Js.t -> 'b Js.t array Callback.t = "insert" [@@bs.send]
  let insert args t = insert t args
end
