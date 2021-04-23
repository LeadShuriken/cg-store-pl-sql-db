CREATE OR REPLACE PROCEDURE display_admins_in_act
	(
	activity_id_id IN ADMIN_ACTIVITIES.ACTIVITY_ID%TYPE
	)
AS
  v_add_varray active_administrators;
BEGIN
	SELECT ACTIVE_ADMINS INTO v_add_varray FROM ADMIN_ACTIVITIES WHERE ACTIVITY_ID = activity_id_id;
	IF v_add_varray.COUNT > 1 THEN
		FOR idx IN 1..v_add_varray.COUNT LOOP
			DBMS_OUTPUT.PUT_LINE('ADMIN NUMBER: ' || TO_CHAR(v_add_varray(idx)) || ' IS PRESENT');
		END LOOP;
	ELSE
		DBMS_OUTPUT.PUT_LINE('NO ADMINS ASSIGNED');
	END IF;
	EXCEPTION WHEN OTHERS THEN
		DBMS_OUTPUT.PUT_LINE(SQLERRM);
END display_admins_in_act;
/

CREATE OR REPLACE FUNCTION is_member_of
(
	s_array IN active_administrators
	,id IN NUMBER
)
RETURN BOOLEAN
	AS
BEGIN
	FOR idx IN 1..s_array.COUNT LOOP
		IF id = s_array(idx) THEN
			  RETURN TRUE;
		END IF;
	END LOOP;
	RETURN FALSE;
	EXCEPTION 
		WHEN OTHERS THEN
			DBMS_OUTPUT.PUT_LINE(SQLERRM);
END is_member_of;
/

CREATE OR REPLACE FUNCTION admin_id_is_good
	(admin_id IN NUMBER)
RETURN BOOLEAN
AS
v_id_cnt NUMBER;
BEGIN
	SELECT COUNT(*) INTO v_id_cnt FROM ADMINISTRATORS WHERE ADMINISTRATOR_ID = admin_id;
	RETURN 1 = v_id_cnt;
	EXCEPTION
		WHEN OTHERS
			THEN RETURN FALSE;
END admin_id_is_good;
/

CREATE OR REPLACE PROCEDURE add_admin_to_activity
(
	activity_id_id IN ADMIN_ACTIVITIES.ACTIVITY_ID%TYPE
	,admin_id IN ADMINISTRATORS.ADMINISTRATOR_ID%TYPE
)
AS
	v_add_varray active_administrators;
	v_counter BINARY_INTEGER := 0;
	ALLREADY_IN EXCEPTION;
	ADMIN_MISSING EXCEPTION;
BEGIN
	IF NOT admin_id_is_good(admin_id) THEN
		RAISE ADMIN_MISSING;
	END IF;
	
	SELECT ACTIVE_ADMINS INTO v_add_varray FROM ADMIN_ACTIVITIES WHERE ACTIVITY_ID = activity_id_id;

	IF is_member_of(v_add_varray,admin_id) THEN
		RAISE ALLREADY_IN;
	ELSE
		v_add_varray.extend(1);
		v_add_varray(v_add_varray.COUNT) := admin_id;

		UPDATE ADMIN_ACTIVITIES
		SET ACTIVE_ADMINS = v_add_varray 
		WHERE ACTIVITY_ID = activity_id_id;
		DBMS_OUTPUT.PUT_LINE ('ADDED..');
	END IF;

	EXCEPTION 
		WHEN SUBSCRIPT_OUTSIDE_LIMIT THEN
			DBMS_OUTPUT.PUT_LINE('TOO MANY ADMINS IN ACTIVITY');
		WHEN NO_DATA_FOUND THEN
			DBMS_OUTPUT.PUT_LINE ('NO SUCH ACTIVITY OR ADMIN');
		WHEN ALLREADY_IN THEN
			DBMS_OUTPUT.PUT_LINE ('ADMIN ALLREADY IN');
		WHEN ADMIN_MISSING THEN
			DBMS_OUTPUT.PUT_LINE ('ADMIN MISSING');
		WHEN OTHERS THEN
			DBMS_OUTPUT.PUT_LINE(SQLERRM);
END add_admin_to_activity;
/

CREATE OR REPLACE PROCEDURE add_admin_to_activity
(
	activity_id_id IN ADMIN_ACTIVITIES.ACTIVITY_ID%TYPE
	,admin_id IN ADMINISTRATORS.ADMINISTRATOR_ID%TYPE
)
AS
	v_add_varray active_administrators;
	v_counter BINARY_INTEGER := 0;
	ALLREADY_IN EXCEPTION;
	ADMIN_MISSING EXCEPTION;
BEGIN
	IF NOT admin_id_is_good(admin_id) THEN
		RAISE ADMIN_MISSING;
	END IF;
	
	SELECT ACTIVE_ADMINS INTO v_add_varray FROM ADMIN_ACTIVITIES WHERE ACTIVITY_ID = activity_id_id;

	IF is_member_of(v_add_varray,admin_id) THEN
		RAISE ALLREADY_IN;
	ELSE
		v_add_varray.extend(1);
		v_add_varray(v_add_varray.COUNT) := admin_id;

		UPDATE ADMIN_ACTIVITIES
		SET ACTIVE_ADMINS = v_add_varray 
		WHERE ACTIVITY_ID = activity_id_id;
		DBMS_OUTPUT.PUT_LINE ('ADDED..');
	END IF;

	EXCEPTION 
		WHEN SUBSCRIPT_OUTSIDE_LIMIT THEN
			DBMS_OUTPUT.PUT_LINE('TOO MANY ADMINS IN ACTIVITY');
		WHEN NO_DATA_FOUND THEN
			DBMS_OUTPUT.PUT_LINE ('NO SUCH ACTIVITY OR ADMIN');
		WHEN ALLREADY_IN THEN
			DBMS_OUTPUT.PUT_LINE ('ADMIN ALLREADY IN');
		WHEN ADMIN_MISSING THEN
			DBMS_OUTPUT.PUT_LINE ('ADMIN MISSING');
		WHEN OTHERS THEN
			DBMS_OUTPUT.PUT_LINE(SQLERRM);
