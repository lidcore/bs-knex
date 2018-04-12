type instance
type client = string -> instance

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

module type Instance_t = sig
  type t
  val knex : string -> t
  val where_ : 'a Js.t -> t -> t
end

module Make(Config:Config_t) = struct
  type t = instance
  let knex = Config.client
  external where_ : 'a Js.t -> t = "where" [@@bs.send.pipe: t]
end
