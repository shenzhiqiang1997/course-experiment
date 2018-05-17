/*==============================================================*/
/* DBMS name:      ORACLE Version 11g                           */
/* Created on:     2018-5-14 22:00:58                           */
/*==============================================================*/


alter table "book"
   drop constraint FK_BOOK_HAVE_BOOK_LIS;

alter table "book"
   drop constraint FK_BOOK_PUBLISH_PUBLISHI;

alter table "borrow_return_record"
   drop constraint FK_BORROW_R_BOOK_BORR_BOOK;

alter table "borrow_return_record"
   drop constraint FK_BORROW_R_BORROWER__BORROWER;

alter table "order"
   drop constraint FK_ORDER_ORDER_BOOK;

alter table "order"
   drop constraint FK_ORDER_ORDER2_BORROWER;

alter table "write"
   drop constraint FK_WRITE_WRITE_BOOK;

alter table "write"
   drop constraint FK_WRITE_WRITE2_AUTHOR;

drop table "author" cascade constraints;

drop index "have_FK";

drop index "publish_FK";

drop table "book" cascade constraints;

drop table "book_list" cascade constraints;

drop index "borrower_borrow_FK";

drop index "book_borrow_FK";

drop table "borrow_return_record" cascade constraints;

drop table "borrower" cascade constraints;

drop index "order_FK";

drop index "order2_FK";

drop table "order" cascade constraints;

drop table "publishing" cascade constraints;

drop index "write_FK";

drop index "write2_FK";

drop table "write" cascade constraints;

drop sequence "S_book";

drop sequence "S_book_list";

drop sequence "S_borrow_return_record";

create sequence "S_book";

create sequence "S_book_list";

create sequence "S_borrow_return_record";

/*==============================================================*/
/* Table: "author"                                              */
/*==============================================================*/
create table "author" 
(
   "author_id"          CHAR(18)             not null,
   "author_name"        VARCHAR2(30)         not null,
   "author_sex"         CHAR(2),
   "author_location"    VARCHAR2(50),
   "author_tel"         CHAR(11),
   constraint PK_AUTHOR primary key ("author_id")
);

/*==============================================================*/
/* Table: "book"                                                */
/*==============================================================*/
create table "book" 
(
   "book_id"            NUMBER(16)           not null,
   "pub_id"             CHAR(4)              not null,
   "book_list_id"       INTEGER              not null,
   "book_name"          VARCHAR2(30)         not null,
   "book_isbn"          CHAR(21),
   "book_price"         NUMBER(8,2),
   constraint PK_BOOK primary key ("book_id")
);

/*==============================================================*/
/* Index: "publish_FK"                                          */
/*==============================================================*/
create index "publish_FK" on "book" (
   "pub_id" ASC
);

/*==============================================================*/
/* Index: "have_FK"                                             */
/*==============================================================*/
create index "have_FK" on "book" (
   "book_list_id" ASC
);

/*==============================================================*/
/* Table: "book_list"                                           */
/*==============================================================*/
create table "book_list" 
(
   "book_list_id"       NUMBER(16)           not null,
   "book_list_name"     VARCHAR2(30)         not null,
   "book_list_type"     VARCHAR2(20),
   constraint PK_BOOK_LIST primary key ("book_list_id")
);

/*==============================================================*/
/* Table: "borrow_return_record"                                */
/*==============================================================*/
create table "borrow_return_record" 
(
   "borrow_return_id"   NUMBER(32)           not null,
   "book_id"            INTEGER              not null,
   "borrower_id"        CHAR(18)             not null,
   "borrow_return_type" CHAR(4)              not null,
   "borrow_return_time" DATE,
   constraint PK_BORROW_RETURN_RECORD primary key ("borrow_return_id")
);

/*==============================================================*/
/* Index: "book_borrow_FK"                                      */
/*==============================================================*/
create index "book_borrow_FK" on "borrow_return_record" (
   "book_id" ASC
);

/*==============================================================*/
/* Index: "borrower_borrow_FK"                                  */
/*==============================================================*/
create index "borrower_borrow_FK" on "borrow_return_record" (
   "borrower_id" ASC
);

/*==============================================================*/
/* Table: "borrower"                                            */
/*==============================================================*/
create table "borrower" 
(
   "borrower_id"        CHAR(18)             not null,
   "borrower_name"      VARCHAR2(20)         not null,
   "borrower_location"  VARCHAR2(30),
   "borrower_tel"       CHAR(11),
   constraint PK_BORROWER primary key ("borrower_id")
);

/*==============================================================*/
/* Table: "order"                                               */
/*==============================================================*/
create table "order" 
(
   "book_id"            INTEGER              not null,
   "borrower_id"        CHAR(18)             not null,
   "return_deadline"    DATE,
   constraint PK_ORDER primary key ("book_id", "borrower_id")
);

/*==============================================================*/
/* Index: "order2_FK"                                           */
/*==============================================================*/
create index "order2_FK" on "order" (
   "borrower_id" ASC
);

/*==============================================================*/
/* Index: "order_FK"                                            */
/*==============================================================*/
create index "order_FK" on "order" (
   "book_id" ASC
);

/*==============================================================*/
/* Table: "publishing"                                          */
/*==============================================================*/
create table "publishing" 
(
   "pub_id"             CHAR(4)              not null,
   "pub_name"           VARCHAR2(50)         not null,
   "pub_location"       VARCHAR2(50),
   "pub_tel"            VARCHAR2(20),
   constraint PK_PUBLISHING primary key ("pub_id")
);

/*==============================================================*/
/* Table: "write"                                               */
/*==============================================================*/
create table "write" 
(
   "book_id"            INTEGER              not null,
   "author_id"          CHAR(18)             not null,
   ×÷Õß´ÎÐò                 CHAR(16),
   constraint PK_WRITE primary key ("book_id", "author_id")
);

/*==============================================================*/
/* Index: "write2_FK"                                           */
/*==============================================================*/
create index "write2_FK" on "write" (
   "author_id" ASC
);

/*==============================================================*/
/* Index: "write_FK"                                            */
/*==============================================================*/
create index "write_FK" on "write" (
   "book_id" ASC
);

alter table "book"
   add constraint FK_BOOK_HAVE_BOOK_LIS foreign key ("book_list_id")
      references "book_list" ("book_list_id");

alter table "book"
   add constraint FK_BOOK_PUBLISH_PUBLISHI foreign key ("pub_id")
      references "publishing" ("pub_id");

alter table "borrow_return_record"
   add constraint FK_BORROW_R_BOOK_BORR_BOOK foreign key ("book_id")
      references "book" ("book_id");

alter table "borrow_return_record"
   add constraint FK_BORROW_R_BORROWER__BORROWER foreign key ("borrower_id")
      references "borrower" ("borrower_id");

alter table "order"
   add constraint FK_ORDER_ORDER_BOOK foreign key ("book_id")
      references "book" ("book_id");

alter table "order"
   add constraint FK_ORDER_ORDER2_BORROWER foreign key ("borrower_id")
      references "borrower" ("borrower_id");

alter table "write"
   add constraint FK_WRITE_WRITE_BOOK foreign key ("book_id")
      references "book" ("book_id");

alter table "write"
   add constraint FK_WRITE_WRITE2_AUTHOR foreign key ("author_id")
      references "author" ("author_id");

