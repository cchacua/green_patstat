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
INSERT 0 11101615
Time: 29288.220 ms (00:29.288)
*/

COPY glpatents202210.t711_green_docdb_fam TO '/home/input/gl_patents/20230919/t711_green_docdb_fam.csv' DELIMITER ',' CSV HEADER;
/*
COPY 11101615
Time: 3743.724 ms (00:03.744)
*/

CREATE INDEX ON glpatents202210.t711_green_docdb_fam(doc_db_family_id) TABLESPACE tblspc2;

---------------------------------------------------
-- Tests

SELECT * FROM glpatents202210.t711_green_docdb_fam LIMIT 10;

SELECT COUNT(ytag) AS ytag,  COUNT(wipo_green) AS wipo_green, COUNT(envtech) AS envtech
FROM glpatents202210.t711_green_docdb_fam;
/*
  ytag   | wipo_green | envtech 
---------+------------+---------
 4422378 |    8348138 | 5989278
*/
