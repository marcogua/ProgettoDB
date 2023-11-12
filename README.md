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

## Tabelle

### Portafoglio
```SQL
--TABELLA DEI PORTAFOGLI

CREATE TABLE portafoglio(
    --ID_PORTAFOLGIO identifica univocamente un portafoglio
    id_portafoglio int NOT NULL,
    --NOME_PORTAFOGLIO nome assegnato al portafolgio
    nome_portafoglio varchar(255) NOT NULL
);
```
### Conto
```SQL
--TABELLA DEI CONTI

CREATE TABLE conto(
    --ID_CONTO identifica univocamente un conto
    id_conto int NOT NULL,
    --NOME_CONTO nome assegnato al conto
    nome_conto varchar(255) NOT NULL,
    --IBAN iban realtivo al conto se presete
    iban varchar(26),
    --SALDO saldo relativo al conto
    saldo decimal NOT NULL DEFAULT 0.00
);
```
### Transazione
```SQL
--TABELLA DELLE TRANSAZIONI

CREATE TABLE transazione(
    --ID_TRANSAZIONE identifica univocamente una transazione
    id_transazione int NOT NULL,
    --TIPOLOGIA_TRANSAZIONE identifica la tipologia di transazione(entrata/uscita/trasferimento)
    tipologia_transazione tipologia_transazione,
    --CATEGORIA_TRASAZIONE identifica la vategoria della transazione(svago/tasse/affitto)
    categoria_transazione categoria_transazione,
    --VALORE identifica l'importo della transazione
    valore decimal NOT NULL
);
```