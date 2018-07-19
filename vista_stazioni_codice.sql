--crea una vista dell'anagrafica stazioni in cui compare il campo codice come risultato di "nomerete"_"siteid"
DROP VIEW IF EXISTS anagrafica.stazioni_codice;
CREATE VIEW anagrafica.stazioni_codice AS (

	SELECT 
	
		nome_rete ||'_'|| siteid AS codice,
		sitecode,
		sitename,
		longitude AS lon,
		latitude AS lat,
		elevation AS quota,
		reg.regione AS regione,
		rete.nome_rete AS rete,	
		reg.area AS area,
		geom
		
	FROM 
		anagrafica.stazioni ana 

	LEFT JOIN tbl_lookup.rete_guido_lp rete ON ana.cod_rete_guido=rete.cod_rete
	LEFT JOIN tbl_lookup.regione_lp reg ON ana.cod_reg=reg.cod_reg	



);

COMMENT ON VIEW anagrafica.stazioni_codice IS $$Vista dell'anagrafica che include il campo codice nel formato nomerete_siteid$$;
