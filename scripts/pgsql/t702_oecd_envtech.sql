---------------------------------------------------
-- t702_oecd_envtech OECD's ENV-TECH Classification
-- Should be match with both cpc_class_symbol and ipc_class_symbol
---------------------------------------------------
DROP TABLE IF EXISTS glpatents202210.t702_oecd_envtech CASCADE;
CREATE TABLE glpatents202210.t702_oecd_envtech(
  id SERIAL PRIMARY KEY,
  cpc_class_symbol varchar(19)
  ) TABLESPACE tblspc2;

COPY glpatents202210.t702_oecd_envtech(cpc_class_symbol) FROM '/home/input/gl_patents/20230727/ENVTECH_univoco.csv' WITH CSV HEADER; 
/*
COPY 3150
Time: 26.996 ms
*/

CREATE INDEX ON glpatents202210.t702_oecd_envtech(cpc_class_symbol);
CREATE INDEX ON glpatents202210.t702_oecd_envtech USING GIN(cpc_class_symbol gin_trgm_ops);

---------------------------------------------------
-- Tests
SELECT * FROM glpatents202210.t702_oecd_envtech LIMIT 100;

SELECT * FROM glpatents202210.t702_oecd_envtech WHERE CHAR_LENGTH(cpc_class_symbol)=11 LIMIT 100;

SELECT CHAR_LENGTH(cpc_class_symbol), COUNT(*) FROM glpatents202210.t702_oecd_envtech GROUP BY CHAR_LENGTH(cpc_class_symbol) ORDER BY CHAR_LENGTH(cpc_class_symbol)  LIMIT 100;
/*
 char_length | count 
-------------+-------
           4 |     6
          11 |  1224
          12 |  1092
          13 |   800
          14 |    28
*/

