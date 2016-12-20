set define off;
--------------------------------------------------------
--  File created - Wednesday-December-14-2016   
--------------------------------------------------------
--------------------------------------------------------
--  DDL for View VW_RJS_HARBOR
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "VW_RJS_HARBOR" ("IMAGE_ID", "COORDINATE_ID", "DATA_ID", "C_X", "C_Y", "C_T", "C_X_TEXT", "C_Y_TEXT", "RESULT_TYPE", "TEXT", "TEXT_LENGTH", "MAX_LENGTH", "HARBOR_NAME") AS 
  select 
  k.image_id,
  d.coordinate_id,
  d.id as data_id,
  k.c_x,
  k.c_y,
  k.c_t,
  k.c_x_text,
  k.c_y_text,
  d.result_type,
  d.text,
  d.text_length,
  k.max_length,
  k.NAME
from rjs_coordinate_harbor k, rjs_data_harbor d, (Select 60 b, 19 h from dual) z
where k.id = d.coordinate_id;
--------------------------------------------------------
--  DDL for View VW_RJS_POWER_GRID
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "VW_RJS_POWER_GRID" ("IMAGE_ID", "COORDINATE_ID", "C_M_X", "C_M_Y", "C_L_X", "C_L_Y", "COORDINATE_POWER_GRID_ID_FROM", "COORDINATE_POWER_GRID_ID_TO", "AREA", "STATUS") AS 
  select 
  k.image_id,
  k.id as coordinate_id,
  k.c_m_x,
  k.c_m_y,
  k.c_l_x,
  k.c_l_y,
  k.coordinate_power_grid_id_from,
  k.coordinate_power_grid_id_to,
  k.area,
  k.status
from rjs_coordinate_power_grid k;
--------------------------------------------------------
--  DDL for View VW_RJS_POWER_GRID_DEACTIVATION
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "VW_RJS_POWER_GRID_DEACTIVATION" ("ID", "CREATED_ON", "CREATED_BY", "CHANGED_ON", "CHANGED_BY", "C_M_X", "C_M_Y", "C_L_X", "C_L_Y", "IMAGE_ID", "COORDINATE_POWER_GRID_ID_FROM", "COORDINATE_POWER_GRID_ID_TO", "AREA", "STATUS") AS 
  select s1.id,
  s1.created_on,
  s1.created_by,
  s1.changed_on,
  s1.changed_by,
  s1.c_m_x,
  s1.c_m_y,
  s1.c_l_x,
  s1.c_l_y,
  s1.image_id,
  s1.coordinate_power_grid_id_from,
  s1.coordinate_power_grid_id_to,
  s1.area,
  s1.status
from rjs_coordinate_power_grid s1 
cross join
  (select
     round(dbms_random.value(1,10),0) rnd1,
     round(dbms_random.value(1,10),0) rnd2,
     round(dbms_random.value(1,10),0) rnd3,
     round(dbms_random.value(1,10),0) rnd4
   from dual
  ) rn
inner join 
  (
  select 
  s.c_m_x,
  s.c_m_y,
  s.c_l_x,
  s.c_l_y
  -- Beispiel: to_char(S.C_M_X-4)|| ' - ' ||to_char(S.C_M_X+4) as m_x_bereich,
  from rjs_coordinate_power_grid s
  where s.status = 0
  ) s2
  on (s1.c_m_x between s2.c_m_x-rn.rnd1 and s2.c_m_x+rn.rnd1 and
      s1.c_m_y between s2.c_m_y-rn.rnd2 and s2.c_m_y+rn.rnd2 or
      s1.c_m_x between s2.c_l_x-rn.rnd3 and s2.c_l_x+rn.rnd3 and
      s1.c_m_y between s2.c_l_y-rn.rnd4 and s2.c_l_y+rn.rnd4 or
      s1.c_l_x between s2.c_l_x-rn.rnd1 and s2.c_l_x+rn.rnd1 and
      s1.c_l_y between s2.c_l_y-rn.rnd2 and s2.c_l_y+rn.rnd2 or
      s1.c_l_x between s2.c_m_x-rn.rnd3 and s2.c_m_x+rn.rnd3 and
      s1.c_l_y between s2.c_m_y-rn.rnd4 and s2.c_m_y+rn.rnd4
      )
where s1.status != 0;
--------------------------------------------------------
--  DDL for View VW_RJS_TRAM
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "VW_RJS_TRAM" ("TRAM_ID", "STATION_ID", "STATION_ORDER_NUMBER", "RESULT") AS 
  select 
  tram_id,
  station_id,
  station_order_number,
  
  case 
    when station_order_number = 1
    then 'var tram' || tram_id || ';' || CHR(13) ||
         'var t' || tram_id || 'hs' || station_order_number || ' = SVG.get("#' || station_id || '").rbox();' || CHR(13) ||
         
         'setTimeout(function(){'||
         'tram' || tram_id || ' = draw.polygon(' || station_plot || ').move(t' || tram_id || 'hs' || station_order_number || '.x' || decode(station_x_difference,null,null,'+'||station_x_difference) || ', t' || tram_id || 'hs' || station_order_number || '.y' || decode(station_y_difference,null,null,'+'||station_y_difference) || ').stroke("' || tram_stroke || '").fill("' || tram_fill || '").attr({ id: "tram' || tram_id || '" });'
          ||'}, '||2100*station_order_number||');'
          
    when station_on_map = 1 and station_plot is null
    then 'var t' || tram_id || 'hs' || station_order_number || ' = SVG.get("#' || station_id || '").rbox();' || CHR(13) ||
         
         'setTimeout(function(){'||
         'tram' || tram_id || '.animate({duration: "' || station_duration || 's", ease: "<", delay: "' || /*station_delay*/0 || 's" }).move(t' || tram_id || 'hs' || station_order_number || '.x' || decode(station_x_difference,null,null,'+'||station_x_difference) || ', t' || tram_id || 'hs' || station_order_number || '.y' || decode(station_y_difference,null,null,'+'||station_y_difference) || ').stroke("' || tram_stroke || '").fill("' || tram_fill || '");'
          ||'}, '||2100*station_order_number||');'
          
    when station_on_map = 1 and station_plot is not null
    then 'var t' || tram_id || 'hs' || station_order_number || ' = SVG.get("#' || station_id || '").rbox();' || CHR(13) ||
         
         'setTimeout(function(){'||
         'tram' || tram_id || '.animate({duration: "' || station_duration || 's", ease: "<", delay: "' || 0 || 's" }).plot(' || station_plot || ').move(t' || tram_id || 'hs' || station_order_number || '.x' || decode(station_x_difference,null,null,'+'||station_x_difference) || ', t' || tram_id || 'hs' || station_order_number || '.y' || decode(station_y_difference,null,null,'+'||station_y_difference) || ');'
        ||'}, '||2100*station_order_number||');'
        
    when station_on_map = 0
    then 
         't' || tram_id || 'ap' || station_order_number || 'x = ' || station_x || ';' || CHR(13) ||
         't' || tram_id || 'ap' || station_order_number || 'y = ' || station_y || ';' || CHR(13) ||
         
         'setTimeout(function(){'||
         'tram' || tram_id || '.animate({duration: "' || station_duration || 's", ease: "<", delay: "' || 0 || 's" }).plot(' || station_plot || ').move(t' || tram_id || 'ap' || station_order_number || 'x' || decode(station_x_difference,null,null,'+'||station_x_difference) || ', t' || tram_id || 'ap' || station_order_number || 'y' || decode(station_y_difference,null,null,'+'||station_y_difference) || ');'
        ||'}, '||2100*station_order_number||');'
    else null
    end as result
    
    
    
from RJS_DATA_TRAM_PLAN
order by tram_id, station_order_number;
--------------------------------------------------------
--  DDL for View VW_RJS_TRAM_OLD
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "VW_RJS_TRAM_OLD" ("TRAM_ID", "STATION_ID", "STATION_ORDER_NUMBER", "RESULT") AS 
  select 
  tram_id,
  station_id,
  station_order_number,
  case 
    when station_order_number = 1
    then 'var tram' || tram_id || ';' || CHR(13) ||
         'var t' || tram_id || 'hs' || station_order_number || ' = SVG.get("#' || station_id || '").rbox();' || CHR(13) ||
         'tram' || tram_id || ' = draw.polygon(' || station_plot || ').move(t' || tram_id || 'hs' || station_order_number || '.x' || decode(station_x_difference,null,null,'+'||station_x_difference) || ', t' || tram_id || 'hs' || station_order_number || '.y' || decode(station_y_difference,null,null,'+'||station_y_difference) || ').stroke("' || tram_stroke || '").fill("' || tram_fill || '").attr({ id: "tram' || tram_id || '" });'
    when station_on_map = 1 and station_plot is null
    then 'var t' || tram_id || 'hs' || station_order_number || ' = SVG.get("#' || station_id || '").rbox();' || CHR(13) ||
         'tram' || tram_id || '.animate({duration: "' || station_duration || 's", ease: "<", delay: "' || station_delay || 's" }).move(t' || tram_id || 'hs' || station_order_number || '.x' || decode(station_x_difference,null,null,'+'||station_x_difference) || ', t' || tram_id || 'hs' || station_order_number || '.y' || decode(station_y_difference,null,null,'+'||station_y_difference) || ').stroke("' || tram_stroke || '").fill("' || tram_fill || '");'
    when station_on_map = 1 and station_plot is not null
    then 'var t' || tram_id || 'hs' || station_order_number || ' = SVG.get("#' || station_id || '").rbox();' || CHR(13) ||
         'tram' || tram_id || '.animate({duration: "' || station_duration || 's", ease: "<", delay: "' || station_delay || 's" }).plot(' || station_plot || ').move(t' || tram_id || 'hs' || station_order_number || '.x' || decode(station_x_difference,null,null,'+'||station_x_difference) || ', t' || tram_id || 'hs' || station_order_number || '.y' || decode(station_y_difference,null,null,'+'||station_y_difference) || ');'
    when station_on_map = 0
    then 
         't' || tram_id || 'ap' || station_order_number || 'x = ' || station_x || ';' || CHR(13) ||
         't' || tram_id || 'ap' || station_order_number || 'y = ' || station_y || ';' || CHR(13) ||
         'tram' || tram_id || '.animate({duration: "' || station_duration || 's", ease: "<", delay: "' || station_delay || 's" }).plot(' || station_plot || ').move(t' || tram_id || 'ap' || station_order_number || 'x' || decode(station_x_difference,null,null,'+'||station_x_difference) || ', t' || tram_id || 'ap' || station_order_number || 'y' || decode(station_y_difference,null,null,'+'||station_y_difference) || ');'
    else null
    end as result
  
from RJS_DATA_TRAM_PLAN
order by tram_id, station_order_number
;
--------------------------------------------------------
--  DDL for Table ERR_LOG
--------------------------------------------------------

  CREATE TABLE "ERR_LOG" 
   (	"PROC_NAME" VARCHAR2(200), 
	"ACTION" VARCHAR2(4000), 
	"APP_ID" NUMBER, 
	"APP_PAGE_ID" NUMBER, 
	"APP_USER" VARCHAR2(20), 
	"ORA_ERROR" VARCHAR2(4000), 
	"CUSTOM_ERROR" VARCHAR2(4000), 
	"PARAMETER" VARCHAR2(4000), 
	"TIME_STAMP" DATE
   ) ;
--------------------------------------------------------
--  DDL for Table RJS_COORDINATE_HAND
--------------------------------------------------------

  CREATE TABLE "RJS_COORDINATE_HAND" 
   (	"ID" NUMBER, 
	"CREATED_ON" DATE, 
	"CREATED_BY" VARCHAR2(100), 
	"CHANGED_ON" DATE, 
	"CHANGED_BY" VARCHAR2(100), 
	"TYPE" VARCHAR2(10), 
	"ELEMENT_ID" VARCHAR2(50), 
	"ELEMENT_PARENT_ID" VARCHAR2(50), 
	"CODE" VARCHAR2(4000), 
	"ELEMENT_REAL_PARENT_ID" VARCHAR2(50), 
	"ELEMENT_LEVEL" NUMBER
   ) ;
