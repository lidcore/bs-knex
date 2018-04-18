// Generated by BUCKLESCRIPT VERSION 2.2.3, PLEASE EDIT WITH CARE
'use strict';

var Knex = require("knex");
var Curry = require("bs-platform/lib/js/curry.js");
var BsCallback = require("bs-callback/src/bsCallback.js");

function init(param) {
  var config = param[1];
  config.client = "pg";
  return Knex(config);
}

function first(t, from) {
  var p = t.from(from).first();
  return p.then((function (ret) {
                return Promise.resolve((ret == null) ? /* None */0 : [ret]);
              }));
}

var select = (function (knex, args, from) {
    return knex.select.apply(knex, args).from(from);
  });

function select$1(t, $staropt$star, from) {
  var columns = $staropt$star ? $staropt$star[0] : /* array */[];
  return select(t, columns, from);
}

function update(t, table, args) {
  return t.from(table).update(args);
}

function insert(t, into, args) {
  return t.into(into).insert(args);
}

function execute(client, cb) {
  return client.transaction(Curry.__1(cb));
}

function first$1(t, from) {
  var p = t.from(from).first();
  return p.then((function (ret) {
                return Promise.resolve((ret == null) ? /* None */0 : [ret]);
              }));
}

var select$2 = (function (knex, args, from) {
    return knex.select.apply(knex, args).from(from);
  });

function select$3(t, $staropt$star, from) {
  var columns = $staropt$star ? $staropt$star[0] : /* array */[];
  return select$2(t, columns, from);
}

function update$1(t, table, args) {
  return t.from(table).update(args);
}

function insert$1(t, into, args) {
  return t.into(into).insert(args);
}

function first$2(t, from) {
  return Curry._2(BsCallback.$great$great, Curry._1(BsCallback.from_promise, t.from(from).first()), (function (ret) {
                return Curry._1(BsCallback.$$return, (ret == null) ? /* None */0 : [ret]);
              }));
}

var select$4 = (function (knex, args, from) {
    return knex.select.apply(knex, args).from(from);
  });

function select$5(t, $staropt$star, from) {
  var columns = $staropt$star ? $staropt$star[0] : /* array */[];
  return Curry._1(BsCallback.from_promise, select$4(t, columns, from));
}

function update$2(t, table, args) {
  return Curry._1(BsCallback.from_promise, t.from(table).update(args));
}

function insert$2(t, into, args) {
  return Curry._1(BsCallback.from_promise, t.into(into).insert(args));
}

function execute$1(client, cb) {
  return Curry._1(BsCallback.from_promise, client.transaction((function (t) {
                    return BsCallback.to_promise(Curry._1(cb, t));
                  })));
}

function first$3(t, from) {
  return Curry._2(BsCallback.$great$great, Curry._1(BsCallback.from_promise, t.from(from).first()), (function (ret) {
                return Curry._1(BsCallback.$$return, (ret == null) ? /* None */0 : [ret]);
              }));
}

var select$6 = (function (knex, args, from) {
    return knex.select.apply(knex, args).from(from);
  });

function select$7(t, $staropt$star, from) {
  var columns = $staropt$star ? $staropt$star[0] : /* array */[];
  return Curry._1(BsCallback.from_promise, select$6(t, columns, from));
}

function update$3(t, table, args) {
  return Curry._1(BsCallback.from_promise, t.from(table).update(args));
}

function insert$3(t, into, args) {
  return Curry._1(BsCallback.from_promise, t.into(into).insert(args));
}

function Make(funarg) {
  var first = function (t, from) {
    return Curry._2(funarg[/* compose */2], Curry._1(funarg[/* from_promise */0], t.from(from).first()), (function (ret) {
                  return Curry._1(funarg[/* return */3], (ret == null) ? /* None */0 : [ret]);
                }));
  };
  var select = (function (knex, args, from) {
    return knex.select.apply(knex, args).from(from);
  });
  var select$1 = function (t, $staropt$star, from) {
    var columns = $staropt$star ? $staropt$star[0] : /* array */[];
    return Curry._1(funarg[/* from_promise */0], select(t, columns, from));
  };
  var update = function (t, table, args) {
    return Curry._1(funarg[/* from_promise */0], t.from(table).update(args));
  };
  var insert = function (t, into, args) {
    return Curry._1(funarg[/* from_promise */0], t.into(into).insert(args));
  };
  var execute = function (client, cb) {
    return Curry._1(funarg[/* from_promise */0], client.transaction((function (t) {
                      return Curry._1(funarg[/* to_promise */1], Curry._1(cb, t));
                    })));
  };
  var first$1 = function (t, from) {
    return Curry._2(funarg[/* compose */2], Curry._1(funarg[/* from_promise */0], t.from(from).first()), (function (ret) {
                  return Curry._1(funarg[/* return */3], (ret == null) ? /* None */0 : [ret]);
                }));
  };
  var select$2 = (function (knex, args, from) {
    return knex.select.apply(knex, args).from(from);
  });
  var select$3 = function (t, $staropt$star, from) {
    var columns = $staropt$star ? $staropt$star[0] : /* array */[];
    return Curry._1(funarg[/* from_promise */0], select$2(t, columns, from));
  };
  var update$1 = function (t, table, args) {
    return Curry._1(funarg[/* from_promise */0], t.from(table).update(args));
  };
  var insert$1 = function (t, into, args) {
    return Curry._1(funarg[/* from_promise */0], t.into(into).insert(args));
  };
  return [
          (function (prim, prim$1) {
              return prim.where(prim$1);
            }),
          (function (prim, prim$1) {
              return prim.returning(prim$1);
            }),
          first,
          select$1,
          update,
          insert,
          [
            (function (prim, prim$1) {
                return prim.where(prim$1);
              }),
            (function (prim, prim$1) {
                return prim.returning(prim$1);
              }),
            first$1,
            select$3,
            update$1,
            insert$1,
            execute
          ]
        ];
}

function Promise_000(prim, prim$1) {
  return prim.where(prim$1);
}

function Promise_001(prim, prim$1) {
  return prim.returning(prim$1);
}

var Promise_006 = [
  (function (prim, prim$1) {
      return prim.where(prim$1);
    }),
  (function (prim, prim$1) {
      return prim.returning(prim$1);
    }),
  first$1,
  select$3,
  update$1,
  insert$1,
  execute
];

var Promise$1 = [
  Promise_000,
  Promise_001,
  first,
  select$1,
  update,
  insert,
  Promise_006
];

function Callback_000(prim, prim$1) {
  return prim.where(prim$1);
}

function Callback_001(prim, prim$1) {
  return prim.returning(prim$1);
}

var Callback_006 = [
  (function (prim, prim$1) {
      return prim.where(prim$1);
    }),
  (function (prim, prim$1) {
      return prim.returning(prim$1);
    }),
  first$3,
  select$7,
  update$3,
  insert$3,
  execute$1
];

var Callback = [
  Callback_000,
  Callback_001,
  first$2,
  select$5,
  update$2,
  insert$2,
  Callback_006
];

exports.init = init;
exports.Make = Make;
exports.Promise = Promise$1;
exports.Callback = Callback;
/* select Not a pure module */
