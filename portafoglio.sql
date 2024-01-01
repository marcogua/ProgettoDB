--TABELLA DEI PORTAFOGLI

CREATE TABLE portafoglio(
    --ID_PORTAFOLGIO identifica univocamente un portafoglio
    id_portafoglio INT PRIMARY KEY,
    --NOME_PORTAFOGLIO nome assegnato al portafolgio
    nome_portafoglio VARCHAR(256) NOT NULL,
    --SALDO totale dei conti del portafoglio
    saldo DECIMAL NOT NULL DEFAULT 0.00
);

--TRIGGER PER SETTARE IN AUTOMATICO LA CHIAVE PRIMARIA
CREATE OR REPLACE FUNCTION PortafoglioPK()
    RETURNS TRIGGER
AS $$
DECLARE
    pk portafoglio.id_portafoglio%TYPE;
BEGIN
	SELECT MAX(id_portafoglio) + 1 INTO pk FROM portafoglio;
    IF(NEW.id_portafoglio != pk)THEN
        NEW.id_portafoglio := pk;
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE TRIGGER PortafoglioPK
BEFORE INSERT
ON portafoglio
FOR EACH ROW
EXECUTE PROCEDURE PortafoglioPK();
 