--------------------------------------------------------
--  DDL for Table RJS_COORDINATE_HARBOR
--------------------------------------------------------

  CREATE TABLE "RJS_COORDINATE_HARBOR" 
   (	"ID" NUMBER, 
	"CREATED_ON" DATE, 
	"CREATED_BY" VARCHAR2(100), 
	"CHANGED_ON" DATE, 
	"CHANGED_BY" VARCHAR2(100), 
	"C_X" NUMBER, 
	"C_Y" NUMBER, 
	"IMAGE_ID" NUMBER, 
	"C_T" NUMBER, 
	"C_X_TEXT" NUMBER, 
	"C_Y_TEXT" NUMBER, 
	"NAME" VARCHAR2(100), 
	"MAX_LENGTH" NUMBER DEFAULT 80, 
	"GEO" "SDO_GEOMETRY"
   ) ;
--------------------------------------------------------
--  DDL for Table RJS_COORDINATE_IMAGE_EDITOR
--------------------------------------------------------

  CREATE TABLE "RJS_COORDINATE_IMAGE_EDITOR" 
   (	"ID" NUMBER, 
	"CREATED_ON" DATE, 
	"CREATED_BY" VARCHAR2(100), 
	"CHANGED_ON" DATE, 
	"CHANGED_BY" VARCHAR2(100), 
	"IMAGE_ID" NUMBER, 
	"NAME" VARCHAR2(200), 
	"DESCRIPTION" VARCHAR2(1000), 
	"RECT_X" NUMBER, 
	"RECT_Y" NUMBER, 
	"RECT_WIDTH" NUMBER, 
	"RECT_HEIGHT" NUMBER, 
	"RECT_COLOR" VARCHAR2(20)
   ) ;
--------------------------------------------------------
--  DDL for Table RJS_COORDINATE_POWER_GRID
--------------------------------------------------------

  CREATE TABLE "RJS_COORDINATE_POWER_GRID" 
   (	"ID" NUMBER, 
	"CREATED_ON" DATE, 
	"CREATED_BY" VARCHAR2(100), 
	"CHANGED_ON" DATE, 
	"CHANGED_BY" VARCHAR2(100), 
	"C_M_X" NUMBER, 
	"C_M_Y" NUMBER, 
	"C_L_X" NUMBER, 
	"C_L_Y" NUMBER, 
	"IMAGE_ID" NUMBER, 
	"COORDINATE_POWER_GRID_ID_FROM" VARCHAR2(100), 
	"COORDINATE_POWER_GRID_ID_TO" VARCHAR2(100), 
	"AREA" VARCHAR2(100), 
	"STATUS" NUMBER DEFAULT 1
   ) ;
--------------------------------------------------------
--  DDL for Table RJS_DATA_HAND
--------------------------------------------------------

  CREATE TABLE "RJS_DATA_HAND" 
   (	"ID" NUMBER, 
	"CREATED_ON" DATE, 
	"CREATED_BY" VARCHAR2(100), 
	"CHANGED_ON" DATE, 
	"CHANGED_BY" VARCHAR2(100), 
	"FINGER_ID" VARCHAR2(50), 
	"FINGER_NAME" VARCHAR2(100), 
	"DESCRIPTION" VARCHAR2(200), 
	"BONE_NAME" VARCHAR2(100)
   ) ;
--------------------------------------------------------
--  DDL for Table RJS_DATA_HARBOR
--------------------------------------------------------

  CREATE TABLE "RJS_DATA_HARBOR" 
   (	"ID" NUMBER, 
	"CREATED_ON" DATE, 
	"CREATED_BY" VARCHAR2(100), 
	"CHANGED_ON" DATE, 
	"CHANGED_BY" VARCHAR2(100), 
	"RESULT_TYPE" VARCHAR2(50), 
	"COORDINATE_ID" NUMBER, 
	"TEXT" VARCHAR2(200), 
	"TEXT_LENGTH" NUMBER DEFAULT 26
   ) ;
--------------------------------------------------------
--  DDL for Table RJS_DATA_TRAM_PLAN
--------------------------------------------------------

  CREATE TABLE "RJS_DATA_TRAM_PLAN" 
   (	"ID" NUMBER, 
	"CREATED_ON" DATE, 
	"CREATED_BY" VARCHAR2(100), 
	"CHANGED_ON" DATE, 
	"CHANGED_BY" VARCHAR2(100), 
	"TRAM_ID" NUMBER, 
	"STATION_ID_FROM" VARCHAR2(100), 
	"STATION_ID_TILL" VARCHAR2(100), 
	"STATION_ORDER_NUMBER" NUMBER, 
	"STATION_ID" VARCHAR2(100), 
	"STATION_ON_MAP" NUMBER, 
	"STATION_X" NUMBER, 
	"STATION_Y" NUMBER, 
	"STATION_PLOT" VARCHAR2(100), 
	"STATION_DURATION" VARCHAR2(100), 
	"STATION_DELAY" VARCHAR2(100), 
	"STATION_X_DIFFERENCE" NUMBER, 
	"STATION_Y_DIFFERENCE" NUMBER, 
	"TRAM_FILL" VARCHAR2(7), 
	"TRAM_STROKE" VARCHAR2(7)
   ) ;
--------------------------------------------------------
--  DDL for Table RJS_GEO_MARKER
--------------------------------------------------------

  CREATE TABLE "RJS_GEO_MARKER" 
   (	"GEO_TYPE" VARCHAR2(20), 
	"COUNTRY_KEY" VARCHAR2(2), 
	"COUNTRY" VARCHAR2(100), 
	"ATTRIBUTE1" VARCHAR2(100), 
	"ATTRIBUTE2" VARCHAR2(100), 
	"ATTRIBUTE3" VARCHAR2(100), 
	"LAT" NUMBER, 
	"LON" NUMBER
   ) ;
--------------------------------------------------------
--  DDL for Table RJS_IMAGE
--------------------------------------------------------

  CREATE TABLE "RJS_IMAGE" 
   (	"ID" NUMBER, 
	"CREATED_ON" DATE, 
	"CREATED_BY" VARCHAR2(100), 
	"CHANGED_ON" DATE, 
	"CHANGED_BY" VARCHAR2(100), 
	"IMAGE_FILENAME" VARCHAR2(100), 
	"IMAGE_NAME" VARCHAR2(100), 
	"IMAGE_DESCRIPTION" VARCHAR2(500), 
	"IMAGE_WIDTH" NUMBER, 
	"IMAGE_HEIGHT" NUMBER, 
	"IMAGE_BLOB" BLOB, 
	"IMAGE_BASE64" CLOB, 
	"IMAGE_TYPE" VARCHAR2(4)
   ) ;
--------------------------------------------------------
--  DDL for Table RJS_SWEDEN_STATISTIC_DATA
--------------------------------------------------------

  CREATE TABLE "RJS_SWEDEN_STATISTIC_DATA" 
   (	"ID" NUMBER, 
	"NAME" VARCHAR2(100), 
	"POPULATION" NUMBER, 
	"POPULATION_GROWTH" NUMBER, 
	"LIVE_BIRTHS" NUMBER, 
	"DEATHS" NUMBER, 
	"POPULATION_SURPLUS" NUMBER, 
	"LAT" NUMBER, 
	"LON" NUMBER, 
	"YEAR" VARCHAR2(20), 
	"ORIGINAL_NAME" VARCHAR2(100)
   ) ;
--------------------------------------------------------
--  DDL for Sequence RJS_SEQ
--------------------------------------------------------

   CREATE SEQUENCE  "RJS_SEQ"  MINVALUE 1 MAXVALUE 9999999999999999999999999999 INCREMENT BY 1 START WITH 541 CACHE 20 NOORDER  NOCYCLE ;
--------------------------------------------------------
--  DDL for Index RJS_COORDINATE_HAND_PK
--------------------------------------------------------

  CREATE UNIQUE INDEX "RJS_COORDINATE_HAND_PK" ON "RJS_COORDINATE_HAND" ("ID") 
  ;
--------------------------------------------------------
--  DDL for Index RJS_KOORDINATE_PK
--------------------------------------------------------

  CREATE UNIQUE INDEX "RJS_KOORDINATE_PK" ON "RJS_COORDINATE_HARBOR" ("ID") 
  ;
--------------------------------------------------------
--  DDL for Index RJS_COORDINATE_POWER_GRID_PK
--------------------------------------------------------

  CREATE UNIQUE INDEX "RJS_COORDINATE_POWER_GRID_PK" ON "RJS_COORDINATE_POWER_GRID" ("ID") 
  ;
--------------------------------------------------------
--  DDL for Index RJS_DATA_HAND_PK
--------------------------------------------------------

  CREATE UNIQUE INDEX "RJS_DATA_HAND_PK" ON "RJS_DATA_HAND" ("ID") 
  ;
--------------------------------------------------------
--  DDL for Index RJS_DATA_HARBOR_PK
--------------------------------------------------------

  CREATE UNIQUE INDEX "RJS_DATA_HARBOR_PK" ON "RJS_DATA_HARBOR" ("ID") 
  ;
--------------------------------------------------------
--  DDL for Index RJS_DATA_TRAM_PLAN_PK
--------------------------------------------------------

  CREATE UNIQUE INDEX "RJS_DATA_TRAM_PLAN_PK" ON "RJS_DATA_TRAM_PLAN" ("ID") 
  ;
--------------------------------------------------------
--  DDL for Index RJS_IMAGE_PK
--------------------------------------------------------

  CREATE UNIQUE INDEX "RJS_IMAGE_PK" ON "RJS_IMAGE" ("ID") 
  ;
--------------------------------------------------------
--  DDL for Trigger TRG_BUI_RJS_COORDINATE_HAND
--------------------------------------------------------

  CREATE OR REPLACE TRIGGER "TRG_BUI_RJS_COORDINATE_HAND" 
BEFORE INSERT OR UPDATE ON RJS_COORDINATE_HAND
FOR EACH ROW 
BEGIN
  IF INSERTING THEN 
    IF :NEW.ID IS NULL THEN 
      select rjs_seq.nextval into :NEW.ID from dual;
    END IF;
   :NEW.CREATED_ON := SYSDATE;
   :NEW.CREATED_BY := nvl(nvl(v('APP_USER'),USER),'Unknown');
  END IF;
  
  IF UPDATING THEN
   :NEW.CHANGED_ON := SYSDATE;
   :NEW.CHANGED_BY := nvl(nvl(v('APP_USER'),USER),'Unknown');
  END IF;
END;
/
ALTER TRIGGER "TRG_BUI_RJS_COORDINATE_HAND" ENABLE;
--------------------------------------------------------
--  DDL for Trigger TRG_BUI_RJS_COORDINATE_HARBOR
--------------------------------------------------------

  CREATE OR REPLACE TRIGGER "TRG_BUI_RJS_COORDINATE_HARBOR" 
BEFORE INSERT OR UPDATE ON RJS_COORDINATE_HARBOR
FOR EACH ROW 
BEGIN
  IF INSERTING THEN 
    IF :NEW.ID IS NULL THEN 
      select rjs_seq.nextval into :NEW.ID from dual;
    END IF;
   :NEW.CREATED_ON := SYSDATE;
   :NEW.CREATED_BY := nvl(nvl(v('APP_USER'),USER),'Unknown');
   

   
  END IF;
  
  IF UPDATING THEN
   :NEW.CHANGED_ON := SYSDATE;
   :NEW.CHANGED_BY := nvl(nvl(v('APP_USER'),USER),'Unknown');
  END IF;
  
     
   SELECT
   SDO_GEOMETRY(
    2003,  -- two-dimensional polygon
    NULL,
    NULL,
    MDSYS.SDO_ELEM_INFO_ARRAY(1,1003,1), -- one rectangle (1003 = exterior)
    MDSYS.SDO_ORDINATE_ARRAY(:NEW.C_X, :NEW.C_Y, ROUND(g.C2_X), ROUND(g.C2_Y), ROUND(g.C4_X), ROUND(g.C4_Y),ROUND(g.C3_X), ROUND(g.C3_Y), :NEW.C_X, :NEW.C_Y)
    )
   into :NEW.GEO
   FROM  
   /*computated coordinates*/
   (
  SELECT 
  :NEW.C_Y + (SIN ((:NEW.C_T /(180/ACOS(-1)))) * 80) as "C2_Y", /*static width and height 60w and 19h*/
  :NEW.C_X + (COS ((:NEW.C_T /(180/ACOS(-1)))) * 80) as "C2_X",
  :NEW.C_Y + (SIN (((:NEW.C_T+270) /(180/ACOS(-1)))) * 30) as "C3_Y",
  :NEW.C_X + (COS (((:NEW.C_T+270) /(180/ACOS(-1)))) * 30) as "C3_X",
  (:NEW.C_Y + (SIN (((:NEW.C_T+270) /(180/ACOS(-1)))) * 30)) + (SIN ((:NEW.C_T /(180/ACOS(-1)))) * 80) as "C4_Y",
  (:NEW.C_X + (COS (((:NEW.C_T+270) /(180/ACOS(-1)))) * 30)) + (COS ((:NEW.C_T /(180/ACOS(-1)))) * 80) as "C4_X"
  FROM DUAL
  ) g;
