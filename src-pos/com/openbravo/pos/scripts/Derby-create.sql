--    Openbravo POS is a point of sales application designed for touch screens.
--    Copyright (C) 2008-2010 Openbravo, S.L.
--    http://sourceforge.net/projects/openbravopos
--
--    This file is part of Openbravo POS.
--
--    Openbravo POS is free software: you can redistribute it and/or modify
--    it under the terms of the GNU General Public License as published by
--    the Free Software Foundation, either version 3 of the License, or
--    (at your option) any later version.
--
--    Openbravo POS is distributed in the hope that it will be useful,
--    but WITHOUT ANY WARRANTY; without even the implied warranty of
--    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
--    GNU General Public License for more details.
--
--    You should have received a copy of the GNU General Public License
--    along with Openbravo POS.  If not, see <http://www.gnu.org/licenses/>.

-- Database initial script for DERBY
-- v2

CREATE TABLE  APPLICATIONS (
    ID VARCHAR(256) NOT NULL,
    NAME VARCHAR(1024) NOT NULL,
    VERSION VARCHAR(1024) NOT NULL,
    PRIMARY KEY (ID)
);
INSERT INTO APPLICATIONS (ID, NAME, VERSION) VALUES ($APP_ID{}, $APP_NAME{}, $DB_VERSION{});

CREATE TABLE  ROLES (
    ID VARCHAR(256) NOT NULL,
    NAME VARCHAR(1024) NOT NULL,
    PERMISSIONS BLOB,
    PRIMARY KEY (ID)
);
CREATE UNIQUE INDEX ROLES_NAME_INX ON ROLES(NAME);

CREATE TABLE  PEOPLE (
    ID VARCHAR(256) NOT NULL,
    NAME VARCHAR(1024) NOT NULL,
    APPPASSWORD VARCHAR(1024),
    CARD VARCHAR(1024),
    ROLE VARCHAR(256) NOT NULL,
    VISIBLE SMALLINT NOT NULL,
    IMAGE BLOB,
    PRIMARY KEY (ID),
    CONSTRAINT PEOPLE_FK_1 FOREIGN KEY (ROLE) REFERENCES ROLES(ID)
);
CREATE UNIQUE INDEX PEOPLE_NAME_INX ON PEOPLE(NAME);
CREATE INDEX PEOPLE_CARD_INX ON PEOPLE(CARD);

CREATE TABLE  RESOURCES (
    ID VARCHAR(256) NOT NULL,
    NAME VARCHAR(1024) NOT NULL,
    RESTYPE INTEGER NOT NULL,
    CONTENT BLOB,
    PRIMARY KEY (ID)
);
CREATE UNIQUE INDEX RESOURCES_NAME_INX ON RESOURCES(NAME);

CREATE TABLE  TAXCUSTCATEGORIES (
    ID VARCHAR(256) NOT NULL,
    NAME VARCHAR(1024) NOT NULL,
    PRIMARY KEY (ID)
);
CREATE UNIQUE INDEX TAXCUSTCAT_NAME_INX ON TAXCUSTCATEGORIES(NAME);

CREATE TABLE  CUSTOMERS (
    ID VARCHAR(256) NOT NULL,
    SEARCHKEY VARCHAR(1024) NOT NULL,
    TAXID VARCHAR(1024),
    NAME VARCHAR(1024) NOT NULL,
    TAXCATEGORY VARCHAR(256),
    CARD VARCHAR(1024),
    MAXDEBT DOUBLE PRECISION DEFAULT 0 NOT NULL,
    ADDRESS VARCHAR(1024),
    ADDRESS2 VARCHAR(1024),
    POSTAL VARCHAR(1024),
    CITY VARCHAR(1024),
    REGION VARCHAR(1024),
    COUNTRY VARCHAR(1024),
    FIRSTNAME VARCHAR(1024),
    LASTNAME VARCHAR(1024),
    EMAIL VARCHAR(1024),
    PHONE VARCHAR(1024),
    PHONE2 VARCHAR(1024),
    FAX VARCHAR(1024),
    NOTES VARCHAR(1024),
    VISIBLE SMALLINT DEFAULT 1 NOT NULL,
    CURDATE TIMESTAMP,
    CURDEBT DOUBLE PRECISION,
    PRIMARY KEY (ID),
    CONSTRAINT CUSTOMERS_TAXCAT FOREIGN KEY (TAXCATEGORY) REFERENCES TAXCUSTCATEGORIES(ID)
);
CREATE UNIQUE INDEX CUSTOMERS_SKEY_INX ON CUSTOMERS(SEARCHKEY);
CREATE INDEX CUSTOMERS_TAXID_INX ON CUSTOMERS(TAXID);
CREATE INDEX CUSTOMERS_NAME_INX ON CUSTOMERS(NAME);
CREATE INDEX CUSTOMERS_CARD_INX ON CUSTOMERS(CARD);

