type client;

type config = [`Pg(Pg.config)];

let init: config => client;

module type Config_t = {let client: client;};

module type Instance_t = {
  type t;
  let knex: string => t;
  let where_: (Js.t('a), t) => t;
};

module Make: (Config: Config_t) => Instance_t;
