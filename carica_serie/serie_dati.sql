--carica le serie di dati
-- attenzione si deve utilizzare questa funzione come utente postgres in quanto la funzione COPY può utilizzarla solo il superuser
-- il nome del file va specificato con tutto il path assoluto!

CREATE OR  REPLACE FUNCTION serie.carica(param varchar,metodo varchar,periodo varchar,nomefile varchar) RETURNS void AS
$$
BEGIN

	DROP TABLE IF EXISTS appo;

	CREATE TABLE appo (
	
		yymmdd date NOT NULL,
		regione varchar NOT NULL,
		siteid smallint,
		temp double precision DEFAULT NULL

	);


	execute 'COPY appo FROM '||quote_literal(nomefile)||' DELIMITER '';'' HEADER CSV NULL AS ''NA'';';

	GRANT ALL PRIVILEGES ON TABLE appo TO guido;


	EXECUTE 'CREATE TABLE serie.'||param||'_'||metodo||'_'||periodo||' AS (

		SELECT 

			yymmdd,
			rete.cod_rete AS cod_rete_guido,
			siteid,
			temp
			

		FROM

			appo LEFT JOIN tbl_lookup.rete_guido_lp rete ON appo.regione=rete.nome_rete

	);'; 

	EXECUTE 'GRANT ALL PRIVILEGES ON TABLE serie.'||param||'_'||metodo||'_'||periodo||' TO guido;';

	DROP TABLE appo;

	EXECUTE 'ALTER TABLE serie.'||param||'_'||metodo||'_'||periodo||' ADD CONSTRAINT '||param||'_'||metodo||'_'||periodo||'_key PRIMARY KEY(yymmdd,cod_rete_guido,siteid);';
	EXECUTE 'ALTER TABLE serie.'||param||'_'||metodo||'_'||periodo||' ADD CONSTRAINT '||param||'_'||metodo||'_'||periodo||'_fkey FOREIGN KEY (cod_rete_guido,siteid) REFERENCES anagrafica.stazioni(cod_rete_guido,siteid) MATCH FULL ON UPDATE CASCADE ON DELETE NO ACTION;';

END;
$$ 
language plpgsql
