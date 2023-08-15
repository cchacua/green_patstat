---------------------------------------------------
-- t701_wipo_green WIPO's IPC GREEN INVENTORY
---------------------------------------------------
DROP TABLE IF EXISTS glpatents202210.t701_wipo_green CASCADE;
CREATE TABLE glpatents202210.t701_wipo_green(
  id SERIAL PRIMARY KEY,
  ipc_class_symbol varchar(15),
  green_dscr TEXT
  ) TABLESPACE tblspc2;

COPY glpatents202210.t701_wipo_green(ipc_class_symbol, green_dscr ) FROM '/home/input/gl_patents/20230727/IPC_green_codes.csv' WITH CSV; 
/*
COPY 1214
Time: 17.703 ms
*/

-- Harmonize ipc_class_symbol with Patstat format
UPDATE glpatents202210.t701_wipo_green
SET ipc_class_symbol=LEFT(ipc_class_symbol, 4) || LPAD(SPLIT_PART(RIGHT(ipc_class_symbol, CHAR_LENGTH(ipc_class_symbol)-4), '/', 1), 4, ' ') || '/' || SPLIT_PART(ipc_class_symbol, '/', 2)
WHERE SPLIT_PART(ipc_class_symbol, '/', 2) IS NOT NULL AND SPLIT_PART(ipc_class_symbol, '/', 2)!='';

CREATE INDEX ON glpatents202210.t701_wipo_green(ipc_class_symbol);

---------------------------------------------------
-- Tests
SELECT * FROM glpatents202210.t701_wipo_green LIMIT 100;

SELECT * FROM glpatents202210.t701_wipo_green WHERE CHAR_LENGTH(ipc_class_symbol)=11 LIMIT 100;

SELECT CHAR_LENGTH(ipc_class_symbol), COUNT(*) FROM glpatents202210.t701_wipo_green GROUP BY CHAR_LENGTH(ipc_class_symbol) ORDER BY CHAR_LENGTH(ipc_class_symbol)  LIMIT 100;
/*
 char_length | count 
-------------+-------
           3 |     2
           4 |    25
          11 |   911
          12 |   131
          13 |   116
          14 |    29
*/


SELECT ipc_class_symbol, LEFT(ipc_class_symbol, 4) || LPAD(SPLIT_PART(RIGHT(ipc_class_symbol, CHAR_LENGTH(ipc_class_symbol)-4), '/', 1), 4, ' ') || '/' || SPLIT_PART(ipc_class_symbol, '/', 2) FROM glpatents202210.t701_wipo_green
WHERE SPLIT_PART(ipc_class_symbol, '/', 2) IS NOT NULL AND SPLIT_PART(ipc_class_symbol, '/', 2)!=''  ORDER BY RANDOM() LIMIT 100;

