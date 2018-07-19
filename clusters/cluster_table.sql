--tabella in cui compare siteid,il codice rete e il cluster della stazione
--fissare tmin o tmin nel codice

BEGIN;

CREATE SCHEMA IF NOT EXISTS cluster;
--crea tabella di appoggio 
CREATE TEMPORARY TABLE appo (
	regione varchar(25) NOT NULL,
	siteid smallint NOT NULL,
	cluster CHAR(1) NOT NULL,
	subcluster CHAR(2) NOT NULL
);

COMMIT;


--copia dei dati
\copy appo FROM 'cluster_tmin.csv' WITH DELIMITER ';' HEADER CSV;


BEGIN;
--sostituisce al nome della rete il codice della rete assegnato (tbl_lookup.rete_guido_lp)
CREATE TABLE cluster.tmin AS (

	SELECT 
		rete.cod_rete AS cod_rete_guido,
		siteid,
		cluster,
		subcluster
			
	FROM 
		appo LEFT JOIN tbl_lookup.rete_guido_lp rete ON  appo.regione=rete.nome_rete

);


AlTER TABLE cluster.tmin ADD CONSTRAINT cluster_tmin_key PRIMARY KEY(cod_rete_guido,siteid);
ALTER TABLE cluster.tmin ADD CONSTRAINT cluster_tmin_fkey FOREIGN KEY(cod_rete_guido,siteid) REFERENCES anagrafica.stazioni(cod_rete_guido,siteid) MATCH FULL ON UPDATE CASCADE ON DELETE NO ACTION;

COMMENT ON TABLE cluster.tmin IS $$Tabella con suddivisione in cluster e sottocluster per le stazioni lunghe e complete, parametro tmin$$;


COMMIT;


