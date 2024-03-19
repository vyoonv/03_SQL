

/* SUBQUERY (서브쿼리)
 * - 하나의 SQL문 안에 포함된 또 다른 SQL(SELECT)문
 * - 메인쿼리(기존쿼리)를 위해 보조 역할을 하는 쿼리문 
 * - SELECT, FROM, WHERE, HAVING절에서 사용 가능 
 * 
 * */

-- 서브쿼리 예시 1)
-- 부서코드가 노올철 사원과 같은 소속 직원의 
-- 이름 , 부서코드 조회 

-- 1) 노옹철의 부서코드 조회
SELECT DEPT_CODE
FROM EMPLOYEE 
WHERE EMP_NAME = '노옹철';  --D9

-- 2) 부서코드가 D9인 직원 이름, 부서코드 조회 
SELECT EMP_NAME, DEPT_CODE 
FROM EMPLOYEE 
WHERE DEPT_CODE = 'D9';

-- 3) 부서코드가 노옹철 사원과 같은 소속의 직원명단 조회 
--> 위의 2개의 단계를 하나의 쿼리로 
--> 1)번이 서브쿼리가 되어야 함 (조건이라서)
SELECT EMP_NAME, DEPT_CODE 
FROM EMPLOYEE 
WHERE DEPT_CODE = 
 (SELECT DEPT_CODE FROM EMPLOYEE 
  WHERE EMP_NAME = '노옹철');



 -- 서브쿼리 예시 2) 
-- 전 직원의 평균 급여보다 많은 급여를 받고 있는 직원의 사번,이름,직급코드, 급여 조회
 SELECT EMP_ID, EMP_NAME, JOB_CODE, SALARY
 FROM EMPLOYEE 
 WHERE SALARY >=
 (SELECT CEIL(AVG(SALARY)) FROM EMPLOYEE);

 -- 1) 전 직원의 평균 급여 조회 
SELECT CEIL(AVG(SALARY))
FROM EMPLOYEE;

-- 2) 직원 중 급여가 3047663원 이상인 사원들의 사번, 이름, 직급코드, 급여 조회 (메인쿼리) 
SELECT EMP_ID, EMP_NAME, JOB_CODE, SALARY
FROM EMPLOYEE 
WHERE SALARY >=3047663;
-->위의 두 단계를 하나의 쿼리로 만듦 


--------------------------------------------------------------------------------


/* 서브쿼리 유형 
 * 
 * - 단일행 (단일열) 서브쿼리 : 서브쿼리의 조회 결과 값의 개수가 1개일 때 
 * 
 * - 다중행 (단일열) 서브쿼리 : 서브쿼리의 조회 결과 값의 개수가 여러개일 때 
 * 
 * - 다중열 서브쿼리 : 서브쿼리의 SELECT 절에 나열된 항목수가 여러개일 때
 * 
 * - 다중행 다중열 서브쿼리 : 조회 결과 행 수와 열 수가 여러개일 때
 * 
 * - 상(호연)관 서브쿼리 : 서브쿼리가 만든 결과 값을 메인쿼리가 비교 연산할 때 
 * 												 메인 쿼리 테이블의 값이 변경되면 서브쿼리의 결과값도 바뀌는 서브쿼리 
 * 
 * - 스칼라 서브쿼리 : 상관 쿼리이면서 결과 값이 하나인 서브쿼리 
 * 
 *  ** 서브쿼리 유형에 따라 서브쿼리 앞에 붙는 연산자가 다름 **
 * 
 * */


-- 1. 단일행 서브쿼리 (SINGLE ROW SUBQUERY)
-- 서브쿼리 조회 결과 값의 개수가 1개인 서브쿼리 
-- 단일행 서브쿼리 앞에는 비교 연산자 사용 
-- <, >, <=, >=, =, !=, <>, ^= 

SELECT * FROM EMPLOYEE e ;
SELECT * FROM JOB j ;
SELECT * FROM DEPARTMENT d  ;
-- 전 직원의 급여 평균보다 많은 급여를 받는 직원의 이름 직급 부서명 급여를 직급 순으로 정렬
SELECT EMP_NAME, JOB_NAME, DEPT_TITLE, SALARY
FROM EMPLOYEE e 
JOIN JOB USING(JOB_CODE)
LEFT JOIN DEPARTMENT ON (DEPT_CODE = DEPT_ID) 
WHERE SALARY > (SELECT AVG(SALARY) FROM EMPLOYEE) 
ORDER BY JOB_CODE;
-- SELECT절에 명시되지 않은 컬럼이라도 FROM, JOIN으로 인해 존재하는 컬럼이면 ORDER BY에서 사용 가능 

-- 가장 적은 급여를 받는 직원의 
-- 사번, 이름 직급명 부서코드 입사일 조회 
SELECT EMP_ID, EMP_NAME, JOB_NAME, DEPT_CODE, HIRE_DATE
FROM EMPLOYEE 
JOIN JOB j USING (JOB_CODE)
WHERE SALARY = (SELECT MIN(SALARY) FROM EMPLOYEE );