END add_admin_to_activity;
/

CREATE OR REPLACE PROCEDURE remove_admin_from_activity
(
	activity_id_id IN ADMIN_ACTIVITIES.ACTIVITY_ID%TYPE
	,admin_id IN ADMINISTRATORS.ADMINISTRATOR_ID%TYPE
)
AS
	v_add_varray active_administrators;
	v_counter BINARY_INTEGER := 0;
	ADMIN_NOT_IN_ACT EXCEPTION;
	ADMIN_MISSING EXCEPTION;
BEGIN
	IF NOT admin_id_is_good(admin_id) THEN
		RAISE ADMIN_MISSING;
	END IF;
	
	SELECT ACTIVE_ADMINS INTO v_add_varray FROM ADMIN_ACTIVITIES WHERE ACTIVITY_ID = activity_id_id;

	IF is_member_of(v_add_varray,admin_id) THEN
		
		v_add_varray := delete_entry(v_add_varray,admin_id);

		UPDATE ADMIN_ACTIVITIES
		SET ACTIVE_ADMINS = v_add_varray 
		WHERE ACTIVITY_ID = activity_id_id;
		DBMS_OUTPUT.PUT_LINE ('REMOVED..');
	ELSE
		RAISE ADMIN_NOT_IN_ACT;
	END IF;

	EXCEPTION 
		WHEN NO_DATA_FOUND THEN
			DBMS_OUTPUT.PUT_LINE ('NO SUCH ACTIVITY');
		WHEN ADMIN_NOT_IN_ACT THEN
			DBMS_OUTPUT.PUT_LINE ('ADMIN ALLREADY IN');
		WHEN ADMIN_MISSING THEN
			DBMS_OUTPUT.PUT_LINE ('ADMIN MISSING');
		WHEN OTHERS THEN
			DBMS_OUTPUT.PUT_LINE(SQLERRM);
END remove_admin_from_activity;
/

CREATE OR REPLACE FUNCTION delete_entry(p_record IN active_administrators, p_val IN NUMBER)
RETURN active_administrators
IS
   v_ret active_administrators := active_administrators();
BEGIN
   FOR n IN p_record.FIRST..p_record.LAST LOOP
      IF p_record(n) != p_val THEN
        v_ret.EXTEND;
        v_ret(v_ret.LAST) := p_record(n);
      END IF;
   END LOOP;
   RETURN v_ret;
END;
/

CREATE OR REPLACE PROCEDURE checkout_activity
(
	activity_id_id IN ADMIN_ACTIVITIES.ACTIVITY_ID%TYPE
	,admin_id IN ADMINISTRATORS.ADMINISTRATOR_ID%TYPE
)
AS
	ADMIN_NOT_IN_ACT EXCEPTION;
	ADMIN_MISSING EXCEPTION;
	plsql_block VARCHAR2(500);
	v_recored_loc ADMIN_ACTIVITIES%ROWTYPE;
	CURSOR v_recored IS
		SELECT * FROM ADMIN_ACTIVITIES WHERE ACTIVITY_ID = activity_id_id FOR UPDATE;
BEGIN
	IF NOT admin_id_is_good(admin_id) THEN
		RAISE ADMIN_MISSING;
	END IF;
	 
	OPEN v_recored;
	FETCH v_recored INTO v_recored_loc;

		IF NOT is_member_of(v_recored_loc.ACTIVE_ADMINS, admin_id) THEN
			RAISE ADMIN_NOT_IN_ACT;
		ELSE
			plsql_block := 'UPDATE MODEL_PROCESSING SET DONE_WITH_' || v_recored_loc.ACTIVITY_TYPE  || ' = 1 WHERE MODEL_ID = ' || v_recored_loc.MODEL_ID ;
			EXECUTE IMMEDIATE plsql_block;
			
			DELETE FROM ADMIN_ACTIVITIES
			WHERE CURRENT OF v_recored;
			
			DBMS_OUTPUT.PUT_LINE ('ACTIVITY : ' || TO_CHAR(activity_id_id) || 'UPDATED AND REMOVED');
		END IF;
	CLOSE v_recored;
	EXCEPTION 
		WHEN NO_DATA_FOUND THEN
			DBMS_OUTPUT.PUT_LINE ('NO SUCH ACTIVITY');
		WHEN ADMIN_NOT_IN_ACT THEN
			DBMS_OUTPUT.PUT_LINE ('THIS ADMIN IS NOT IN THE ACTIVITY');
		WHEN ADMIN_MISSING THEN
			DBMS_OUTPUT.PUT_LINE ('NO SUCH ADMIN');
		WHEN OTHERS THEN
			DBMS_OUTPUT.PUT_LINE(SQLERRM);
END checkout_activity;
/