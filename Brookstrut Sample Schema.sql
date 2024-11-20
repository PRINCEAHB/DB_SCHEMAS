Brookstrut Sample Schema
Script Name:Brookstrut Sample Schema
Description:Sample basic store, products, purchases schema with ability to generate data.
Oracle
Statement 1
create sequence bs_demo_seq
Sequence created.
Statement 2
create table bs_demo_event_log (  
    id            number  
                  constraint bs_demo_event_log_pk  
                  primary key,  
    log_seq       number not null,  
    event_type    varchar2(255) not null  
                  constraint bs_demo_event_event_type_ck  
                  check (event_type in (  
                  'MESSAGE',  
                  'WARNING',  
                  'ERROR')),  
    event_name    varchar2(255),  
    event_detail  varchar2(4000),  
    error_message varchar2(4000),  
    error_trace   clob,  
    created_by    varchar2(255),  
    created_on    timestamp with local time zone,  
    a1            varchar2(4000),  
    a2            varchar2(4000)  
)
Table created.
Statement 3
create or replace trigger biu_bs_demo_event_log 
before insert or update on bs_demo_event_log 
for each row 
begin 
   if :new.id is null then 
       select to_number(sys_guid(),'XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX') into :new.id from dual; 
  end if; 
  if :new.event_type is null then 
     if :new.error_message is not null then 
        :new.event_type := 'ERROR'; 
     else 
        :new.event_type := 'MESSAGE'; 
     end if; 
  end if; 
  if inserting then  
      :new.log_seq := bs_demo_seq.nextval; 
      :new.created_on := localtimestamp; 
      :new.created_by :=user; 
  end if; 
end; 
Trigger created.
Statement 4
create or replace package bs_demo_event_pkg  
as  
procedure log (  
    p_event_name    in varchar2,  
    p_event_type    in varchar2 default null,  
    p_event_detail  in varchar2 default null,  
    p_error_message in varchar2 default null,  
    p_error_trace   in varchar2 default null,  
    p_a1            in varchar2 default null,  
    p_a2            in varchar2 default null  
    );  
end; 
Package created.
Statement 5
create or replace package body bs_demo_event_pkg 
as 
procedure log ( 
    p_event_name    in varchar2, 
    p_event_type    in varchar2 default null, 
    p_event_detail  in varchar2 default null, 
    p_error_message in varchar2 default null, 
    p_error_trace   in varchar2 default null, 
    p_a1            in varchar2 default null, 
    p_a2            in varchar2 default null 
) 
is 
begin 
   
    insert into bs_demo_event_log  
        (event_type, event_name, event_detail, error_message, error_trace, a1, a2) values 
        (p_event_type, p_event_name, p_event_detail, p_error_message, p_error_trace, p_a1, p_a2); 
    commit; 
end log; 
end bs_demo_event_pkg; 
Package Body created.
Statement 6
begin 
    bs_demo_event_pkg.log (p_event_name => 'create table bs_demo_ITEMS', p_error_message => null); 
end; 
Statement processed.
Statement 7
CREATE TABLE  bs_demo_ITEMS (  
    ID                 NUMBER,   
    ROW_VERSION_NUMBER NUMBER,   
    TYPE               VARCHAR2(255) NOT NULL ENABLE,   
    ITEM_NAME          VARCHAR2(60) NOT NULL ENABLE,   
    ITEM_DESC          VARCHAR2(255),   
    MSRP               NUMBER DEFAULT 1 NOT NULL ENABLE,   
    CONSTRAINT bs_demo_ITEMS_PK PRIMARY KEY (ID) ENABLE  
   )
Table created.
Statement 8
CREATE OR REPLACE TRIGGER BIU_bs_demo_ITEMS 
BEFORE INSERT OR UPDATE ON bs_demo_ITEMS 
FOR EACH ROW 
BEGIN 
   if :new.ID is null then 
     select to_number(sys_guid(),'XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX') into :new.id from dual; 
   end if; 
   if inserting then 
       :new.row_version_number := 1; 
   elsif updating then 
       :new.row_version_number := nvl(:old.row_version_number,1) + 1; 
   end if; 
END; 
Trigger created.
Statement 9
begin 
    bs_demo_event_pkg.log (p_event_name => 'create table bs_demo_REGIONS', p_error_message => null); 
end; 
Statement processed.
Statement 10
CREATE TABLE  bs_demo_REGIONS (  
    ID                 NUMBER,   
    ROW_VERSION_NUMBER NUMBER,  
    REGION_NAME        VARCHAR2(255),  
    REGION_ZOOM        VARCHAR2(50),  
    REGION_LAT         NUMBER(9,6),  
    REGION_LNG         NUMBER(9,6),  
    REGION_COLOR       VARCHAR2(7),  
    IS_DEFAULT_YN      VARCHAR2(1),   
    CONSTRAINT bs_demo_REGIONS_PK PRIMARY KEY (ID) ENABLE  
   )
