#!/bin/sh
#
#
#  +-KUNDEN----------------------------+
#  \ kundennummer | vorname ... | land | 
#   +----------------------------------+
         


create_kunden_db() {
cat << END
CREATE TABLE kunden (kundennummer TEXT PRIMARY KEY, vorname TEXT, nachname TEXT, strasse TEXT, hausnummer TEXT, plz TEXT, stadt TEXT, land TEXT);
.mode csv
.separator ;
.import kunden.CSV kunden
END
}

create_hersteller_db() {
cat << END
CREATE TABLE hersteller (name TEXT PRIMARY KEY, land TEXT);
.mode csv
.separator ;
.import hersteller.CSV hersteller
END

}

create_produkte_db() {
cat << END
CREATE TABLE produkte (produktnummer TEXT PRIMARY KEY, bezeichnung TEXT, hersteller TEXT, FOREIGN KEY (hersteller) REFERENCES hersteller(name));
.mode csv
.separator ;
.import produkte.CSV produkte
END
}

create_warenkorb_db() {
cat << END
CREATE TABLE warenkorb (bestellnummer INTEGER, produktnummer TEXT, menge INTEGER, preis REAL, PRIMARY KEY(bestellnummer, produktnummer), FOREIGN KEY (produktnummer) REFERENCES produkte(produktnummer));
.mode csv
.separator ;
.import warenkorb.CSV warenkorb
END
}

create_bestellung_db() {
cat << END
CREATE TABLE bestellung (bestellnummer INTEGER PRIMARY KEY, datum TEXT, kundennummer TEXT, versandkosten REAL, gesamtkosten REAL, FOREIGN KEY (bestellnummer) REFERENCES warenkorb(bestellnummer), FOREIGN KEY (kundennummer) REFERENCES kunden(kundennummer));
.mode csv
.separator ;
.import bestellung.CSV bestellung
END
}


save_db() {
cat << END
.save shop.db
END
}

show_db() {
cat << END
SELECT * FROM kunden;
END
}

drop_dbs() {
cat << END
DROP TABLE bestellung;
DROP TABLE warenkorb;
DROP TABLE produkte;
DROP TABLE hersteller;
DROP TABLE kunden;
END
}

drop_dbs

create_kunden_db
create_hersteller_db
create_produkte_db
create_warenkorb_db
create_bestellung_db
save_db
show_db


