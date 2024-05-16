
CREATE TABLE "YMEMBER" (
	"MEM_NO"	NUMBER		NOT NULL CONSTRAINT YMEM_PK PRIMARY KEY,
	"MEM_ID"	VARCHAR2(50)		NOT NULL,
	"MEM_PW"	VARCHAR2(100)		NOT NULL,
	"MEM_NN" VARCHAR2(50) NOT NULL,
	"ENROLL_DATE"	DATE	DEFAULT SYSDATE NOT NULL,
	"UNREGISTER_FL" CHAR(1) DEFAULT 'N'
	 CONSTRAINT UNREGISTER_CHECK CHECK(UNREGISTER_FL IN('Y','N'))
);

COMMENT ON COLUMN "YMEMBER".MEM_NO IS '회원번호(시퀀스 SEQ_MEMBER_NO)';
COMMENT ON COLUMN "YMEMBER".MEM_ID IS '아이디';
COMMENT ON COLUMN "YMEMBER".MEM_PW IS '비밀번호';
COMMENT ON COLUMN "YMEMBER".MEM_NN IS '닉네임';
COMMENT ON COLUMN "YMEMBER".ENROLL_DATE IS '가입일';
COMMENT ON COLUMN "YMEMBER".UNREGISTER_FL  IS '탈퇴여부(Y/N)';


CREATE TABLE "POST" (
	"P_NO"	NUMBER		NOT NULL,
	"P_TITLE"	VARCHAR2(600)		NOT NULL,
	"P_CONTENT"	VARCHAR2(4000)		NOT NULL,
	"CREATE_DT"	DATE	DEFAULT SYSDATE	NULL,
	"DELETE_FL"	CHAR(1)	DEFAULT 'N'	CHECK("DELETE_FL" IN ('Y','N')),
	"MEM_NO" NUMBER NOT NULL, 
	CONSTRAINT POST_MEMBER_FK
	FOREIGN KEY("MEM_NO") REFERENCES "YMEMBER"(MEM_NO)
);

ALTER TABLE "POST" ADD CONSTRAINT "PK_POST" PRIMARY KEY (
	"P_NO"
);

COMMENT ON COLUMN "POST"."P_NO" IS '글 번호 (시퀀스 SEQ_BOARD_NO)';
COMMENT ON COLUMN "POST"."P_TITLE" IS '글 제목';
COMMENT ON COLUMN "POST"."P_CONTENT" IS '글 내용';
COMMENT ON COLUMN "POST"."CREATE_DT" IS '작성일';
COMMENT ON COLUMN "POST"."DELETE_FL" IS '삭제여부(Y/N)';
COMMENT ON COLUMN "POST"."MEM_NO" IS '회원번호(FK)';


CREATE TABLE "COMMENT" (
	"C_NO"	NUMBER		NOT NULL,
	"C_CONTENT"	VARCHAR2(2000)		NOT NULL,
	"CREATE_DT"	DATE	DEFAULT SYSDATE	NULL,
	"DELETE_FL"	CHAR(1)	DEFAULT 'N'	CHECK("DELETE_FL" IN ('Y','N')),
	"MEM_NO"	NUMBER	NOT NULL 
	CONSTRAINT COMMENT_MEMBER_FK REFERENCES "YMEMBER"(MEM_NO),
	"P_NO"	NUMBER	NOT NULL
	CONSTRAINT COMMENT_POST_FK REFERENCES "POST"(P_NO)
);


COMMENT ON COLUMN "COMMENT"."C_NO" IS '댓글 번호 (시퀀스 SEQ_COMMENT_NO)';
COMMENT ON COLUMN "COMMENT"."C_CONTENT" IS '댓글 내용';
COMMENT ON COLUMN "COMMENT"."CREATE_DT" IS '댓글 작성일';
COMMENT ON COLUMN "COMMENT"."DELETE_FL" IS '삭제여부(Y/N)';
COMMENT ON COLUMN "COMMENT"."MEM_NO" IS '회원번호(FK)';
COMMENT ON COLUMN "COMMENT"."P_NO" IS '글번호(FK)';

ALTER TABLE "COMMENT" ADD CONSTRAINT "PK_COMMENT" PRIMARY KEY (
	"C_NO"
);


CREATE TABLE "DM" (
	"D_NO" NUMBER NOT NULL,	
	"D_CONTENT"	VARCHAR2(2000)		NOT NULL,
	"CREATE_DT"	DATE	DEFAULT SYSDATE	NULL,
	"DELETE_FL"	CHAR(1)	DEFAULT 'N'	CHECK("DELETE_FL" IN ('Y','N')),
	"MEM_NO"	NUMBER	NOT NULL 
	CONSTRAINT DM_MEMBER_FK REFERENCES "YMEMBER"(MEM_NO),
	"MEM_NN" VARCHAR2(50) NOT NULL
);

ALTER TABLE "DM" ADD CONSTRAINT "PK_DM" PRIMARY KEY (
	"D_NO"
);

COMMENT ON COLUMN "DM"."D_NO" IS 'DM 번호 (시퀀스 SEQ_COMMENT_NO)';
COMMENT ON COLUMN "DM"."D_CONTENT" IS 'DM 내용';
COMMENT ON COLUMN "DM"."CREATE_DT" IS 'DM 작성일';
COMMENT ON COLUMN "DM"."DELETE_FL" IS '삭제여부(Y/N)';
COMMENT ON COLUMN "DM"."MEM_NO" IS '회원번호(FK)';
COMMENT ON COLUMN "DM"."MEM_NN" IS '닉네임';




DROP TABLE DM;


COMMIT;



SELECT * FROM YMEMBER;
SELECT * FROM "POST";
SELECT * FROM "COMMENT";
SELECT * FROM DM;


CREATE SEQUENCE SEQ_MEM_NO NOCACHE;
CREATE SEQUENCE SEQ_P_NO NOCACHE;
CREATE SEQUENCE SEQ_C_NO NOCACHE;
CREATE SEQUENCE SEQ_D_NO NOCACHE;

DROP SEQUENCE SEQ_D_NO;

DROP TABLE BOARD  ;


INSERT INTO "YMEMBER"
VALUES(SEQ_MEM_NO.NEXTVAL, 'redsea_in', 'redsea', 
	 '홍해', DEFAULT, DEFAULT);




INSERT INTO "POST"
VALUES(SEQ_P_NO.NEXTVAL, '샘플 제목 1', '내용1 입니다\n안녕하세요',
	DEFAULT, DEFAULT, 1);

INSERT INTO "POST"
VALUES(SEQ_P_NO.NEXTVAL, '샘플 제목 1', '내용1 입니다\n안녕하세요',
	DEFAULT, DEFAULT, 2);

INSERT INTO "COMMENT"
VALUES(SEQ_C_NO.NEXTVAL, '댓글 샘플 1번', DEFAULT, DEFAULT,
		1, 1);

COMMIT;

















