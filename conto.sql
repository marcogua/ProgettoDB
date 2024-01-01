--TABELLA DEI CONTI

CREATE TABLE conto(
    --ID_CONTO identifica univocamente un conto
    id_conto INT PRIMARY KEY,
    --NOME_CONTO nome assegnato al conto
    nome_conto VARCHAR(256) NOT NULL,
    --IBAN iban realtivo al conto se presete
    iban VARCHAR(26),
    --SALDO saldo relativo al conto
    saldo DECIMAL NOT NULL DEFAULT 0.00,
    id_portafoglio INT,
    CONSTRAINT FK_id_portafoglio FOREIGN KEY(id_portafoglio)
        REFERENCES portafoglio(id_portafoglio)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    CONSTRAINT validate_iban
        CHECK (iban ~ '^IT[0-9]{2}[A-Z]{1}[0-9]{21}$')
);

--Trigger per settare la chiave primaria automaticamente
CREATE OR REPLACE FUNCTION ContoPK()
    RETURNS TRIGGER
AS $$
DECLARE
    pk conto.id_conto%TYPE;
BEGIN
	SELECT MAX(id_conto) + 1 INTO pk FROM conto;
    IF(NEW.id_conto != pk)THEN
        NEW.id_conto := pk;
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE TRIGGER ContoPK
BEFORE INSERT
ON conto
FOR EACH ROW
EXECUTE PROCEDURE ContoPK();
