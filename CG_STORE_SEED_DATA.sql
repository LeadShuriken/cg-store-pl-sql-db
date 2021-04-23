ALTER SESSION SET NLS_DATE_FORMAT = 'DD-MON-RR';

-- ################# 'ADMINISTRATORS' #################
-- ################# 'ADMINISTRATORS' #################
-- ################# 'ADMINISTRATORS' #################

INSERT INTO ADMINISTRATORS VALUES 
(
	NULL,
	'ADMIN_FN_1',
	'ADMIN_LN_1',
	23123123,
	TO_DATE('29-MAR-2007 20:14:33','DD-MON-YYYY HH24:MI:SS'),
	'ARISCHER',
	'12345', NULL, NULL, NULL, NULL
);

INSERT INTO ADMINISTRATORS VALUES 
(
	NULL,
	'ADMIN_FN_2',
	'ADMIN_LN_2',
	23123123,
	TO_DATE('29-MAR-2007 20:14:33','DD-MON-YYYY HH24:MI:SS'),
	'ARISCHER',
	'12345', NULL, NULL, NULL, NULL
);

INSERT INTO ADMINISTRATORS VALUES 
(
	NULL,
	'ADMIN_FN_3',
	'ADMIN_LN_3',
	23123123,
	TO_DATE('29-MAR-2007 20:14:33','DD-MON-YYYY HH24:MI:SS'),
	'ARISCHER',
	'12345', NULL, NULL, NULL, NULL
);

INSERT INTO ADMINISTRATORS VALUES 
(
	NULL,
	'ADMIN_FN_4',
	'ADMIN_LN_4',
	23123123,
	TO_DATE('29-MAR-2007 20:14:33','DD-MON-YYYY HH24:MI:SS'),
	'ARISCHER',
	'12345', NULL, NULL, NULL, NULL
);

COMMIT;

-- ################# 'CONTRIBUTORS' #################
-- ################# 'CONTRIBUTORS' #################
-- ################# 'CONTRIBUTORS' #################

INSERT INTO CONTRIBUTORS VALUES 
(
	NULL,
	'CONTRIBUTOR_FN_1',
	'CONTRIBUTOR_LN_1',
	122312,
	TO_DATE('29-MAR-2007 20:14:33','DD-MON-YYYY HH24:MI:SS'),
	'ELM STREET',
	'123'
);

INSERT INTO CONTRIBUTORS VALUES 
(
	NULL,
	'CONTRIBUTOR_FN_2',
	'CONTRIBUTOR_LN_2',
	122312,
	TO_DATE('29-MAR-2007 20:14:33','DD-MON-YYYY HH24:MI:SS'),
	'ELM STREET',
	'123'
);

INSERT INTO CONTRIBUTORS VALUES 
(
	NULL,
	'CONTRIBUTOR_FN_3',
	'CONTRIBUTOR_LN_3',
	122312,
	TO_DATE('29-MAR-2007 20:14:33','DD-MON-YYYY HH24:MI:SS'),
	'ELM STREET',
	'123'
);

INSERT INTO CONTRIBUTORS VALUES 
(
	NULL,
	'CONTRIBUTOR_FN_4',
	'CONTRIBUTOR_LN_4',
	122312,
	TO_DATE('29-MAR-2007 20:14:33','DD-MON-YYYY HH24:MI:SS'),
	'ELM STREET',
	'123'
);

COMMIT;

-- ################# 'CONTRIBUTORS' #################
-- ################# 'CONTRIBUTORS' #################
-- ################# 'CONTRIBUTORS' #################

-- ################# '1' #################
INSERT INTO MODELS VALUES 
(
	NULL,
	1,
	'MODEL_1_OF_CONT_1',
	segmentation(1, 2, 3)
);
-- ################# '2' #################
INSERT INTO MODELS VALUES 
(
	NULL,
	2,
	'MODEL_1_OF_CONT_2',
	segmentation(3, 4, 2)
);

INSERT INTO MODELS VALUES 
(
	NULL,
	2,
	'MODEL_2_OF_CONT_2',
	segmentation(1, 2, 3)
);

INSERT INTO MODELS VALUES 
(
	NULL,
	2,
	'MODEL_3_OF_CONT_2',
	segmentation(10, 9, 3)
);
-- ################# '4' #################
INSERT INTO MODELS VALUES 
(
	NULL,
	4,
	'MODEL_1_OF_CONT_4',
	segmentation(16, 2, 12)
);

INSERT INTO MODELS VALUES 
(
	NULL,
	4,
	'MODEL_2_OF_CONT_4',
	segmentation(4, 8, 7)
);

COMMIT;

-- ################# 'MODELS_CONTRIBUTORS' #################
-- ################# 'MODELS_CONTRIBUTORS' #################
-- ################# 'MODELS_CONTRIBUTORS' #################

INSERT INTO MODELS_CONTRIBUTORS VALUES
(
	1,
	2
);

INSERT INTO MODELS_CONTRIBUTORS VALUES
(
	3,
	3
);

INSERT INTO MODELS_CONTRIBUTORS VALUES
(
	4,
	3
);

INSERT INTO MODELS_CONTRIBUTORS VALUES
(
	2,
	3
);

COMMIT;

-- ################# 'ADMIN_ACTIVITIES' #################
-- ################# 'ADMIN_ACTIVITIES' #################
-- ################# 'ADMIN_ACTIVITIES' #################

INSERT INTO ADMIN_ACTIVITIES VALUES 
(
	NULL,
	NULL,
	'SEGMENTATION',
	'MODEL_1_SEGMENTATION',
	1,
	NULL,
	NULL
);

INSERT INTO ADMIN_ACTIVITIES VALUES 
(
	NULL,
	NULL,
	'QA',
	'MODEL_1_QA',
	1,
	NULL,
	NULL
);

INSERT INTO ADMIN_ACTIVITIES VALUES 
(
	NULL,
	NULL,
	'SEGMENTATION',
	'MODEL_2_SEGMENTATION',
	2,
	NULL,
	NULL
);

INSERT INTO ADMIN_ACTIVITIES VALUES 
(
	NULL,
	NULL,
	'QA',
	'MODEL_2_QA',
	2,
	NULL,
	NULL
);

COMMIT;