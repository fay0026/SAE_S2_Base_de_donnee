drop table EVENEMENT cascade constraints;

drop table PARTICIPANT cascade constraints;

drop table RESERVATION cascade constraints;

drop table SITE cascade constraints;

drop table TERRITOIRE cascade constraints;

drop table THEME cascade constraints;

--Génération des tables 

/*==============================================================*/
/* Table : THEME                                                */
/*==============================================================*/
create table THEME 
(
   cdTheme              CHAR(5),
   libThme              VARCHAR2(50),
   constraint PK_THEME primary key (cdTheme)
);

/*==============================================================*/
/* Table : TERRITOIRE                                           */
/*==============================================================*/
create table TERRITOIRE 
(
   cdTerr               CHAR(5),
   nomTerr              VARCHAR2(20),
   constraint PK_TERRITOIRE primary key (cdTerr)
);

/*==============================================================*/
/* Table : SITE                                                 */
/*==============================================================*/
create table SITE 
(
   cdSite               CHAR(5),
   nomSite              VARCHAR2(20),
   tpSite               CHAR(5),
   adrSite              VARCHAR2(30),
   cpSite               NUMBER(6),
   villeSite            VARCHAR2(30),
   emailSite            VARCHAR2(20),
   telSite              CHAR(10),
   siteweb              VARCHAR2(20),
   cdTerr               CHAR(5)               not null,
   cdTheme              CHAR(5)               not null,
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
   numEv                CHAR(5),
   cdSite               CHAR(5),
   dateDebEv            DATE,
   dateFinEv            DATE,
   nbPlaces             NUMBER(5),
   tarif                FLOAT,
   constraint PK_EVENEMENT primary key (numEv, cdSite),
   constraint CKC_NBPLACES check (nbPlaces > 20),
   constraint CKC_dateFinEv check (dateFinEv IS NULL or dateFinEv >= dateDebEv),
   constraint FK_EVENEMEN_PRENDRE_SITE foreign key (cdSite)
      references SITE (cdSite)
);

/*==============================================================*/
/* Table : PARTICIPANT                                          */
/*==============================================================*/
create table PARTICIPANT 
(
   cdPers               CHAR(5),
   nomPers              VARCHAR(20),
   prenomPers           VARCHAR(20),
   adrPers              VARCHAR(20),
   cpPers               NUMBER(6),
   villePers            VARCHAR(20),
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
   cdSite               CHAR(5),
   numEv                CHAR(5),
   cdPers               CHAR(5),
   nbPlResa             NUMBER,
   modeReglt            NUMBER,
   constraint PK_RESERVATION primary key (dateResa,cdSite,numEv,cdPers),
   constraint CKC_MODEREGLT_RESERVATION check (modeReglt between 1 and 3),
   --constraint FK_RESERVAT_REFERENCE_SITE foreign key (cdSite)
      --references SITE (cdSite),
   constraint FK_RESERVAT_CONCERNER_EVENEMEN foreign key (cdSite, numEv)
      references EVENEMENT (cdSite, numEv),
   constraint FK_RESERVAT_APPARTENI_PARTICIP foreign key (cdPers)
      references PARTICIPANT (cdPers)
);



