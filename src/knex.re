type instance;

type client = string => instance;

type config = [`Pg(Pg.config)];

[@bs.module] external init : Js.t('a) => client = "knex";

[@bs.set] external add_client : (Js.t('a), string) => unit = "client";

let init =
  fun
  | `Pg(config) => {
      add_client(config, "pg");
      init(config);
    };

module type Config_t = {let client: client;};

module type Instance_t = {
  type t;
  let knex: string => t;
  let where_: (Js.t('a), t) => t;
};

module Make = (Config: Config_t) => {
  type t = instance;
  let knex = Config.client;
  [@bs.send.pipe: t] external where_ : Js.t('a) => t = "where";
};