CREATE TABLE  CATEGORIES (
    ID VARCHAR(256) NOT NULL,
    NAME VARCHAR(1024) NOT NULL,
    PARENTID VARCHAR(256),
    IMAGE BLOB,
    PRIMARY KEY(ID),
    CONSTRAINT CATEGORIES_FK_1 FOREIGN KEY (PARENTID) REFERENCES CATEGORIES(ID)
);
CREATE UNIQUE INDEX CATEGORIES_NAME_INX ON CATEGORIES(NAME);

CREATE TABLE  TAXCATEGORIES (
    ID VARCHAR(256) NOT NULL,
    NAME VARCHAR(1024) NOT NULL,
    PRIMARY KEY (ID)
);
CREATE UNIQUE INDEX TAXCAT_NAME_INX ON TAXCATEGORIES(NAME);

CREATE TABLE  TAXES (
    ID VARCHAR(256) NOT NULL,
    NAME VARCHAR(1024) NOT NULL,
    VALIDFROM TIMESTAMP DEFAULT '2001-01-01 00:00:00' NOT NULL,
    CATEGORY VARCHAR(256) NOT NULL,
    CUSTCATEGORY VARCHAR(256),
    PARENTID VARCHAR(256),
    RATE DOUBLE PRECISION NOT NULL,
    RATECASCADE SMALLINT DEFAULT 0 NOT NULL,
    RATEORDER INTEGER,
    PRIMARY KEY(ID),
    CONSTRAINT TAXES_CAT_FK FOREIGN KEY (CATEGORY) REFERENCES TAXCATEGORIES(ID),
    CONSTRAINT TAXES_CUSTCAT_FK FOREIGN KEY (CUSTCATEGORY) REFERENCES TAXCUSTCATEGORIES(ID),
    CONSTRAINT TAXES_TAXES_FK FOREIGN KEY (PARENTID) REFERENCES TAXES(ID)
);
CREATE UNIQUE INDEX TAXES_NAME_INX ON TAXES(NAME);

CREATE TABLE  ATTRIBUTE (
    ID VARCHAR(256) NOT NULL,
    NAME VARCHAR(1024) NOT NULL,
    PRIMARY KEY (ID)
);

CREATE TABLE  ATTRIBUTEVALUE (
    ID VARCHAR(256) NOT NULL,
    ATTRIBUTE_ID VARCHAR(256) NOT NULL,
    VALUE VARCHAR(1024),
    PRIMARY KEY (ID),
    CONSTRAINT ATTVAL_ATT FOREIGN KEY (ATTRIBUTE_ID) REFERENCES ATTRIBUTE(ID) ON DELETE CASCADE
);

CREATE TABLE  ATTRIBUTESET (
    ID VARCHAR(256) NOT NULL,
    NAME VARCHAR(1024) NOT NULL,
    PRIMARY KEY (ID)
);