-- 노옹철 사원의 급여보다 많이 받는 직원의 사번 이름 부서명 직급명 급여 조회 
SELECT EMP_ID, EMP_NAME, DEPT_TITLE, JOB_NAME, SALARY
FROM EMPLOYEE
JOIN JOB USING (JOB_CODE)   --NATURAL JOIN
LEFT JOIN DEPARTMENT ON (DEPT_CODE = DEPT_ID)
WHERE SALARY > (SELECT SALARY FROM EMPLOYEE WHERE EMP_NAME = '노옹철'); 


-- 부서별 (부서가 없는 사람 포함) 급여의 합계 중 가장 큰 부서의 부서명, 급여 합계 조회 
SELECT DEPT_TITLE, SUM(SALARY)
FROM EMPLOYEE 
LEFT JOIN DEPARTMENT ON (DEPT_CODE = DEPT_ID)
GROUP BY DEPT_TITLE 
HAVING SUM(SALARY) = (SELECT MAX(SUM(SALARY)) FROM EMPLOYEE GROUP BY DEPT_CODE) ;
-- 부서별 급여 합 중 값이 가장 큰 값 조회 + 부서별 급여합이 앞의 값과 같은 부서명, 급여합 조회 
-- 위 둘을 합쳐 작성 
-- GROUP BY 사용하면 HAVING절로 서브쿼리 작성!!


------------------------------------------------------------------------------------------


-- 2. 다중행 서브쿼리 (MULTI ROW SUBQUERY)
-- 서브쿼리의 조회 결과 값의 개수가 여러행일 때
/*
 * >> 다중행 서브쿼리 앞에는 일반 비교연산자 사용 X
 * 
 * - IN / NOT IN : 여러개의 결과값 중 한개라도 일치하는 값이 있다면 
 * 								 혹은 없다면 이라는 의미 (가장 많이 사용)
 * 
 * -   > ANY / < ANY : 여러개의 결과값 중에서 한개라도 큰 / 작은 경우  
 * 										   가장 작은 값보다 큰가? / 가장 큰 값보다 작은가?
 * 
 * -   > ALL / < ALL : 여러개의 결과값의 모든 값보다 큰 / 작은 경우 
 * 										 가장 큰 값보다 큰가? / 가장 작은 값보다 작은가?
 * 
 * - EXISTS / NOT EXISTS : 값이 존재하는가 / 존재하지 않는가
 * 
 * 
 * */


-- 부서별 최고 급여를 받는 직원의 이름 직급 부서 급여를 부서순으로 정렬

-- 부서별 최고 급여 
SELECT MAX(SALARY)
FROM EMPLOYEE 
GROUP BY DEPT_CODE ;

-- 최고 급여를 받는 직원 조회 
SELECT EMP_NAME, JOB_CODE, DEPT_CODE, SALARY
FROM EMPLOYEE
WHERE SALARY IN (SELECT MAX(SALARY)
FROM EMPLOYEE 
GROUP BY DEPT_CODE) 
ORDER BY DEPT_CODE ; 

--SELECT * FROM EMPLOYEE ;


-- 사수에 해당하는 직원 조회 
-- 사번 이름 부서명 직급명 구분(사수/직원)

-- * 사수 == MANAGER_ID 컬럼에 작성된 사번 
-- 1) 사수에 해당하는 사원번호 조회 
SELECT DISTINCT MANAGER_ID 
FROM EMPLOYEE 
WHERE MANAGER_ID IS NOT NULL;   -- 7 명 

-- 2) 직원의 사번 이름 부서명 직급명 조회 
SELECT EMP_ID, EMP_NAME, DEPT_TITLE, JOB_NAME
FROM EMPLOYEE
JOIN JOB USING (JOB_CODE)
LEFT JOIN DEPARTMENT ON (DEPT_CODE = DEPT_ID); 

-- 3) 사수에 해당하는 직원에 대한 정보 추출 조회 (구분 '사수')
SELECT EMP_ID, EMP_NAME, DEPT_TITLE, JOB_NAME, '사수' 구분 
FROM EMPLOYEE
JOIN JOB USING (JOB_CODE)
LEFT JOIN DEPARTMENT ON (DEPT_CODE = DEPT_ID)
WHERE EMP_ID IN (SELECT DISTINCT MANAGER_ID FROM EMPLOYEE 
								WHERE MANAGER_ID IS NOT NULL);
							
-- 4) 일반 직원에 해당하는 사원들 정보 조회 (구분 '사원')
SELECT EMP_ID, EMP_NAME, DEPT_TITLE, JOB_NAME, '사원' 구분 
FROM EMPLOYEE
JOIN JOB USING (JOB_CODE)
LEFT JOIN DEPARTMENT ON (DEPT_CODE = DEPT_ID)
WHERE EMP_ID NOT IN (SELECT DISTINCT MANAGER_ID FROM EMPLOYEE 
								WHERE MANAGER_ID IS NOT NULL);					

-- 5) 3, 4 조회 결과를 하나로 합침 -> SELECT 절 SUBQUERY 
-- SELECT 절에도 서브쿼리 사용할 수 있음 

-- 선택 함수 사용
--> DECODE(컬럼명, 값1, 1인경우, 값2, 2인경우, ... 일치하지 않는경우)
--> CASE WHEN 조건1 THEN 값1 WHEN 조건2 THEN 값2 ... ELSE 값 END [별칭]

