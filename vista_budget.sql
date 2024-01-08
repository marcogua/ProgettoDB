--VISTA BUDGET INTATTENIMENTO

CREATE OR REPLACE VIEW budegt_intrattenimento AS
Select SUM(transazione.importo) as totale_intrattenimento
FROM transazione
WHERE categoria_transazione = 'Intrattenimento';

--VISTA BUDGET STIPENDIO

CREATE OR REPLACE VIEW budegt_stipendio AS
Select SUM(transazione.importo) as totale_stipendio
FROM transazione
WHERE categoria_transazione = 'Stipendio';

--VISTA BUDGET TASSE

CREATE OR REPLACE VIEW budegt_tasse AS
Select SUM(transazione.importo) as totale_tasse
FROM transazione
WHERE categoria_transazione = 'Tasse';

--VISTA BUDGET INVESTIMENTO

CREATE OR REPLACE VIEW budegt_investimento AS
Select SUM(transazione.importo) as totale_investimento
FROM transazione
WHERE categoria_transazione = 'Investimento';

CREATE OR REPLACE VIEW budget_entate AS
SELECT SUM(transazione.importo) AS totale_entrate
FROM transazione
WHERE tipologia_transazione = 'Entrata';

CREATE OR REPLACE VIEW budget_uscite AS
SELECT SUM(transazione.importo) AS totale_uscite
FROM transazione
WHERE tipologia_transazione = 'Uscita';