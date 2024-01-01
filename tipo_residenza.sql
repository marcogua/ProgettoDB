--CREAZIONE DEL TIPO STRUTTURATO RESIDENZA

CREATE TYPE residenza AS (
    via VARCHAR(255),
    civico VARCHAR(5),
    cap VARCHAR(5),
    citta VARCHAR(255),
    provincia VARCHAR(255)
);
 