SELECT EMP_ID, EMP_NAME, DEPT_TITLE, JOB_NAME, 
			 CASE WHEN EMP_ID IN (SELECT DISTINCT MANAGER_ID FROM EMPLOYEE 
														WHERE MANAGER_ID IS NOT NULL)	THEN '사수' ELSE '사원' END 구분
FROM EMPLOYEE
JOIN JOB USING (JOB_CODE)
LEFT JOIN DEPARTMENT ON (DEPT_CODE = DEPT_ID)						
ORDER BY EMP_ID;
							

-- 집합 연산자 (UNION:합집합) 사용 방법 
SELECT EMP_ID, EMP_NAME, DEPT_TITLE, JOB_NAME, '사수' 구분 
FROM EMPLOYEE
JOIN JOB USING (JOB_CODE)
LEFT JOIN DEPARTMENT ON (DEPT_CODE = DEPT_ID)
WHERE EMP_ID IN (SELECT DISTINCT MANAGER_ID FROM EMPLOYEE 
								WHERE MANAGER_ID IS NOT NULL)
UNION
SELECT EMP_ID, EMP_NAME, DEPT_TITLE, JOB_NAME, '사원' 구분 
FROM EMPLOYEE
JOIN JOB USING (JOB_CODE)
LEFT JOIN DEPARTMENT ON (DEPT_CODE = DEPT_ID)
WHERE EMP_ID NOT IN (SELECT DISTINCT MANAGER_ID FROM EMPLOYEE 
								WHERE MANAGER_ID IS NOT NULL); 

							
							
-- 대리 직급의 직원들 중 과장 직급의 최소 급여보다 많이 받는 직원의 사번 이름 직급 급여 조회 
-- > ANY 연산자 사용  : 가장 작은 값보다 큰가?
							
-- 1) 직급이 대리인 직원들 조회 
SELECT EMP_ID, EMP_NAME, JOB_NAME, SALARY
FROM EMPLOYEE 
NATURAL JOIN JOB 
WHERE JOB_NAME = '대리'; 

-- 2) 과장 직급의 급여 
SELECT SALARY
FROM EMPLOYEE 
NATURAL JOIN JOB 
WHERE JOB_NAME = '과장'; 
						
-- 3) 220만원보다 많이 받는 대리 직급 직원 조회 
-- 3-1) 단일행 서브쿼리 
SELECT EMP_ID, EMP_NAME, JOB_NAME, SALARY
FROM EMPLOYEE 
NATURAL JOIN JOB 
WHERE JOB_NAME = '대리' AND SALARY > 
(SELECT MIN(SALARY) FROM EMPLOYEE NATURAL JOIN JOB 
	WHERE JOB_NAME = '과장');							
-- 3-2) ANY 이용 
SELECT EMP_ID, EMP_NAME, JOB_NAME, SALARY
FROM EMPLOYEE 
NATURAL JOIN JOB 
WHERE JOB_NAME = '대리' 
AND SALARY > ANY 
		(SELECT SALARY FROM EMPLOYEE NATURAL JOIN JOB 
			WHERE JOB_NAME = '과장');									
							
	
-- 차장 직급의 급여의 가장 큰 값보다 많이 받는 과장 직급의 직원 조회 
-- 사번, 이름, 직급, 급여 조회 
-- > ALL  /  < ALL		
		
SELECT EMP_ID, EMP_NAME, JOB_NAME, SALARY
FROM EMPLOYEE 
NATURAL JOIN JOB
WHERE JOB_NAME = '과장' AND SALARY > ALL 
	(SELECT SALARY FROM EMPLOYEE NATURAL JOIN JOB WHERE JOB_NAME = '차장'); 
							

-- 서브쿼리 중첩 사용하기 (응용편)
-- LOCATION 테이블에서 NATIONAL_CODE 가 KO인 경우의 LOCAL_CODE와 
-- DEPARTMENT 테이블의 LOCATION_ID가 동일한 DEPT_ID가 
-- EMPLOYEE 테이블의 DEPT_CODE와 동일한 사원을 구하시오 

SELECT * FROM LOCATION;
SELECT * FROM DEPARTMENT;

--1)
SELECT LOCAL_CODE  
FROM LOCATION WHERE NATIONAL_CODE = 'KO';  
--2)
SELECT DEPT_ID 
FROM DEPARTMENT WHERE LOCATION_ID = (SELECT LOCAL_CODE FROM LOCATION 
																			WHERE NATIONAL_CODE = 'KO');
--3)
SELECT EMP_NAME, DEPT_CODE 
FROM EMPLOYEE WHERE DEPT_CODE 
IN (SELECT DEPT_ID FROM DEPARTMENT 
		WHERE LOCATION_ID = (SELECT LOCAL_CODE FROM LOCATION 
															WHERE NATIONAL_CODE = 'KO')); 

														
--------------------------------------------------------------------------

														
-- 3) (단일행) 다중열 서브쿼리 
-- 서브쿼리 SELECT 절에 나열된 컬럼수가 여러개일 때 
														
														
-- 퇴사한 여직원과 같은 부서, 같은 직급에 해당하는 사원의 이름, 직급, 부서, 입사일 조회 
--1) 퇴사한 여직원 
SELECT DEPT_CODE, JOB_CODE 
FROM EMPLOYEE 
WHERE ENT_YN = 'Y'AND SUBSTR(EMP_NO, 8, 1) = '2';  -- D8, J6

