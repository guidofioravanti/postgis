-- crea per ogni tabella di serie acmant/climatol una vista con solo le serie che hanno RMSE minore di 2°C, la soglia
-- scelta per filtrare le serie


CREATE OR  REPLACE FUNCTION serie.crea_vista_serie_basso_rmse(p varchar,m varchar,periodo varchar,soglia integer) RETURNS void AS
$$
BEGIN

	--identifico le serie con rmse minore di soglia
	EXECUTE '
		DROP VIEW IF EXISTS serie_utili.'||p||'_'||m||'_'||periodo||';

		CREATE VIEW serie_utili.'||p||'_'||m||'_'||periodo||' AS (
			SELECT * FROM serie.'||p||'_'||m||'_'||periodo||' WHERE (cod_rete_guido,siteid) IN (

				SELECT
					cod_rete_guido,siteid
				FROM
					analisi.rmse WHERE (rmse<'|| soglia||' AND metodo LIKE '||quote_literal(m)||' AND param LIKE '||quote_literal(p)||')
			)  ORDER BY cod_rete_guido, siteid, yymmdd
		);';
		

	RETURN;

END;
$$ 
language plpgsql;


--questa funzione è analoga alla precente ma serve per le funzioni raw. Per le funzioni raw prendiamo come rmse di riferimento quello calcolato
-- sulle serie acmant. La funzione è identica a quella sopra se non fosse che la tabella delle serie è quella raw e la tabella degli rmse fissata mediante parametro m
CREATE OR  REPLACE FUNCTION serie.crea_vista_serie_basso_rmse_raw(p varchar,m varchar,periodo varchar,soglia integer) RETURNS void AS
$$
BEGIN

	--identifico le serie con rmse minore di soglia
	EXECUTE '
		DROP VIEW IF EXISTS serie_utili.'||p||'_'||'raw'||'_'||periodo||';

		CREATE VIEW serie_utili.'||p||'_'||'raw'||'_'||periodo||' AS (
			SELECT * FROM serie.'||p||'_'||'raw'||'_'||periodo||' WHERE (cod_rete_guido,siteid) IN (

				SELECT
					cod_rete_guido,siteid
				FROM
					analisi.rmse WHERE (rmse<'|| soglia||' AND metodo LIKE '||quote_literal(m)||' AND param LIKE '||quote_literal(p)||')
			)  ORDER BY cod_rete_guido, siteid, yymmdd
		);';
		

	RETURN;

END;
$$ 
language plpgsql;



CREATE SCHEMA IF NOT EXISTS serie_utili;

-- vista con le serie giornaliere/mensili/annuali di acmant con rmse < di soglia
SELECT * FROM serie.crea_vista_serie_basso_rmse('tmax','acmant','giornaliere',2);
SELECT * FROM serie.crea_vista_serie_basso_rmse('tmax','acmant','mensili',2);
SELECT * FROM serie.crea_vista_serie_basso_rmse('tmax','acmant','annuali',2);

SELECT * FROM serie.crea_vista_serie_basso_rmse('tmin','acmant','giornaliere',2);
SELECT * FROM serie.crea_vista_serie_basso_rmse('tmin','acmant','mensili',2);
SELECT * FROM serie.crea_vista_serie_basso_rmse('tmin','acmant','annuali',2);

--climatol
-- vista con le serie giornaliere/mensili/annuali di climatol con rmse < di soglia
SELECT * FROM serie.crea_vista_serie_basso_rmse('tmax','climatol','giornaliere',2);
SELECT * FROM serie.crea_vista_serie_basso_rmse('tmax','climatol','mensili',2);
SELECT * FROM serie.crea_vista_serie_basso_rmse('tmax','climatol','annuali',2);

SELECT * FROM serie.crea_vista_serie_basso_rmse('tmin','climatol','giornaliere',2);
SELECT * FROM serie.crea_vista_serie_basso_rmse('tmin','climatol','mensili',2);
SELECT * FROM serie.crea_vista_serie_basso_rmse('tmin','climatol','annuali',2);



--raw 
-- vista con le serie giornaliere/mensili/annuali di raw con rmse < di soglia avendo come riferimento acmant
SELECT * FROM serie.crea_vista_serie_basso_rmse_raw('tmax','acmant','giornaliere',2);
SELECT * FROM serie.crea_vista_serie_basso_rmse_raw('tmax','acmant','mensili',2);
SELECT * FROM serie.crea_vista_serie_basso_rmse_raw('tmax','acmant','annuali',2);

SELECT * FROM serie.crea_vista_serie_basso_rmse_raw('tmin','acmant','giornaliere',2);
SELECT * FROM serie.crea_vista_serie_basso_rmse_raw('tmin','acmant','mensili',2);
SELECT * FROM serie.crea_vista_serie_basso_rmse_raw('tmin','acmant','annuali',2);
