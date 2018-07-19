--crea una TABELLA con gli rmse IN BASE A METODO (PARAMETRO MET: ACMANT O CLIMATOL) e parametro (par: tmax o tmin)
DROP FUNCTION IF EXISTS serie.calcola_rmse;
CREATE OR REPLACE FUNCTION serie.calcola_rmse(par char(4),met varchar) RETURNS 
TABLE (
	root_mse double precision,
	cod_rete smallint,
	id smallint,
	param char(4),
	metodo varchar
) AS $$
BEGIN

	 

	EXECUTE 'CREATE TABLE diff AS(

		select 

			homog.yymmdd,
			pow(raw.temp-homog.temp,2.0) AS differenza,
			homog.cod_rete_guido,
			homog.siteid


		FROM 

			serie.' ||par||'_'||met||'_'||'annuali homog JOIN serie.'||par||'_raw_annuali raw

		ON
			(
				homog.yymmdd=raw.yymmdd AND
				homog.cod_rete_guido=raw.cod_rete_guido AND
				homog.siteid=raw.siteid AND
				homog.temp IS NOT NULL AND
				raw.temp IS NOT NULL

			)
	);';


	EXECUTE 'CREATE TABLE rmse AS(
		 SELECT
	 		SQRT(AVG(differenza)) AS r,
			cod_rete_guido as c,
			siteid as s,'
			|| quote_literal(par) ||'::char(4) as p,'|| quote_literal(met) ||'::varchar as m' ||' FROM diff GROUP BY cod_rete_guido, siteid
		);';



	RETURN QUERY SELECT * FROM rmse;

	DROP TABLE IF EXISTS diff;
	DROP TABLE IF EXISTS rmse;


END;
$$ language plpgsql;


DROP TABLE IF EXISTS analisi.rmse;
CREATE TABLE analisi.rmse AS(

	WITH valori AS (
		SELECT * FROM serie.calcola_rmse('tmax','acmant') 
		UNION ALL
		SELECT * FROM serie.calcola_rmse('tmax','climatol')
	 	UNION ALL
		SELECT * FROM serie.calcola_rmse('tmin','acmant')
	 	UNION ALL
		SELECT * FROM serie.calcola_rmse('tmin','climatol')	
	) SELECT 

		v.cod_rete AS cod_rete_guido,
		v.id AS siteid,
		v.root_mse AS rmse,
		v.param,
		v.metodo,
		ana.sitecode,
		ana.sitename,
		ana.longitude,
		ana.latitude,
		ana.elevation,
		ana.geom
	

	FROM 
		valori v LEFT JOIN anagrafica.stazioni ana 
	ON 
		v.cod_rete=ana.cod_rete_guido AND v.id=ana.siteid

);



