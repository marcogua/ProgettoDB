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