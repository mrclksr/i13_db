#!/bin/sh

DB_NAME="online_shop2.sql"
CSV_PATH="../aufgabe1"
CSV_SEPARATOR=';'
ORDERED_TABLES="kunden bestellung hersteller produkte warenkorb"

print_import_commands() {
cat << END
LOAD DATA LOCAL INFILE '${CSV_PATH}/$2'
INTO TABLE $1
FIELDS TERMINATED BY '${CSV_SEPARATOR}'
ENCLOSED BY '"'
LINES TERMINATED BY '\n';

END
}

create_kunden_db() {
cat << END
CREATE TABLE kunden (
    kundennummer VARCHAR(255) PRIMARY KEY,
    vorname VARCHAR(255),
    nachname VARCHAR(255),
    strasse VARCHAR(255),
    hausnummer VARCHAR(50),
    plz VARCHAR(20),
    stadt VARCHAR(255),
    land VARCHAR(255)
);

END
    print_import_commands kunden kunden.CSV
}

create_hersteller_db(){
cat << END	
CREATE TABLE hersteller (
    name VARCHAR(255) PRIMARY KEY,
    land VARCHAR(255)
);

END
    print_import_commands hersteller hersteller.CSV
}

create_produkte_db() {
cat << END
CREATE TABLE produkte (
    produktnummer VARCHAR(255) PRIMARY KEY,
    bezeichnung VARCHAR(255),
    hersteller VARCHAR(255),
    FOREIGN KEY (hersteller) REFERENCES hersteller(name)
);

END
    print_import_commands produkte produkte.CSV
}

create_warenkorb_db() {
cat << END

CREATE TABLE warenkorb (
    bestellnummer INT,
    produktnummer VARCHAR(255),
    menge INT,
    preis DECIMAL(10,2),
    PRIMARY KEY (bestellnummer, produktnummer),
	FOREIGN KEY (bestellnummer) REFERENCES bestellung(bestellnummer),
    FOREIGN KEY (produktnummer) REFERENCES produkte(produktnummer)
);

END
    print_import_commands warenkorb warenkorb.CSV
}

create_bestellung_db() {
cat << END

CREATE TABLE bestellung (
    bestellnummer INT PRIMARY KEY,
    datum DATE,
    kundennummer VARCHAR(255),
    versandkosten DECIMAL(10,2),
    gesamtkosten DECIMAL(10,2),
    FOREIGN KEY (kundennummer) REFERENCES kunden(kundennummer)
);

END
    print_import_commands bestellung bestellung.CSV
}

drop_dbs() {
    for t in $(echo ${ORDERED_TABLES} | tr ' ' '\n' | tac | tr '\n' ' ') ; do
        echo "DROP TABLE IF EXISTS $t;"
    done
}

create_tables() {
	for table in ${ORDERED_TABLES}; do
    	create_${table}_db
	done
}

drop_dbs
create_tables