END;
/
ALTER TRIGGER "TRG_BUI_RJS_COORDINATE_HARBOR" ENABLE;
--------------------------------------------------------
--  DDL for Trigger TRG_BUI_RJS_COORDINATE_IE
--------------------------------------------------------

  CREATE OR REPLACE TRIGGER "TRG_BUI_RJS_COORDINATE_IE" 
BEFORE INSERT OR UPDATE ON RJS_COORDINATE_IMAGE_EDITOR
FOR EACH ROW 
BEGIN
  IF INSERTING THEN 
    IF :NEW.ID IS NULL THEN 
      select rjs_seq.nextval into :NEW.ID from dual;
    END IF;
   :NEW.CREATED_ON := SYSDATE;
   :NEW.CREATED_BY := nvl(nvl(v('APP_USER'),USER),'Unknown');
  END IF;
  
  IF UPDATING THEN
   :NEW.CHANGED_ON := SYSDATE;
   :NEW.CHANGED_BY := nvl(nvl(v('APP_USER'),USER),'Unknown');
  END IF;
END;
/
ALTER TRIGGER "TRG_BUI_RJS_COORDINATE_IE" ENABLE;
--------------------------------------------------------
--  DDL for Trigger TRG_BUI_RJS_COORDINATE_POWER
--------------------------------------------------------

  CREATE OR REPLACE TRIGGER "TRG_BUI_RJS_COORDINATE_POWER" 
BEFORE INSERT OR UPDATE ON RJS_COORDINATE_POWER_GRID
FOR EACH ROW 
BEGIN
  IF INSERTING THEN 
    IF :NEW.ID IS NULL THEN 
      select rjs_seq.nextval into :NEW.ID from dual;
    END IF;
   :NEW.CREATED_ON := SYSDATE;
   :NEW.CREATED_BY := nvl(nvl(v('APP_USER'),USER),'Unknown');
  END IF;
  
  IF UPDATING THEN
   :NEW.CHANGED_ON := SYSDATE;
   :NEW.CHANGED_BY := nvl(nvl(v('APP_USER'),USER),'Unknown');
  END IF;
END;
/
ALTER TRIGGER "TRG_BUI_RJS_COORDINATE_POWER" ENABLE;
--------------------------------------------------------
--  DDL for Trigger TRG_BUI_RJS_DATA_HAND
--------------------------------------------------------

  CREATE OR REPLACE TRIGGER "TRG_BUI_RJS_DATA_HAND" 
BEFORE INSERT OR UPDATE ON RJS_DATA_HAND
FOR EACH ROW 
BEGIN
  IF INSERTING THEN 
    IF :NEW.ID IS NULL THEN 
      select rjs_seq.nextval into :NEW.ID from dual;
    END IF;
   :NEW.CREATED_ON := SYSDATE;
   :NEW.CREATED_BY := nvl(nvl(v('APP_USER'),USER),'Unknown');
  END IF;
  
  IF UPDATING THEN
   :NEW.CHANGED_ON := SYSDATE;
   :NEW.CHANGED_BY := nvl(nvl(v('APP_USER'),USER),'Unknown');
  END IF;
END;
/
ALTER TRIGGER "TRG_BUI_RJS_DATA_HAND" ENABLE;
--------------------------------------------------------
--  DDL for Trigger TRG_BUI_RJS_DATA_HARBOR
--------------------------------------------------------

  CREATE OR REPLACE TRIGGER "TRG_BUI_RJS_DATA_HARBOR" 
BEFORE INSERT OR UPDATE ON RJS_DATA_HARBOR
FOR EACH ROW 
BEGIN
  IF INSERTING THEN 
    IF :NEW.ID IS NULL THEN 
      select rjs_seq.nextval into :NEW.ID from dual;
    END IF;
   :NEW.CREATED_ON := SYSDATE;
   :NEW.CREATED_BY := nvl(nvl(v('APP_USER'),USER),'Unknown');
  END IF;
  
  IF UPDATING THEN
   :NEW.CHANGED_ON := SYSDATE;
   :NEW.CHANGED_BY := nvl(nvl(v('APP_USER'),USER),'Unknown');
  END IF;
END;
/
ALTER TRIGGER "TRG_BUI_RJS_DATA_HARBOR" ENABLE;
--------------------------------------------------------
--  DDL for Trigger TRG_BUI_RJS_DATA_TRAM_PLAN
--------------------------------------------------------

  CREATE OR REPLACE TRIGGER "TRG_BUI_RJS_DATA_TRAM_PLAN" 
BEFORE INSERT OR UPDATE ON RJS_DATA_TRAM_PLAN
FOR EACH ROW 
BEGIN
  IF INSERTING THEN 
    IF :NEW.ID IS NULL THEN 
      select rjs_seq.nextval into :NEW.ID from dual;
    END IF;
   :NEW.CREATED_ON := SYSDATE;
   :NEW.CREATED_BY := nvl(nvl(v('APP_USER'),USER),'Unknown');
  END IF;
  
  IF UPDATING THEN
   :NEW.CHANGED_ON := SYSDATE;
   :NEW.CHANGED_BY := nvl(nvl(v('APP_USER'),USER),'Unknown');
  END IF;
END;
/
ALTER TRIGGER "TRG_BUI_RJS_DATA_TRAM_PLAN" ENABLE;
--------------------------------------------------------
--  DDL for Trigger TRG_BUI_RJS_IMAGE
--------------------------------------------------------

  CREATE OR REPLACE TRIGGER "TRG_BUI_RJS_IMAGE" 
BEFORE INSERT OR UPDATE ON RJS_IMAGE 
FOR EACH ROW 
BEGIN
  IF INSERTING THEN 
    IF :NEW.ID IS NULL THEN 
      select rjs_seq.nextval into :NEW.ID from dual;
    END IF;
   :NEW.CREATED_ON := SYSDATE;
   :NEW.CREATED_BY := nvl(nvl(v('APP_USER'),USER),'Unknown');
  END IF;
  
  IF UPDATING THEN
   :NEW.CHANGED_ON := SYSDATE;
   :NEW.CHANGED_BY := nvl(nvl(v('APP_USER'),USER),'Unknown');
  END IF;
END;
/
ALTER TRIGGER "TRG_BUI_RJS_IMAGE" ENABLE;
--------------------------------------------------------
--  DDL for Package Body RJS_DEMO
--------------------------------------------------------

  CREATE OR REPLACE PACKAGE BODY "RJS_DEMO" as
	  /* Static variables */
	  s_proc_name    varchar2(100);
	  s_action       varchar2(4000);
	  s_ora_error    varchar2(4000);
	  s_custom_error varchar2(4000);
	  s_parameter    varchar2(4000);
	  s_apex_err_txt varchar2(500);
	  s_username     varchar2(100) := nvl(nvl(v('APP_USER'),user),'Unknown');
	  s_app_id       number := nvl(v('APP_ID'),0);
	  s_page_id      number := nvl(v('APP_PAGE_ID'),0);
	  s_protokoll_id number;
	  s_zeilen_nr    number;


	  
	  /* Save errors */
	  procedure add_err  is
		 pragma autonomous_transaction;
	  begin
		   insert
		   into err_log
			( proc_name,action,app_id,app_page_id,app_user,ora_error,custom_error,parameter,time_stamp )
			values
			( s_proc_name,s_action,s_app_id,s_page_id,s_username, s_ora_error,s_custom_error,s_parameter,sysdate);
	
			commit;
	  end; 
 
/* create harbor 1 (HTML,CSS,JS)  */ 
procedure generate_harbor (in_image_id number)
is
  v_image_filename           varchar2(100);
  v_image_name                varchar2(100);
  v_image_width              number;
  v_image_height               number;
  
  v_background_color varchar2(100);
