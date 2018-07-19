--associa alla tabella cluster le coordinate lat e lon

CREATE VIEW cluster.tmin_sp AS (

	SELECT 

	t.*,
	s.longitude as longitude,
	s.latitude as latitude,
	s.elevation as elevation,
	s.sitecode as sitecode,
	s.sitename as sitename,
	geom	

	FROM

	cluster.tmin t LEFT JOIN anagrafica.stazioni s ON t.siteid=s.siteid AND t.cod_rete_guido=s.cod_rete_guido

);
