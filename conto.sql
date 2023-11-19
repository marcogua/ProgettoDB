--TABELLA DEI CONTI

CREATE TABLE conto(
    --ID_CONTO identifica univocamente un conto
    id_conto int PRIMARY KEY,
    --NOME_CONTO nome assegnato al conto
    nome_conto varchar(255) NOT NULL,
    --IBAN iban realtivo al conto se presete
    iban varchar(26),
    --SALDO saldo relativo al conto
    saldo decimal NOT NULL DEFAULT 0.00,
    id_portafoglio int,
    CONSTRAINT FK_id_portafoglio FOREIGN KEY(id_portafoglio)
        REFERENCES portafoglio(id_portafoglio)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);

--Trigger per settare la chiave primaria automaticamente
CREATE OR REPLACE FUNCTION ContoPK()
    RETURNS TRIGGER
AS $$
DECLARE
    pk conto.id_conto%TYPE;
BEGIN
	SELECT MAX(id_conto) + 1 into pk FROM conto;
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

--Inserimenti di esempio
INSERT INTO conto VALUES(1, 'Contanti', null , 51.25, 1);
INSERT INTO conto VALUES(2, 'BBVA'; 'IT01S0000000000DSF00000002', 4523.89, 1);
INSERT INTO conto VALUES(3, 'Hype', 'IT02H0000000000DSF00000001', 1235.22, 1);