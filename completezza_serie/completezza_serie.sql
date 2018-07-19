--tabella in cui viene riportata la completezza delle serie
--Si tratta di serie lunghe almeno dieci anni di dati
--La completezza minima è dell'80%, completezze inferiori non sono riportate in tabella.
-- Quindi se una stazione riporta una completezza del 90% significa che è una serie lunga almeno dieci anni e che soddisfa
-- una completezza dell'80, 85 e 90% dei dati.

-- Da questi risultati sono state estratte le serie per la cluster analysis i cui risultati sono stati poi usati per l'omogeneizzazione delle serie di temperatura
-- del 208 con CLIMATOL e ACMANT.

BEGIN;

DROP TABLE IF EXISTS analisi.completezza;
DROP TABLE IF EXISTS analisi.appo;
--crea tabella di appoggio con nome della regione/rete (non è la regione in quanto le serie dell'aeronautica compaiono come aeronautica, bolzano compare come rete a se..)
CREATE TABLE analisi.appo (
	regione varchar(25) NOT NULL,
	siteid smallint NOT NULL,
	annoI smallint NOT NULL,
	annoF smallint NOT NULL,
	parametro char(4) NOT NULL,
	completezza smallint NOT NULL 
);


COMMIT;


--copia dei dati
\copy analisi.appo FROM 'completezza_serie.csv' WITH DELIMITER ';' HEADER CSV;


BEGIN;
--sostituisce al nome della rete il codice della rete assegnato (tbl_lookup.rete_guido_lp)
CREATE TABLE analisi.completezza AS (

	SELECT 
		rete.cod_rete AS cod_rete_guido,
		siteid,
		annoI,
		annoF,
		parametro,
		completezza
			
	FROM 
		analisi.appo appo LEFT JOIN tbl_lookup.rete_guido_lp rete ON  appo.regione=rete.nome_rete

);


DROP TABLE IF EXISTS analisi.appo;

AlTER TABLE analisi.completezza ADD CONSTRAINT anno_constraint CHECK(annoI >=1850 AND annoI <=2050 AND annoF >= 1850 AND annoF <=2050);
AlTER TABLE analisi.completezza ADD CONSTRAINT completezza_constraint CHECK(completezza >=80 AND completezza<=100);
AlTER TABLE analisi.completezza ADD CONSTRAINT completezza_key PRIMARY KEY(cod_rete_guido,siteid,parametro);
ALTER TABLE analisi.completezza ADD CONSTRAINT completezza_fkey FOREIGN KEY(cod_rete_guido,siteid) REFERENCES anagrafica.stazioni(cod_rete_guido,siteid) MATCH FULL ON UPDATE CASCADE ON DELETE NO ACTION;

COMMENT ON TABLE analisi.completezza IS $$Tabella con completezza percentuale delle serie lunghe almeno 10 anni tra il 1961 e il 2015. Completezza minima dell'80%$$;


COMMIT;