Table created.
Statement 11
CREATE OR REPLACE TRIGGER BIU_bs_demo_REGIONS 
BEFORE INSERT OR UPDATE ON bs_demo_REGIONS 
FOR EACH ROW 
BEGIN 
   if :new.ID is null then 
     select to_number(sys_guid(),'XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX') into :new.id from dual; 
   end if; 
   if inserting then 
       :new.row_version_number := 1; 
   elsif updating then 
       :new.row_version_number := nvl(:old.row_version_number,1) + 1; 
   end if; 
END; 
Trigger created.
Statement 12
CREATE TABLE  bs_demo_STORES (  
    ID                   NUMBER,   
    ROW_VERSION_NUMBER   NUMBER,   
    STORE_NAME           VARCHAR2(255),   
    STORE_TYPE           VARCHAR2(50),   
    STORE_ADDRESS        VARCHAR2(255),   
    STORE_OPEN_DATE      timestamp with local time zone,  
    STORE_CITY           VARCHAR2(50),   
    STORE_STATE          VARCHAR2(50),   
    region_id            number,  
    STORE_ZIP            VARCHAR2(12),   
    STORE_LAT            NUMBER(9,6),   
    STORE_LNG            NUMBER(9,6),   
    n1                   number,  
    n2                   number,  
    n3                   number,  
    n4                   number,  
    CONSTRAINT bs_demo_STORES_PK PRIMARY KEY (ID) ENABLE  
   )
Table created.
Statement 13
CREATE OR REPLACE TRIGGER BIU_bs_demo_STORES 
BEFORE INSERT OR UPDATE ON bs_demo_STORES 
FOR EACH ROW 
BEGIN 
   if :new.ID is null then 
     select to_number(sys_guid(),'XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX') into :new.id from dual; 
   end if; 
   if inserting then 
       :new.row_version_number := 1; 
   elsif updating then 
       :new.row_version_number := nvl(:old.row_version_number,1) + 1; 
   end if; 
   if :new.n1 is null then 
     :new.n1 := round(dbms_random.value(1,1000000)); 
   end if;    
   if :new.n2 is null then 
     :new.n2 := round(dbms_random.value(1,1000000)); 
   end if;    
   if :new.n3 is null then 
     :new.n3 := round(dbms_random.value(1,1000000)); 
   end if; 
   if :new.n4 is null then 
     :new.n4 := round(dbms_random.value(1,1000000)); 
   end if;    
END; 
Trigger created.
Statement 14
CREATE TABLE  bs_demo_SALES_HISTORY (  
    ID             NUMBER,   
    STORE_ID       NUMBER NOT NULL ENABLE,   
    PRODUCT_ID     NUMBER NOT NULL ENABLE,   
    DATE_OF_SALE   TIMESTAMP (6) WITH LOCAL TIME ZONE,   
    QUANTITY       NUMBER DEFAULT 1,   
    TRANSACTION_ID VARCHAR2(30),   
    ITEM_PRICE     NUMBER,   
    created_on     timestamp with local time zone,  
    CONSTRAINT bs_demo_SALES_HISTORY_PK PRIMARY KEY (ID) ENABLE  
   )
Table created.
Statement 15
CREATE OR REPLACE TRIGGER BIU_bs_demo_SALES_HIST  
BEFORE INSERT OR UPDATE ON bs_demo_SALES_HISTORY  
FOR EACH ROW 
BEGIN 
   if :new.ID is null then 
     select to_number(sys_guid(),'XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX') into :new.id from dual; 
   end if; 
   if inserting then :new.created_on := localtimestamp; end if; 
END; 
Trigger created.
Statement 16
CREATE TABLE  bs_demo_STORE_PRODUCTS (  
    ID                 NUMBER,   
    ROW_VERSION_NUMBER NUMBER,   
    STORE_ID           NUMBER,   
    ITEM_ID            NUMBER,   
    SALE_START_DATE    DATE,   
    DISCOUNT_PCT       NUMBER,   
    SALE_END_DATE      DATE,   
    ITEM_PRICE         NUMBER,  
    CONSTRAINT bs_demo_STORE_PRODUCTS_PK PRIMARY KEY (ID) ENABLE  
   )

--Statement 17 Trigger create.
CREATE OR REPLACE TRIGGER BIU_bs_demo_STORE_PRODUCTS 
BEFORE INSERT OR UPDATE ON bs_demo_STORE_PRODUCTS 
FOR EACH ROW 
BEGIN 
   if :new.ID is null then 
     select to_number(sys_guid(),'XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX') into :new.id from dual; 
   end if; 
   if inserting then 
       :new.row_version_number := 1; 
   elsif updating then 
       :new.row_version_number := nvl(:old.row_version_number,1) + 1; 
   end if; 