begin
  s_proc_name := 'RJS_DEMO.GENERATE_HARBOR';
  s_parameter := 'in_image_id: ' || to_char(in_image_id);
  
  s_action := 'Bild auswaehlen';
  select image_filename, image_name, image_width, image_height
  into   v_image_filename,v_image_name, 
         v_image_width, v_image_height
  from   rjs_image
  where  id = in_image_id;
  
  s_action := 'HTML generation';
  htp.p('
   <style>
    #wrapper {
        position: relative;
        width: ' || v_image_width || 'px;
        height: ' || v_image_height || 'px;
        padding: 0;
        outline: 1px solid #999;
    }
    #wrapper img {
        position: absolute;
        top: 0;
        left: 0;
    }
    #canvas{
        position: absolute;
        top: 0;
        left: 0;
    }
   </style>
   <div id="wrapper">
    <img src="' || v('APP_IMAGES') || 'harbor/'  || v_image_filename ||'">
    <div id="canvas">
    </div>
   </div>
   ');
   

  s_action := 'JS open';
  htp.p('
   <script>
    document.addEventListener("DOMContentLoaded", function(){ 
      var canvas = Raphael(document.getElementById("canvas"), ' || v_image_width || ', ' || v_image_height || ');
  ');

  s_action := 'JS data loop';
  for rec_k in (
         select rownum, image_id, coordinate_id, 
                result_type, text, c_x, c_y, c_t, c_x_text, c_y_text
         from vw_rjs_harbor
         where image_id = in_image_id
  ) loop
    
      s_action := 'txt'||rec_k.rownum || ' generation.';
      htp.p ('
        var txt'||rec_k.rownum||' = canvas.text('||(rec_k.c_x_text)||', '||(rec_k.c_y_text)||', "'||rec_k.text||'");
        txt'||rec_k.rownum||'.attr({ "font-size": '||'"9"'||','
                                   || ' "font-family": "Arial, Helvetica, sans-serif",'
                                   || ' "fill": "black",'
                                   || ' transform:"r-'||rec_k.c_t||'"});  
        var box'||rec_k.rownum||' = txt'||rec_k.rownum||'.getBBox();
        var img'||rec_k.rownum||' = canvas.image("'|| v('APP_IMAGES') || 'raphael/' ||rec_k.result_type||'.png", '
                                                   || rec_k.c_x||', '||rec_k.c_y||', '||'26'||', '||'19'||')'
                                                   || '.attr({transform:"r-'||rec_k.c_t||'"}).glow({width:1,opacity:0.8});
        txt'||rec_k.rownum||'.toFront();
        ');   

  end loop;
  
  s_action := 'JS close';
  htp.p('
    }, false);
   </script>
  ');

  
exception
when others then   
      rollback; s_ora_error := sqlerrm;
      s_custom_error := 'Internal error occured. Processing stopped.';
      add_err; commit;raise_application_error(-20001, s_custom_error);
end;  

/* create harbor 2 (HTML,CSS,JS)  */  
procedure generate_harbor2 (in_image_id number)
is
  v_image_filename           varchar2(100);
  v_image_name                varchar2(100);
  v_image_width              number;
  v_image_height               number;
  
  v_background_color varchar2(100);
begin
  s_proc_name := 'RJS_DEMO.GENERATE_HARBOR2';
  s_parameter := 'in_image_id: ' || to_char(in_image_id);
  
  s_action := 'Bild auswaehlen';
  select image_filename, image_name, image_width, image_height
  into   v_image_filename,v_image_name, 
         v_image_width, v_image_height
  from   rjs_image
  where  id = in_image_id;
  
  s_action := 'HTML generation';
  htp.p('
   <style>
    #wrapper {
        position: relative;
        width: ' || v_image_width || 'px;
        height: ' || v_image_height || 'px;
        padding: 0;
        outline: 1px solid #999;
    }
    #wrapper img {
        position: absolute;
        top: 0;
        left: 0;
    }
    #canvas{
        position: absolute;
        top: 0;
        left: 0;
    }
   </style>
   <div id="wrapper">
    <img src="' || v('APP_IMAGES') || 'harbor/' || v_image_filename ||'">
    <div id="canvas">
    </div>
   </div>
   ');
   

  s_action := 'JS open';
  htp.p('
   <script>
    document.addEventListener("DOMContentLoaded", function(){ 
      var canvas = Raphael(document.getElementById("canvas"), ' || v_image_width || ', ' || v_image_height || ');
  ');

  s_action := 'JS Daten Loop';
  for rec_k in (
         select rownum, image_id, coordinate_id, data_id,
                result_type, text, c_x, c_y, c_t, c_x_text, c_y_text,
                text_length, max_length
         from vw_rjs_harbor
         where image_id = in_image_id
        and harbor_name not in ('Entry', 'Exit')
  ) loop
    
      s_action := 'txt'||rec_k.rownum || ' generation.';
      htp.p ('
        var txt'||rec_k.rownum||' = canvas.text('||case when rec_k.c_t <= 90 then
                                                      to_char(rec_k.c_x_text-26+rec_k.text_length)||', '
                                                   else
                                                      to_char(rec_k.c_x_text)||', '
                                                   end
                                                 ||case when rec_k.c_t >= 90 then
                                                      to_char(rec_k.c_y_text-26+rec_k.text_length)
                                                   else
                                                      to_char(rec_k.c_y_text)
                                                   end  
                                                 ||', "'||rec_k.text||'");
        txt'||rec_k.rownum||'.attr({ "font-size": '||'"9"'||','
                                   || ' "font-family": "Arial, Helvetica, sans-serif",'
                                   || ' "fill": "black",'
                                   || ' transform:"r-'||rec_k.c_t||'"})'
                                   || '.data("id","'||rec_k.data_id||'");
        var box'||rec_k.rownum||' = txt'||rec_k.rownum||'.getBBox();
        var img'||rec_k.rownum||' = canvas.image("'|| v('APP_IMAGES') || 'raphael/' ||rec_k.result_type||'.png", '
                                                     ||case when rec_k.c_t >= 90 then
                                                          to_char(rec_k.c_x+round((26-rec_k.text_length)/2,0))||', '
                                                       else
                                                          to_char(rec_k.c_x)||', '
                                                       end  
                                                     ||case when rec_k.c_t <= 90  then
                                                          to_char(rec_k.c_y-round((rec_k.text_length/26-1)*2,0))||', '
                                                       else
                                                          to_char(rec_k.c_y)||', '
                                                       end 
                                                     ||rec_k.text_length||', '
                                                     ||'19'||')'
                                                   || '.attr({transform:"r-'||rec_k.c_t||'"})' 
                                                   || '.click( function (event) { apex.navigation.redirect("f?p='||v('APP_ID')||':11:'||v('APP_SESSION')||'::NO::P11_ID:'||rec_k.data_id||'"); })'
                                                   || '.glow({width:1,opacity:0.8})'
                                                   ||
                                                   case when rec_k.text_length > rec_k.max_length then
                                                      '.attr({"fill": "#FF2424"});'
                                                   else
                                                      '.attr({"fill": "none"});'
                                                   end 
                                                   || '
        txt'||rec_k.rownum||'.toFront();
        '); 
  end loop;
  
  s_action := 'JS close';
  htp.p('
    }, false);
   </script>
  ');

  
exception
when others then   
      rollback; s_ora_error := sqlerrm;
      s_custom_error := 'Internal error occured. Processing stopped.';
      add_err; commit;raise_application_error(-20001, s_custom_error);
end;  


/* create harbor with Drag and Drop (HTML,CSS,JS)  */  
procedure generate_harbor_dd (in_image_id number)
is
  v_image_filename        varchar2(100);
  v_image_name            varchar2(100);
  v_image_width           number;
  v_image_height          number;
  
  v_background_color      varchar2(100);
  v_clob                  clob;
  begin
  s_proc_name := 'RJS_DEMO.generate_harbor_dd_head';
  s_parameter := 'in_image_id: ' || to_char(in_image_id);
  
  s_action := 'Bild auswaehlen';
  select image_filename, image_name, image_width, image_height
  into   v_image_filename,v_image_name, 
         v_image_width, v_image_height
  from   rjs_image
  where  id = in_image_id;
  /*htp.p weg und return clob?*/
  s_action := 'HTML generation';
  v_clob := v_clob || to_clob('
  <div class="tooltip"></div>

  <div id="paper">
   <style>
    #wrapper {
        position: relative;
        width: ' || v_image_width || 'px;
        height: ' || v_image_height || 'px;
        padding: 0;
        outline: 1px solid #999;
    }
    #wrapper img {
        position: absolute;
        top: 0;
        left: 0;
    }
    #canvas{
        position: absolute;
        top: 0;
        left: 0;
    }
  .tooltip{
   position : absolute;
   border : 1px solid black;
   background-color : grey;
   color: white;
   padding : 3px;
   z-index: 100;
}
   </style>

  <div id="wrapper">
    <img src="' || v('APP_IMAGES') || 'harbor/'  || v_image_filename ||'">
    <div id="canvas">
    </div>
   </div>
   ');
    
s_action := 'JS Daten Loop';
  v_clob := v_clob || to_clob('
  <script type="text/javascript" src="/i/libraries/jquery/2.1.3/jquery-2.1.3.min.js?v=5.0.3.00.03"></script>
  <script>

var tooltip = $(".tooltip").hide();
var tooltipText = "";
var over = false;
 $("#paper").mousemove(function(e){
    if (over){
      var parentOffset = $(this).parent().offset(); 
      tooltip.css("left", e.pageX - parentOffset.left + 10);
      tooltip.css("top", e.pageY - parentOffset.top);
      tooltip.text(tooltipText);
    }
});

function bindToolTip(element, txt){
    $(element).mouseenter(function(){
       tooltipText = txt;
       tooltip.fadeIn();
       over = true;
    }).mouseleave(function(){
       tooltip.fadeOut(200);
       over = false;
    });
}
  $(document).ready(function () {
      $(".tooltip").hide();

      var canvas = Raphael(document.getElementById("canvas"), ' || v_image_width || ', ' || v_image_height || ');
      Raphael.st.draggable = function() {
        var me = this,
            lx = 0,
            ly = 0,
            ox = 0,
            oy = 0,
            moveFnc = function(dx, dy) {
                lx = dx + ox;
                ly = dy + oy;
                me.transform("t" + lx + "," + ly);
            },
            startFnc = function() {
              me.attr({"stroke-dasharray":"-"});
            },
            endFnc = function() {
                me.attr({"stroke-dasharray":""});
                ox = lx;
                oy = ly;
                var b = me.getBBox();
                this.attr({"stroke-dasharray":""});
                checkHarbour(this.attr("x") + lx, this.attr("y") +ly, b.width, b.height, me[0].data("id"), me);
                
            };
      
        this.drag(moveFnc, startFnc, endFnc);
      };
      
      
           //Begin changeHarbour
      
      function checkHarbour(x, y, width, height, shipId, set) {
          var newX;
          var newY;
          var newT;
          //DB-Call to Harbor by Position of the ship
          apex.server.process("getHarborByPosition", {
                  x01: parseInt(x),
                  x02: parseInt(y),
                  x03: parseInt(width),
                  x04: parseInt(height),
                  x05: parseInt(shipId)
              }, {
                  dataType: "text",
                  success: function(pData) {
                      //return ID of Harbor
                      var harbourId = pData;
      
                      //change Harbour if found
                      if (harbourId != 0) {
                          apex.server.process("changeHarbour", {
                              x01: parseInt(harbourId),
                              x02: parseInt(shipId)
                          }, {
                              dataType: "text",
                              success: function(pData) {
                            
                            
                    //reload content if success
                    apex.server.process("getHarbor", 
                        { 
                          },
                      {
                        dataType: "text",
                        success: function(pData) {
                       $( "#paper" ).replaceWith( pData );
                        $(".tooltip").hide();
                        }
                      });
                          
                              }
                          });
                      }
else{
//no harbor found
set.attr({"stroke-dasharray":"-..", "stroke":"red"});
//check if exit from harbr
}					 
                  }
      
              }
          
      
      
      );
      };
');
  for rec_k in (
         select rownum, image_id, coordinate_id, data_id,
                result_type, text, c_x, c_y, c_t, c_x_text, c_y_text,
                text_length, max_length, harbor_name
         from vw_rjs_harbor
         where image_id = in_image_id
         and harbor_name <> 'Exit'
  ) loop
    
      s_action := 'txt'||rec_k.rownum || ' generation.';
       v_clob := v_clob || to_clob('
        var set'||rec_k.rownum||' = canvas.set();
        set'||rec_k.rownum||'.data("id","'||rec_k.data_id||'");
        var txt'||rec_k.rownum||' = canvas.text('||case when rec_k.c_t <= 90 then
                                                      to_char(rec_k.c_x_text-26+rec_k.text_length)||', '
                                                   else
                                                      to_char(rec_k.c_x_text)||', '
                                                   end
                                                 ||case when rec_k.c_t >= 90 then
                                                      to_char(rec_k.c_y_text-26+rec_k.text_length)
                                                   else
                                                      to_char(rec_k.c_y_text)
                                                   end
                                                  ||', "'||rec_k.text||'");
        txt'||rec_k.rownum||'.attr({ "font-size": '||'"9"'||','
                                   || ' "font-family": "Arial, Helvetica, sans-serif",'
                                   || ' "fill": "black",'
                                   || ' transform:"r-'||rec_k.c_t||'"})'
                                   || '.data("id","'||rec_k.data_id||'");
                                   
        var box'||rec_k.rownum||' = txt'||rec_k.rownum||'.getBBox();
        var img'||rec_k.rownum||' = canvas.image("'|| v('APP_IMAGES') || 'raphael/' ||rec_k.result_type||'.png", '
                                                     ||case when rec_k.c_t >= 90 then
                                                          to_char(rec_k.c_x+round((26-rec_k.text_length)/2,0))||', '
                                                       else
                                                          to_char(rec_k.c_x)||', '
                                                       end  
                                                     ||case when rec_k.c_t <= 90  then
                                                          to_char(rec_k.c_y-round((rec_k.text_length/26-1)*2,0))||', '
                                                       else
                                                          to_char(rec_k.c_y)||', '
                                                       end 
                                                     ||rec_k.text_length||', '
                                                     ||'19'||')'
                                                     || '.attr({transform:"r-'||rec_k.c_t||'"})' 
                                                   --|| '.click( function (event) { apex.navigation.redirect("f?p='||v('APP_ID')||':13:'||v('APP_SESSION')||'::NO::P13_ID:'||rec_k.data_id||'"); })'
                                                   ||
                                                   case when rec_k.text_length > rec_k.max_length then
                                                      '.attr({"fill": "#FF2424"});'
                                                   else
                                                      '.attr({"fill": "none"});'
                                                   end 
                                                   || '
        var rect'||rec_k.rownum||' = canvas.rect('||case when rec_k.c_t >= 90 then
                                                          to_char(rec_k.c_x+round((26-rec_k.text_length)/2,0))||', '
                                                       else
                                                          to_char(rec_k.c_x)||', '
                                                       end  
                                                     ||case when rec_k.c_t <= 90  then
                                                          to_char(rec_k.c_y-round((rec_k.text_length/26-1)*2,0))||', '
                                                       else
                                                          to_char(rec_k.c_y)||', '
                                                       end 
                                                     ||rec_k.text_length||', '
                                                     ||'19'||')'
                                                     || '.attr({transform:"r-'||rec_k.c_t||'"})' 
                                                    ||
                                                   case when rec_k.text_length > rec_k.max_length then
                                                      '.attr({"fill": "#FF2424"});'
                                                   else
                                                      '.attr({"fill": "none"});'
                                                   end 
                                                   || '                                     
        bindToolTip(txt'||rec_k.rownum||'.node, "'||rec_k.harbor_name||'");
        set'||rec_k.rownum||'.push(txt'||rec_k.rownum||',  box'||rec_k.rownum||', img'||rec_k.rownum||',rect'||rec_k.rownum||');
      
        txt'||rec_k.rownum||'.toFront();
        set'||rec_k.rownum||'.draggable();
        

        
        '); 
  end loop;
  
  s_action := 'JS close';
  v_clob := v_clob || to_clob('  
 }); 
   </script>
   </div>
  ');   
 
 htp.p(v_clob);   
exception
when others then   
      rollback; s_ora_error := sqlerrm;
      s_custom_error := 'Internal error occured. Processing stopped.';
      add_err; commit;raise_application_error(-20001, s_custom_error);
end;



/*
Returnung harbor by position used in ajax callback to get harbor by drag an drop

*/  
function return_harbor_by_pos (in_x number, in_y number, in_width number, in_height number, in_ship_id number) 
return number
as
v_id rjs_coordinate_harbor.id%type;
begin

select id
into v_id
  from(
  select
  h.id id,
  h.name,
  h.geo,
  sdo_geom.relate
    ( h.geo, 
    'ANYINTERACT',
      sdo_geometry (2003, null, null, sdo_elem_info_array (1,1003,3),
                    sdo_ordinate_array (
                          in_x, in_y,
                          (in_x + in_width), (in_y +  in_height)
                            )
                )
      ,5) relatio
    from rjs_coordinate_harbor h
    left join rjs_data_harbor d
    on d.coordinate_id = h.id
    where (d.id is null or d.id = in_ship_id or h.name = 'Exit') --not loaded or current place
    and image_id = 2
    order by h.id
  )
where relatio = 'TRUE'
and rownum <=1;


  return v_id;
  
  exception when no_data_found then
    return 0;
end;



/* Image with tags */  
procedure generate_image_editor (in_image_id number)
is
  v_image_filename           varchar2(100);
  v_image_type               varchar2(4);
  v_image_width              number;
  v_image_height             number;
  v_clob                     clob;
  v_clob_puffer              varchar2(32000);
  
  v_background_color varchar2(100);
begin
  s_proc_name := 'RJS_DEMO.GENERATE_IMAGE_EDITOR';
  s_parameter := 'in_image_id: ' || to_char(in_image_id);
  
  s_action := 'Select image';
  select image_filename, image_type, image_width, image_height, image_base64
  into   v_image_filename,v_image_type, 
         v_image_width, v_image_height,
         v_clob
  from   rjs_image
  where  id = in_image_id;
  
  s_action := 'Generate HTML';
  htp.p('
   <style>
    #wrapper {
        position: relative;
        width: ' || v_image_width || 'px;
        height: ' || v_image_height || 'px;
        padding: 0;
        outline: 1px solid #999;
    }
    #wrapper img {
        position: absolute;
        top: 0;
        left: 0;
    }
    #canvas{
        position: absolute;
        top: 0;
        left: 0;
    }
   </style>
   <div id="wrapper">
     <img src="data:image/'||v_image_type||';base64,');
     
   /* Print CLOB */   
   while length(v_clob) > 0 loop
      begin
        if length(v_clob) > 16000 then
           v_clob_puffer:= substr(v_clob,1,16000);
           htp.prn(v_clob_puffer);
           v_clob:= substr(v_clob,length(v_clob_puffer)+1);
        else
           v_clob_puffer := v_clob;
           htp.prn(v_clob_puffer);
           v_clob:='';
           v_clob_puffer := '';
        end if;
      end;
    end loop;
    
  htp.p('" alt="RJS Image" />
    <div id="canvas">
    </div>
   </div>
   ');
   

  s_action := 'JS - initialize';
  htp.p('
   <script>
    document.addEventListener("DOMContentLoaded", function(){ 
      var canvas = Raphael(document.getElementById("canvas"), ' || v_image_width || ', ' || v_image_height || ');
  ');

  s_action := 'JS - data loop';
  for rec_k in (
         select rownum, image_id, id as coordinate_id,
                name, description,
                rect_x, rect_y,
                rect_width, rect_height, rect_color
         from rjs_coordinate_image_editor
         where image_id = in_image_id
  ) loop
    
      s_action := 'rect'||rec_k.rownum || ' generated.';
      htp.p ('  
        var rect'||rec_k.rownum||' = canvas.rect('||replace(trim(to_char(rec_k.rect_x)),',','.')||', '||replace(trim(to_char(rec_k.rect_y)),',','.')||','||
                                                    rec_k.rect_width||','||rec_k.rect_height || ' )'
                                   || '.attr({ "fill":"white","fill-opacity":"0.01","stroke-width":"2","cursor":"pointer","stroke":"'||rec_k.rect_color||'"})'
                                   || '.data("id","'||rec_k.coordinate_id||'")'
                                   || '.click( function (event) { apex.event.trigger(document,"DA_REDIRECT", [{popup_link:"'||apex_util.prepare_url(p_url => 'f?p='||v('APP_ID')||':65:'||v('APP_SESSION')||'::NO::P65_ID:'||rec_k.coordinate_id, p_checksum_type => 'SESSION')||'", popup_id:"popup_'||rec_k.coordinate_id||'"}]); });
        '); 
  end loop;
  
  s_action := 'JS - finish';
  htp.p('
     }, false);
   </script>
  ');

  
exception
when others then   
      rollback; s_ora_error := sqlerrm;
      s_custom_error := 'Internal error occured. Processing stopped.';
      add_err; commit;raise_application_error(-20001, s_custom_error);
end;  

/* Image with tags - new element */
procedure generate_image_editor_new_el (in_image_id number)
is
  v_image_filename           varchar2(100);
  v_image_type               varchar2(4);
  v_image_width              number;
  v_image_height             number;
  v_clob                     clob;
  v_clob_puffer              varchar2(32000);
  
  v_background_color varchar2(100);
begin
  s_proc_name := 'RJS_DEMO.GENERATE_IMAGE_EDITOR_NEW_EL';
  s_parameter := 'in_image_id: ' || to_char(in_image_id);
  
  s_action := 'Select image';
  select image_filename, image_type, image_width, image_height, image_base64
  into   v_image_filename,v_image_type, 
         v_image_width, v_image_height,
         v_clob
  from   rjs_image
  where  id = in_image_id;
  
  s_action := 'Generate HTML';
  htp.p('
   <style>
    #wrapper {
        position: relative;
        width: ' || v_image_width || 'px;
        height: ' || v_image_height || 'px;
        padding: 0;
        outline: 1px solid #999;
    }
    #wrapper img {
        position: absolute;
        top: 0;
        left: 0;
    }
    #canvas{
        position: absolute;
        top: 0;
        left: 0;
    }
   </style>
   <div id="wrapper">
     <img src="data:image/'||v_image_type||';base64,');
     
   /* Print CLOB */   
   while length(v_clob) > 0 loop
      begin
        if length(v_clob) > 16000 then
           v_clob_puffer:= substr(v_clob,1,16000);
           htp.prn(v_clob_puffer);
           v_clob:= substr(v_clob,length(v_clob_puffer)+1);
        else
           v_clob_puffer := v_clob;
           htp.prn(v_clob_puffer);
           v_clob:='';
           v_clob_puffer := '';
        end if;
      end;
    end loop;
    
  htp.p('" alt="RJS Image" />
    <div id="canvas">
    </div>
   </div>
   ');
   

  s_action := 'JS - Initialize';
  htp.p('
   <script>
    var rect;
    document.addEventListener("DOMContentLoaded", function(){ 
      var canvas = Raphael(document.getElementById("canvas"), ' || v_image_width || ', ' || v_image_height || ');
      
      var rect_master = canvas.rect(0, 0, ' || v_image_width || ', ' || v_image_height || ');
      rect_master.attr({ "fill":"white","fill-opacity":"0.01"});
      rect_master.node.id = "rect_master";
  ');

  s_action := 'JS - Add click functionality';
  htp.p('
    
      rect_master.mousedown(function (event, a, b) {
            
            // get bounding rect of the paper
            var bnds = event.target.getBoundingClientRect();
            var targetBox = this.getBBox();
            
            // adjust mouse x/y
            var mx = event.clientX - bnds.left;
            var my = event.clientY - bnds.top;
                
            // divide x/y by the bounding w/h to get location %s and apply factor by actual paper w/h
            var fx = mx/bnds.width * rect_master.attrs.width + targetBox.x;
            var fy = my/bnds.height * rect_master.attrs.height + targetBox.y;
            
            // cleanup output
            fx = Number(fx).toPrecision(3);
            fy = Number(fy).toPrecision(3);
            
            $("#rect_detail").remove();
            
            var borderColor = $(''#P63_RECT_COLOR'').val();
             
            var rect_detail = canvas.rect( fx, fy, $(''#P63_RECT_WIDTH'').val(), $(''#P63_RECT_HEIGHT'').val()); 
            rect_detail.attr({ "fill":"white","fill-opacity":"0.01","stroke-width":"2","stroke":borderColor});
            rect_detail.node.id = "rect_detail";
            $(''#P63_RECT_X'').val(fx);
            $(''#P63_RECT_Y'').val(fy);
            
      });
  ');


  s_action := 'JS - finish';
  htp.p('
    }, false);
      
      
   </script>
  ');

  
exception
when others then   
      rollback; s_ora_error := sqlerrm;
      s_custom_error := 'Internal error occured. Processing stopped.';
      add_err; commit;raise_application_error(-20001, s_custom_error);
end;

/* create power_grid (HTML,CSS,JS)  */  
procedure generate_power_grid (in_image_id number)
is
  v_image_filename           varchar2(100);
  v_image_name                varchar2(100);
  v_image_width              number;
  v_image_height               number;
  
  v_background_color varchar2(100);
begin
  s_proc_name := 'RJS_DEMO.GENERATE_POWER_GRID';
  s_parameter := 'in_image_id: ' || to_char(in_image_id);
  
  s_action := 'Select image';
  select image_filename, image_name, image_width, image_height
  into   v_image_filename,v_image_name, 
         v_image_width, v_image_height
  from   rjs_image
  where  id = in_image_id;
  
  s_action := 'HTML generation';
  htp.p('
   <style>
    #wrapper {
        position: relative;
        width: ' || v_image_width || 'px;
        height: ' || v_image_height || 'px;
        padding: 0;
        outline: 1px solid #999;
    }
    #wrapper img {
        position: absolute;
        top: 0;
        left: 0;
    }
    #canvas{
        position: absolute;
        top: 0;
        left: 0;
    }
   </style>
   <div id="wrapper">
    <img src="' || v('APP_IMAGES') || 'raphael/'  || v_image_filename ||'">
    <div id="canvas">
    </div>
   </div>
   ');
   

  s_action := 'JS open';
  htp.p('
   <script>
    document.addEventListener("DOMContentLoaded", function(){ 
      var canvas = Raphael(document.getElementById("canvas"), ' || v_image_width || ', ' || v_image_height || ');
  ');

  s_action := 'JS data loop';
  for rec_k in (
         select rownum, image_id, coordinate_id, 
                c_m_x, c_m_y, c_l_x, c_l_y,
                coordinate_power_grid_id_from,
                coordinate_power_grid_id_to,
                area, status,
                case when status = 1 then 0 else 1 end as status_neu
         from vw_rjs_power_grid
         where image_id = in_image_id
  ) loop
    
      s_action := 'txt'||rec_k.rownum || ' generation.';
      htp.p ('
        var path'||rec_k.coordinate_id||' = canvas.path("M'||(rec_k.c_m_x)||','||(rec_k.c_m_y)||' L'||(rec_k.c_l_x)||','||(rec_k.c_l_y)||'")' 
                                                    || case when rec_k.status = 1 then
                                                         '.attr({"stroke": "#58C932","stroke-width": "4"})'
                                                       else
                                                         '.attr({"stroke": "#C93232","stroke-width": "4"})'
                                                       end
                                                    || '.click( function (event) { $s("P30_POWER_GRID_ENTRY","'||rec_k.coordinate_id||'"); });'
        || 'path'||rec_k.coordinate_id||'.node.id = path'||rec_k.coordinate_id||';
        ');   

  end loop; 

  s_action := 'JS close';
  htp.p('
    }, false);
   </script>
  ');

  
exception
when others then   
      rollback; s_ora_error := sqlerrm;
      s_custom_error := 'Internal error occured. Processing stopped.';
      add_err; commit;raise_application_error(-20001, s_custom_error);
end;  


/* deactivate power grid */  
procedure deactivate_power_grid (coordinate_id number default null)
is
begin
  s_proc_name := 'RJS_DEMO.DEACTIVATE_POWER_GRID';
  s_parameter := null;
  
  if coordinate_id is null then
    s_action := 'Update power_grid';
    update rjs_coordinate_power_grid
    set status = 0 
    where id in (select sd.id from vw_rjs_power_grid_deactivation sd);
  else
    s_action := 'Update power_grid';
    update rjs_coordinate_power_grid
    set status = 0 
    where id = coordinate_id;
  end if;
exception
when others then   
      rollback; s_ora_error := sqlerrm;
      s_custom_error := 'Internal error occured. Processing stopped.';
      add_err; commit;raise_application_error(-20001, s_custom_error);
end;    

/* power_grid reset data */  
procedure reset_power_grid
is
begin
  s_proc_name := 'RJS_DEMO.RESET_POWER_GRID';
  s_parameter := null;
  
  s_action := 'Update power grid';
  update rjs_coordinate_power_grid
  set status = 1;

exception
when others then   
      rollback; s_ora_error := sqlerrm;
      s_custom_error := 'Internal error occured. Processing stopped.';
      add_err; commit;raise_application_error(-20001, s_custom_error);
end;    

/* create sweden cities (HTML,JS)  */ 
procedure generate_sweden_cities
is
  v_image_filename           varchar2(100);
  v_image_name                varchar2(100);
  v_image_width              number;
  v_image_height               number;
  
  v_background_color varchar2(100);
begin
  s_proc_name := 'RJS_DEMO.generate_sweden_cities';
  s_parameter := null;
  
  s_action := 'HTML und JS initialization';
  htp.p('
    <div id="svg_scandinavia" class="container">
        <div class="map">No data found</div>
    </div>
    <script>
    
     /* Call the procedure after every JS library got loaded */
     document.addEventListener("DOMContentLoaded", function(){ 
    
        $("#svg_scandinavia").mapael({
            map : {
                name : "scandinavia",
                defaultArea: {
                            attrs: {
                              fill: "#f4f4e8"
                              , stroke: "#00a1fe"
                            }
                            , attrsHover: {
                               fill: "#a4e100"
                            }
                },
                // Enable zoom on the map
                zoom: {
                        enabled: true
                }
            },
            // Add some plots on the map
            plots: {
                    // Image plot');
                        
  s_action := 'JS data loop';
  for rec_k in (
      select 
        case 
         when rownum != max(rownum) over () 
         then ','
         else ''
        end as comma,
        geo_type,
        country_key,
        country,
        attribute1,
        case 
          when to_number(attribute2) > 50000 then attribute1
          else null
        end as important_city_names,
        attribute2,
        attribute3,
        to_char(lat, 'fm9999999990d0', 'NLS_NUMERIC_CHARACTERS = ''. ''') as lat,
        to_char(lon, 'fm9999999990d0', 'NLS_NUMERIC_CHARACTERS = ''. ''') as lon
      from rjs_geo_marker
      where country_key = 'SE'
      and lat is not null
      and geo_type = 'City'
      order by rownum
  ) loop
    
      s_action := 'City '||rec_k.attribute1 || ' generation.';
      htp.p ('
                    '''||rec_k.attribute1||''': {
                        type: "image",
                        url: "'||v('APP_IMAGES')||'mapael/marker.png",
                        width: 6,
                        height: 20,
                        latitude: '||rec_k.lat||',
                        longitude: '||rec_k.lon||',
                        attrs: {
                            opacity: 1
                        },
                        attrsHover: {
                            transform: "s2.0"
                        },
                        href: "#",
                        /* target: "_blank", */
                        text: {
                            content: "'||rec_k.important_city_names||'"
                            , position: "right"
                            , margin: 0
                            , attrs: {"font-size": 8, fill: "#505444", opacity: 1}
                            , attrsHover: {fill: "#000", opacity: 1}
                        },
                        "tooltip": {
                            "content": "<span style=\"font-weight:bold;\">'||rec_k.attribute1||'<\/span><br \/>Population : '||rec_k.attribute2||'"
                        }
                    }' || rec_k.comma 
            );   

  end loop;
  
  s_action := 'JS close';
  htp.p('  
                }
        });
    
     }, false);      
    </script>
  ');
  
exception
when others then   
      rollback; s_ora_error := sqlerrm;
      s_custom_error := 'Internal error occured. Processing stopped.';
      add_err; commit;raise_application_error(-20001, s_custom_error);
end;  

/* create sweden cities (HTML,JS) - Extended  */ 
procedure generate_sweden_cities2
is
  v_image_filename           varchar2(100);
  v_image_name                varchar2(100);
  v_image_width              number;
  v_image_height               number;
  
  v_background_color varchar2(100);
  
  v_zoom_x   number;
  v_zoom_y   number;
  v_zoom_lvl number;
begin
  s_proc_name := 'RJS_DEMO.generate_sweden_cities';
  s_parameter := null;

  s_action := 'Zoom Faktor berechnen';
  select
   nvl(to_char((max(x)+min(x))/2, 'fm9999999990', 'NLS_NUMERIC_CHARACTERS = ''. '''),296) x,
   nvl(to_char((max(y)+min(y))/2, 'fm9999999990', 'NLS_NUMERIC_CHARACTERS = ''. '''),400) y,
   case 
     when max(x)-min(x) > 300
       or max(y)-min(y) > 300 then 0
     when max(x)-min(x) > 150
       or max(y)-min(y) > 150 then 2
     when max(x)-min(x) > 70 
       or max(y)-min(y) > 70 then 5
     when max(x)-min(x) > 50 
       or max(y)-min(y) > 50 then 8
     when max(x)-min(x) > 30 
       or max(y)-min(y) > 30 then 9
     when max(x)-min(x) >= 0 
       or max(y)-min(y) >= 0 then 10
     else 0
   end as zoom
  into 
    v_zoom_x,
    v_zoom_y,
    v_zoom_lvl 
  from (
    select 
      (gm.lat*-53.693765921788)+3839.1042634078 as y,--lat, y = (lat * yfactor) + yoffset
      (gm.lon*26.85115122807)+-102.03437466667 as x, --lon, x = (lon * xfactor) + xoffset
      gm.attribute1
    from rjs_geo_marker gm
    where geo_type = 'Custom'
    and (v('P28_FILTER_MARKER') is null or gm.attribute3 = v('P28_FILTER_MARKER'))
  );  
  
  s_action := 'HTML und JS initialization';
  htp.p('
    <div id="svg_scandinavia" class="container">
        <div class="map">No data found</div>
    </div>
    <script>
    
     /* Call the procedure after every JS library got loaded */
     document.addEventListener("DOMContentLoaded", function(){ 
    
       $(function () {
         $mapcontainer = $("#svg_scandinavia");
         $mapcontainer.mapael({   
            map : {
                name : "scandinavia",
                defaultArea: {
                            attrs: {
                              fill: "#f4f4e8"
                              , stroke: "#00a1fe"
                            }
                            , attrsHover: {
                               fill: "#a4e100"
                            }
                },
                // Enable zoom on the map
                zoom: {
                        enabled: true
                }
            },
            // Add some plots on the map
            plots: {
                    // Image plot');
                        
  s_action := 'JS data loop';
  for rec_k in (
      select 
        rowid as row_id, 
        lower(geo_type)||'_'||to_char(rownum,'fm0000000') as cust_id,
        case 
         when rownum != max(rownum) over () 
         then ','
         else ''
        end as comma,
        geo_type,
        country_key,
        country,
        attribute1,
        case 
          when geo_type = 'City' and to_number(attribute2) > 50000 then attribute1
          else null
        end as important_city_names,
        attribute2,
        nvl(attribute3,'mapael/marker_grey.png') attribute3,
        to_char(lat, 'fm9999999990d0', 'NLS_NUMERIC_CHARACTERS = ''. ''') as lat,
        to_char(lon, 'fm9999999990d0', 'NLS_NUMERIC_CHARACTERS = ''. ''') as lon,
        apex_util.prepare_url('f?p='||v('APP_ID')||':28:'||v('APP_SESSION')||'::NO::P28_ROWID:'||rowid) as link
      from rjs_geo_marker
      where country_key = 'SE'
      and lat is not null
      and  (v('P28_FILTER_MARKER') is null or 
              geo_type = 'Custom' and
              attribute3 = v('P28_FILTER_MARKER') or 
              geo_type != 'Custom'
           )
      order by rownum
  ) loop
    
    s_action := 'City '||rec_k.attribute1 || ' generation.';
    if rec_k.geo_type = 'City' then
      htp.p ('
                    '''||rec_k.attribute1||''': {
                        type: "image",
                        url: "'||v('APP_IMAGES')||'mapael/marker.png",
                        width: 6,
                        height: 20,
                        latitude: '||rec_k.lat||',
                        longitude: '||rec_k.lon||',
                        attrs: {
                            opacity: 1
                        },
                        attrsHover: {
                            transform: "s2.0"
                        },
                        href: "#",
                        /* target: "_blank", */
                        text: {
                            content: "'||rec_k.important_city_names||'"
                            , position: "right"
                            , margin: 0
                            , attrs: {"font-size": 8, fill: "#505444", opacity: 1}
                            , attrsHover: {fill: "#000", opacity: 1}
                        },
                        "tooltip": {
                            "content": "<span style=\"font-weight:bold;\">'||rec_k.attribute1||'<\/span><br \/>Population : '||rec_k.attribute2||'"
                        }
                    }' || rec_k.comma 
            );   
    else
      htp.p ('
                    '''||rec_k.cust_id||''': {
                        type: "image",
                        url: "'||v('APP_IMAGES')||rec_k.attribute3||'",
                        width: 6,
                        height: 20,
                        latitude: '||rec_k.lat||',
                        longitude: '||rec_k.lon||',
                        attrs: {
                            opacity: 1
                        },
                        attrsHover: {
                            transform: "s2.0"
                        },
                        href: "javascript:apex.navigation.redirect('''||rec_k.link||''');",
                        /* target: "_blank", */
                        text: {
                            content: "'||rec_k.attribute1||'"
                            , position: "right"
                            , margin: 0
                            , attrs: {"font-size": 8, fill: "#505444", opacity: 1}
                            , attrsHover: {fill: "#000", opacity: 1}
                        },
                        "tooltip": {
                            "content": "'||rec_k.attribute2||'"
                        }
                    }' || rec_k.comma 
            );   
    end if;
  end loop;
  
  s_action := 'JS close';
  htp.p('  
                }
          });
        });
    
    
       setTimeout(function(){ $(".zoomButton").css("display","none") }, 500);
     }, false);  
     
     function mapaelZoomIn() {
          $mapcontainer.trigger(''zoom'', {level : '||v_zoom_lvl||', x: '||v_zoom_x||', y : '||v_zoom_y||'});
     };   
     
     function mapaelZoomOut() {
          $(''.zoomReset'').click();
     };    
    </script>
  ');
  
exception
when others then   
      rollback; s_ora_error := sqlerrm;
      s_custom_error := 'Internal error occured. Processing stopped.';
      add_err; commit;raise_application_error(-20001, s_custom_error);
end;  

/* create sweden cities (HTML,JS,Sparklines)  */ 
procedure generate_sweden_cities3
is
  v_image_filename           varchar2(100);
  v_image_name                varchar2(100);
  v_image_width              number;
  v_image_height               number;
  
  v_background_color varchar2(100);
begin
  s_proc_name := 'RJS_DEMO.generate_sweden_cities';
  s_parameter := null;

  htp.p('
    <script>
     /* Offset definition */
     var v_top;
     var v_left;
     var v_pie_size;
    
     document.addEventListener("DOMContentLoaded", function(){ 
         
        if ($(window).width() < 1024) {
          v_top = 17;
          v_left = 7;
          v_pie_size = "10px";
         } else if ($(window).width() > 1023 && $(window).width() < 1280) {
          v_top = 20;
          v_left = 5;
          v_pie_size = "14px";
         } else if ($(window).width() > 1279 && $(window).width() < 1600) {
          v_top = 20;
          v_left = 3;
          v_pie_size = "18px";
         } else {
          v_top = 27;
          v_left = 7;
          v_pie_size = "18px";
        }
         
     }, false);       
    </script>
  ');
  
  s_action := 'Map HTML und JS initialization';
  htp.p('
    <div id="svg_scandinavia" class="container">
        <div class="map">No data found</div>
    </div>
    <script>
    
     /* Call the procedure after every JS library got loaded */
     document.addEventListener("DOMContentLoaded", function(){ 
    
        $("#svg_scandinavia").mapael({
            map : {
                name : "scandinavia",
                defaultArea: {
                            attrs: {
                              fill: "#f4f4e8"
                              , stroke: "#00a1fe"
                            }
                            , attrsHover: {
                               fill: "#a4e100"
                            }
                },
                // Enable zoom on the map
                zoom: {
                        enabled: false
                }
            },
            // Add some plots on the map
            plots: {
                    // Image plot');
                        
  s_action := 'Map data loop';
  for rec_k in (
      select 
        case 
         when rownum != max(rownum) over () 
         then ','
         else ''
        end as comma,
        id,
        name,
        live_births,
        deaths,
        to_char(lat, 'fm9999999990d0', 'NLS_NUMERIC_CHARACTERS = ''. ''') as lat,
        to_char(lon, 'fm9999999990d0', 'NLS_NUMERIC_CHARACTERS = ''. ''') as lon
      from rjs_sweden_statistic_data
      where year = 2015
      and lat is not null
      and (v('P31_COMMUNITY') is null or instr(':'||v('P31_COMMUNITY')||':',':'||id||':')>0 )
      order by rownum
  ) loop
    
      s_action := 'City lc_'||rec_k.id || ' generation.';
      htp.p ('
                    ''lc_'||rec_k.id||''': {
                        type: "image",
                        url: "'||v('APP_IMAGES')||'mapael/marker_hidden.png",
                        width: 6,
                        height: 20,
                        latitude: '||rec_k.lat||',
                        longitude: '||rec_k.lon||',
                        attrs: {
                            opacity: 1
                        },
                        attrsHover: {
                            transform: "s2.0"
                        },
                        href: "#",
                        /* target: "_blank", */
                        text: {
                            content: "'||rec_k.name||'"
                            , position: "right"
                            , margin: 0
                            , attrs: {"font-size": 8, fill: "#505444", opacity: 1}
                            , attrsHover: {fill: "#000", opacity: 1}
                        }
                    }' || rec_k.comma 
            );   

  end loop;
  
  s_action := 'Map close';
  htp.p('  
                }
        });
        
     }, false);      
    </script>
  ');

  s_action := 'JS data loop';
  for rec_s in (
      select 
        case 
         when rownum != max(rownum) over () 
         then ','
         else ''
        end as comma,
        id,
        name,
        to_char(live_births,'fm9999990') as live_births,
        to_char(deaths,'fm9999990') as deaths
      from rjs_sweden_statistic_data
      where year = 2015
      and lat is not null
      and (v('P31_COMMUNITY') is null or instr(':'||v('P31_COMMUNITY')||':',':'||id||':')>0 )
      order by rownum
  ) loop      
  
  s_action := 'Sparkline Span creation + Data loop';
  htp.p('
    <span id="sp_'||rec_s.id||'" data-detail-id="'||rec_s.id||'" data-sp="'||rec_s.live_births||','||rec_s.deaths||'">'||rec_s.live_births||','||rec_s.deaths||'</span>
  ');
  end loop;
  
  s_action := 'Sparkline Initialization';
  htp.p('
    <script>
     document.addEventListener("DOMContentLoaded", function(){        
       /* Draw a sparkline for the #sparkline element */
       $("span[data-sp]").each(function() {
         $(this).sparkline("html",{
             type: "pie",
             width: v_pie_size,
             height: v_pie_size,
             sliceColors: ["#5FBA7D", "#BF151B"]
         }).find("canvas").attr("id","spc_"+$(this).data("detail-id"));
         $("#spc_"+$(this).data("detail-id")).css(
           {"position": "absolute",
            "top": $("image[data-id$=''lc_"+$(this).data("detail-id")+"'']").offset().top-$(".map").offset().top+v_top,
            "left": $("image[data-id$=''lc_"+$(this).data("detail-id")+"'']").offset().left-$(".map").offset().left+v_left
           }
         ).attr("data-spc","spChart").attr("data-ref-id","lc_"+$(this).data("detail-id"));
       });
     }, false);      
    </script>
  ');

exception
when others then   
      rollback; s_ora_error := sqlerrm;
      s_custom_error := 'Internal error occured. Processing stopped.';
      add_err; commit;raise_application_error(-20001, s_custom_error);
end;  

/* create hand svg model (HTML,CSS,JS)  */  
procedure generate_hand
is
  v_image_filename   varchar2(100);
  v_image_name       varchar2(100);
  v_image_width      number;
  v_image_height     number;
  
  v_background_color varchar2(100);
  
  v_groups           varchar2(4000);
begin
  s_proc_name := 'RJS_DEMO.GENERATE_HAND';
  s_parameter := null;
  
  s_action := 'HTML generation';
  htp.p('
   <style>
     #rjs_hand{
      height: 100%;
      width: 100%;
     }
   </style>
   <div id="rjs_hand"></div>
   ');
   

  s_action := 'JS open';
  htp.p('<script>');
  
  s_action := 'JS initialize variables';
  for rec_k in (
      select
         element_id,
         'var ' || element_id || ';' || chr(13) as code
      from rjs_coordinate_hand
      where type = 'GROUP'
      and element_id is not null
      order by element_id
  ) loop
    
      s_action := '  variable '||rec_k.element_id || ' generation.';
      htp.p (rec_k.code); 
  end loop;
  
  s_action := 'JS initialize Raphael after "Page Load" and set up responsive behavior';
  htp.p('
document.addEventListener("DOMContentLoaded", function(){ 
var w = 255;
var h = 379.99999;

var rjs_hand = Raphael("rjs_hand");

rjs_hand.setViewBox(0,0,w,h,true);
rjs_hand.setSize(''100%'', ''100%'');
  ' || chr(13) );

  s_action := 'JS data loop - SVG elements';
  for rec_k in (
       select
         id,
         group_name,
         rn,
         case
           when rn = 1
           then nvl(element_parent_id,element_id) || ' = rjs_hand.set();' || chr(13) || code
           else code 
           end as code
       from (
         select id,
                element_id,
                element_parent_id,
                element_real_parent_id,
                case
                 when nvl(instr(sys_connect_by_path(element_id,'>'),'>',2),0) = 0
                 then '>'||element_id||'>'
                 else substr(sys_connect_by_path(element_id,'>'),1,instr(sys_connect_by_path(element_id,'>'),'>',2)) 
                end as group_name,
                row_number () over (
                  partition by
                    case
                     when nvl(instr(sys_connect_by_path(element_id,'>'),'>',2),0) = 0
                     then '>'||element_id||'>'
                     else substr(sys_connect_by_path(element_id,'>'),1,instr(sys_connect_by_path(element_id,'>'),'>',2))
                    end 
                  order by
                    sys_connect_by_path(element_id,'>') desc, id
                  ) as rn,
                  code
         from rjs_coordinate_hand
         start with element_parent_id is null
         connect by prior element_id = element_parent_id
      )
      order by decode(element_real_parent_id,null,group_name,'>'||element_real_parent_id||'>'), rn
  ) loop
    
      s_action := 'txt'||rec_k.id || ' generation.';
      htp.p (rec_k.code); 
  end loop;

  s_action := 'JS Initialize data group';
  select 
    chr(13)||'var rs
    rGroups = ['||listagg(element_id,', ') within group (order by id)||'];'||chr(13)||chr(13)
  into
    v_groups
  from rjs_coordinate_hand 
  where type ='GROUP';
  htp.p(v_groups);
  
  s_action := 'JS data loop - path grouping';
  for rec_k in (
      select 
        element_parent_id,
        element_parent_id ||
        '.push(' ||
        listagg(substr(code,5,instr(code,'=')-6),', ') within group (order by id) ||
        ');' || chr(13) as path_group
      from rjs_coordinate_hand 
      where type ='PATH'
      group by element_parent_id
      order by element_parent_id
  ) loop
    
      s_action := 'path group for '||rec_k.element_parent_id || ' generation.';
      htp.p (rec_k.path_group); 
  end loop;
  

  s_action := 'JS data loop - Events (Click events, Hover effects, Finger move)';
  for rec_k in (
      select 
        element_id,
        chr(13) || element_id||'.hover(' || chr(13) ||
        '  function(){'||element_id||'.animate({ "fill-opacity": "0.5" }, 100); $('||element_id||').css("cursor","pointer")}, ' || chr(13) ||
        '  function(){'||element_id||'.animate({ "fill-opacity": "' ||
        case
          when instr(code,'fill-opacity:') > 0
          then substr(code,instr(code,'fill-opacity:')+13,10)
          else '1.0'
        end
        ||'", "cursor": "auto" }, 100)} '|| chr(13)||
        '); '|| chr(13)||
        case
         when element_id = 'g_zf4'
         then  element_id||'.click(function(){ apex.event.trigger(document,"FingerMove") });'
         else  element_id||'.click(function(){ apex.event.trigger(document,"FingerShowDetails", [{fingerid:"'||decode(element_real_parent_id,null,element_id,element_real_parent_id)||'"}]) });'
        end as hover_effect
      from rjs_coordinate_hand 
      where type ='GROUP'
      order by element_id
  ) loop
    
      s_action := 'Event for '||rec_k.element_id || ' generation.';
      htp.p (rec_k.hover_effect); 
  end loop;
  
  s_action := 'JS close';
  htp.p('
}, false);
</script>
  ');

  
exception
when others then   
      rollback; s_ora_error := sqlerrm;
      s_custom_error := 'Internal error occured. Processing stopped.';
      add_err; commit;raise_application_error(-20001, s_custom_error);
end;  


/* create tram (JS)  */  
procedure generate_tram (in_tram_id in number, in_counter in out number)
is
  v_image_filename   varchar2(100);
  v_image_name       varchar2(100);
  v_image_width      number;
  v_image_height     number;
  
  v_background_color varchar2(100);
  
  v_groups           varchar2(4000);
begin
  s_proc_name := 'RJS_DEMO.GENERATE_TRAM';
  s_parameter := null;
  
  s_action := 'JS open';
  htp.p('<script>'||chr(13));
  
  s_action := 'JS initialize variables';
  for rec_t in (
      select 
        tram_id,
        station_id,
        replace(
          replace(
            replace(result,'tram'||tram_id,'tram'||tram_id||'_'||in_counter) 
          ,'t'||tram_id||'hs','t'||tram_id||'_'||in_counter||'hs') 
        ,'t'||tram_id||'ap','t'||tram_id||'_'||in_counter||'ap') as result
      from vw_rjs_tram
      where tram_id = in_tram_id
      order by station_order_number
  ) loop
  
      s_action := 'tram: ' || rec_t.tram_id || ', station: '|| rec_t.station_id || ' generation.';
      htp.prn (rec_t.result); 
  
  end loop;
  
  s_action := 'JS close';
  htp.p(chr(13)||'</script>');
  
exception
when others then   
      rollback; s_ora_error := sqlerrm;
      s_custom_error := 'Internal error occured. Processing stopped.';
      add_err; commit;raise_application_error(-20001, s_custom_error);
end;  

end;

/
--------------------------------------------------------
--  DDL for Package RJS_DEMO
--------------------------------------------------------

  CREATE OR REPLACE PACKAGE "RJS_DEMO" as
/* Error Handling */
procedure add_err;

/* Harbor example */
procedure generate_harbor (in_image_id number);
procedure generate_harbor2 (in_image_id number);
procedure generate_harbor_dd(in_image_id number);
function return_harbor_by_pos (in_x number, in_y number, in_width number, in_height number, in_ship_id number) return number;


/* Image Editor */
procedure generate_image_editor (in_image_id number);
procedure generate_image_editor_new_el (in_image_id number);

/* Power grid example */
procedure generate_power_grid (in_image_id number);
  
procedure deactivate_power_grid (coordinate_id number default null);

procedure reset_power_grid;

/* Mapael - Sweden example */
procedure generate_sweden_cities;
procedure generate_sweden_cities2;
procedure generate_sweden_cities3;

/* SVG example - Raphaël */
procedure generate_hand;

/* SVG example - SVG.JS */
procedure generate_tram (in_tram_id number, in_counter in out number);

end rjs_demo;

/
--------------------------------------------------------
--  DDL for Function GET_DISTANCE
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "GET_DISTANCE" (a_lat number,a_lon number,b_lat number, b_lon number)
return number is
/* Prüfe Zwei Geo Koordinaten auf Entfernung */
/* Source: https://community.oracle.com/message/1703382 */
  circum number := 40000; -- kilometers
  pai number := acos(-1);
  a_nx number;
  a_ny number;
  a_nz number;
  b_nx number;
  b_ny number;
  b_nz number;
  inner_product number;
begin
  if (a_lat=b_lat) and (a_lon=b_lon) then
    return 0;
    else
    a_nx := cos(a_lat*pai/180) * cos(a_lon*pai/180);
    a_ny := cos(a_lat*pai/180) * sin(a_lon*pai/180);
    a_nz := sin(a_lat*pai/180);
    
    b_nx := cos(b_lat*pai/180) * cos(b_lon*pai/180);
    b_ny := cos(b_lat*pai/180) * sin(b_lon*pai/180);
    b_nz := sin(b_lat*pai/180);
    
    inner_product := a_nx*b_nx + a_ny*b_ny + a_nz*b_nz;
    
    if inner_product > 1 then
      return 0;
    else
      return (circum*acos(inner_product))/(2*pai);
    end if;
  end if;
end;

/
--------------------------------------------------------
--  DDL for Function GET_WITH_CLAUSE
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "GET_WITH_CLAUSE" (p_table_name in varchar2, p_include_with_clause number default 1, p_rows in number default 10) return clob as
/* Dynamische WITH-Klausel mit SELECT FROM DUAL auf Basis einer vorhandenen Tabelle generieren
   Übergabeparameter: 
     p_table_name = Tabellename
     p_include_with_clause = 1 oder 0, wenn 1 dann mit WITH-Klausel ansonsten nur SELECT FROM DUAL
     p_rows  = Anzahl Zeilen die zurückgegeben werden sollen, wenn NULL, dann alle
*/
 l_sql1 varchar2(4000);
 l_sql2 clob;
begin 
  select 'SELECT ' || chr(13) 
    || 
       case 
        when p_include_with_clause = 1 then
         '''WITH ' || max(table_name) || ' AS ('' ||' || chr(13) 
        else 
         null
       end
    || 'REGEXP_REPLACE(DBMS_XMLGEN.CONVERT(XMLAGG(XMLELEMENT(E, ' || chr(13) 
       || 'CHR(13) || ''SELECT '' || CHR(13) || '
       || replace(listagg(
                case 
                  when data_type = 'NUMBER' 
                    then 'nvl(trim(to_char('||column_name||')),''NULL'') || ''  as ' || column_name || ',''|| CHR(13) || '
                  when data_type = 'VARCHAR2' 
                    then 'decode('||column_name||',NULL,''NULL'',''''''''||'||column_name||'||'''''''') || ''  as ' || column_name || ',''|| CHR(13) || '
                  when data_type = 'DATE' 
                    then 'decode('||column_name||',NULL,''NULL'',''''''''||to_char('||column_name||',''dd.mm.yyyy hh24:mi'')||'''''''') || '' as ' || column_name || ',''|| CHR(13) || '
                  else 
                    null
                end
                , ' '
          ) within group (order by rownum) || 'ZZ',',''|| CHR(13) || ZZ',' '' ||')
       || chr(13) 
       || '''FROM DUAL UNION ALL '''
       || chr(13) 
    || ')).EXTRACT(''//text()'').GETCLOBVAL(),1)||''XX'','' UNION ALL XX'','''')'
    ||
       case 
        when p_include_with_clause = 1 then
          '|| CHR(13) || '') ' || 'SELECT t1.* FROM ' || max(table_name) || ' t1 ORDER BY 1'''
        else 
          null
       end
    || chr(13) 
    || 'FROM ' 
    || max(table_name)
    || chr(13) 
    || case when p_rows is null then null else 'WHERE ROWNUM BETWEEN 1 AND ' || trim(to_char(p_rows)) end
  into l_sql1
  from user_tab_columns
  where table_name = p_table_name
  and data_type in ('NUMBER','VARCHAR2','DATE');
 
  execute immediate (l_sql1) into l_sql2;
 
  return l_sql2;
end get_with_clause;

/
--------------------------------------------------------
--  Constraints for Table RJS_COORDINATE_HAND
--------------------------------------------------------

  ALTER TABLE "RJS_COORDINATE_HAND" MODIFY ("CREATED_BY" NOT NULL ENABLE);
  ALTER TABLE "RJS_COORDINATE_HAND" MODIFY ("CREATED_ON" NOT NULL ENABLE);
  ALTER TABLE "RJS_COORDINATE_HAND" MODIFY ("ID" NOT NULL ENABLE);
--------------------------------------------------------
--  Constraints for Table RJS_COORDINATE_HARBOR
--------------------------------------------------------

  ALTER TABLE "RJS_COORDINATE_HARBOR" MODIFY ("ID" NOT NULL ENABLE);
  ALTER TABLE "RJS_COORDINATE_HARBOR" MODIFY ("CREATED_ON" NOT NULL ENABLE);
  ALTER TABLE "RJS_COORDINATE_HARBOR" MODIFY ("CREATED_BY" NOT NULL ENABLE);
  ALTER TABLE "RJS_COORDINATE_HARBOR" MODIFY ("C_X" NOT NULL ENABLE);
  ALTER TABLE "RJS_COORDINATE_HARBOR" MODIFY ("C_Y" NOT NULL ENABLE);
  ALTER TABLE "RJS_COORDINATE_HARBOR" MODIFY ("IMAGE_ID" NOT NULL ENABLE);
  ALTER TABLE "RJS_COORDINATE_HARBOR" ADD CONSTRAINT "RJS_KOORDINATE_PK" PRIMARY KEY ("ID") ENABLE;
  ALTER TABLE "RJS_COORDINATE_HARBOR" MODIFY ("MAX_LENGTH" NOT NULL ENABLE);
--------------------------------------------------------
--  Constraints for Table RJS_COORDINATE_POWER_GRID
--------------------------------------------------------

  ALTER TABLE "RJS_COORDINATE_POWER_GRID" MODIFY ("ID" NOT NULL ENABLE);
  ALTER TABLE "RJS_COORDINATE_POWER_GRID" MODIFY ("CREATED_ON" NOT NULL ENABLE);
  ALTER TABLE "RJS_COORDINATE_POWER_GRID" MODIFY ("CREATED_BY" NOT NULL ENABLE);
  ALTER TABLE "RJS_COORDINATE_POWER_GRID" MODIFY ("C_M_X" NOT NULL ENABLE);
  ALTER TABLE "RJS_COORDINATE_POWER_GRID" MODIFY ("C_M_Y" NOT NULL ENABLE);
  ALTER TABLE "RJS_COORDINATE_POWER_GRID" MODIFY ("C_L_X" NOT NULL ENABLE);
  ALTER TABLE "RJS_COORDINATE_POWER_GRID" MODIFY ("C_L_Y" NOT NULL ENABLE);
  ALTER TABLE "RJS_COORDINATE_POWER_GRID" MODIFY ("IMAGE_ID" NOT NULL ENABLE);
  ALTER TABLE "RJS_COORDINATE_POWER_GRID" ADD CONSTRAINT "RJS_COORDINATE_POWER_GRID_PK" PRIMARY KEY ("ID") ENABLE;
  ALTER TABLE "RJS_COORDINATE_POWER_GRID" MODIFY ("STATUS" NOT NULL ENABLE);
--------------------------------------------------------
--  Constraints for Table RJS_DATA_HAND
--------------------------------------------------------

  ALTER TABLE "RJS_DATA_HAND" MODIFY ("CREATED_BY" NOT NULL ENABLE);
  ALTER TABLE "RJS_DATA_HAND" MODIFY ("CREATED_ON" NOT NULL ENABLE);
  ALTER TABLE "RJS_DATA_HAND" MODIFY ("ID" NOT NULL ENABLE);
--------------------------------------------------------
--  Constraints for Table RJS_DATA_HARBOR
--------------------------------------------------------

  ALTER TABLE "RJS_DATA_HARBOR" MODIFY ("ID" NOT NULL ENABLE);
  ALTER TABLE "RJS_DATA_HARBOR" MODIFY ("CREATED_ON" NOT NULL ENABLE);
  ALTER TABLE "RJS_DATA_HARBOR" MODIFY ("CREATED_BY" NOT NULL ENABLE);
  ALTER TABLE "RJS_DATA_HARBOR" MODIFY ("RESULT_TYPE" NOT NULL ENABLE);
  ALTER TABLE "RJS_DATA_HARBOR" MODIFY ("COORDINATE_ID" NOT NULL ENABLE);
  ALTER TABLE "RJS_DATA_HARBOR" ADD CONSTRAINT "RJS_DATA_HARBOR_PK" PRIMARY KEY ("ID") ENABLE;
  ALTER TABLE "RJS_DATA_HARBOR" MODIFY ("TEXT_LENGTH" NOT NULL ENABLE);
--------------------------------------------------------
--  Constraints for Table RJS_DATA_TRAM_PLAN
--------------------------------------------------------

  ALTER TABLE "RJS_DATA_TRAM_PLAN" MODIFY ("CREATED_BY" NOT NULL ENABLE);
  ALTER TABLE "RJS_DATA_TRAM_PLAN" MODIFY ("CREATED_ON" NOT NULL ENABLE);
  ALTER TABLE "RJS_DATA_TRAM_PLAN" MODIFY ("ID" NOT NULL ENABLE);
--------------------------------------------------------
--  Constraints for Table RJS_IMAGE
--------------------------------------------------------

  ALTER TABLE "RJS_IMAGE" ADD CONSTRAINT "RJS_IMAGE_PK" PRIMARY KEY ("ID") ENABLE;
  ALTER TABLE "RJS_IMAGE" MODIFY ("ID" NOT NULL ENABLE);
  ALTER TABLE "RJS_IMAGE" MODIFY ("CREATED_ON" NOT NULL ENABLE);
  ALTER TABLE "RJS_IMAGE" MODIFY ("CREATED_BY" NOT NULL ENABLE);
  ALTER TABLE "RJS_IMAGE" MODIFY ("IMAGE_FILENAME" NOT NULL ENABLE);
  ALTER TABLE "RJS_IMAGE" MODIFY ("IMAGE_NAME" NOT NULL ENABLE);
  ALTER TABLE "RJS_IMAGE" MODIFY ("IMAGE_WIDTH" NOT NULL ENABLE);
  ALTER TABLE "RJS_IMAGE" MODIFY ("IMAGE_HEIGHT" NOT NULL ENABLE);
--------------------------------------------------------
--  Ref Constraints for Table RJS_COORDINATE_HARBOR
--------------------------------------------------------

  ALTER TABLE "RJS_COORDINATE_HARBOR" ADD CONSTRAINT "RJS_KOORDINATE_FK1" FOREIGN KEY ("IMAGE_ID")
	  REFERENCES "RJS_IMAGE" ("ID") ENABLE;
--------------------------------------------------------
--  Ref Constraints for Table RJS_COORDINATE_POWER_GRID
--------------------------------------------------------

  ALTER TABLE "RJS_COORDINATE_POWER_GRID" ADD CONSTRAINT "RJS_COORDINATE_POWER_GRID_FK1" FOREIGN KEY ("IMAGE_ID")
	  REFERENCES "RJS_IMAGE" ("ID") ENABLE;
--------------------------------------------------------
--  Ref Constraints for Table RJS_DATA_HARBOR
--------------------------------------------------------

  ALTER TABLE "RJS_DATA_HARBOR" ADD CONSTRAINT "RJS_DATA_HARBOR_FK1" FOREIGN KEY ("COORDINATE_ID")
	  REFERENCES "RJS_COORDINATE_HARBOR" ("ID") ENABLE;
