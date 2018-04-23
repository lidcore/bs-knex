type client

type config = [
  | `Pg of Pg.config
]

val init : config -> client

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

  module Migrate : sig
    val latest : client -> unit async
  end

  module Seed : sig
    val run : client -> unit async
  end
end

module type AsyncMonad_t = sig
  type 'a t
  val from_promise : 'a Js.Promise.t -> 'a t
  val to_promise : 'a t -> 'a Js.Promise.t
  val compose : 'a t -> ('a -> 'b t) -> 'b t
  val return : 'a -> 'a t
end

module Make(Async:AsyncMonad_t) : Query_t with type 'a async := 'a Async.t

module Promise : Query_t with type 'a async := 'a Js.Promise.t

module Callback : Query_t with type 'a async := 'a BsCallback.t
