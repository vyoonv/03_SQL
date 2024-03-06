

-- TCL ( Transaction Controll Language) : 트랜잭션 제어 언어 
-- COMMIT(트랜잭션 종료 후 저장) , 
-- ROLLBACK(트랜잭션 취소), 
-- SAVEPOINT(임시저장)

-- DML : 데이터 조작 언어로 데이터의 삽입, 수정, 삭제 
--> 트랜잭션은 DML과 관련되어 있음 


/* TRANSACTION 이란 ?
 * - 데이터베이스의 논리적 연산 단위 
 * - 데이터 변경 사항을 묶어서 하나의 트랜잭션에 담아 처리함 
 * - 트랜잭션의 대상이 되는 데이터 변경사항 : INSERT, UPDATE, DELETE, MERGE 
 * 
 * INSERT 수행 -------------------------------------------------> DB 반영 X
 * 
 * INSERT 수행 ------>  트랜잭션에 추가  ------>  COMMIT  ------> DB 반영 O
 * 
 * INSERT 10번 수행 --> 1개 트랜잭션에 10개 추가 --> ROLLBACK --> DB 반영 X
 * 
 * 
 * 1 ) COMMIT : 메모리 버퍼(트랜잭션)에 임시 저장된 데이터 변경 사항을 DB에 반영 
 *  
 * 2 ) ROLLBACK : 메모리 버퍼(트랜잭션)에 임시 저장된 데이터 변경 사항을 삭제하고 
 * 								마지막 커밋 상태로 돌아감 (DB에 변경 내용 반영 X)
 * 
 * 3) SAVEPOINT : 메모리 버퍼(트랜잭션)에 저장 지점을 정의하여 
 * 								ROLLBACK 수행 시 전체 작업을 삭제하는 것이 아닌 
 * 								저장 지점까지만 일부 ROLLBACK
 * 
 * [ SAVEPOINT 사용법]
 * 
 * ...
 * SAVEPOINT "포인트명1";    
 * 
 * ...
 * SAVEPOINT "포인트명2"; 
 * 
 * ...
 * ROLLBACK TO "포인트명1"; --> 포인트명2 작성한 구문까지 다 없어짐 
 * 
 * ** SAVEPOINT 지정 및 호출 시 이름에 " "(쌍따옴표) 붙여야 함 **
 * 
 * 
 * */



-- 새로운 데이터 INSERT 
SELECT * FROM DEPARTMENT2;

INSERT INTO DEPARTMENT2 VALUES('T1', '개발1팀', 'L2'); 
INSERT INTO DEPARTMENT2 VALUES('T2', '개발2팀', 'L2'); 
INSERT INTO DEPARTMENT2 VALUES('T3', '개발3팀', 'L2'); 

-- INSERT 확인 
SELECT * FROM DEPARTMENT2; 
--> DB에 반영된 것처럼 보이지만 
-- 실제로 아직 DB 반영된 것 아님 
--> SQL 수행 시 트랜잭션 내용도 포함해서 수행된다 

-- ROLLBACK 수행
ROLLBACK; 

-- COMMIT 후 ROLLBACK 여부 확인 
INSERT INTO DEPARTMENT2 VALUES('T1', '개발1팀', 'L2'); 
INSERT INTO DEPARTMENT2 VALUES('T2', '개발2팀', 'L2'); 
INSERT INTO DEPARTMENT2 VALUES('T3', '개발3팀', 'L2'); 

COMMIT; 
ROLLBACK; -- T1~T3 그대로 남아있음 -- ROLLBACK 수행 안됨 == DB에 이미 반영 완 


---------------------------------------------------------------------------

-- SAVEPOINT 확인
INSERT INTO DEPARTMENT2 VALUES('T4', '개발4팀', 'L2');
SAVEPOINT "SP1"; 

INSERT INTO DEPARTMENT2 VALUES('T5', '개발5팀', 'L2');
SAVEPOINT "SP2"; 

INSERT INTO DEPARTMENT2 VALUES('T6', '개발6팀', 'L2');
SAVEPOINT "SP3"; 

-- 수행 순서대로 저장되기 때문에 순서대로 수행해야 함 


ROLLBACK TO "SP1"; 
SELECT * FROM DEPARTMENT2; -- SP1 이후 저장한 데이터 사라짐 
-- SAVEPOINT까지 삭제됨 

ROLLBACK TO "SP2"; -- 에러

INSERT INTO DEPARTMENT2 VALUES('T5', '개발5팀', 'L2');
SAVEPOINT "SP2"; 

INSERT INTO DEPARTMENT2 VALUES('T6', '개발6팀', 'L2');
SAVEPOINT "SP3"; 

SELECT * FROM DEPARTMENT2;


-- 개발팀 전체 삭제해보기 
DELETE FROM DEPARTMENT2
WHERE DEPT_ID LIKE 'T%'; 

SELECT * FROM DEPARTMENT2;

-- SP2 ROLLBACK 
ROLLBACK TO "SP2"; -- 개발6팀만 롤백 

-- SP1 ROLLBACK 
ROLLBACK TO "SP1"; -- 개발5팀만 롤백 

--롤백 수행 
ROLLBACK; 
SELECT * FROM DEPARTMENT2; -- 커밋한 시점까지 롤백 




































