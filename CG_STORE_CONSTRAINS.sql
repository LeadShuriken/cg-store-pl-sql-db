-- ################# 'ADMINISTRATORS' #################
-- ################# 'ADMINISTRATORS' #################
-- ################# 'ADMINISTRATORS' #################

ALTER TABLE ADMINISTRATORS
 ADD CONSTRAINT ADMINISTRATORS_PK PRIMARY KEY (ADMINISTRATOR_ID)
 ADD CONSTRAINT ADMIN_IS_UNIQUE UNIQUE (FIRST_NAME,LAST_NAME,PHONE)
/

CREATE SEQUENCE ADMINISTRATORS_ID_SEQ
 INCREMENT BY 1
 START WITH 1
 NOMAXVALUE
 MINVALUE 1
 NOCYCLE
 NOCACHE
/

CREATE OR REPLACE TRIGGER ADMIN_BI
BEFORE INSERT ON ADMINISTRATORS
FOR EACH ROW
BEGIN
:NEW.ADMINISTRATOR_ID := ADMINISTRATORS_ID_SEQ.NEXTVAL;
:NEW.CREATED_BY := USER;
:NEW.CREATED_DATE := SYSDATE;
END;
/

CREATE OR REPLACE TRIGGER ADMIN_BU
BEFORE UPDATE ON ADMINISTRATORS
FOR EACH ROW
BEGIN
:NEW.MODIFIED_BY := USER;
:NEW.MODIFIED_DATE := SYSDATE;
END;
/

-- ################# 'CONTRIBUTORS' #################
-- ################# 'CONTRIBUTORS' #################
-- ################# 'CONTRIBUTORS' #################

ALTER TABLE CONTRIBUTORS
 MODIFY(FIRST_NAME CONSTRAINT CONTRIBUTORS_FIRST_NAME_NNULL NOT NULL)
 MODIFY(LAST_NAME CONSTRAINT CONTRIBUTORS_LAST_NAME_NNULL NOT NULL)
 ADD CONSTRAINT CONTRIBUTORS_PK PRIMARY KEY (CONTRIBUTOR_ID)
 ADD CONSTRAINT CONTRIBUTORS_UK UNIQUE (FIRST_NAME,LAST_NAME)
/

CREATE SEQUENCE CONTRIBUTORS_ID_SEQ
 INCREMENT BY 1
 START WITH 1
 NOMAXVALUE
 MINVALUE 1
 NOCYCLE
 NOCACHE
/

CREATE OR REPLACE TRIGGER CONTRIBUTORS_BI
BEFORE INSERT ON CONTRIBUTORS
FOR EACH ROW
BEGIN
:NEW.CONTRIBUTOR_ID := CONTRIBUTORS_ID_SEQ.NEXTVAL;
END;
/

-- ################# 'MODELS' #################
-- ################# 'MODELS' #################
-- ################# 'MODELS' #################

ALTER TABLE MODELS
 MODIFY(ADDED_CONTRIBUTOR_ID CONSTRAINT M_CONTRIBUTOR_ID_NNULL NOT NULL)
 ADD CONSTRAINT MODELS_PK PRIMARY KEY (MODEL_ID)
 ADD CONSTRAINT MODELS_FK FOREIGN KEY (ADDED_CONTRIBUTOR_ID) REFERENCES CONTRIBUTORS (CONTRIBUTOR_ID) ON DELETE CASCADE
 ADD CONSTRAINT MODELS_UK UNIQUE (ADDED_CONTRIBUTOR_ID, MODEL_NAME)
/
 
CREATE SEQUENCE MODEL_ID_SEQ
 INCREMENT BY 1
 START WITH 1
 NOMAXVALUE
 MINVALUE 1
 NOCYCLE
 NOCACHE
/
  
CREATE OR REPLACE FUNCTION contributor_is_good
	(con_id IN NUMBER)
RETURN BOOLEAN
AS
v_id_cnt NUMBER;
BEGIN
	SELECT COUNT(*) INTO v_id_cnt FROM CONTRIBUTORS WHERE CONTRIBUTOR_ID = con_id;
	RETURN 1 = v_id_cnt;
	EXCEPTION
		WHEN OTHERS
			THEN RETURN FALSE;
END contributor_is_good;
/

CREATE OR REPLACE FUNCTION segmentation_is_good
	(seg IN segmentation)
RETURN BOOLEAN
AS
	TYPE v_array IS TABLE OF NUMBER(8,0);
	my_array v_array;
BEGIN
	SELECT ID BULK COLLECT INTO my_array FROM MODELS_SEGMENTATION;
	FOR idx IN 1..seg.COUNT LOOP
		IF NOT seg(idx) member OF my_array THEN
			  RETURN FALSE;
		END IF;
	END LOOP;
	RETURN TRUE;
	EXCEPTION
		WHEN OTHERS
			THEN RETURN FALSE;
END segmentation_is_good;
/

CREATE OR REPLACE TRIGGER MODELS_BI
BEFORE INSERT ON MODELS
FOR EACH ROW
DECLARE
  TYPE tp IS TABLE OF NUMBER INDEX BY PLS_INTEGER;
  arr tp;
