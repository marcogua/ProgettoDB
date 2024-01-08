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
    id_portafoglio INT NOT NULL,
    CONSTRAINT FK_id_portafoglio FOREIGN KEY(id_portafoglio)
        REFERENCES portafoglio(id_portafoglio)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    CONSTRAINT validate_iban
        CHECK (iban ~ '^IT[0-9]{2}[A-Z]{1}[0-9]{21}$')
);

--TRIGGER PER SETTARE IN AUTOMATICO LA CHIAVE PRIMARIA
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

--TRIGGER PER L'AGGIORNAMENTO AUTOMATICO DEL CONTO QUANDO VIENE INSERITO UN NUOVO CONTO
CREATE OR REPLACE FUNCTION UpdatePortafoglio()
    RETURNS TRIGGER
AS $$
DECLARE
    valore conto.saldo%TYPE;
BEGIN
	SELECT SUM(saldo)
	FROM conto 
    INTO valore;
	UPDATE portafoglio 
	SET saldo = valore
	WHERE id_portafoglio = NEW.id_portafoglio;
    RETURN NULL;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE TRIGGER UpdatePortafoglio
AFTER INSERT OR UPDATE OR DELETE
ON conto
FOR EACH ROW
EXECUTE PROCEDURE UpdatePortafoglio();

--INSERIMENTI DI ESEMPIO DELLA TABELLA CONTO

INSERT INTO conto VALUES(1, 'Contanti', NULL , 0.00, 1);
INSERT INTO conto VALUES(2, 'BBVA', 'IT29P844011537774326265595', 0.00, 1);
INSERT INTO conto VALUES(3, 'Hype', 'IT36B169081657815759055107', 0.00, 1);
INSERT INTO conto VALUES(4, 'Contanti', NULL , 0.00, 2);
INSERT INTO conto VALUES(5, 'BBVA', 'IT38A212839255600364290011', 0.00, 2);
INSERT INTO conto VALUES(6, 'Hype Premium', 'IT04S835192780118008364153', 0.00, 2);
INSERT INTO conto VALUES(7, 'Intesa San Paolo', 'IT45R680346289226113181082' , 0.00, 3);
INSERT INTO conto VALUES(8, 'BPER Business', 'IT53Q751339339027770554323', 0.00, 3);
INSERT INTO conto VALUES(9, 'AMEX Platinum', 'IT52S690780806085480774399', 0.00, 3);
 