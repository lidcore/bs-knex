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
  val client : client
  val knex : string -> t
  val where : t -> 'a Js.t -> t
  val returning : t -> string -> t
  val first : t -> 'a Js.t Js.Nullable.t BsCallback.Callback.t
  val select : t -> ?columns:string array -> 'a Js.t array BsCallback.Callback.t
  val update : t -> 'a Js.t -> 'b Js.t array BsCallback.Callback.t
  val insert : t -> 'a Js.t -> 'b Js.t array BsCallback.Callback.t
end

module BuildQuery(Config:Config_t) = struct
  type t = instance
  let client = Config.client
  let knex table =
    Config.client table [@bs]

  external where : t -> 'a Js.t -> t = "where" [@@bs.send]
  external returning : t -> string -> t = "returning" [@@bs.send]
  external first : t -> 'a Js.t Js.Nullable.t Js.Promise.t = "first" [@@bs.send]
  let first t =
    BsCallback.Callback.from_promise (first t)

  (* [@@bs.splice] needs syntactic arrays, i.e. fixed at compile time.. 💩*)
  let select : t -> string array -> 'a Js.Promise.t [@bs] = [%bs.raw{|function (knex, args) {
    return knex.select.apply(knex, args);
  }|}]
  let select t ?(columns=[||]) =
    BsCallback.Callback.from_promise (select t columns [@bs])

  external update : t -> 'a Js.t -> 'b Js.t array BsCallback.Callback.t = "update" [@@bs.send]
  external insert : t -> 'a Js.t -> 'b Js.t array BsCallback.Callback.t = "insert" [@@bs.send]
end