--2) 퇴사한 여직원과 같은 부서, 같은 직급에 해당하는 사원 

-- 단일행 서브쿼리를 2개 사용해서 조회 
--> 서브쿼리가 같은 테이블, 같은 조건, 다른 컬럼 조회 

SELECT EMP_NAME, JOB_CODE, DEPT_CODE, HIRE_DATE
FROM EMPLOYEE 
WHERE DEPT_CODE = (SELECT DEPT_CODE FROM EMPLOYEE 
									WHERE ENT_YN = 'Y'AND SUBSTR(EMP_NO, 8, 1) = '2')
AND JOB_CODE = (SELECT JOB_CODE FROM EMPLOYEE 
								WHERE ENT_YN = 'Y'AND SUBSTR(EMP_NO, 8, 1) = '2'); 


-- 다중열 서브쿼리 
-- WHERE 절에 작성된 컬럼 순서에 맞게 
--서브쿼리에 조회된 컬럼과 비교하여 일치하는 행만 조회 (컬럼순서 중요!!)		
SELECT EMP_NAME, JOB_CODE, DEPT_CODE, HIRE_DATE
FROM EMPLOYEE 							
WHERE (DEPT_CODE, JOB_CODE) = (SELECT DEPT_CODE, JOB_CODE FROM EMPLOYEE 
															WHERE ENT_YN = 'Y'AND SUBSTR(EMP_NO, 8, 1) = '2');
														
											
														
														
														
														
														
------연습문제--------														
														
-- 1. 노옹철 사원과 같은 부서, 같은 직급인 사원을 조회 단 노옹철 제외 
-- 사번, 이름, 부서코드, 직급코드, 부서명, 직급명 
SELECT EMP_ID, EMP_NAME, DEPT_CODE, JOB_CODE, DEPT_TITLE, JOB_NAME
FROM EMPLOYEE 
NATURAL JOIN JOB LEFT JOIN DEPARTMENT ON (DEPT_ID = DEPT_CODE)
WHERE (DEPT_CODE, JOB_CODE) = (SELECT DEPT_CODE, JOB_CODE FROM EMPLOYEE 
WHERE EMP_NAME = '노옹철') AND EMP_NAME != '노옹철'; 





--2. 2000년도에 입사한 사원의 부서와 직급이 같은 사원 조회 
-- 사번, 이름, 부서코드, 직급코드, 입사일 
SELECT EMP_ID, EMP_NAME, DEPT_CODE, JOB_CODE, HIRE_DATE
FROM EMPLOYEE 
WHERE (DEPT_CODE, JOB_CODE ) = (SELECT DEPT_CODE, JOB_CODE FROM EMPLOYEE 
WHERE EXTRACT (YEAR FROM HIRE_DATE) = '2000' );




--3. 77년생 여자 사원과 동일한 부서이면서 동일한 사수를 가지고 있는 사원 조회 
-- 사번, 이름, 부서코드, 사수번호, 주민번호, 입사일 
SELECT EMP_ID, EMP_NAME, DEPT_CODE, MANAGER_ID, EMP_NO, HIRE_DATE
FROM EMPLOYEE 
WHERE (DEPT_CODE, MANAGER_ID) IN (SELECT DEPT_CODE, MANAGER_ID FROM EMPLOYEE 
WHERE EXTRACT(YEAR FROM TO_DATE('19'||SUBSTR(EMP_NO, 1, 6), 'YYYYMMDD')) = '1977' 
AND SUBSTR(EMP_NO,8,1 )= '2') ; 
-- WHERE 절에 = 
-- SUBSTR(EMP_NO, 1, 6) = '77'													
														
									

-----------------------------------------------------------------------------------------

-- 4. 다중행 다중열 서브쿼리 
-- 서브쿼리 조회 결과 행 수와 열 수가 여러개일 때 

-- 본인 직급의 평균 급여를 받고 있는 직원의 사번, 이름, 직급, 급여 조회 
-- 급여와 급여 평균은 만원단위로 계산 TRUNC(컬럼명, -4)

--1) 직급별 평균 급여 
SELECT JOB_CODE, TRUNC(AVG(SALARY), -4) 평균급여
FROM EMPLOYEE 
GROUP BY JOB_CODE;
	
--2) 본인 직급의 평균 급여 받고 있는 직원 
SELECT EMP_ID, EMP_NAME, JOB_CODE, SALARY
FROM EMPLOYEE 
WHERE (JOB_CODE, SALARY) IN (SELECT JOB_CODE, TRUNC(AVG(SALARY), -4) 평균급여
FROM EMPLOYEE GROUP BY JOB_CODE); 
							
							
---------------------------------------------------------------------------------


-- 5. 상[호연]관 서브쿼리 
-- 상관쿼리는 메인쿼리가 사용하는 테이블 값을 서브쿼리가 이용해서 결과를 만듦
-- 메인쿼리의 테이블값이 변경되면 서브쿼리의 결과값도 바뀌게 되는 구조 

--  상관쿼리는 먼저 메인쿼리 한 행을 조회하고 
-- 해당 행이 서브쿼리의 조건을 충족하는지 확인하여 SELECT를 진행함 