CREATE TABLE  ATTRIBUTEUSE (
    ID VARCHAR(256) NOT NULL,
    ATTRIBUTESET_ID VARCHAR(256) NOT NULL,
    ATTRIBUTE_ID VARCHAR(256) NOT NULL,
    LINENO INTEGER,
    PRIMARY KEY (ID),
    CONSTRAINT ATTUSE_SET FOREIGN KEY (ATTRIBUTESET_ID) REFERENCES ATTRIBUTESET(ID) ON DELETE CASCADE,
    CONSTRAINT ATTUSE_ATT FOREIGN KEY (ATTRIBUTE_ID) REFERENCES ATTRIBUTE(ID)
);
CREATE UNIQUE INDEX ATTUSE_LINE ON ATTRIBUTEUSE(ATTRIBUTESET_ID, LINENO);

CREATE TABLE  ATTRIBUTESETINSTANCE (
    ID VARCHAR(256) NOT NULL,
    ATTRIBUTESET_ID VARCHAR(256) NOT NULL,
    DESCRIPTION VARCHAR(1024),
    PRIMARY KEY (ID),
    CONSTRAINT ATTSETINST_SET FOREIGN KEY (ATTRIBUTESET_ID) REFERENCES ATTRIBUTESET(ID) ON DELETE CASCADE
);

CREATE TABLE  ATTRIBUTEINSTANCE (
    ID VARCHAR(256) NOT NULL,
    ATTRIBUTESETINSTANCE_ID VARCHAR(256) NOT NULL,
    ATTRIBUTE_ID VARCHAR(256) NOT NULL,
    VALUE VARCHAR(1024),
    PRIMARY KEY (ID),
    CONSTRAINT ATTINST_SET FOREIGN KEY (ATTRIBUTESETINSTANCE_ID) REFERENCES ATTRIBUTESETINSTANCE(ID) ON DELETE CASCADE,
    CONSTRAINT ATTINST_ATT FOREIGN KEY (ATTRIBUTE_ID) REFERENCES ATTRIBUTE(ID)
);

CREATE TABLE  PRODUCTS (
    ID VARCHAR(256) NOT NULL,
    REFERENCE VARCHAR(1024) NOT NULL,
    CODE VARCHAR(1024),
    CODETYPE VARCHAR(1024),
    NAME VARCHAR(1024) NOT NULL,
    PRICEBUY DOUBLE PRECISION,
    PRICESELL DOUBLE PRECISION NOT NULL,
    CATEGORY VARCHAR(256) NOT NULL,
    TAXCAT VARCHAR(256) NOT NULL,
    ATTRIBUTESET_ID VARCHAR(256),
    STOCKCOST DOUBLE PRECISION,
    STOCKVOLUME DOUBLE PRECISION,
    IMAGE BLOB,
    ISCOM SMALLINT DEFAULT 0 NOT NULL,
    ISSCALE SMALLINT DEFAULT 0 NOT NULL,
    ATTRIBUTES BLOB,
    PRIMARY KEY (ID),
    CONSTRAINT PRODUCTS_FK_1 FOREIGN KEY (CATEGORY) REFERENCES CATEGORIES(ID),
    CONSTRAINT PRODUCTS_TAXCAT_FK FOREIGN KEY (TAXCAT) REFERENCES TAXCATEGORIES(ID),
    CONSTRAINT PRODUCTS_ATTRSET_FK FOREIGN KEY (ATTRIBUTESET_ID) REFERENCES ATTRIBUTESET(ID)
);
CREATE UNIQUE INDEX PRODUCTS_INX_0 ON PRODUCTS(REFERENCE);
CREATE UNIQUE INDEX PRODUCTS_NAME_INX ON PRODUCTS(NAME);

CREATE TABLE  PRODUCTS_CAT (
    PRODUCT VARCHAR(256) NOT NULL,
    CATORDER INTEGER,
    PRIMARY KEY (PRODUCT),
    CONSTRAINT PRODUCTS_CAT_FK_1 FOREIGN KEY (PRODUCT) REFERENCES PRODUCTS(ID)
);
CREATE INDEX PRODUCTS_CAT_INX_1 ON PRODUCTS_CAT(CATORDER);

