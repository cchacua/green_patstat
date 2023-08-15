---------------------------------------------------
-- Descriptives 
---------------------------------------------------

-- Evolution per year
SELECT b.EARLIEST_FILING_YEAR, a.source, COUNT(a.doc_db_family_id) AS doc_db_families
FROM glpatents202210.t710_green_docdb_fam a
INNER JOIN patstat2021a.TLS201_APPLN b
ON a.doc_db_family_id=b.doc_db_family_id
GROUP BY  b.EARLIEST_FILING_YEAR, a.source
ORDER BY  b.EARLIEST_FILING_YEAR DESC, a.source;



-- TOP applicants by Country of inventor's location
-- b.EARLIEST_FILING_YEAR, 
SELECT d.PERSON_CTRY_CODE, d.PERSON_NAME, COUNT(DISTINCT a.doc_db_family_id) AS doc_db_families
FROM glpatents202210.t710_green_docdb_fam a
INNER JOIN patstat2021a.TLS201_APPLN b
ON a.doc_db_family_id=b.doc_db_family_id
INNER JOIN patstat2021a.TLS207_PERS_APPLN c
ON b.appln_id=c.appln_id
INNER JOIN patstat2021a.TLS206_PERSON d
ON c.PERSON_ID=d.PERSON_ID
WHERE c.INVT_SEQ_NR>0
GROUP BY d.PERSON_CTRY_CODE, d.PERSON_NAME
ORDER BY COUNT(DISTINCT a.doc_db_family_id) DESC
LIMIT 100;
