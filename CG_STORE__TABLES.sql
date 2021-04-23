-- PROMPT Creating Table 'ADMINISTRATOR'
CREATE TABLE ADMINISTRATORS
 (ADMINISTRATOR_ID NUMBER(8,0)
 ,FIRST_NAME VARCHAR2(25)
 ,LAST_NAME VARCHAR2(25)
 ,PHONE VARCHAR2(15)
 ,DATE_OF_BIRTH DATE
 ,STREET_ADDRESS VARCHAR2(50)
 ,ZIP VARCHAR2(5)
 ,CREATED_BY VARCHAR2(30) 
 ,CREATED_DATE DATE
 ,MODIFIED_BY VARCHAR2(30) 
 ,MODIFIED_DATE DATE
 )
/

COMMENT ON TABLE ADMINISTRATORS IS 'Profile information for an administrator.'
/

COMMENT ON COLUMN ADMINISTRATORS.ADMINISTRATOR_ID IS 'The unique ID for an administrator.'
/

COMMENT ON COLUMN ADMINISTRATORS.FIRST_NAME IS 'This administrator''s first name.'
/

COMMENT ON COLUMN ADMINISTRATORS.LAST_NAME IS 'This administrator''s last name'
/

COMMENT ON COLUMN ADMINISTRATORS.PHONE IS 'The phone number for this administrator including area code.'
/

COMMENT ON COLUMN ADMINISTRATORS.DATE_OF_BIRTH IS 'Is the date of birth of an administrator.'
/

COMMENT ON COLUMN ADMINISTRATORS.STREET_ADDRESS IS 'This administrator''s street address.'
/

COMMENT ON COLUMN ADMINISTRATORS.ZIP IS 'The postal zip code for this administrator.'
/

COMMENT ON COLUMN ADMINISTRATORS.CREATED_BY IS 'Audit column - indicates who made last update.'
/

COMMENT ON COLUMN ADMINISTRATORS.CREATED_DATE IS 'Audit column - indicates date of insert.'
/

COMMENT ON COLUMN ADMINISTRATORS.MODIFIED_BY IS 'Audit column - indicates who made last update.'
/

COMMENT ON COLUMN ADMINISTRATORS.MODIFIED_DATE IS 'Audit column - date of last update.'
/

-- PROMPT Creating Table 'ADMIN_ACTIVITIES'
CREATE OR REPLACE TYPE active_administrators IS VARRAY (3) OF NUMBER(8,0); 
/

CREATE TABLE ADMIN_ACTIVITIES
 (ACTIVITY_ID NUMBER(8,0)
 ,ACTIVE_ADMINS active_administrators
 ,ACTIVITY_TYPE VARCHAR2(15)
 ,ACTIVITY_COMMENTS VARCHAR2(50)
 ,MODEL_ID NUMBER(8,0)
 ,CREATED_BY VARCHAR2(30)
 ,STARTED_DATE DATE
 )
/

COMMENT ON TABLE ADMIN_ACTIVITIES IS 'Lookup table for admin activities.'
/

COMMENT ON COLUMN ADMIN_ACTIVITIES.ACTIVITY_ID IS 'The unique code which identifies the model refered to the admin activity.'
/

COMMENT ON COLUMN ADMIN_ACTIVITIES.ACTIVITY_TYPE IS 'Spesification of the activity type.'
/

COMMENT ON COLUMN ADMIN_ACTIVITIES.ACTIVITY_COMMENTS IS 'The unique code which identifies the comments code for the activity.'
/

COMMENT ON COLUMN ADMIN_ACTIVITIES.CREATED_BY IS 'The unique code which identifies the comments code for the activity.'
/

COMMENT ON COLUMN ADMIN_ACTIVITIES.STARTED_DATE IS 'The date of starting for the activity.'
/

-- PROMPT Creating Table 'CONTRIBUTORS'
CREATE TABLE CONTRIBUTORS
 (CONTRIBUTOR_ID NUMBER(8,0) 
 ,FIRST_NAME VARCHAR2(25)
 ,LAST_NAME VARCHAR2(25)
 ,PHONE VARCHAR2(15)
 ,DATE_OF_BIRTH DATE
 ,STREET_ADDRESS VARCHAR2(50)
 ,ZIP VARCHAR2(5)
 )
/

COMMENT ON TABLE CONTRIBUTORS IS 'Profile information for the contributors.'
/

COMMENT ON COLUMN CONTRIBUTORS.CONTRIBUTOR_ID IS 'The unique ID for the contributor.'
/

COMMENT ON COLUMN CONTRIBUTORS.FIRST_NAME IS 'This contributor''s first name.'
/

COMMENT ON COLUMN CONTRIBUTORS.LAST_NAME IS 'This contributor''s last name'
/

COMMENT ON COLUMN CONTRIBUTORS.PHONE IS 'The phone number for this contributor including area code.'
/

COMMENT ON COLUMN CONTRIBUTORS.DATE_OF_BIRTH IS 'Is the date of birth of an contributor.'
/

COMMENT ON COLUMN CONTRIBUTORS.STREET_ADDRESS IS 'This contributor''s street address.'
/

COMMENT ON COLUMN CONTRIBUTORS.ZIP IS 'The postal zip code for this contributor.'
/

CREATE OR REPLACE TYPE segmentation IS VARRAY (3) OF NUMBER(8,0);
/

-- PROMPT Creating Table 'MODELS'
CREATE TABLE MODELS
 (MODEL_ID NUMBER(8,0)
 ,ADDED_CONTRIBUTOR_ID NUMBER(8,0)
 ,MODEL_NAME VARCHAR2(50)
 ,SEGMENTATION segmentation
 )
/

COMMENT ON TABLE MODELS IS 'Model information.'
/

COMMENT ON COLUMN MODELS.MODEL_ID IS 'The unique model ID for model.'
/

COMMENT ON COLUMN MODELS.MODEL_NAME IS 'Name of the model.'
/

COMMENT ON COLUMN MODELS.SEGMENTATION IS 'An array with the type segmentation of the model.'
/

-- PROMPT Creating Table 'MODELS_CONTRIBUTORS'
CREATE TABLE MODELS_CONTRIBUTORS
 (MODEL_ID NUMBER(8,0)
 ,CONTRIBUTOR_ID NUMBER(8,0)
 )
/

COMMENT ON TABLE MODELS_CONTRIBUTORS IS 'Model Contributor Connection information.'
/

COMMENT ON COLUMN MODELS_CONTRIBUTORS.MODEL_ID IS 'The unique model ID for model.'
/

COMMENT ON COLUMN MODELS_CONTRIBUTORS.CONTRIBUTOR_ID IS 'Name of the model.'
/

-- PROMPT Creating Table 'MODEL_PROCESSIONG'
CREATE TABLE MODEL_PROCESSING
 (MODEL_ID NUMBER(8,0)
 ,DONE_WITH_SEGMENTATION NUMBER (1) DEFAULT 0
 ,DONE_WITH_QA NUMBER (1) DEFAULT 0
 )
/

COMMENT ON TABLE MODEL_PROCESSING IS 'Definition of the status of a processing model'
/

COMMENT ON COLUMN MODEL_PROCESSING.MODEL_ID IS 'The unique id of a model.'
/

COMMENT ON COLUMN MODEL_PROCESSING.DONE_WITH_SEGMENTATION IS 'The number grade on a scale from 0 (F) to 4 (A).'
/

COMMENT ON COLUMN MODEL_PROCESSING.DONE_WITH_QA IS 'The highest grade number which makes this letter grade.'
/