END; 

Statement 18
ALTER TABLE  bs_demo_STORE_PRODUCTS ADD CONSTRAINT bs_demo_STORE_PRODUCTS_FK1 FOREIGN KEY (ITEM_ID) 
      REFERENCES  bs_demo_ITEMS (ID) ENABLE 
Table altered.
Statement 19
ALTER TABLE  bs_demo_STORE_PRODUCTS ADD CONSTRAINT bs_demo_STORE_PRODUCTS_FK2 FOREIGN KEY (STORE_ID) 
      REFERENCES  bs_demo_STORES (ID) ENABLE 
Table altered.
Statement 20
ALTER TABLE  bs_demo_SALES_HISTORY ADD CONSTRAINT bs_demo_SALES_HISTORY_FK1 FOREIGN KEY (STORE_ID) 
      REFERENCES  bs_demo_STORES (ID) ENABLE 
Table altered.
Statement 21
ALTER TABLE  bs_demo_SALES_HISTORY ADD CONSTRAINT bs_demo_SALES_HISTORY_FK2 FOREIGN KEY (PRODUCT_ID) 
      REFERENCES  bs_demo_ITEMS (ID) ENABLE 
Table altered.
Statement 22
create index bs_demo_STORE_PRODUCTS_i1 on bs_demo_STORE_PRODUCTS (store_id)
Index created.
Statement 23
create index bs_demo_STORE_PRODUCTS_i2 on bs_demo_STORE_PRODUCTS (item_id)
Index created.
Statement 24
create index bs_demo_sales_history_i1 on bs_demo_sales_history (store_id)
Index created.
Statement 25
create index bs_demo_sales_history_i2 on bs_demo_sales_history (product_id)
Index created.
Statement 26
create table bs_demo_hist_gen_log (  
    id             number,  
    APP_SESSION_ID varchar2(255),  
    owner          varchar2(255) not null,  
    num_days       number,  
    max_orders     number,  
    start_time     timestamp with local time zone,  
    end_time       timestamp with local time zone,  
    row_count      number,  
    constraint bs_demo_hist_gen_log_pk primary key ( id )  
    )
Table created.
Statement 27
create or replace trigger bi_bs_demo_hist_gen_log 
    before insert or update on bs_demo_hist_gen_log 
for each row 
declare 
    l_cnt number := null; 
begin 
    if :new.id is null then 
        select to_number(sys_guid(),'XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX') into :new.id from dual; 
    end if; 
    :new.owner := user; 
end; 
Trigger created.
Statement 28
create or replace package bs_demo_sample_data as  
    procedure load;  
    procedure remove;  
    function is_loaded return boolean;  
    procedure load_regions;  
    procedure load_items;  
    procedure load_stores;  
    procedure load_store_products;  
end bs_demo_sample_data; 
Package created.
Statement 29
create or replace package body bs_demo_sample_data  
as 
 
procedure p ( 
i in number, 
s in number, 
ii in number, 
ip in number, 
d number, 
ss in timestamp with local time zone, 
se in timestamp with local time zone) 
is 
begin 
insert into bs_demo_store_products (id, store_id, item_id, item_price, discount_pct, sale_start_date, sale_end_date) values (i,s,ii,ip,d,ss,se); 
commit; 
end; 
 
procedure l ( 
i in number, 
t in varchar2, 
n in varchar2, 
m number, 
d in varchar2) is 
begin 
  insert into bs_demo_items (id, type, item_name, msrp, item_desc) values (i,t,n,m,d); 
  commit; 
end; 
 
procedure s ( 
i in number, 
sn in varchar2, 
st in varchar2, 
sa in varchar2, 
sc in varchar2, 
ss in varchar2, 
sz in varchar2, 
ri in number, 
lt in number, 
lg in number, 
sod in timestamp with local time zone)  
is 
begin 
  insert into bs_demo_stores  
  (id, store_name, store_type, store_address, store_city, store_state, store_zip, region_id, store_lat, store_lng, store_open_date)  
  values (i,sn,st,sa,sc,ss,sz,ri,lt,lg,sod); 
  commit; 
end; 
 
 
procedure load  
is 
begin 
    load_regions; 
    load_items; 
    load_stores; 
    load_store_products; 
end load; 
 
procedure load_regions 
is 
begin 
    bs_demo_event_pkg.log (p_event_name => 'insert bs_demo_regions begin', p_error_message => null); 
    insert into bs_demo_regions 
    (id, region_name, region_zoom, region_lat, region_lng, region_color, is_default_yn ) 
    values 
    (1, 'San Francisco', 13, 37.8, -122.4, '#FE523A', null); 