CREATE TABLE  PRODUCTS_COM (
    ID VARCHAR(256) NOT NULL,
    PRODUCT VARCHAR(256) NOT NULL,
    PRODUCT2 VARCHAR(256) NOT NULL,
    PRIMARY KEY (ID),
    CONSTRAINT PRODUCTS_COM_FK_1 FOREIGN KEY (PRODUCT) REFERENCES PRODUCTS(ID),
    CONSTRAINT PRODUCTS_COM_FK_2 FOREIGN KEY (PRODUCT2) REFERENCES PRODUCTS(ID)
);
CREATE UNIQUE INDEX PCOM_INX_PROD ON PRODUCTS_COM(PRODUCT, PRODUCT2);

CREATE TABLE  LOCATIONS (
    ID VARCHAR(256) NOT NULL,
    NAME VARCHAR(1024) NOT NULL,
    ADDRESS VARCHAR(1024),
    PRIMARY KEY (ID)
);
CREATE UNIQUE INDEX LOCATIONS_NAME_INX ON LOCATIONS(NAME);

CREATE TABLE  STOCKDIARY (
    ID VARCHAR(256) NOT NULL,
    DATENEW TIMESTAMP NOT NULL,
    REASON INTEGER NOT NULL,
    LOCATION VARCHAR(256) NOT NULL,
    PRODUCT VARCHAR(256) NOT NULL,
    ATTRIBUTESETINSTANCE_ID VARCHAR(256),
    UNITS DOUBLE PRECISION NOT NULL,
    PRICE DOUBLE PRECISION NOT NULL,
    PRIMARY KEY (ID),
    CONSTRAINT STOCKDIARY_FK_1 FOREIGN KEY (PRODUCT) REFERENCES PRODUCTS(ID),
    CONSTRAINT STOCKDIARY_ATTSETINST FOREIGN KEY (ATTRIBUTESETINSTANCE_ID) REFERENCES ATTRIBUTESETINSTANCE(ID),
    CONSTRAINT STOCKDIARY_FK_2 FOREIGN KEY (LOCATION) REFERENCES LOCATIONS(ID)
);
CREATE INDEX STOCKDIARY_INX_1 ON STOCKDIARY(DATENEW);

CREATE TABLE  STOCKLEVEL (
    ID VARCHAR(256) NOT NULL,
    LOCATION VARCHAR(256) NOT NULL,
    PRODUCT VARCHAR(256) NOT NULL,
    STOCKSECURITY DOUBLE PRECISION,
    STOCKMAXIMUM DOUBLE PRECISION,
    PRIMARY KEY (ID),
    CONSTRAINT STOCKLEVEL_PRODUCT FOREIGN KEY (PRODUCT) REFERENCES PRODUCTS(ID),
    CONSTRAINT STOCKLEVEL_LOCATION FOREIGN KEY (LOCATION) REFERENCES LOCATIONS(ID)
);

CREATE TABLE  STOCKCURRENT (
    LOCATION VARCHAR(256) NOT NULL,
    PRODUCT VARCHAR(256) NOT NULL,
    ATTRIBUTESETINSTANCE_ID VARCHAR(256),
    UNITS DOUBLE PRECISION NOT NULL,
    CONSTRAINT STOCKCURRENT_FK_1 FOREIGN KEY (PRODUCT) REFERENCES PRODUCTS(ID),
    CONSTRAINT STOCKCURRENT_ATTSETINST FOREIGN KEY (ATTRIBUTESETINSTANCE_ID) REFERENCES ATTRIBUTESETINSTANCE(ID),
    CONSTRAINT STOCKCURRENT_FK_2 FOREIGN KEY (LOCATION) REFERENCES LOCATIONS(ID)
);
CREATE UNIQUE INDEX STOCKCURRENT_INX ON STOCKCURRENT(LOCATION, PRODUCT, ATTRIBUTESETINSTANCE_ID);

CREATE TABLE  CLOSEDCASH (
    MONEY VARCHAR(256) NOT NULL,
    HOST VARCHAR(1024) NOT NULL,
    HOSTSEQUENCE INTEGER NOT NULL,
    DATESTART TIMESTAMP,
    DATEEND TIMESTAMP,
    PRIMARY KEY(MONEY)
);
CREATE INDEX CLOSEDCASH_INX_1 ON CLOSEDCASH(DATESTART);
CREATE UNIQUE INDEX CLOSEDCASH_INX_SEQ ON CLOSEDCASH(HOST, HOSTSEQUENCE);