-- ** 해석순서가 기존 서브쿼리와 다르게 
-- 메인쿼리 1행 -> 1행에 대한 서브쿼리 수행 
-- 메인쿼리 2행 -> 2행에 대한 서브쿼리 수행 
-- ...
-- 메인쿼리의 행의 수만큼 서브쿼리가 생성되어 진행됨 



-- 직급별 급여 평균보다 급여를 많이 받는 직원의 이름, 직급코드, 급여 조회 
-- 메인쿼리 
SELECT EMP_NAME, JOB_CODE, SALARY
FROM EMPLOYEE;


-- 서브쿼리 (직급별 급여 평균)
SELECT AVG(SALARY)
FROM EMPLOYEE 
WHERE JOB_CODE = 'J1'; 

/* 1. 메인쿼리에서 우선 1행을 읽음 (선동일) 
 * --> 선동일은 JOB_CODE가 'J1'이고, SALARY가 8백만임 
 * 
 * 2. 서브쿼리에서 선동일 직급인 'J1'의 평균 급여를 조회함 
 * --> 'J1'직급의 평균 급여는 8백만 
 * 
 * 3. 메인쿼리가 서브쿼리의 수행결과를 이용하여 
 * 		선동일이 평균 급여보다 초과하여 받는지 판별 
 * 		--> 선동일은 J1이고, 평균 급여보다 초과하여 받지 않음 
 * 
 * 결론 : 선동일은 조건을 만족하지 않으므로 메인쿼리가 선동일을 RESULT SET에서 제외
 * 
 * 다음.. ------------------------------------
 * 
 * 1. 메인쿼리에서 다음 1행을 읽음 (2행)
 * --> 송종기는 'J2'이고 600만을 받음 
 * 
 * 2. 서브쿼리에서 'J2'의 평균 급여를 조회 
 * --> 'J2'의 평균급여 485만 
 * 
 * 3. 메인쿼리가 서브쿼리의 수행결과를 이용하여 
 * 		송종기가 평균 급여보다 초과하여 받는지 판별 
 * 	--> 송종기는 J2이고, 평균 급여보다 초과하여 받음 (600 > 485)
 * 		
 * 결론 : 송종기는 조건을 만족하므로 메인쿼리가 송종기의 EMP_NAME, JOB_CODE, SALARY반환 
 * 	--> RESULT SET에 포함 
 * 
 * */

	SELECT EMP_NAME, JOB_CODE, SALARY
	FROM EMPLOYEE MAIN
	WHERE SALARY > (SELECT AVG(SALARY) FROM EMPLOYEE SUB WHERE MAIN.JOB_CODE = SUB.JOB_CODE);


-- 사수가 있는 직원의 사번, 이름, 부서명, 사수사번 조회 

-- 메인쿼리 
SELECT EMP_ID, EMP_NAME, DEPT_TITLE, MANAGER_ID
FROM EMPLOYEE 
LEFT JOIN DEPARTMENT ON (DEPT_ID = DEPT_CODE);

-- 서브쿼리 
SELECT EMP_ID 
FROM EMPLOYEE 
WHERE MANAGER_ID = 214; 

/* 사수가 214번(방명수)인 사원의 EMP_ID가 216, 217
 * 이 번호들이 메인쿼리의 EMP_ID에 존재하면 조회결과에 포함 
 * 
 * 메인쿼리 조회하면 216,217 모두 존재하는 사원 
 * 그러면 RESULT SET에 포함 
 * 
 * 
 * 
 * 
 * 
 * */

-- 방법 1 ) 
-- IN 연산자 

SELECT EMP_ID, EMP_NAME, DEPT_TITLE, MANAGER_ID
FROM EMPLOYEE MAIN
LEFT JOIN DEPARTMENT ON (DEPT_ID = DEPT_CODE)
WHERE MAIN.MANAGER_ID IN (SELECT EMP_ID FROM EMPLOYEE SUB WHERE MAIN.MANAGER_ID = EMP_ID); 


/* IN 서브쿼리는 메인쿼리의 조건을 만족하는 데이터를 반환함 
 * 따라서 각 직원의 MANAGER_ID가 다른 직원의 EMP_ID와 일치하는 경우에 
 * 해당 직원의 정보를 반환함 */
							
-- 방법 2) 
-- EXISTS : 서브쿼리에서 조회된 결과와 일치하는 행이 
--       메인쿼리에 하나라도 있으면 조회 결과에 포함 

SELECT EMP_ID, EMP_NAME, DEPT_TITLE, MANAGER_ID
FROM EMPLOYEE MAIN
LEFT JOIN DEPARTMENT ON (DEPT_ID = DEPT_CODE)
WHERE EXISTS (SELECT EMP_ID FROM EMPLOYEE SUB WHERE MAIN.MANAGER_ID = EMP_ID); 		

/*
 * EXISTS 서브쿼리는 조건을 만족하는 데이터가 하나 이상 존재하는지만 확인하고 
 * 실제 데이터 값을 반환하지 않음 
 * 즉, 각 직원의 MANAGER_ID가 다른 직원의 EMP_ID와 일치하는 경우만 확인됨 
 * 
 * -->  서브쿼리 결과가 메인쿼리의 행들 중 일치하는게 있냐? TRUE
 * --> 그럼 일치하는 행을 결과에 포함 
 *
 * */

	
