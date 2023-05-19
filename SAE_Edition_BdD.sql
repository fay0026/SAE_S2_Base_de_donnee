--2 Modification du script de création de la base

DROP TABLE PROGRAMME CASCADE CONSTRAINTS;
DROP TABLE ACTIVITE CASCADE CONSTRAINTS;
DROP SEQUENCE NEW_THEME;
DROP SEQUENCE NEW_TERR;
DROP SEQUENCE NEW_PERS;

CREATE TABLE ACTIVITE AS
(
    SELECT  cdAct, 
            libAct AS nomAct
    FROM    TESTSAELD.ACTIVITE
);

ALTER TABLE ACTIVITE ADD (
    CONSTRAINT PK_ACTIVITE PRIMARY KEY (cdAct));

--CREATE TABLE ACTIVITE 
--(
--    cdAct       CHAR(5),
--    nomAct      VARCHAR2(20),
--    CONSTRAINT PK_ACTIVITE PRIMARY KEY (cdAct)
--);

CREATE TABLE PROGRAMME
(
    cdAct       CHAR(5),
    cdSite      CHAR(5),
    tpPublic    CHAR(4),
    CONSTRAINT PK_PROGRAMME PRIMARY KEY (cdAct, cdSite),
    CONSTRAINT FK_REPERTORIER FOREIGN KEY (cdSite)
        REFERENCES SITE (cdSite),
    CONSTRAINT FK_INCLURE FOREIGN KEY (cdAct)
        REFERENCES ACTIVITE (cdAct),
    CONSTRAINT  CKC_TPPUBLIC CHECK (tpPublic in ('TOUS', '+18', '+10', '+5'))
);

ALTER TABLE PARTICIPANT ADD dateNais DATE;

ALTER TABLE EVENEMENT ADD dureeEv GENERATED ALWAYS AS (dateFinEv - dateDebEv) VIRTUAL;

ALTER TABLE THEME ADD CONSTRAINT THEME_UNIQUE UNIQUE (libThme);

CREATE INDEX FK_THEME ON SITE (cdTheme);
CREATE INDEX FK_TERR ON SITE (cdTerr);
CREATE INDEX FK_SITE ON EVENEMENT (cdSite);
CREATE INDEX FK_EVENT ON RESERVATION (cdSite, numEv);
CREATE INDEX FK_PARTI ON RESERVATION (cdPers);
CREATE INDEX SITES ON SITE (nomSite);
CREATE INDEX NAME ON PARTICIPANT (nomPers, prenomPers);
CREATE INDEX ACTI ON ACTIVITE (nomAct);

--3 Chargement de la base Vidéothèque

--a) Tables THEME et TERRITOIRE

CREATE SEQUENCE NEW_THEME
    INCREMENT BY 1
    START WITH 1;

INSERT INTO THEME (cdTheme, libTheme)
VALUES (NEW_THEME.NEXTVAL, 'Animaux');
INSERT INTO THEME (cdTheme, libTheme)
VALUES (NEW_THEME.NEXTVAL, 'Sport');
INSERT INTO THEME (cdTheme, libTheme)
VALUES (NEW_THEME.NEXTVAL, 'Bateaux');
INSERT INTO THEME (cdTheme, libTheme)
VALUES (NEW_THEME.NEXTVAL, 'Ferme pédagogique');
INSERT INTO THEME (cdTheme, libTheme)
VALUES (NEW_THEME.NEXTVAL, 'Parcs et jardins');
INSERT INTO THEME (cdTheme, libTheme)
VALUES (NEW_THEME.NEXTVAL, 'Jeux pour enfants');
INSERT INTO THEME (cdTheme, libTheme)
VALUES (NEW_THEME.NEXTVAL, 'Patrimoine');
INSERT INTO THEME (cdTheme, libTheme)
VALUES (NEW_THEME.NEXTVAL, 'Parcours Sportifs');
INSERT INTO THEME (cdTheme, libTheme)
VALUES (NEW_THEME.NEXTVAL, 'Golf');
INSERT INTO THEME (cdTheme, libTheme)
VALUES (NEW_THEME.NEXTVAL, 'Sports nautiques');
INSERT INTO THEME (cdTheme, libTheme)
VALUES (NEW_THEME.NEXTVAL, 'Parc d attractions');

CREATE SEQUENCE NEW_TERR
    INCREMENT BY 1
    START WITH 1;

INSERT INTO TERRITOIRE (cdTerr, nomTerr)
    VALUES (NEW_TERR.NEXTVAL, 'Autour du Louvres - Lens');
INSERT INTO TERRITOIRE (cdTerr, nomTerr)
    VALUES (NEW_TERR.NEXTVAL, 'Vallées et Marais');
INSERT INTO TERRITOIRE (cdTerr, nomTerr)
    VALUES (NEW_TERR.NEXTVAL, 'Côte d opale');
    
--b

CREATE SEQUENCE NEW_PERS
    INCREMENT BY 1
    START WITH 1;
    
--Ici, je n'insère pas les numéros car dans TESTS1.EMPRUNTER, les numéros sont codés sur 14 caractères.
    
INSERT INTO PARTICIPANT (cdPers, nomPers, prenomPers, adrPers, villePers, tpPers, datenais)
SELECT  NEW_PERS.NEXTVAL,
        nomPers,
        prenomPers,
        adrPers,
        villePers,
        tpPers,
        datenais
FROM    TESTS1.EMPRUNTEUR;

INSERT INTO PARTICIPANT (cdPers, nomPers, prenomPers, adrPers, tpPers, datenais)
SELECT  NEW_PERS.NEXTVAL,
        nom,
        prnm,
        adr,
        'P',
        datns
FROM TESTS1.CLIENT;

INSERT INTO RESERVATION ();





    
    