BEGIN
	FOR i IN 1 .. :new.SEGMENTATION.count loop
	  arr(:new.SEGMENTATION(i)) := i;
	END LOOP;
	IF arr.count <> :new.SEGMENTATION.count then
		RAISE_APPLICATION_ERROR (-20000, 'DUPLICATE SEGMENTATION');
	END IF;
	IF NOT segmentation_is_good(:new.SEGMENTATION) THEN
		RAISE_APPLICATION_ERROR(-20000, 'SEGMENTATION ID IS MISSING FROM GROUPS');
	END IF;
	IF NOT contributor_is_good(:new.ADDED_CONTRIBUTOR_ID) THEN
		RAISE_APPLICATION_ERROR(-20000, 'CONTRIBUTOR NOT FOUND');
	END IF;
	:NEW.MODEL_ID := MODEL_ID_SEQ.NEXTVAL;
END;
/

CREATE OR REPLACE TRIGGER MODELS_AI
AFTER INSERT ON MODELS
FOR EACH ROW
BEGIN
	INSERT INTO MODELS_CONTRIBUTORS VALUES
	(
		:new.MODEL_ID,
		:new.ADDED_CONTRIBUTOR_ID
	);
	INSERT INTO MODEL_PROCESSING VALUES
	(
		:new.MODEL_ID,
		NULL,
		NULL
	);
END;
/

-- ################# 'MODELS_CONTRIBUTORS' #################
-- ################# 'MODELS_CONTRIBUTORS' #################
-- ################# 'MODELS_CONTRIBUTORS' #################

ALTER TABLE MODELS_CONTRIBUTORS
 MODIFY(MODEL_ID CONSTRAINT MO_CO_MODELS_ID_NNULL NOT NULL)
 MODIFY(CONTRIBUTOR_ID CONSTRAINT MO_CO_CONTRIBUTOR_ID_NNULL NOT NULL)
 ADD CONSTRAINT MODEL_REL_IS_UNIQUE UNIQUE (MODEL_ID,CONTRIBUTOR_ID)
 ADD CONSTRAINT CON_MODEL_ID_FK FOREIGN KEY (MODEL_ID) REFERENCES MODELS (MODEL_ID) ON DELETE CASCADE
 ADD CONSTRAINT CON_CONTRIBUTOR_ID_FK FOREIGN KEY (CONTRIBUTOR_ID) REFERENCES CONTRIBUTORS (CONTRIBUTOR_ID) ON DELETE CASCADE
/

-- ################# 'MODEL_PROCESSING' #################
-- ################# 'MODEL_PROCESSING' #################
-- ################# 'MODEL_PROCESSING' #################

ALTER TABLE MODEL_PROCESSING
 MODIFY(MODEL_ID CONSTRAINT MP_MODELS_ID_NNULL NOT NULL)
 ADD CONSTRAINT MP_MODELS_PK PRIMARY KEY (MODEL_ID)
/

-- ################# 'ADMIN_ACTIVITIES' #################
-- ################# 'ADMIN_ACTIVITIES' #################
-- ################# 'ADMIN_ACTIVITIES' #################

ALTER TABLE ADMIN_ACTIVITIES
 ADD CONSTRAINT ADMIN_ACTIVITIES_PK PRIMARY KEY (ACTIVITY_ID)
 ADD CONSTRAINT ADMIN_ACTIVITIES_UNIQUE UNIQUE (MODEL_ID, ACTIVITY_TYPE)
 ADD CONSTRAINT ADMIN_ACTIVITIES_FK FOREIGN KEY (MODEL_ID) REFERENCES MODELS (MODEL_ID) ON DELETE CASCADE
 ADD CONSTRAINT TYPE_IS_SET_FROM CHECK (ACTIVITY_TYPE IN ('QA', 'SEGMENTATION'))
/

CREATE SEQUENCE ADMIN_ACTIVITIES_ID_SEQ
 INCREMENT BY 1
 START WITH 1
 NOMAXVALUE
 MINVALUE 1
 NOCYCLE
 NOCACHE
/

CREATE OR REPLACE FUNCTION model_id_is_good
	(model_id_id IN NUMBER)
RETURN BOOLEAN
AS
v_id_cnt NUMBER;
BEGIN
	SELECT COUNT(*) INTO v_id_cnt FROM MODELS WHERE MODEL_ID = model_id_id;
	RETURN 1 = v_id_cnt;
	EXCEPTION
		WHEN OTHERS
			THEN RETURN FALSE;
END model_id_is_good;
/

CREATE OR REPLACE TRIGGER ADMIN_ACTIVITIES_BI
BEFORE INSERT ON ADMIN_ACTIVITIES
FOR EACH ROW
BEGIN
	IF NOT model_id_is_good(:new.MODEL_ID) THEN
		RAISE_APPLICATION_ERROR(-20000, 'MODEL NOT FOUND');
	END IF;
	IF :new.ACTIVE_ADMINS IS NULL THEN
		:NEW.ACTIVE_ADMINS := active_administrators();
	END IF;
	:NEW.ACTIVITY_ID := ADMIN_ACTIVITIES_ID_SEQ.NEXTVAL;
	:NEW.CREATED_BY := USER;
	:NEW.STARTED_DATE := SYSDATE;
END;
/

CREATE OR REPLACE TRIGGER ADMIN_BU
BEFORE UPDATE ON ADMINISTRATORS
FOR EACH ROW
BEGIN
	:NEW.MODIFIED_BY := USER;
	:NEW.MODIFIED_DATE := SYSDATE;
END;
/