-- 부서별 입사일이 가장 빠른 사원의 
-- 사번, 이름, 부서명(NULL이면 '소속없음'), 직급명, 입사일 조회하고 
-- 입사일이 빠른순으로 정렬 / 퇴사한 직원은 제외 

-- 메인쿼리 (사번, 이름, 부서명(NULL이면 '소속없음'), 직급명, 입사일, 퇴사한 직원 제외)
SELECT EMP_ID, EMP_NAME, DEPT_CODE, NVL(DEPT_TITLE, '소속없음'), JOB_NAME, HIRE_DATE
FROM EMPLOYEE 
JOIN JOB USING (JOB_CODE)
LEFT JOIN DEPARTMENT ON (DEPT_ID = DEPT_CODE)
WHERE ENT_YN = 'N'; 

-- 서브쿼리 (부서별 입사일이 가장 빠른 사원)
SELECT MIN(HIRE_DATE) FROM EMPLOYEE WHERE DEPT_CODE = 'D1'; 
/* 1. 메인쿼리의 첫번째 행인 방명수가 있는 부서 D1의 가장 빠른 입사일을 조회했는데 
 * 2007-03-20 00:00:00.000 
 * 방명수 입사일과 달라 방명수 제외 
 * 
 * 2. 차태연 입사일이랑 다름, 차태연 아님 RESULT SET 제외 
 * 3. 전지연 입사일이랑 같음, 전지연이 D1부서의 가장 빠른 입사자 

 * 
 * */

SELECT EMP_ID, EMP_NAME, DEPT_CODE, NVL(DEPT_TITLE, '소속없음'), JOB_NAME, HIRE_DATE
FROM EMPLOYEE MAIN
JOIN JOB USING (JOB_CODE)
LEFT JOIN DEPARTMENT ON (DEPT_ID = DEPT_CODE)
WHERE ENT_YN = 'N'
AND HIRE_DATE = (SELECT MIN(HIRE_DATE) FROM EMPLOYEE SUB WHERE MAIN.DEPT_CODE = SUB.DEPT_CODE)
ORDER BY HIRE_DATE ; 


---------------------------------------------------------------------------------------


-- 6. 스칼라 서브쿼리 
-- SELECT절에 사용되는 서브쿼리 결과로 1행만 반환 
-- SQL에서 단일 값을 가리켜 '스칼라'라고 함 
--> SELECT절에 작성되는 단일행 서브쿼리 

--모든 직원의 이름 직급 급여 전체사원 중 가장 높은 급여와의 차 
SELECT EMP_NAME, JOB_CODE, SALARY, 
			 (SELECT MAX(SALARY) FROM EMPLOYEE) - SALARY
FROM EMPLOYEE ;






-- 모든 사원의 이름, 직급코드, 급여, 각 직원들이 속한 직급의 급여 평균 조회 

-- 메인쿼리
SELECT EMP_NAME, JOB_CODE, SALARY 
FROM EMPLOYEE;
-- 서브쿼리 
SELECT AVG(SALARY)
FROM EMPLOYEE 
WHERE JOB_CODE = 'J1'; 

-- (스칼라+상관쿼리)
SELECT EMP_NAME, JOB_CODE, SALARY, 
			(SELECT CEIL(AVG(SALARY)) 
			 FROM EMPLOYEE SUB  
			 WHERE SUB.JOB_CODE = MAIN.JOB_CODE)
FROM EMPLOYEE MAIN 
ORDER BY JOB_CODE ;


-- 모든 사원의 사번, 이름, 관리자사번, 관리자명을 조회 
-- 단 관리자가 없는 경우 없음으로 표시 

-- 스칼라 + 상관쿼리 
SELECT EMP_ID, EMP_NAME, MANAGER_ID, 
			 NVL((SELECT EMP_NAME 
			 			FROM EMPLOYEE SUB 
			 			WHERE MAIN.MANAGER_ID = SUB.EMP_ID), '없음') 관리자명
FROM EMPLOYEE MAIN;


---------------------------------------------------------------------------------------


--7. 인라인 뷰 (INLINE-VIEW)
-- FROM 절에서 서브쿼리를 사용하는 경우로 
-- 서브쿼리가 만든 결과의 집합(RESULT SET)을 테이블 대신 사용

-- 서브쿼리 
SELECT EMP_NAME 이름, DEPT_TITLE 부서
FROM EMPLOYEE 
JOIN DEPARTMENT ON (DEPT_CODE = DEPT_ID); -- 메인쿼리의 테이블로 사용 

-- 부서가 기술지원부인 모든 컬럼 
SELECT * FROM (SELECT EMP_NAME 이름, DEPT_TITLE 부서 
							 FROM EMPLOYEE 
						   JOIN DEPARTMENT ON (DEPT_CODE = DEPT_ID))
WHERE 부서 = '기술지원부'; 



-- 인라인뷰를 활용한 TOP-N 분석 
-- 전 직원중 급여가 높은 상위 5명의 순위, 이름, 급여 조회 


-- ROWNUM 컬럼 : 행 번호를 나타내는 가상 컬럼 
-- SELECT, WHERE, ORDER BY 절 사용가능 

