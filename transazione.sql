--DOMINIO CATEGORIA_TRANSAZIONE

CREATE DOMAIN categoria_transazione AS 
    VARCHAR NOT NULL CHECK (VALUE = 'Intrattenimento' OR
                            VALUE = 'Tasse e bolette' OR
                            VALUE = 'Lavoro' OR
                            VALUE = 'Investimento' OR
                            VALUE = 'Salute' OR
                            VALUE = 'Fitness' OR
                            VALUE = 'Regali' OR
                            VALUE = 'Cibo e bevande' OR
                            VALUE = 'Alimentari' OR
                            VALUE = 'Trasporti' OR
                            VALUE = 'Shopping' OR
                            VALUE = 'Viaggi' OR
                            VALUE = 'Istruzione' OR
                            VALUE = 'Casa');

--DOMINIO TIPOLOGIA_TRANSAZIONE

CREATE DOMAIN tipologia_transazione AS 
    VARCHAR NOT NULL CHECK (VALUE = 'Entrata' OR
                            VALUE = 'Uscita' OR
                            VALUE = 'Trasferimento');

--TABELLA DELLE TRANSAZIONI

CREATE TABLE transazione(
    --ID_TRANSAZIONE identifica univocamente una transazione
    id_transazione VARCHAR(22) PRIMARY KEY,
    --TIPOLOGIA_TRANSAZIONE identifica la tipologia di transazione(entrata/uscita/trasferimento)
    tipologia_transazione tipologia_transazione NOT NULL,
    --DESCRIZIONE_TRANSAZIONE descrive la transazione
    descrizione_transazione VARCHAR(255),
    --DATA_TRANSAZIONE data della transazione
    data_transazione DATE NOT NULL,
    --CATEGORIA_TRASAZIONE identifica la vategoria della transazione(svago/tasse/affitto)
    categoria_transazione categoria_transazione,
    --VALORE identifica l'importo della transazione
    importo DECIMAL NOT NULL,
    id_conto INT NOT NULL,
    CONSTRAINT FK_id_conto FOREIGN KEY(id_conto)
        REFERENCES conto(id_conto)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);

--TRIGGER PER SETTARE IN AUTOMATICO LA CHIAVE PRIMARIA
CREATE OR REPLACE FUNCTION TransazionePK()
    RETURNS TRIGGER
AS $$
DECLARE
    pk Transazione.id_transazione%TYPE;
BEGIN
    SELECT REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(CAST(CURRENT_TIMESTAMP AS VARCHAR), '-', ''), ' ', ''), ':', ''), '.', ''), '+', '') INTO pk;
    NEW.id_transazione := pk;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE TRIGGER TransazionePK
BEFORE INSERT
ON transazione
FOR EACH ROW
EXECUTE PROCEDURE TransazionePK();

--TRIGGER PER L'AGGIORNAMENTO AUTOMATICO DEL CONTO QUANDO VIENE INSERITA UNA TRANSAZIONE
CREATE OR REPLACE FUNCTION UpdateConto()
    RETURNS TRIGGER
AS $$
DECLARE
    valore Transazione.importo%TYPE;
BEGIN
	SELECT SUM(importo) - (
		SELECT SUM(importo) 
		FROM transazione 
		WHERE tipologia_transazione = 'Uscita') 
	FROM transazione 
    INTO valore
	WHERE tipologia_transazione = 'Entrata';
	UPDATE conto 
	SET saldo= valore
	WHERE id_conto = NEW.id_conto;
    return NULL;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE TRIGGER UpdateConto
AFTER INSERT OR UPDATE OR DELETE
ON transazione
FOR EACH ROW
EXECUTE PROCEDURE UpdateConto();

--INSERIMENTI DI ESEMPIO DELLA TABLLA TRANSAZIONE

INSERT INTO transazione VALUES (NULL, 'Entrata', 'Stipendio gennaio 2024', '2024-01-01', 'Lavoro', 1000.00, 2);