insert into bs_demo_regions 
    (id, region_name, region_zoom, region_lat, region_lng, region_color, is_default_yn ) 
    values 
    (2, 'Boston Area', 10, 42.324789, -71.083448, '#598BC9', 'Y'); 
insert into bs_demo_regions 
    (id, region_name, region_zoom, region_lat, region_lng, region_color, is_default_yn ) 
    values 
    (3, 'Chicago Area', 11, 41.95, -87.8, '#169928', null); 
    bs_demo_event_pkg.log (p_event_name => 'insert bs_demo_regions end', p_error_message => null); 
    commit; 
end load_regions; 
 
procedure load_items 
is 
begin 
bs_demo_event_pkg.log (p_event_name => 'insert  bs_demo_items begin', p_error_message => null); 
l(1, 'Food', 'Coconut Water', 7.5, 'Refreshing Coconut Water from NuttyH2O'); 
l(2, 'Food', 'Free range Beef', 25, 'Home, home on that free range'); 
l(3, 'Soap', 'Dr. Bronners Liquid Soap', 4.99, 'One world - Now!'); 
l(4, 'Soap', 'Aloe Vera Pure', 3.25, 'Gentlest on your skin'); 
l(5, 'Food', 'Macademia nuts', 9.99, 'Fresh from the Hawaiian Islands'); 
l(6, 'Food', 'Rea-Dee Protein Bars', 11.99, 'Make you strong like ox.'); 
l(7, 'Miscellaneous', 'Tennis Balls', 6, 'Can of 3'); 
bs_demo_event_pkg.log (p_event_name => 'insert  bs_demo_items end', p_error_message => null); 
commit; 
end; 
 
procedure load_stores 
is 
begin 
bs_demo_event_pkg.log (p_event_name => 'insert bs_demo_stores begin', p_error_message => null); 
s(1, 'All U Can Eat', 'Branch', '1000 California St', 'San Francisco', 'CA', '94108', 1, 37.79226, -122.411397, to_date('23-AUG-2010', 'DD-MON-YYYY')); 
s(2, 'Holistic Foods of San Francicso', 'Branch', '1221 Fell St', 'San Francisco', 'CA', '94117', 1, 37.773862, -122.438354, to_date('04-FEB-2011', 'DD-MON-YYYY')); 
s(3, 'Moscone Store', 'Branch', '800 Howard St', 'San Francisco', 'CA', '94103',  1, 37.783197, -122.403445, to_date('11-JUN-2011', 'DD-MON-YYYY')); 
s(4, 'Holistic Foods - Sacramento St.', 'Competitor', '1 Sacramento Street', 'San Francisco', 'CA', '94108',  1, 37.793025, -122.409409, to_date('04-JAN-2007', 'DD-MON-YYYY')); 
s(5, 'Mission Eats of San Francicso', 'Branch', '154 Lombard St', 'San Francisco', 'CA', '94111',  1, 37.80445, -122.404178, to_date('04-JAN-2010', 'DD-MON-YYYY')); 
s(6, 'Holistic Foods - Hayes', 'Competitor', '301 Hayes St', 'San Francisco', 'CA', '94102',  1, 37.776981, -122.421451, to_date('04-MAY-2009', 'DD-MON-YYYY')); 
s(7, 'Stop and Buy', 'Competitor', '12 Main St', 'Cambridge', 'MA', '02142',  2, 42.361811, -71.080314, to_date('04-JAN-2010', 'DD-MON-YYYY')); 
s(8, 'Big Yellow Dog', 'Branch', '987 West St', 'Boston', 'MA', '02136',  2, 42.271113, -71.131913, sysdate-2); 
s(9, 'Holistic Foods - Lexington', 'Branch', '187 Massachusetts Ave', 'Lexington', 'MA', '02421', 2, 42.426179, -71.196743, to_date('04-APR-2011', 'DD-MON-YYYY')); 
s(10, 'Big Grab', 'Branch', '5500 Pearl St', 'Rosemont', 'IL', '60018', 3, 41.978683, -87.872729, to_date('04-JUL-2011', 'DD-MON-YYYY')); 
s(11, 'Central Supply', 'Branch', '5100 W Harrison St', 'Chicago', 'IL', '60644',3, 41.872867, -87.752103, to_date('27-MAR-2002', 'DD-MON-YYYY')); 
s(12, 'The Warehouse', 'Competitor', '4015 N Western Ave', 'Chicago', 'IL', '60618', 3, 41.954396, -87.688393, sysdate-70); 
s(13, 'Big Al', 'Branch', '640 S Clark St', 'Chicago', 'IL', '60605', 3, 41.873792, -87.630648, sysdate-28); 
bs_demo_event_pkg.log (p_event_name => 'insert bs_demo_stores end', p_error_message => null); 
end; 
 