CREATE TABLE  RECEIPTS (
    ID VARCHAR(256) NOT NULL,
    MONEY VARCHAR(256) NOT NULL,
    DATENEW TIMESTAMP NOT NULL,
    ATTRIBUTES BLOB,
    PRIMARY KEY(ID),
    CONSTRAINT RECEIPTS_FK_MONEY FOREIGN KEY (MONEY) REFERENCES CLOSEDCASH(MONEY)
);
CREATE INDEX RECEIPTS_INX_1 ON RECEIPTS(DATENEW);

CREATE TABLE  TICKETS (
    ID VARCHAR(256) NOT NULL,
    TICKETTYPE INTEGER DEFAULT 0 NOT NULL,
    TICKETID INTEGER NOT NULL,
    PERSON VARCHAR(256) NOT NULL,
    CUSTOMER VARCHAR(256),
    STATUS INTEGER DEFAULT 0 NOT NULL,
    PRIMARY KEY (ID),
    CONSTRAINT TICKETS_FK_ID FOREIGN KEY (ID) REFERENCES RECEIPTS(ID),
    CONSTRAINT TICKETS_FK_2 FOREIGN KEY (PERSON) REFERENCES PEOPLE(ID),
    CONSTRAINT TICKETS_CUSTOMERS_FK FOREIGN KEY (CUSTOMER) REFERENCES CUSTOMERS(ID)
);
CREATE INDEX TICKETS_TICKETID ON TICKETS(TICKETTYPE, TICKETID);

CREATE TABLE  TICKETSNUM (ID INTEGER GENERATED ALWAYS AS IDENTITY (START WITH 1));
INSERT INTO TICKETSNUM VALUES (DEFAULT);
CREATE TABLE  TICKETSNUM_REFUND (ID INTEGER GENERATED ALWAYS AS IDENTITY (START WITH 1));
INSERT INTO TICKETSNUM_REFUND VALUES (DEFAULT);
CREATE TABLE  TICKETSNUM_PAYMENT (ID INTEGER GENERATED ALWAYS AS IDENTITY (START WITH 1));
INSERT INTO TICKETSNUM_PAYMENT VALUES (DEFAULT);

CREATE TABLE  TICKETLINES (
    TICKET VARCHAR(256) NOT NULL,
    LINE INTEGER NOT NULL,
    PRODUCT VARCHAR(256),
    ATTRIBUTESETINSTANCE_ID VARCHAR(256),
    UNITS DOUBLE PRECISION NOT NULL,
    PRICE DOUBLE PRECISION NOT NULL,
    TAXID VARCHAR(256) NOT NULL,
    ATTRIBUTES BLOB,
    PRIMARY KEY (TICKET, LINE),
    CONSTRAINT TICKETLINES_FK_TICKET FOREIGN KEY (TICKET) REFERENCES TICKETS(ID),
    CONSTRAINT TICKETLINES_FK_2 FOREIGN KEY (PRODUCT) REFERENCES PRODUCTS(ID),
    CONSTRAINT TICKETLINES_ATTSETINST FOREIGN KEY (ATTRIBUTESETINSTANCE_ID) REFERENCES ATTRIBUTESETINSTANCE(ID),
    CONSTRAINT TICKETLINES_FK_3 FOREIGN KEY (TAXID) REFERENCES TAXES(ID)
);

CREATE TABLE  PAYMENTS (
    ID VARCHAR(256) NOT NULL,
    RECEIPT VARCHAR(256) NOT NULL,
    PAYMENT VARCHAR(1024) NOT NULL,
    TOTAL DOUBLE PRECISION NOT NULL,
    TRANSID VARCHAR(1024),
    RETURNMSG BLOB,
    PRIMARY KEY (ID),
    CONSTRAINT PAYMENTS_FK_RECEIPT FOREIGN KEY (RECEIPT) REFERENCES RECEIPTS(ID)
);
CREATE INDEX PAYMENTS_INX_1 ON PAYMENTS(PAYMENT);

