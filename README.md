# ProgettoDB

Progetto di base di dati 23/24

## Autori

|Matricola|Nome|Cognome|
|---------|----|-------|
|N86002851|Marco|Guadagno|
|N86002863|Vittorio|Somma|

## Traccia

SavingMoneyUnina è un sistema che permette di tenere sotto controllo le finanze personali o familiari.
Permette di collegare più carte di credito o debito, proprie o di un altro membro della famiglia gestendo
le transazioni in entrata ed in uscita. Il sistema permette di suddividere le transazioni in gruppi
(portafogli) appartenenti a diverse categorie (es. svago, spese mediche, stipendio, bollette ecc.). È
possibile sincronizzare automaticamente le transazioni effettuate da una carta assegnandole ad uno
specifico gruppo, oppure registrare una transazione manualmente. Si utilizzino le proprie conoscenze
del dominio per definire dettagli non specificati nella traccia.

## Documentazione

### Creazione file unico per generare DB

```Bash
cat tipo_residenza.sql, categoria_transazione.sql, tipologia_transazione.sql, tipo_relazione.sql, persona.sql, utente.sql, membro.sql, portafoglio.sql, conto.sql, transazione.sql, inserimenti_utente.sql, inserimenti_portafoglio.sql, inserimenti_conto.sql > SavingMoneyUnina.sql
```

### Tipi

#### Tipo residenza

```SQL
--CREAZIONE DEL TIPO STRUTTURATO RESIDENZA

CREATE TYPE residenza AS (
    via VARCHAR(255),
    civico VARCHAR(5),
    cap VARCHAR(5),
    citta VARCHAR(255),
    provincia VARCHAR(255)
);
```

### Domini

#### Tipologia transazione

```SQL
--DOMINIO TIPOLOGIA_TRANSAZIONE

CREATE DOMAIN tipologia_transazione AS 
    VARCHAR NOT NULL CHECK (VALUE = 'Entrata' OR
                            VALUE = 'Uscita' OR
                            VALUE = 'Trasferimento');
```

#### Categoria transazione

```SQL
--DOMINIO CATEGORIA_TRANSAZIONE

CREATE DOMAIN categoria_transazione AS 
    VARCHAR NOT NULL CHECK (VALUE = 'Intrattenimento' OR
                            VALUE = 'Tasse' OR
                            VALUE = 'Stipendio' OR
                            VALUE = 'Investimento');
```

#### Tipo Relazione

```SQL
--DOMINIO TIPO_RELAZIONE

CREATE DOMAIN tipo_relazione AS 
    VARCHAR(1000) NOT NULL CHECK(
                                VALUE = 'Fratello-Sorella' OR
                                VALUE = 'Coniuge' OR
                                VALUE = 'Figlio-Figlia' OR
                                VALUE = 'Parente' OR
                                VALUE = 'Amico');
```

### Tabelle

#### Portafoglio

```SQL
--TABELLA DEI PORTAFOGLI

CREATE TABLE portafoglio(
    --ID_PORTAFOLGIO identifica univocamente un portafoglio
    id_portafoglio INT PRIMARY KEY,
    --NOME_PORTAFOGLIO nome assegnato al portafolgio
    nome_portafoglio VARCHAR(256) NOT NULL,
    --SALDO totale dei conti del portafoglio
    saldo DECIMAL NOT NULL DEFAULT 0.00
);
```

#### Conto

```SQL
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
```

#### Persona

```SQL
--TABELLA DELLE PERSONE

CREATE TABLE persona(
    nome VARCHAR(256) NOT NULL,
    cognome VARCHAR(256) NOT NULL,
    codice_fiscale CHAR(16) PRIMARY KEY,
    residenza residenza NOT NULL,
    telefono VARCHAR(15) NOT NULL,
    CONSTRAINT validate_nome
        CHECK (nome ~ '^([a-zA-Z ])+$'),
    CONSTRAINT validate_cognome
        CHECK (cognome ~ '^([a-zA-Z ])+$'),
    CONSTRAINT validate_codice_fiscale
        CHECK (codice_fiscale ~ '^[A-Z]{6}[0-9]{2}[A-Z]{1}[0-9]{2}[A-Z]{1}[0-9]{3}[A-Z]{1}$'),
    CONSTRAINT validate_telefono
        CHECK (telefono ~ '^\d{9,15}$')
);
```

#### Utente

```SQL
--TABELLA DEGLI UTENTI

CREATE TABLE utente(
    email VARCHAR(255) PRIMARY KEY,
    password VARCHAR(255) NOT NULL,
    CONSTRAINT validate_email
        CHECK (email ~ '^[\w\-\.]+@([\w-]+\.)+[\w-]{2,}$')
);
```

#### Membro

