#!/bin/sh

CSV_SEPARATOR=';'
ORDERED_TABLES="bestellung warenkorb produkte hersteller kunden"

init_import_params() {
cat << END
.mode csv
.separator ${CSV_SEPARATOR}

END
}

create_kunden_db() {
cat << END
CREATE TABLE kunden (kundennummer TEXT PRIMARY KEY,
vorname TEXT,
nachname TEXT,
strasse TEXT,
hausnummer TEXT,
plz TEXT,
stadt TEXT,
land TEXT);
.import kunden.CSV kunden

END
}

create_hersteller_db() {
cat << END
CREATE TABLE hersteller (name TEXT PRIMARY KEY, land TEXT);
.import hersteller.CSV hersteller

END
}

create_produkte_db() {
cat << END
CREATE TABLE produkte (produktnummer TEXT PRIMARY KEY,
bezeichnung TEXT,
hersteller TEXT,
FOREIGN KEY (hersteller) REFERENCES hersteller(name));
.import produkte.CSV produkte

END
}

create_warenkorb_db() {
cat << END
CREATE TABLE warenkorb (bestellnummer INTEGER,
produktnummer TEXT,
menge INTEGER,
preis REAL,
PRIMARY KEY(bestellnummer, produktnummer),
FOREIGN KEY (produktnummer) REFERENCES produkte(produktnummer));
.import warenkorb.CSV warenkorb

END
}

create_bestellung_db() {
cat << END
CREATE TABLE bestellung (bestellnummer INTEGER PRIMARY KEY,
datum TEXT, kundennummer TEXT,
versandkosten REAL,
gesamtkosten REAL,
FOREIGN KEY (bestellnummer) REFERENCES warenkorb(bestellnummer),
FOREIGN KEY (kundennummer) REFERENCES kunden(kundennummer));
.import bestellung.CSV bestellung

END
}

save_db() {
cat << END
.save shop.db

END
}

drop_dbs() {
    for t in ${ORDERED_TABLES}; do
        echo "DROP TABLE IF EXISTS $t;"
    done
}

create_tables() {
	for table in ${ORDERED_TABLES}; do
    	create_${table}_db
	done
}

init
drop_dbs
create_tables
save_db