CREATE TABLE  TAXLINES (
    ID VARCHAR(256) NOT NULL,
    RECEIPT VARCHAR(256) NOT NULL,
    TAXID VARCHAR(256) NOT NULL,
    BASE DOUBLE PRECISION NOT NULL,
    AMOUNT DOUBLE PRECISION NOT NULL,
    PRIMARY KEY (ID),
    CONSTRAINT TAXLINES_TAX FOREIGN KEY (TAXID) REFERENCES TAXES(ID),
    CONSTRAINT TAXLINES_RECEIPT FOREIGN KEY (RECEIPT) REFERENCES RECEIPTS(ID)
);

CREATE TABLE  FLOORS (
    ID VARCHAR(256) NOT NULL,
    NAME VARCHAR(1024) NOT NULL,
    IMAGE BLOB,
    PRIMARY KEY (ID)
);
CREATE UNIQUE INDEX FLOORS_NAME_INX ON FLOORS(NAME);

CREATE TABLE  PLACES (
    ID VARCHAR(256) NOT NULL,
    NAME VARCHAR(1024) NOT NULL,
    X INTEGER NOT NULL,
    Y INTEGER NOT NULL,
    FLOOR VARCHAR(256) NOT NULL,
    PRIMARY KEY (ID),
    CONSTRAINT PLACES_FK_1 FOREIGN KEY (FLOOR) REFERENCES FLOORS(ID)
);
CREATE UNIQUE INDEX PLACES_NAME_INX ON PLACES(NAME);

CREATE TABLE  RESERVATIONS (
    ID VARCHAR(256) NOT NULL,
    CREATED TIMESTAMP NOT NULL,
    DATENEW TIMESTAMP DEFAULT '2001-01-01 00:00:00' NOT NULL,
    TITLE VARCHAR(1024) NOT NULL,
    CHAIRS INTEGER NOT NULL,
    ISDONE SMALLINT NOT NULL,
    DESCRIPTION VARCHAR(1024),
    PRIMARY KEY (ID)
);
CREATE INDEX RESERVATIONS_INX_1 ON RESERVATIONS(DATENEW);

CREATE TABLE  RESERVATION_CUSTOMERS (
    ID VARCHAR(256) NOT NULL,
    CUSTOMER VARCHAR(256) NOT NULL,
    PRIMARY KEY (ID),
    CONSTRAINT RES_CUST_FK_1 FOREIGN KEY (ID) REFERENCES RESERVATIONS(ID),
    CONSTRAINT RES_CUST_FK_2 FOREIGN KEY (CUSTOMER) REFERENCES CUSTOMERS(ID)
);

CREATE TABLE  THIRDPARTIES (
    ID VARCHAR(256) NOT NULL,
    CIF VARCHAR(1024) NOT NULL,
    NAME VARCHAR(1024) NOT NULL,
    ADDRESS VARCHAR(1024),
    CONTACTCOMM VARCHAR(1024),
    CONTACTFACT VARCHAR(1024),
    PAYRULE VARCHAR(1024),
    FAXNUMBER VARCHAR(1024),
    PHONENUMBER VARCHAR(1024),
    MOBILENUMBER VARCHAR(1024),
    EMAIL VARCHAR(1024),
    WEBPAGE VARCHAR(1024),
    NOTES VARCHAR(1024),
    PRIMARY KEY (ID)
);
CREATE UNIQUE INDEX THIRDPARTIES_CIF_INX ON THIRDPARTIES(CIF);
CREATE UNIQUE INDEX THIRDPARTIES_NAME_INX ON THIRDPARTIES(NAME);

CREATE TABLE  SHAREDTICKETS (
    ID VARCHAR(256) NOT NULL,
    NAME VARCHAR(1024) NOT NULL,
    CONTENT BLOB,
    PRIMARY KEY(ID)
);
