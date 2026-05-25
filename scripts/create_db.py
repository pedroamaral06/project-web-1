#!../env_3.11/bin/python
import sqlite3
import sys

def create_sqlite_database(db_name):
    conn = sqlite3.connect(db_name)
    cursor = conn.cursor()

    cursor.executescript('''
    PRAGMA journal_mode = WAL;
    PRAGMA cache_size = -2000;
    PRAGMA busy_timeout = 5000;
    PRAGMA synchronous = NORMAL;
    PRAGMA mmap_size = 134217728;
    PRAGMA journal_size_limit = 27103364;

    DROP TABLE IF EXISTS Cliente;
    CREATE TABLE Cliente (
        NIF TEXT PRIMARY KEY,
        Nome TEXT,
        Morada TEXT,
        CodigoPostal TEXT,
        Localidade TEXT,
        Area TEXT,
        Zona TEXT
    );

    DROP TABLE IF EXISTS Equipamento;
    CREATE TABLE Equipamento (
        ID INTEGER PRIMARY KEY,
        NumeroSerie TEXT
    );

    DROP TABLE IF EXISTS PropriedadeEquipamento;
    CREATE TABLE PropriedadeEquipamento (
        Equipamento_ID INTEGER,
        Cliente_NIF TEXT,
        DataInicio TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
        DataFim TIMESTAMP,
        PRIMARY KEY (Equipamento_ID, Cliente_NIF, DataInicio),
        FOREIGN KEY (Equipamento_ID) REFERENCES Equipamento(ID),
        FOREIGN KEY (Cliente_NIF) REFERENCES Cliente(NIF)
    );

    DROP TABLE IF EXISTS Temperatura;
    CREATE TABLE Temperatura (
        ID INTEGER PRIMARY KEY AUTOINCREMENT,
        Equipamento_ID INTEGER,
        DataHora TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
        Temp0 REAL,
        Temp1 REAL,
        Temp2 REAL,
        UNIQUE(Equipamento_ID, DataHora),
        FOREIGN KEY (Equipamento_ID) REFERENCES Equipamento(ID)
    );

    DROP TABLE IF EXISTS limites_sensores;
    CREATE TABLE limites_sensores (
        Sensor_tipo TEXT PRIMARY KEY,
        Min_val REAL,
        Max_val REAL
    );

    INSERT INTO limites_sensores (Sensor_tipo, Min_val, Max_val) VALUES ('temp0', 0, 50);
    INSERT INTO limites_sensores (Sensor_tipo, Min_val, Max_val) VALUES ('temp1', 0, 50);
    INSERT INTO limites_sensores (Sensor_tipo, Min_val, Max_val) VALUES ('temp2', 0, 50);

    DROP TABLE IF EXISTS alertas_sensores;
    CREATE TABLE alertas_sensores (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        Equipamento_ID INTEGER,
        Sensor_tipo TEXT,
        Leitura REAL,
        DataHora TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
        Mensagem TEXT,
        FOREIGN KEY (Equipamento_ID) REFERENCES Equipamento(ID)
    );
    ''')

    conn.commit()
    conn.close()

def main():
    db_name = "../db/test_database.db"
    create_sqlite_database(db_name)
    print("Base de dados criada com sucesso!")
    sys.exit(0)

if __name__ == "__main__":
    main()