SELECT ROWNUM, EMP_NAME, SALARY
FROM EMPLOYEE 
WHERE ROWNUM <= 5
ORDER BY SALARY DESC; 
--> 문제점 : SELECT 해석 순서 때문에 
-- 급여 상위 5명이 아니라 조회 순서 상위 5명의 급여 순위가 조회됨 

--> 인라인뷰를 이용해서 해결 가능 

-- 1) 이름, 급여를 급여 내림차순으로 조회한 결과를 인라인뷰로 사용
--> FROM 절에 작성되기 때문에 해석 1순위 

--2) 메인쿼리 조회시 ROWNUM을 5 이하까지만 조회 

SELECT ROWNUM, EMP_NAME, SALARY
FROM (SELECT EMP_NAME, SALARY 
			FROM EMPLOYEE
			ORDER BY SALARY DESC) 
WHERE ROWNUM <= 5; 			



-- 급여 평균이 3위 안에 드는 부서의 부서코드, 부서명, 평균 급여 조회 
SELECT ROWNUM, DEPT_CODE, DEPT_TITLE, 평균급여 
FROM (SELECT DEPT_CODE, DEPT_TITLE, CEIL(AVG(SALARY)) 평균급여 
			FROM EMPLOYEE LEFT JOIN DEPARTMENT ON(DEPT_CODE = DEPT_ID) 
			GROUP BY DEPT_CODE, DEPT_TITLE
			ORDER BY 평균급여 DESC)
WHERE ROWNUM <= 3; 

--SELECT 절에 없어도 사용 가능 
-------------------------------------------------------------------------

-- 8. WITH 
-- 서브쿼리에 이름을 붙여주고 사용시 이름을 사용하게 함 
-- 인라인뷰로 사용될 서브쿼리에 주로 사용됨 
-- 실행 속도 빨라진다는 장점 있음 

-- 전직원의 급여 순위 
-- 순위, 이름, 급여 조회 

WITH TOP_SAL AS( SELECT EMP_NAME, SALARY FROM EMPLOYEE ORDER BY SALARY DESC)
SELECT ROWNUM, EMP_NAME, SALARY 
FROM TOP_SAL 
WHERE ROWNUM <= 10; 



----------------------------------------------------------------------------


-- 9. RANK() OVER / DENSE_RANK() OVER
-- RANK() OVER : 동일한 순위 이후의 등수를 동일한 인원수 만큼 건너뛰고 순위 계산 
-- EX) 공동 1위가 2명이면 다음 순위는 3위 
-- 사원별 급여 순위 

SELECT RANK() OVER(ORDER BY SALARY DESC) 순위, EMP_NAME, SALARY
FROM EMPLOYEE ; 
/*
19	전형돈	2000000
19	윤은해	2000000
21	박나라	1800000
 * */

-- DENSE_RANK() OVER : 동일한 순위 이후의 등수를 이후의 순위로 계산
-- EX) 공동 1위가 2명이어도 다음 순위 2위 
SELECT DENSE_RANK()	OVER(ORDER BY SALARY DESC) 순위, EMP_NAME, SALARY 
FROM EMPLOYEE ; 

/*
19	전형돈	2000000
19	윤은해	2000000
20	박나라	1800000
 * */



-----------------------------------------------------------------------------------------------


--1. 전지연 사원이 속해있는 부서원들 조회 , 전지연은 제외 
-- 사번 사원명 전화번호 고용일 부서명 

SELECT EMP_ID, EMP_NAME, PHONE, HIRE_DATE, DEPT_TITLE 
FROM EMPLOYEE
LEFT JOIN DEPARTMENT ON (DEPT_ID = DEPT_CODE)
WHERE DEPT_CODE = (SELECT DEPT_CODE FROM EMPLOYEE WHERE EMP_NAME = '전지연')
AND EMP_NAME != '전지연';


--2. 고용일이 2000년도 이후인 사원들 중 급여가 가장 높은 사원 
-- 사번, 사원명, 전화번호, 급여, 직급명 
--SELECT MAX(SALARY) FROM EMPLOYEE ;
--SELECT EMP_NAME, SALARY FROM EMPLOYEE WHERE EXTRACT(YEAR FROM HIRE_DATE) >= '2000';

SELECT EMP_ID, EMP_NAME, PHONE, SALARY
FROM EMPLOYEE WHERE SALARY = 
(SELECT MAX(SALARY) FROM EMPLOYEE WHERE EXTRACT(YEAR FROM HIRE_DATE) >= '2000') ;



--3. 노옹철 사원과 같은 부서 같은 직급인 사원 조회 노옹철 사원 제외 
--사번, 이름, 부서코드, 직급코드, 부서명, 직급명 

SELECT EMP_ID, EMP_NAME, DEPT_CODE, JOB_CODE, DEPT_TITLE, JOB_NAME
FROM EMPLOYEE 
NATURAL JOIN JOB 
LEFT JOIN DEPARTMENT ON(DEPT_ID = DEPT_CODE)
WHERE (DEPT_CODE, JOB_CODE) 
= (SELECT DEPT_CODE, JOB_CODE FROM EMPLOYEE 
		WHERE EMP_NAME = '노옹철')
AND EMP_NAME != '노옹철';


--4. 2000년도에 입사한 사원과 부서와 직급이 같은 사원 
-- 사번, 이름, 부서코드, 직급코드, 고용일 

