drop table EVENEMENT cascade constraints;

drop table PARTICIPANT cascade constraints;

drop table RESERVATION cascade constraints;

drop table SITE cascade constraints;

drop table TERRITOIRE cascade constraints;

drop table THEME cascade constraints;

--Generation des tables

/*==============================================================*/
/* Table : THEME                                                */
/*==============================================================*/
create table THEME 
(
   cdTheme              NUMBER(38),
   libTheme              VARCHAR2(50),
   constraint PK_THEME primary key (cdTheme)
);

/*==============================================================*/
/* Table : TERRITOIRE                                           */
/*==============================================================*/
create table TERRITOIRE 
(
   cdTerr               NUMBER(38),
   nomTerr              VARCHAR2(30),
   constraint PK_TERRITOIRE primary key (cdTerr)
);

/*==============================================================*/
/* Table : SITE                                                 */
/*==============================================================*/
create table SITE 
(
   cdSite               NUMBER(38),
   nomSite              VARCHAR2(60),
   tpSite               CHAR(3),
   adrSite              VARCHAR2(50),
   cpSite               CHAR(6),
   villeSite            VARCHAR2(30),
   emailSite            VARCHAR2(30),
   telSite              CHAR(10),
   siteweb              VARCHAR2(50),
   cdTerr               NUMBER(38)               not null,
   cdTheme              NUMBER(38)               not null,
   constraint PK_SITE primary key (cdSite),
   constraint FK_SITE_POSSEDER_THEME foreign key (cdTheme)
      references THEME (cdTheme),
   constraint FK_SITE_INCLURE_TERRITOI foreign key (cdTerr)
      references TERRITOIRE (cdTerr)
);

/*==============================================================*/
/* Table : EVENEMENT                                            */
/*==============================================================*/
create table EVENEMENT 
(
   numEv                NUMBER(38),
   cdSite               NUMBER(38),
   dateDebEv            DATE,
   dateFinEv            DATE,
   nbPlaces             NUMBER(5),
   tarif                FLOAT,
   constraint PK_EVENEMENT primary key (numEv, cdSite),
   constraint CKC_NBPLACES check (nbPlaces >= 20),
   constraint CKC_dateFinEv check (dateFinEv IS NULL or dateFinEv > dateDebEv),
   constraint FK_EVENEMEN_PRENDRE_SITE foreign key (cdSite)
      references SITE (cdSite)
);

/*==============================================================*/
/* Table : PARTICIPANT                                          */
/*==============================================================*/
create table PARTICIPANT 
(
   cdPers               NUMBER(38),
   nomPers              VARCHAR(20),
   prenomPers           VARCHAR(20),
   adrPers              VARCHAR(30),
   cpPers               NUMBER(6),
   villePers            VARCHAR(30),
   telPers              CHAR(10),
   tpPers               CHAR(5),
   constraint PK_PARTICIPANT primary key (cdPers),
   constraint CKC_TPPERS check (tpPers in ('P','C','E'))
);

/*==============================================================*/
/* Table : RESERVATION                                          */
/*==============================================================*/
create table RESERVATION 
(
   dateResa             DATE,
   cdSite               NUMBER(38),
   numEv                NUMBER(38),
   cdPers               NUMBER(38),
   nbPlResa             NUMBER(38)    NOT NULL,
   modeReglt            NUMBER(38),
   constraint PK_RESERVATION primary key (dateResa,cdSite,numEv,cdPers),
   constraint CKC_MODEREGLT_RESERVATION check (modeReglt between 1 and 3),
   --constraint FK_RESERVAT_REFERENCE_SITE foreign key (cdSite)
      --references SITE (cdSite),
   constraint FK_RESERVAT_CONCERNER_EVENEMEN foreign key (cdSite, numEv)
      references EVENEMENT (cdSite, numEv),
   constraint FK_RESERVAT_APPARTENI_PARTICIP foreign key (cdPers)
      references PARTICIPANT (cdPers)
);

--2 Modification du script de creation de la base

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
    cdSite      NUMBER(38),
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

ALTER TABLE THEME ADD CONSTRAINT THEME_UNIQUE UNIQUE (libTheme);

CREATE INDEX FK_THEME ON SITE (cdTheme);
CREATE INDEX FK_TERR ON SITE (cdTerr);
CREATE INDEX FK_SITE ON EVENEMENT (cdSite);
CREATE INDEX FK_EVENT ON RESERVATION (cdSite, numEv);
CREATE INDEX FK_PARTI ON RESERVATION (cdPers);
CREATE INDEX SITES ON SITE (nomSite);
CREATE INDEX NAME ON PARTICIPANT (nomPers, prenomPers);
CREATE INDEX ACTI ON ACTIVITE (nomAct);

--3 Chargement de la base Videotheque

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
VALUES (NEW_THEME.NEXTVAL, 'Ferme pï¿½dagogique');
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
    VALUES (NEW_TERR.NEXTVAL, 'Vallï¿½es et Marais');
INSERT INTO TERRITOIRE (cdTerr, nomTerr)
    VALUES (NEW_TERR.NEXTVAL, 'Cï¿½te d opale');
    
--b

CREATE SEQUENCE NEW_PERS
    INCREMENT BY 1
    START WITH 1;
    
--Ici, je n'insere pas les numeros car dans TESTS1.EMPRUNTER, les numeros sont codes sur 14 caracteres.
    
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

--Pour insérer dans réservation, il nous faut les données de Site, Participant
--et d'évènement, donc l'ordre est le suivant :

INSERT INTO SITE(cdSite, cdTerr, cdTheme, nomSite, tpSite, siteWeb,adrSite, cpSite, villeSite, emailSite)
SELECT  cdSite,
        cdTerr,
        cdTheme,
        nomSite,
        tpSite,
        siteWeb,
        adrSite,
        cpSite,
        villeSite,
        emailSite
FROM    TESTSAELD.SITE
WHERE   cdTerr IN ( SELECT  cdTerr
                    FROM    TERRITOIRE)
        AND cdTheme IN (SELECT  cdTheme
                        FROM    THEME);

INSERT INTO EVENEMENT (numEv, cdSite, dateDebEv, dateFinEv, nbPlaces, tarif)
SELECT  numEv,
        cdSite,
        dateDebEv,
        dateFinEv,
        nbPlaces,
        tarif       
FROM    TESTSAELD.EVENEMENT
WHERE   nbPlaces >= 20
        AND cdSite IN ( SELECT  cdSite
                        FROM    SITE);
        
INSERT INTO RESERVATION (dateResa, cdSite, numEv, cdPers, nbPlResa, modeReglt) 
SELECT  dateInscr AS dateResa,
        cdSite,
        numEv,
        cdPers,
        nbPlResa,
        modeReglt
FROM TESTSAELD.INSCRIPTION
WHERE   cdSite in ( SELECT  cdSite
                    FROM    SITE)
        AND cdPers in ( SELECT  cdPers
                        FROM    PARTICIPANT)
        AND numEv in (  SELECT  numEv
                        FROM    EVENEMENT);

--PACO
--PENSE
--A
--T'AJOUTER
--EN
--PARTICIPANT
--!!!!!!!

--c Tables PROGRAMME



