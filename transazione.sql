--TABELLA DELLE TRANSAZIONI

CREATE TABLE transazione(
    --ID_TRANSAZIONE identifica univocamente una transazione
    id_transazione int PRIMARY KEY,
    --TIPOLOGIA_TRANSAZIONE identifica la tipologia di transazione(entrata/uscita/trasferimento)
    tipologia_transazione tipologia_transazione,
    --CATEGORIA_TRASAZIONE identifica la vategoria della transazione(svago/tasse/affitto)
    categoria_transazione categoria_transazione,
    --VALORE identifica l'importo della transazione
    valore decimal NOT NULL,
    id_conto int,
    CONSTRAINT FK_id_conto FOREIGN KEY(id_conto)
        REFERENCES conto(id_conto)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);

--Trigger per settare la chiave primaria automaticamente
CREATE OR REPLACE FUNCTION TransazionePK()
    RETURNS TRIGGER
AS $$
DECLARE
    pk Transazione.id_transazione%TYPE;
BEGIN
	SELECT MAX(id_transazione) + 1 into pk FROM transazione;
    IF(NEW.id_transazione != pk)THEN
        NEW.id_transazione := pk;
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE TRIGGER TransazionePK
BEFORE INSERT
ON transazione
FOR EACH ROW
EXECUTE PROCEDURE TransazionePK();