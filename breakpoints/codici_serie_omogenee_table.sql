-- si tratta delle serie omogenizzate che a livello annuale sono continue e complete e che funzionano nel 2015



COMMENT ON TABLE analisi.codici_serie_omogenee_tmax IS $$
Codici serie tmax omogeneizzate 1961-2015 complete e continue a livello annuale.
La tabella elenca tutte le serie indipendentemente che vengano utilizzate o meno per il calcolo delle anomalie.
$$;

COMMENT ON TABLE analisi.codici_serie_omogenee_tmin IS $$
Codici serie tmin omogeneizzate 1961-2015 complete e continue a livello annuale e che funzionano nel 2015. 
La tabella elenca tutte le serie indipendentemente che vengano utilizzate o meno per il calcolo delle anomalie.
$$;


ALTER TABLE analisi.codici_serie_omogenee_tmax ADD CONSTRAINT codici_tmax_fkey FOREIGN KEY (siteid,cod_rete_guido) REFERENCES anagrafica.stazioni(siteid,cod_rete_guido)
MATCH FULL ON UPDATE CASCADE ON DELETE NO ACTION;

ALTER TABLE analisi.codici_serie_omogenee_tmin ADD CONSTRAINT codici_tmax_fkey FOREIGN KEY (siteid,cod_rete_guido) REFERENCES anagrafica.stazioni(siteid,cod_rete_guido)
MATCH FULL ON UPDATE CASCADE ON DELETE NO ACTION;