procedure load_store_products 
is 
begin 
bs_demo_event_pkg.log (p_event_name => 'insert bs_demo_store_products begin', p_error_message => null); 
p(1, 1, 1, 8, null, null, null); 
p(2, 1, 2, 30, null, null, null); 
p(3, 1, 4, 3.75, null, null, null); 
p(4, 1, 5, 12.50, null, null, null); 
p(5, 1, 6, 14.95, null, null, null); 
p(6, 1, 3, null, null, null, null); 
p(7, 2, 4, 4.25, 20, to_date('04-FEB-2011', 'DD-MON-YYYY'), to_date('04-FEB-2011', 'DD-MON-YYYY')+4); 
p(8, 2, 1, null, 15, to_date('04-FEB-2011', 'DD-MON-YYYY'), to_date('04-FEB-2011', 'DD-MON-YYYY')+7); 
p(9, 3, 3, null, 15, to_date('11-JUN-2011', 'DD-MON-YYYY'), to_date('11-JUN-2011', 'DD-MON-YYYY')+5); 
p(10, 3, 5, null, 15, to_date('11-JUN-2011', 'DD-MON-YYYY'), to_date('11-JUN-2011', 'DD-MON-YYYY')+5); 
p(11, 3, 6, null, 15, to_date('11-JUN-2011', 'DD-MON-YYYY'), to_date('11-JUN-2011', 'DD-MON-YYYY')+5); 
p(12, 3, 2, 20, null, to_date('11-JUN-2011', 'DD-MON-YYYY'), to_date('11-JUN-2011', 'DD-MON-YYYY')+5); 
p(13, 4, 1, 8.95, null, null, null); 
p(14, 4, 5, 8.50, null, null, null); 
p(15, 4, 6, 9.99, null, null, null); 
p(16, 5, 4, null, null, null, null); 
p(17, 5, 5, null, 10, to_date('04-JAN-2010', 'DD-MON-YYYY'), to_date('04-JAN-2010', 'DD-MON-YYYY')+4); 
p(18, 6, 1, 7.35, null, null, null); 
p(19, 7, 1, 7.75, null, null, null); 
p(20, 7, 2, 27, null, null, null); 
p(21, 7, 7, 5.50, null, null, null); 
p(22, 8, 1, 8.5, null, null, null); 
p(23, 8, 2, 26, null, null, null); 
p(24, 8, 3, 5.99, null, null, null); 
p(25, 8, 4, 3.50, null, null, null); 
p(26, 8, 5,10.99, null, null, null); 
p(27, 8, 6, 12.99, null, null, null); 
p(28, 8, 7, 7, null, null, null); 
p(29, 9, 2, null, null, null, null); 
p(30, 9, 3, null, null, null, null); 
p(31, 9, 4, null, null, null, null); 
p(32, 9, 5, null, null, null, null); 
p(33, 10, 1, null, null, null, null); 
p(34, 10 , 4, null, null, null, null); 
p(35, 10, 5, null, null, null, null); 
p(36, 10, 7, null, null, null, null); 
p(37, 11, 1, null, null, null, null); 
p(38, 11, 4, null, null, null, null); 
p(39, 11, 5, null, null, null, null); 
p(40, 11, 7, null, null, null, null); 
p(41, 12, 2, 23.95, null, null, null); 
p(42, 12, 4, 2.95, null, null, null); 
p(43, 12, 6, 9.95, null, null, null); 
p(44, 12, 7, 4.95, null, null, null); 
p(45, 13, 1, null, null, null, null); 
p(46, 13, 2, null, null, null, null); 
p(47, 13, 5, null, null, null, null); 
bs_demo_event_pkg.log (p_event_name => 'insert bs_demo_store_products end', p_error_message => null); 
end; 
 
procedure remove  
is 
begin 
  delete from bs_demo_sales_history where store_id < 100 or product_id < 100; 
  commit; 
  delete from bs_demo_store_products where id < 100; 
  commit; 
  delete from bs_demo_stores where id < 100; 
  commit; 
  delete from bs_demo_items where id < 100; 
  commit; 
  delete from bs_demo_regions where id < 100; 
  commit; 
exception 
  when others then 
  if sqlcode <> -2292 then 
      raise; 
  end if; 
end remove; 
 
function is_loaded return boolean is 
   l_cnt number := 0; 
begin 
  select count(*) into l_cnt from bs_demo_regions where id < 100; 
  if l_cnt > 0 then return true; end if; 
  select count(*) into l_cnt from bs_demo_items where id < 100; 
  if l_cnt > 0 then return true; end if; 
  select count(*) into l_cnt from bs_demo_stores where id < 100; 
  if l_cnt > 0 then return true; end if; 
  select count(*) into l_cnt from bs_demo_store_products where id < 100; 
  if l_cnt > 0 then return true; end if; 
  return false; 
