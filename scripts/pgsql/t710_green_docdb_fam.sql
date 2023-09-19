---------------------------------------------------
-- t710_green_docdb_fam Green DocDB patent family 
---------------------------------------------------
DROP TABLE IF EXISTS glpatents202210.t710_green_docdb_fam CASCADE;
CREATE TABLE glpatents202210.t710_green_docdb_fam(
  id SERIAL PRIMARY KEY,
  doc_db_family_id integer,
  source VARCHAR(1)
  ) TABLESPACE tblspc2;

-- ytag
INSERT INTO glpatents202210.t710_green_docdb_fam(doc_db_family_id, source)
SELECT DISTINCT a.doc_db_family_id, 'y'
FROM patstat2023a.TLS225_DOCDB_FAM_CPC a
WHERE a.cpc_class_symbol ILIKE  'Y02%' OR a.cpc_class_symbol ILIKE  'Y04S%';
/*
INSERT 0 4,422,378
Time: 35661.592 ms (00:35.662)
*/

-- WIPO IPC
INSERT INTO glpatents202210.t710_green_docdb_fam(doc_db_family_id, source)
SELECT DISTINCT c.doc_db_family_id, 'w'
FROM patstat2023a.tls209_appln_ipc a
INNER JOIN glpatents202210.t701_wipo_green b
ON a.ipc_class_symbol ILIKE b.ipc_class_symbol  || '%'
INNER JOIN patstat2023a.tls201_appln c
ON a.appln_id=c.appln_id;
/*
INSERT 0 8,348,138
Time: 2513218.251 ms (41:53.218)
*/

-- ENV-TECH CPC
INSERT INTO glpatents202210.t710_green_docdb_fam(doc_db_family_id, source)
SELECT DISTINCT a.doc_db_family_id, 'c'
FROM patstat2023a.TLS225_DOCDB_FAM_CPC a
INNER JOIN glpatents202210.t702_oecd_envtech b
ON a.cpc_class_symbol ILIKE b.cpc_class_symbol  || '%';
/*
INSERT 0 4,518,024
Time: 2857414.290 ms (47:37.414)
*/

-- ENV-TECH IPC
INSERT INTO glpatents202210.t710_green_docdb_fam(doc_db_family_id, source)
SELECT DISTINCT c.doc_db_family_id, 'e'
FROM patstat2023a.tls209_appln_ipc a
INNER JOIN glpatents202210.t702_oecd_envtech b
ON a.ipc_class_symbol ILIKE b.cpc_class_symbol  || '%'
INNER JOIN patstat2023a.tls201_appln c
ON a.appln_id=c.appln_id;
/*
INSERT 0 2,664,019
Time: 3323579.789 ms (55:23.580)
*/

CREATE INDEX ON glpatents202210.t710_green_docdb_fam(doc_db_family_id);

---------------------------------------------------
-- Tests
SELECT * FROM glpatents202210.t710_green_docdb_fam LIMIT 100;

SELECT source, COUNT(*) 
FROM glpatents202210.t710_green_docdb_fam 
GROUP BY source 
ORDER BY source  
LIMIT 100;
/*
 source |  count  
--------+---------
 c      | 4518024
 e      | 2664019
 w      | 8348138
 y      | 4422378
(4 rows)
*/

WITH t1 AS (
SELECT doc_db_family_id, COUNT(DISTINCT source) AS sources
FROM glpatents202210.t710_green_docdb_fam
GROUP BY doc_db_family_id
)
SELECT sources, COUNT(doc_db_family_id)
FROM t1
GROUP BY sources
ORDER BY COUNT(doc_db_family_id) DESC
LIMIT 100;
/*
 sources |  count  
---------+---------
       1 | 5301352
       2 | 3172576
       3 | 2204693
       4 |  422994
(4 rows)
*/

SELECT a.doc_db_family_id, a.cpc_class_symbol, b.cpc_class_symbol 
FROM patstat2023a.TLS225_DOCDB_FAM_CPC a
INNER JOIN glpatents202210.t702_oecd_envtech b
ON  a.cpc_class_symbol ILIKE b.cpc_class_symbol || '%'
LIMIT 100;

SELECT c.doc_db_family_id, a.ipc_class_symbol, b.ipc_class_symbol  
FROM patstat2023a.tls209_appln_ipc a
INNER JOIN glpatents202210.t701_wipo_green b
ON a.ipc_class_symbol ILIKE b.ipc_class_symbol  || '%'
INNER JOIN patstat2023a.tls201_appln c
ON a.appln_id=c.appln_id
LIMIT 100;