```SQL
--TABELLA DEI MEMBRI

CREATE TABLE membro(
    relazione tipo_relazione,
    codice_fiscale VARCHAR(16),
    CONSTRAINT fk_Membro FOREIGN KEY(codice_fiscale)
        REFERENCES persona(codice_fiscale)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    CONSTRAINT validate_codice_fiscale
        CHECK (codice_fiscale ~ '^[A-Z]{6}[0-9]{2}[A-Z]{1}[0-9]{2}[A-Z]{1}[0-9]{3}[A-Z]{1}$')
);
```

#### Transazione

```SQL
--TABELLA DELLE TRANSAZIONI

CREATE TABLE transazione(
    --ID_TRANSAZIONE identifica univocamente una transazione
    id_transazione INT PRIMARY KEY,
    --TIPOLOGIA_TRANSAZIONE identifica la tipologia di transazione(entrata/uscita/trasferimento)
    tipologia_transazione tipologia_transazione,
    --DESCRIZIONE_TRANSAZIONE descrive la transazione
    descrizione_transazione VARCHAR(256)
    --DATA_TRANSAZIONE data della transazione
    data_transazione DATE NOT NULL
    --CATEGORIA_TRASAZIONE identifica la vategoria della transazione(svago/tasse/affitto)
    categoria_transazione categoria_transazione,
    --VALORE identifica l'importo della transazione
    valore DECIMAL NOT NULL,
    id_conto INT,
    CONSTRAINT FK_id_conto FOREIGN KEY(id_conto)
        REFERENCES conto(id_conto)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);
```

### Trigger

#### Creazione chiave primaria Portafoglio

```SQL
--Trigger per settare la chiave primaria automaticamente
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
```

#### Creazione chiave primaria Conto

```SQL
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
```

#### Creazione chiave primaria Transazione

```SQL
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
```

### Inserimenti

#### Portafogli

```SQL
--INSERIEMTNI DI ESEMPIO DELLA TABELLA PORTAFOGLIO

INSERT INTO portafoglio VALUES(1, 'Personale', 2000.00);
INSERT INTO portafoglio VALUES(2, 'Familiare', 5000.00);
INSERT INTO portafoglio VALUES(3, 'Aziendale', 2500.00);
```

#### Conti

```SQL
--INSERIMENTI DI ESEMPIO DELLA TABELLA CONTO

INSERT INTO conto VALUES(1, 'Contanti', NULL , 51.25, 1);
INSERT INTO conto VALUES(2, 'BBVA', 'IT29P8440115377743262655956', 1248.50, 1);
INSERT INTO conto VALUES(3, 'Hype', 'IT36B1690816578157590551079', 700.25, 1);
INSERT INTO conto VALUES(4, 'Contanti', NULL , 100.00, 2);
INSERT INTO conto VALUES(5, 'BBVA', 'IT38A2128392556003642900114', 4500.00, 2);
INSERT INTO conto VALUES(6, 'Hype Premium', 'IT04S8351927801180083641532', 400.00, 2);
INSERT INTO conto VALUES(7, 'Intesa San Paolo', 'IT45R6803462892261131810825' , 1000.00, 3);
INSERT INTO conto VALUES(8, 'BPER Business', 'IT53Q7513393390277705543243', 750.00, 3);
INSERT INTO conto VALUES(9, 'AMEX Platinum', 'IT52S6907808060854807743999', 750.00, 3);
```

#### Utenti

```SQL
--INSERIMENTI DI ESEMPIO DELLA TABELLA UTENTI

INSERT INTO utente VALUES ('admin.admin@admin.admin', 'admin');
INSERT INTO utente VALUES ('luca.rossi@email.it', 'LR.password12');
INSERT into utente values ('mario.rossi@email.com', 'password');
```

#### Persone

```SQL
--INSERIMENTI DI ESEMPIO DELLA TABELLA PERSONA

INSERT INTO persona VALUES('Mario', 'Rossi', 'RSSMRA90A01F839Y', ROW('via mario rossi', '12', '12345', 'Acerra', 'Napoli'), '0818907665');
```

### Viste

#### Vista budget intrattenimento

```SQL
--VISTA BUDGET INTATTENIMENTO

CREATE OR REPLACE VIEW budegt_intrattenimento AS
Select SUM(transazione.importo) as totale_intrattenimento
FROM transazione
WHERE categoria_transazione = 'Intrattenimento';
```

#### Vista budegt stipendio

```SQL
--VISTA BUDGET STIPENDIO

CREATE OR REPLACE VIEW budegt_stipendio AS
Select SUM(transazione.importo) as totale_stipendio
FROM transazione
WHERE categoria_transazione = 'Stipendio';
```

#### Vista budget tasse

```SQL
--VISTA BUDGET TASSE

CREATE OR REPLACE VIEW budegt_tasse AS
Select SUM(transazione.importo) as totale_tasse
FROM transazione
WHERE categoria_transazione = 'Tasse';
```

#### Vista budget investimento

```SQL
--VISTA BUDGET INVESTIMENTO

CREATE OR REPLACE VIEW budegt_investimento AS
Select SUM(transazione.importo) as totale_investimento
FROM transazione
WHERE categoria_transazione = 'Investimento';
```