end is_loaded; 
 
end bs_demo_sample_data; 
Package Body created.
Statement 30
show errors 
Unsupported Command
Statement 31
create or replace package bs_demo_gen_data_pkg 
is 
    g_i               number := null; 
    g_store_count     integer := null; 
    g_transaction     varchar2(255) := null; 
    g_item_id         number := null; 
    g_qty             number := null; 
    g_price           number := null; 
    g_progress        number := 0; 
    g_context         varchar2(4000) := null; 
    g_insert_count    integer := 0; 
     
function generate_transaction  
    return number; 
 
procedure bs_demo_gen_sales_data ( 
    p_days      in number default 90, -- 365 
    p_orders    in number default 50, -- 500 
    p_truncate  in varchar2 default 'Y', 
    p_max_stores in number default 500, 
    p_max_rows   in number default 0 
); 
 
procedure exec_100_transactions; 
 
end; 
Package created.
Statement 32
show errors 
Unsupported Command
Statement 33
create or replace package body bs_demo_gen_data_pkg   
is   
    g_last_history_id number;   
  
function v (  
    p_item in varchar2)  
    return varchar2  
is  
begin   
   -- if running with an apex enabled schema remove this function  
   return null;  
end;  
   
function generate_transaction    
    return number   
is   
begin   
    bs_demo_gen_sales_data (   
       p_days => 1,   
       p_orders => 1,   
       p_truncate => 'N',   
       p_max_stores => 1   
       );   
    commit;   
    return g_last_history_id;   
end generate_transaction;   
   
procedure bs_demo_gen_sales_data (   
    p_days       in number default 90, -- 365   
    p_orders     in number default 50, -- 500   
    p_truncate   in varchar2 default 'Y',   
    p_max_stores in number default 500,   
    p_max_rows   in number default 0   
)   
as   
    cursor log_csr is   
        select owner, start_time, to_char(start_time,'YYYY.MM.DD HH24:MI:SS') start_txt   
        from bs_demo_hist_gen_log   
        where start_time is not null   
            and end_time is null;   
    log_rec log_csr%ROWTYPE;   
    l_log_id number;   
   
    l_date timestamp with local time zone;   
    l_transaction varchar2(30);   
    l_order number;   
    i number;   
    l_qty number;   
    l_item_price number;   
    l_app_user   varchar(255);   
    l_history_id number;   
    l_max_stores number;   
    l_store_count integer := 0;   
    l_product_count integer := 0;   
    x number;   
    l_app_session varchar2(255);   
    l_error_trace varchar2(32767);   
    l_continue    boolean := true;   
    l_max_rows    integer := 0;   
