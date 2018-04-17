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
  val knex : string -> t
  val where : 'a Js.t -> t -> t
  val update : 'a Js.t -> t -> t
  val returning : string -> t -> t
  val first : t -> 'a Js.t Js.Nullable.t Callback.t
  val select : ?columns:string array -> t -> 'a Js.t array Callback.t
  val update : 'a Js.t -> t -> 'b Js.t array Callback.t
  val insert : 'a Js.t -> t -> 'b Js.t array Callback.t
end

module BuildQuery(Config:Config_t) : Query_t