SELECT EMP_ID, EMP_NAME, DEPT_CODE, JOB_CODE, HIRE_DATE
FROM EMPLOYEE 
WHERE (DEPT_CODE, JOB_CODE) =
(SELECT DEPT_CODE, JOB_CODE 
FROM EMPLOYEE WHERE EXTRACT (YEAR FROM HIRE_DATE) = '2000');


--5. 77년생 여자 사원과 동일한 부서 동일한 사수 
-- 사번,이름, 부서코드, 사수번호, 주민번호, 고용일 

SELECT EMP_ID, EMP_NAME, MANAGER_ID, EMP_NO, HIRE_DATE 
FROM EMPLOYEE 
WHERE (DEPT_CODE, MANAGER_ID ) =
(SELECT DEPT_CODE, MANAGER_ID 
FROM EMPLOYEE 
WHERE SUBSTR(EMP_NO, 8,1)= '2' 
AND SUBSTR(EMP_NO, 1, 2) ='77');


--6. 부서별 입사일이 가장 빠른 사원의 
--사번, 이름, 부서명('소속없음'), 직급명, 입사일 /입사일은 빠른순으로 조회/퇴사직원 빼고 
/*SELECT EMP_ID, EMP_NAME, NVL(DEPT_TITLE, '소속없음'), JOB_NAME, HIRE_DATE 
FROM EMPLOYEE NATURAL JOIN JOB LEFT JOIN DEPARTMENT ON (DEPT_ID= DEPT_CODE);

SELECT MIN(HIRE_DATE) FROM EMPLOYEE GROUP BY DEPT_CODE ; */

SELECT EMP_ID, EMP_NAME, NVL(DEPT_TITLE, '소속없음'), JOB_NAME, HIRE_DATE 
FROM EMPLOYEE 
JOIN JOB USING(JOB_CODE) 
LEFT JOIN DEPARTMENT ON (DEPT_ID= DEPT_CODE)
WHERE HIRE_DATE IN (SELECT MIN(HIRE_DATE) 
										FROM EMPLOYEE 
										WHERE ENT_YN = 'N' 
										GROUP BY DEPT_CODE)
ORDER BY HIRE_DATE;

-- 부서별로 그룹을 묶을 때 퇴사한 직원을 서브쿼리에서 제외해야함 
-- 부서별로 가장 빠른 입사자 구했을 때 D8부서는 이태림이어서 
--> 문제점 : 부서별로 가장 빠른 입사자 구한 후 메인쿼리에서 퇴사자 제외하니까 D8부서가 제외됨 
--> 부서별 가장 빠른 입사자 구할 때 (서브쿼리) 퇴사한 직원 뺀 상태에서 그룹으로 묶으면 
-- D8부서의 가장 빠른 입사자는 이태림 제외 후 전형돈 



-- 7. 직급별 나이가 가장 어린 직원 
-- 사번, 이름, 직급명, 나이, 보너스 포함 연봉 조회 
--나이순 내림차순 / 연봉은 \124,800,000으로 출력되게 

/*
SELECT MAX(EMP_NO) FROM EMPLOYEE GROUP BY JOB_CODE ; 

SELECT EMP_NAME, TO_CHAR(SALARY * (1 + NVL(BONUS, 0)) * 12, 'L999,999,999'),
CEIL(MONTHS_BETWEEN (SYSDATE, TO_DATE(19||SUBSTR(EMP_NO, 1, 6),'YYYYMMDD') ) / 12) 나이
FROM EMPLOYEE ; 

SELECT TO_DATE(19||SUBSTR(EMP_NO, 1, 6),'YYYYMMDD') FROM EMPLOYEE e ;

SELECT EMP_ID, EMP_NAME, JOB_NAME, 
MONTHS_BETWEEN (TO_DATE(19||SUBSTR(EMP_NO, 1, 6)), 'YYYYMMDD') AND SYSDATE / 12 나이, 
TO_CHAR(SALARY * (1 + NVL(BONUS, 0)) * 12, 'L999,999,999')  
FROM EMPLOYEE NATURAL JOIN JOB 
WHERE EMP_NO = (MAX(EMP_NO) FROM EMPLOYEE GROUP BY JOB_CODE) ; */


SELECT EMP_ID, EMP_NAME, JOB_NAME, 
			 FLOOR(MONTHS_BETWEEN (SYSDATE, TO_DATE(SUBSTR(EMP_NO, 1, 6),'RRMMDD') ) / 12) 나이,
			 TO_CHAR(SALARY * (1 + NVL(BONUS, 0)) * 12, 'L999,999,999') 연봉
FROM EMPLOYEE NATURAL JOIN JOB 
WHERE EMP_NO IN (SELECT MAX(EMP_NO) 
									FROM EMPLOYEE GROUP BY JOB_CODE)
ORDER BY 나이 DESC;




SELECT EMP_NAME,
FLOOR (MONTHS_BETWEEN(SYSDATE, TO_DATE(SUBSTR(EMP_NO, 1, 6), 'RRMMDD') ) /12) 나이,
 TO_CHAR(SALARY * (1 + NVL(BONUS, 0))*12 , 'L999,999,999' ) 연봉 
FROM EMPLOYEE 
ORDER BY 2 ;





















							
							
							