begin   
    l_max_rows := nvl(p_max_rows,0);   
    g_insert_count := 0;   
    g_progress := 1;   
    l_max_stores := nvl(p_max_stores,100);   
    l_app_user := v('APP_USER');   
    l_app_user := v('APP_SESSION');   
    g_progress := 2;   
   
       
    g_progress := 3;   
    insert into bs_demo_hist_gen_log ( owner, start_time, num_days, max_orders )   
    values ( l_app_user, localtimestamp, p_days, p_orders )   
    returning id into l_log_id;   
   
    if nvl(p_truncate,'N') = 'Y' then   
        bs_demo_event_pkg.log(p_event_name => 'about to truncate bs_demo_sales_history table');   
        execute immediate 'truncate table bs_demo_sales_history';   
    end if;   
   
    x := round(dbms_random.value(1,4));   
    g_progress := 4;   
    for i in 1..greatest(p_days,1) loop   
        g_progress := 5;   
        g_context := 'i='||i;   
        l_date := localtimestamp - numtodsinterval(i-1,'day');   
           
        g_i := i;   
        -- walk every store for the date   
        l_store_count := 0;   
   
        for s in (select id, region_id, decode(x,1,n1,2,n2,3,n3,4,n4,id) x   
                  from bs_demo_stores   
                  where STORE_OPEN_DATE <= l_date   
                  and store_type <> 'Competitor'    
                  order by 3) loop   
            g_progress := 6;   
            g_context := 'i='||i||', store_id='||s.id;   
            l_store_count := l_store_count + i;   
            g_store_count := l_store_count;   
            if l_store_count > l_max_stores then exit; end if;   
            g_last_history_id := null;   
            -- make 0 to p_orders 500 orders for this date in the store   
            g_transaction := null;   
            for l_order in 1..greatest(round(dbms_random.value(0,p_orders)),1) loop   
                g_progress := 7;   
                g_context := 'i='||i||', store_id='||s.id||', l_order_id='||l_order;   
                -- something unique for a transaction id   
                l_transaction := to_char(l_date,'YYYYMMDD') || '-'|| l_order ;   
                g_transaction := l_transaction;   
                -- add a weight to sales items to give a higher chance they are sold   
                g_item_id := null;   
                for p in (select id, item_id, item_price,   
                            case when l_date between sale_start_date and sale_end_date then 3   
                            else 1 end weight   
                        from bs_demo_store_products   
                        where store_id = s.id ) loop   
                    g_progress := 8;   
                    l_product_count := l_product_count + 1;   
                    g_context := 'i='||i||', store_id='||s.id||', l_order_id='||l_order||', product_id='||p.id||', l_product_count='||l_product_count;   
                    if p_orders = 1 and l_product_count > 1 then exit; end if;   
                    g_item_id := p.item_id;   
                    -- for none sale items a 50/50 on sale   
                    -- for sale items its 3/4 chance   
                    -- for one transaction orders buy 1 anyway   
                    g_qty := null;   
                    g_price := null;   
                    g_progress := 8;   
                    if ( round(dbms_random.value(0,p.weight)) != 0 ) or (p_days = 1 and p_orders = 1) then   
                        -- pick how many to buy   
                        l_qty := greatest(round(dbms_random.value(1,10)),1);   
                        g_qty := l_qty;   
                        -- if store discount price null, use msrp price   
                        if p.item_price is null then   
                            for c1 in (select msrp from bs_demo_items where id = p.item_id) loop   
                                l_item_price := c1.msrp;   
                            end loop;   
                        else   
                            l_item_price := p.item_price;   
                        end if;   
                        g_price := l_item_price;   
                        -- order it up   
                        g_progress := 9;   
                        insert into bs_demo_sales_history(   
                            store_id,product_id,date_of_sale,quantity,transaction_id,item_price)   
                        values   
                            (s.id,p.item_id,l_date,l_qty,l_transaction,l_item_price)   
                        returning id into g_last_history_id;   
                        g_insert_count := g_insert_count +1;   
                        if l_max_rows != 0 and g_insert_count >= nvl(l_max_rows,5000) then   
                            l_continue := false;   
                        end if;   
                    end if;   
                    if not l_continue then exit; end if;   
                end loop;   
                commit;   
                g_progress := 10;   
                if not l_continue then exit; end if;   
            end loop;   
            if not l_continue then exit; end if;   
        end loop;   
        if not l_continue then exit; end if;   
    end loop;   
    g_progress := 100;   
    update bs_demo_hist_gen_log   
    set end_time = localtimestamp, row_count = g_insert_count   
    where id = l_log_id;   
    commit;   
   
exception   
    when others then   
    --l_error_trace := dbms_utility.format_error_backtrace;   
    bs_demo_event_pkg.log (p_event_name => 'error executing bs_demo_gen_sales_data', p_error_message => sqlerrm, p_error_trace => l_error_trace, p_a1=>g_progress, p_a2=>g_context);   
        if l_log_id is not null then   
            update bs_demo_hist_gen_log   
            set end_time = localtimestamp, row_count = g_insert_count   
            where id = l_log_id;   
        end if;   
        raise;   
end bs_demo_gen_sales_data;   
   
procedure exec_100_transactions   
is   
   x number;   
   l_found boolean;   
begin   
for i in 1..100 loop   
   x :=  generate_transaction;   
   
   l_found := false;   
   for c1 in (select id,   
                     store_id,    
                     created_on,   
                     product_id,    
                     quantity,    
                     item_price,   
                     date_of_sale,   
                     (select store_name    
                      from bs_demo_stores s    
                      where s.id = h.store_id) store,   
                     (select item_Name from bs_demo_items i   
                      where i.id = h.product_id) product   
              from bs_demo_sales_history h   
              where id = x) loop   
     dbms_output.put_line('Transaction: '||to_char(i));   
     dbms_output.put_line('ID: '||c1.id);   
     dbms_output.put_line('Store: '||c1.store);   
     dbms_output.put_line('Product: '||c1.product);   
     dbms_output.put_line('Date of Sale: '||to_char(c1.date_of_sale,'DD-MON-YYYY HH24:MI:SS'));   
     dbms_output.put_line('Date of Posting: '||to_char(c1.created_on,'DD-MON-YYYY HH24:MI:SS'));   
     dbms_output.put_line('Quantity: '||to_char(c1.quantity,'999G999G999G990'));   
     dbms_output.put_line('Price: '||to_char(c1.item_price,'$999G999G999G990D00'));   
     dbms_output.put_line('Sale: '||to_char(c1.item_price * c1.quantity,'$999G999G999G990D00'));   
     l_found := true;   
   end loop;   
     if not l_found then    
         dbms_output.put_line('Transaction: '||to_char(i));   
         dbms_output.put_line('Day loop: '||bs_demo_gen_data_pkg.g_i);   
         dbms_output.put_line('Store loop: '||bs_demo_gen_data_pkg.g_store_count);   
         dbms_output.put_line('Item ID: '||bs_demo_gen_data_pkg.g_item_id);   
         dbms_output.put_line('Quantity: '||bs_demo_gen_data_pkg.g_qty);   
         dbms_output.put_line('Attempted Transaction: '||bs_demo_gen_data_pkg.g_transaction);   
         dbms_output.put_line('Order request did not result in order being processed');   
     end if;   
     commit;   
