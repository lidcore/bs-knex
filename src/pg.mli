type config = <
  connection: string;
  pool: <
    min: int;
    max: int
  > Js.t [@bs.get nullable ];
  migrations: <
    directory: string;
    tableName: string
  > Js.t [@bs.get nullable ];
    seeds: <
    directory: string
  > Js.t [@bs.get nullable ]
> Js.t
