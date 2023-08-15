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
FROM patstat2021a.TLS225_DOCDB_FAM_CPC a
WHERE a.cpc_class_symbol ILIKE  'Y02%' OR a.cpc_class_symbol ILIKE  'Y04S%';
/*
INSERT 0 3,134,380
Time: 167479.344 ms (02:47.479)
*/

-- WIPO IPC
INSERT INTO glpatents202210.t710_green_docdb_fam(doc_db_family_id, source)
SELECT DISTINCT c.doc_db_family_id, 'w'
FROM patstat2021a.tls209_appln_ipc a
INNER JOIN glpatents202210.t701_wipo_green b
ON a.ipc_class_symbol ILIKE b.ipc_class_symbol  || '%'
INNER JOIN patstat2021a.tls201_appln c
ON a.appln_id=c.appln_id;
/*
INSERT 0 6820493    
Time: 2116203.629 ms (35:16.204)
*/


-- ENV-TECH CPC
INSERT INTO glpatents202210.t710_green_docdb_fam(doc_db_family_id, source)
SELECT DISTINCT a.doc_db_family_id, 'c'
FROM patstat2021a.TLS225_DOCDB_FAM_CPC a
INNER JOIN glpatents202210.t702_oecd_envtech b
ON a.cpc_class_symbol ILIKE b.cpc_class_symbol  || '%';
/*
INSERT 0 3,363,736
Time: 2087346.499 ms (34:47.346)
*/


-- ENV-TECH IPC
INSERT INTO glpatents202210.t710_green_docdb_fam(doc_db_family_id, source)
SELECT DISTINCT c.doc_db_family_id, 'e'
FROM patstat2021a.tls209_appln_ipc a
INNER JOIN glpatents202210.t702_oecd_envtech b
ON a.ipc_class_symbol ILIKE b.cpc_class_symbol  || '%'
INNER JOIN patstat2021a.tls201_appln c
ON a.appln_id=c.appln_id;
/*
INSERT 0 2127733
Time: 2801670.308 ms (46:41.670)
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
 c      | 3363736
 e      | 2127733
 w      | 6820493
 y      | 3134380
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
       1 | 4427056
       2 | 2273962
       3 | 1734758
       4 |  316772
*/



SELECT a.doc_db_family_id, a.cpc_class_symbol, b.cpc_class_symbol 
FROM patstat2021a.TLS225_DOCDB_FAM_CPC a
INNER JOIN glpatents202210.t702_oecd_envtech b
ON  a.cpc_class_symbol ILIKE b.cpc_class_symbol || '%'
LIMIT 100;

SELECT c.doc_db_family_id, a.ipc_class_symbol, b.ipc_class_symbol  
FROM patstat2021a.tls209_appln_ipc a
INNER JOIN glpatents202210.t701_wipo_green b
ON a.ipc_class_symbol ILIKE b.ipc_class_symbol  || '%'
INNER JOIN patstat2021a.tls201_appln c
ON a.appln_id=c.appln_id
LIMIT 100;

