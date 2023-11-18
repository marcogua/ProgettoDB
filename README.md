# ProgettoDB
Progetto di base di dati 23/24

# Autori
|Matricola|Nome|Cognome|
|---------|----|-------|
|N86002851|Marco|Guadagno|
|N86002863|Vittorio|Somma|

# Traccia
SavingMoneyUnina è un sistema che permette di tenere sotto controllo le finanze personali o familiari.
Permette di collegare più carte di credito o debito, proprie o di un altro membro della famiglia gestendo
le transazioni in entrata ed in uscita. Il sistema permette di suddividere le transazioni in gruppi
(portafogli) appartenenti a diverse categorie (es. svago, spese mediche, stipendio, bollette ecc.). È
possibile sincronizzare automaticamente le transazioni effettuate da una carta assegnandole ad uno
specifico gruppo, oppure registrare una transazione manualmente. Si utilizzino le proprie conoscenze
del dominio per definire dettagli non specificati nella traccia.

# Documentazione

## Domini

### Tipologia transazione
```SQL
--DOMINIO TIPOLOGIA_TRANSAZIONE

CREATE DOMAIN tipologia_transazione AS 
    VARCHAR NOT NULL CHECK (VALUE ~ 'Entrata' OR
                            VALUE ~ 'Uscita' OR
                            VALUE ~ 'Trasferimento');
```

### Categoria transazione
```SQL
--DOMINIO CATEGORIA_TRANSAZIONE

CREATE DOMAIN categoria_transazione AS 
    VARCHAR NOT NULL CHECK (VALUE ~ 'Intrattenimento' OR
                            VALUE ~ 'Tasse' OR
                            VALUE ~ 'Stipendio');
```

### Tipo Relazione
```SQL
-- DOMINIO Tipo relazione

CREATE DOMAIN TipoRelazione AS 
    VARCHAR(1000) NOT NULL CHECK(
                                VALUE = 'Fratello-Sorella' OR
                                VALUE = 'Coniuge' OR
                                VALUE = 'Figlio-Figlia' OR
                                VALUE = 'Parente' OR
                                VALUE = 'Amico');
```


## Tabelle

### Portafoglio
```SQL
--TABELLA DEI PORTAFOGLI

CREATE TABLE portafoglio(
    --ID_PORTAFOLGIO identifica univocamente un portafoglio
    id_portafoglio int PRIMARY KEY,
    --NOME_PORTAFOGLIO nome assegnato al portafolgio
    nome_portafoglio varchar(255) NOT NULL
);
```
### Conto
```SQL
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
```

### Persona
```SQL
--TABELLA DEI Persona

CREATE TABLE Persona(
    Nome VARCHAR(1000),
    Cognome VARCHAR(1000),
    -- identificativo per la persona
    CodiceFiscale CHAR(16) PRIMARY KEY,
    telefono VARCHAR(1000)
);
```

### Membreo
```SQL
--TABELLA DEI Membreo

CREATE TABLE Membro(
    Relazione TipoRelazione,
    CodiceFiscale CHAR(16),

    CONSTRAINT fk_Membro FOREIGN KEY(CodiceFiscale)
        REFERENCES Persona(codicefiscale)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);
```
### Transazione
```SQL
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
```

## Trigger

### Creazione chiave primaria Portafoglio

```SQL
--Trigger per settare la chiave primaria automaticamente
CREATE OR REPLACE FUNCTION PortafoglioPK()
    RETURNS TRIGGER
AS $$
DECLARE
    pk portafoglio.id_portafoglio%TYPE;
BEGIN
	SELECT MAX(id_portafoglio) + 1 into pk FROM portafoglio;
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
```

### Creazione chiave primaria Conto

```SQL
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
```

### Creazione chiave primaria Transazione

```SQL
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
```

