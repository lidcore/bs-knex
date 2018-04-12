type client

type config = [
  | `Pg of Pg.config
]

val init : config -> client

module type Config_t = sig
  val client : client
end

module type Instance_t = sig
  type t
  val knex : string -> t
  val where_ : 'a Js.t -> t -> t
end

module Make(Config:Config_t) : Instance_t
