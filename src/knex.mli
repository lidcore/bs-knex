type client

type config = [
  | `Pg of Pg.config
]

val init : config -> client

module type Config_t = sig
  val client : client
end

module type Query_t = sig
  type t
  val client : client
  val knex : string -> t
  val where : t -> 'a Js.t -> t
  val returning : t -> string -> t
  val first : t -> 'a Js.t option BsCallback.t
  val select : t -> ?columns:string array -> 'a Js.t array BsCallback.t
  val update : t -> 'a Js.t -> 'b Js.t array BsCallback.t
  val insert : t -> 'a Js.t -> 'b Js.t array BsCallback.t
end

module BuildQuery(Config:Config_t) : Query_t
