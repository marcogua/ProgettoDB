--DOMINIO CATEGORIA_TRANSAZIONE

CREATE DOMAIN categoria_transazione AS 
    VARCHAR NOT NULL CHECK (VALUE ~ 'Intrattenimento' OR
                            VALUE ~ 'Tasse' OR
                            VALUE ~ 'Stipendio');
 