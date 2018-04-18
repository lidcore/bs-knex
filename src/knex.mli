type client

type config = [
  | `Pg of Pg.config
]

val init : config -> client

module type QueryOps_t = sig
  type t
  val where : t -> 'a Js.t -> t
  val returning : t -> string -> t
  val first : t -> 'a Js.t option BsCallback.t
  val select : t -> ?columns:string array -> from:string -> 'a Js.t array BsCallback.t
  val update : t -> into:string -> 'a Js.t -> int BsCallback.t
  val insert : t -> into:string -> 'a Js.t -> int array BsCallback.t
end

include QueryOps_t with type t := client

module Transaction : sig
  include QueryOps_t
  val execute : client -> (t -> 'a BsCallback.t) -> 'a BsCallback.t
end
