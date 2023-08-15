---------------------------------------------------
-- t711_green_docdb_fam Summary table of Green DocDB patent families
---------------------------------------------------
DROP TABLE IF EXISTS glpatents202210.t711_green_docdb_fam CASCADE;
CREATE TABLE glpatents202210.t711_green_docdb_fam(
  doc_db_family_id integer,
  ytag BOOL,
  wipo_green BOOL,
  envtech BOOL
  ) TABLESPACE tblspc2;

INSERT INTO glpatents202210.t711_green_docdb_fam(doc_db_family_id, ytag, wipo_green, envtech)
SELECT a.doc_db_family_id, 
	MAX((CASE WHEN a.source='y' THEN 1 END))::BOOL AS ytag,
	MAX((CASE WHEN a.source='w' THEN 1 END))::BOOL AS wipo_green,
	MAX((CASE WHEN a.source='c' OR source='e'  THEN 1 END))::BOOL AS envtech
FROM glpatents202210.t710_green_docdb_fam a
GROUP BY a.doc_db_family_id;
/*
INSERT 0 8752548
Time: 23328.896 ms (00:23.329)
*/

COPY glpatents202210.t711_green_docdb_fam TO '/home/input/gl_patents/20230815/t711_green_docdb_fam.csv' DELIMITER ',' CSV HEADER;
/*
COPY 8752548
Time: 3043.521 ms (00:03.044)
*/

---------------------------------------------------
-- Tests
SELECT COUNT(ytag),  COUNT(wipo_green), COUNT(envtech)
FROM glpatents202210.t711_green_docdb_fam;
/*
  count  |  count  |  count  
---------+---------+---------
 3134380 | 6820493 | 4526830
*/
