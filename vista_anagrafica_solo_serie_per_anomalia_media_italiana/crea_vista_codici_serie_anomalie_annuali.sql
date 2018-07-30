-- crea una vista dell'anagrafica delle stazioni con i codici delle sole serie utilizzate per il calcolo dell'anomalia media italiana di tmax/tmin.
-- Le serie nello schema "anomalie." sono quelle calcolate con acmant ma per l'individuazione dei codici delle serie lunghe continue e con dati suff. per
-- il calcolo dell'anomalia 1961-1990 questo non importa (sarebbero andate bene anche le serie di climatol).
DROP VIEW anagrafica.stazioni_anomalie_tmax;

CREATE VIEW anagrafica.stazioni_anomalie_tmax AS (


	WITH temp AS (

		SELECT * FROM anagrafica.stazioni staz WHERE (staz.siteid,staz.cod_rete_guido) IN (

			SELECT
			
				DISTINCT siteid,cod_rete_guido 

			FROM

				anomalie.tmax_acmant_annuali

		) 

	) SELECT 

	rete.nome_rete||'_'||temp.siteid AS codice,
	temp.*

	FROM temp LEFT JOIN tbl_lookup.rete_guido_lp rete ON temp.cod_rete_guido=rete.cod_rete

);

--stessa cosa per le stazioni di tmin

CREATE VIEW anagrafica.stazioni_anomalie_tmin AS (


	WITH temp AS (

		SELECT * FROM anagrafica.stazioni staz WHERE (staz.siteid,staz.cod_rete_guido) IN (

			SELECT
			
				DISTINCT siteid,cod_rete_guido 

			FROM

				anomalie.tmin_acmant_annuali

		) 

	) SELECT 

	rete.nome_rete||'_'||temp.siteid AS codice,
	temp.*

	FROM temp LEFT JOIN tbl_lookup.rete_guido_lp rete ON temp.cod_rete_guido=rete.cod_rete

);
