PRAGMA journal_mode = WAL;
PRAGMA cache_size = -2000;
PRAGMA busy_timeout = 5000;
PRAGMA synchronous = NORMAL;
PRAGMA mmap_size = 134217728;
PRAGMA journal_size_limit = 27103364;
PRAGMA foreign_keys = ON;

DROP VIEW IF EXISTS ClienteEquipamentoView;
DROP TABLE IF EXISTS alertas_sensores;
DROP TABLE IF EXISTS limites_sensores;
DROP TABLE IF EXISTS Temperatura;
DROP TABLE IF EXISTS PropriedadeEquipamento;
DROP TABLE IF EXISTS Equipamento;
DROP TABLE IF EXISTS Cliente;

CREATE TABLE Cliente (
    NIF TEXT PRIMARY KEY NOT NULL,
    Nome TEXT NOT NULL,
    Morada TEXT,
    CodigoPostal TEXT,
    Localidade TEXT,
    Area TEXT,
    Zona TEXT,
    CHECK (length(trim(NIF)) = 12 AND length(trim(Nome)) > 0)
);

CREATE TABLE Equipamento (
    ID INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
    NumeroSerie TEXT NOT NULL UNIQUE,
    CHECK (length(trim(NumeroSerie)) > 0)
);

CREATE TABLE PropriedadeEquipamento (
    ID INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
    Equipamento_ID INTEGER NOT NULL,
    Cliente_NIF TEXT NOT NULL,
    DataInicio TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    DataFim TIMESTAMP,
    FOREIGN KEY (Equipamento_ID) REFERENCES Equipamento(ID) ON DELETE CASCADE,
    FOREIGN KEY (Cliente_NIF) REFERENCES Cliente(NIF) ON DELETE CASCADE,
    CHECK (DataFim IS NULL OR DataFim > DataInicio)
);

CREATE TABLE Temperatura (
    ID INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
    Equipamento_ID INTEGER NOT NULL,
    DataHora TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    Temp0 REAL,
    Temp1 REAL,
    Temp2 REAL,
    FOREIGN KEY (Equipamento_ID) REFERENCES Equipamento(ID) ON DELETE CASCADE,
    CHECK (Temp0 IS NOT NULL OR Temp1 IS NOT NULL OR Temp2 IS NOT NULL)
);

CREATE TABLE limites_sensores (
    Sensor_tipo TEXT PRIMARY KEY,
    Min_val REAL NOT NULL,
    Max_val REAL NOT NULL,
    CHECK (Max_val > Min_val)
);

CREATE TABLE alertas_sensores (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    Equipamento_ID INTEGER NOT NULL,
    Sensor_tipo TEXT NOT NULL,
    Leitura REAL NOT NULL,
    DataHora TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    Mensagem TEXT,
    FOREIGN KEY (Equipamento_ID) REFERENCES Equipamento(ID) ON DELETE CASCADE,
    FOREIGN KEY (Sensor_tipo) REFERENCES limites_sensores(Sensor_tipo)
);

CREATE VIEW ClienteEquipamentoView AS
SELECT 
    c.NIF,
    c.Nome AS NomeCliente,
    e.ID AS EquipamentoID,
    e.NumeroSerie,
    pe.DataInicio AS DataInicioPropriedade,
    pe.DataFim AS DataFimPropriedade
FROM Cliente c
INNER JOIN PropriedadeEquipamento pe ON c.NIF = pe.Cliente_NIF
INNER JOIN Equipamento e ON pe.Equipamento_ID = e.ID
WHERE pe.DataFim IS NULL OR pe.DataFim > CURRENT_TIMESTAMP;

INSERT INTO limites_sensores (Sensor_tipo, Min_val, Max_val) VALUES 
('temp0', -30.0, 100.0),
('temp1', -30.0, 100.0),
('temp2', -30.0, 100.0);