end loop;   
end exec_100_transactions;   
   
end; 
Package Body created.
Statement 34
begin 
    bs_demo_event_pkg.log (p_event_name => 'load sample data starting', p_error_message => null); 
    bs_demo_sample_data.load(); 
    bs_demo_event_pkg.log (p_event_name => 'load sample data completed', p_error_message => null); 
    commit; 
exception when others then 
    bs_demo_event_pkg.log (p_event_name => 'error loading sample data', p_error_message => sqlerrm); 
end; 
Statement processed.
Statement 35
begin 
    for j in 1..4 loop 
    for c1 in (select count(*) c from bs_demo_regions) loop 
        if c1.c = 0 then  
            begin 
               bs_demo_event_pkg.log (p_event_name => 'retry loading regions '||j, p_error_message => null); 
               bs_demo_sample_data.load_regions; 
            exception when others then 
               bs_demo_event_pkg.log (p_event_name => 'error loading regions '||j, p_error_message => sqlerrm); 
            end; 
        end if; 
    end loop; 
    end loop; 
end; 
Statement processed.
Statement 36
begin 
    for j in 1..4 loop 
    for c1 in (select count(*) c from bs_demo_items) loop 
        if c1.c = 0 then  
            begin 
               bs_demo_event_pkg.log (p_event_name => 'retry loading items '||j, p_error_message => null); 
               bs_demo_sample_data.load_items; 
            exception when others then 
               bs_demo_event_pkg.log (p_event_name => 'error loading items '||j, p_error_message => sqlerrm); 
            end; 
        end if; 
    end loop; 
    end loop; 
end; 
Statement processed.
Statement 37
begin 
    for j in 1..4 loop 
    for c1 in (select count(*) c from bs_demo_stores) loop 
        if c1.c = 0 then  
            begin 
               bs_demo_event_pkg.log (p_event_name => 'retry loading stores '||j, p_error_message => null); 
               bs_demo_sample_data.load_stores; 
            exception when others then 
               bs_demo_event_pkg.log (p_event_name => 'error loading stores '||j, p_error_message => sqlerrm); 
            end; 
        end if; 
    end loop; 
    end loop; 
end; 
Statement processed.
Statement 38
begin 
    for j in 1..4 loop 
    for c1 in (select count(*) c from bs_demo_store_products) loop 
        if c1.c = 0 then  
            begin 
               bs_demo_event_pkg.log (p_event_name => 'retry loading products '||j, p_error_message => null); 
               bs_demo_sample_data.load_store_products; 
            exception when others then 
               bs_demo_event_pkg.log (p_event_name => 'error loading products '||j, p_error_message => sqlerrm); 
            end; 
        end if; 
    end loop; 
    end loop; 
end; 
Statement processed.
Statement 39
declare 
    t varchar(32767) := null; 
begin 
    bs_demo_event_pkg.log (p_event_name => 'transaction generation starting, attempt 1', p_error_message => null); 
    bs_demo_gen_data_pkg.bs_demo_gen_sales_data ( 
        p_days      =>365, 
        p_orders    => 5, 
        p_truncate  =>'N'); 
    bs_demo_event_pkg.log (p_event_name => 'transaction generation completed', p_error_message => null); 
exception when others then 
    --t := dbms_utility.format_error_backtrace; 
    bs_demo_event_pkg.log (p_event_name => 'error gennerating data', p_error_message => sqlerrm, p_error_trace=>t); 
    raise; 
end; 
Statement processed.
Statement 40
alter package bs_demo_gen_data_pkg compile body
Package altered.
Statement 41
select count(*) bs_demo_ITEMS_COUNT from bs_demo_ITEMS
 
BS_DEMO_ITEMS_COUNT
7
Statement 42
select count(*) bs_demo_REGIONS_COUNT from bs_demo_REGIONS
 
BS_DEMO_REGIONS_COUNT
3
Statement 43
select count(*) bs_demo_STORES_COUNT from bs_demo_STORES
 
BS_DEMO_STORES_COUNT
13
Statement 44
select count(*) bs_demo_STORE_PRODUCTS_C from bs_demo_STORE_PRODUCTS
 
BS_DEMO_STORE_PRODUCTS_C
47
Statement 45
select count(*) bs_demo_SALES_HISTORY_CNT from bs_demo_SALES_HISTORY
 
BS_DEMO_SALES_HISTORY_CNT
5068
