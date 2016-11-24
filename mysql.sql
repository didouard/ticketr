-- Initial script for DB

DROP DATABASE c9;
CREATE DATABASE c9;

use c9;

CREATE TABLE tbl_ticket
(
  id VARCHAR(30) NOT NULL,
  iduser VARCHAR(30),
  iduserlast VARCHAR(30),
  idsolver VARCHAR(30),
  idsolution VARCHAR(30), -- ID comment
  category VARCHAR(50),
  project VARCHAR(50),
  company VARCHAR(50),
  name VARCHAR(80),
  search VARCHAR(80),
  linker VARCHAR(80),
  language VARCHAR(2),
  labels VARCHAR(200),
  tags VARCHAR(100),
  ip VARCHAR(80),
  countcomments integer DEFAULT 0,
  countupdates integer DEFAULT 0,
  minutes integer DEFAULT 0,
  issolved boolean DEFAULT false,
  ispriority boolean DEFAULT false,
  isremoved boolean DEFAULT false,
  datesolved DATETIME,
  datechanged DATETIME,
  dateupdated DATETIME,
  datecreated timestamp DEFAULT CURRENT_TIMESTAMP,
  CONSTRAINT tbl_ticket_pkey PRIMARY KEY (id)
);

CREATE TABLE tbl_ticket_comment
(
  id VARCHAR(30) NOT NULL,
  idticket VARCHAR(30),
  idparent VARCHAR(30),
  iduser VARCHAR(30),
  search VARCHAR(300),
  ip VARCHAR(80),
  body text,
  countupdates integer DEFAULT 0,
  operation smallint DEFAULT '0',
  isoperation boolean DEFAULT false,
  issolution boolean DEFAULT false,
  isremoved boolean DEFAULT false,
  dateupdated DATETIME,
  datecreated timestamp DEFAULT CURRENT_TIMESTAMP,
  CONSTRAINT tbl_ticket_comment_pkey PRIMARY KEY (id)
)
;

CREATE TABLE tbl_time
(
  id VARCHAR(30) NOT NULL,
  idsolver VARCHAR(30),
  iduser VARCHAR(30),
  idticket VARCHAR(30),
  company VARCHAR(50),
  minutes integer DEFAULT 0,
  minutesuser integer DEFAULT 0,
  day smallint DEFAULT '0',
  month smallint DEFAULT '0',
  year smallint DEFAULT '0',
  datecreated timestamp DEFAULT CURRENT_TIMESTAMP,
  CONSTRAINT tbl_time_pkey PRIMARY KEY (id)
)
;

CREATE TABLE tbl_user
(
  id VARCHAR(30) NOT NULL,
  token VARCHAR(50),
  photo VARCHAR(30),
  name VARCHAR(50),
  search VARCHAR(200),
  language VARCHAR(2),
  firstname VARCHAR(30),
  lastname VARCHAR(30),
  company VARCHAR(50),
  position VARCHAR(50),
  email VARCHAR(200),
  password VARCHAR(60),
  notes VARCHAR(200),
  minutes smallint DEFAULT 0,
  ispriority boolean DEFAULT false,
  isremoved boolean DEFAULT false,
  isconfirmed boolean DEFAULT false,
  iscustomer boolean DEFAULT false,
  isadmin boolean DEFAULT false,
  isnotification boolean DEFAULT false,
  isactivated boolean DEFAULT false,
  countlogins smallint DEFAULT 0,
  countupdates smallint DEFAULT 0,
  datelogged DATETIME,
  dateupdated DATETIME,
  dateconfirmed DATETIME,
  datecreated timestamp DEFAULT CURRENT_TIMESTAMP,
  CONSTRAINT tbl_user_pkey PRIMARY KEY (id)
)
;

CREATE TABLE tbl_user_project
(
  iduser VARCHAR(30),
  company VARCHAR(50),
  name VARCHAR(30)
)
;

CREATE TABLE cdl_project
(
   name VARCHAR(30),
   primary key(name)
);

CREATE TABLE cdl_label
(
   name VARCHAR(30),
   primary key(name)
);

CREATE TABLE cdl_language
(
   name VARCHAR(30),
   primary key(name)
);

CREATE OR REPLACE VIEW view_ticket AS
 SELECT a.id,
    a.name,
    a.project,
    a.search,
    a.labels,
    a.minutes,
    b.name AS "user",
    b.email,
    b.language,
    b.photo,
    b.company,
    a.iduser,
    a.iduserlast,
    a.idsolver,
    a.issolved,
    a.ispriority,
    b.isnotification,
    a.datecreated,
    a.dateupdated,
    b.minutes AS minutesuser,
    a.idsolution,
    b.position,
    a.countcomments
   FROM tbl_ticket a
     JOIN tbl_user b ON b.id = a.iduser
  WHERE a.isremoved = false;


CREATE OR REPLACE VIEW view_ticket_comment AS
 SELECT a.id,
    a.iduser,
    a.idparent,
    a.idticket,
    a.body,
    b.name AS "user",
    b.email,
    b.photo,
    b.language,
    a.isoperation,
    a.datecreated,
    a.dateupdated,
    b.company,
    b.isnotification,
    a.issolution AS issolved,
    a.operation,
    b.position,
    b.iscustomer
   FROM tbl_ticket_comment a
     JOIN tbl_user b ON a.iduser = b.id
  WHERE a.isremoved = false;

CREATE OR REPLACE VIEW view_user AS
 SELECT a.id,
    a.name,
    a.photo,
    a.email,
    a.company,
    a.iscustomer,
    a.minutes,
    a.position,
    a.isactivated,
    a.isconfirmed,
    a.isadmin,
    a.ispriority,
    a.datecreated,
    a.dateupdated,
    a.datelogged,
    ( SELECT sum(tbl_time.minutes) AS sum
           FROM tbl_time
          WHERE (tbl_time.iduser = a.id OR tbl_time.idsolver = a.id) AND tbl_time.year = date_part('year', 'now') AND tbl_time.month = date_part('month', 'now')) AS minutesmonth,
    a.search
   FROM tbl_user a
  WHERE a.isremoved = false;

-- CODELIST
INSERT INTO cdl_label VALUES('bug');
INSERT INTO cdl_label VALUES('duplicate');
INSERT INTO cdl_label VALUES('enhancement');
INSERT INTO cdl_label VALUES('invalid');
INSERT INTO cdl_label VALUES('question');
INSERT INTO cdl_label VALUES('waiting for more info');
INSERT INTO cdl_label VALUES('wontfix');

INSERT INTO cdl_project VALUES('Adminer');
INSERT INTO cdl_project VALUES('Eshop + CMS');
INSERT INTO cdl_project VALUES('HelpDesk');
INSERT INTO cdl_project VALUES('jComponent');
INSERT INTO cdl_project VALUES('OpenPlatform');
INSERT INTO cdl_project VALUES('SuperAdmin');
INSERT INTO cdl_project VALUES('Total.js');

INSERT INTO cdl_language VALUES('en');

-- DEFAULT ADMINISTRATOR
-- login: support@totaljs.com
-- password: 123456
INSERT INTO tbl_user (id, token, name, language, company, position, email, password, isadmin, isconfirmed, isnotification, isactivated) VALUES('16072309220001xlu1', '97z8ctkw16tu11tasmin5iefmmijyr', 'Peter Sirka', '', 'Total.js', 'Developer', 'support@totaljs.com', '7c4a8d09ca3762af61e59520943dc26494f8941b', true, true, true, true);



