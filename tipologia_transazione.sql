--DOMINIO TIPOLOGIA_TRANSAZIONE

CREATE DOMAIN tipologia_transazione AS 
    VARCHAR NOT NULL CHECK (VALUE = 'Entrata' OR
                            VALUE = 'Uscita' OR
                            VALUE = 'Trasferimento');