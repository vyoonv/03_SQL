
--학번 이름 입학년도 
--입학년도 빠른 순으로 

SELECT STUDENT_NO 학번, STUDENT_NAME 이름, ENTRANCE_DATE 입학년도 
FROM TB_STUDENT 
WHERE DEPARTMENT_NO = '002'
ORDER BY ENTRANCE_DATE ; 


-- 교수 중 이름이 세글자가 아닌 교수가 한 명 
-- 그 교수 이름, 주민번호 조회 

SELECT PROFESSOR_NAME, PROFESSOR_SSN
FROM TB_PROFESSOR 
WHERE PROFESSOR_NAME NOT LIKE '___'; 

-- ***** 남자 교수들의 이름과 나이를 출력 

SELECT PROFESSOR_NAME 교수이름, PROFESSOR_SSN 나이 
FROM TB_PROFESSOR
-- EXTRACT(YEAR FROM(SYSDATE)) 
WHERE SUBSTR(PROFESSOR_SSN, 8, 1) = 1; 


-- 교수들의 이름 중 성을 제외한 이름만 출력

SELECT SUBSTR(PROFESSOR_NAME, 2) 이름 
FROM TB_PROFESSOR ;


-- 재수생 입학자 

SELECT STUDENT_NO, STUDENT_NAME
FROM TB_STUDENT 
WHERE EXTRACT(YEAR FROM ENTRANCE_DATE) - EXTRACT(YEAR FROM TO_DATE(SUBSTR(STUDENT_SSN, 1, 2), 'RR')) > 20 ;A


--2020크리스마스는 무슨요일?
SELECT TO_CHAR(TO_DATE( 20201225) , 'YY-MM-DD,DY' )
FROM DUAL; --금요일 

SELECT TO_DATE('99/10/11', 'YY/MM/DD')
FROM DUAL; --2099-10-11 00:00:00.000

SELECT TO_DATE('49/10/11', 'YY/MM/DD')
FROM DUAL; --2049-10-11 00:00:00.000

SELECT TO_DATE('99/10/11', 'RR/MM/DD')
FROM DUAL; --1999-10-11 00:00:00.000

SELECT TO_DATE('49/10/11', 'RR/MM/DD')
FROM DUAL; --2049-10-11 00:00:00.000


--춘 기술대학교 2000년도 이후 입학자들은 학번이 A로 시작하게 되어있다 
--이전 학번을 받은 학생들의 학번과 이름을 조회 
SELECT STUDENT_NO, STUDENT_NAME
FROM TB_STUDENT 
WHERE NOT SUBSTR(STUDENT_NO, 1, 1) = 'A' ; 

-- 학번이 A517178 한아름 학생의 학점 총 평점 

SELECT ROUND( AVG(POINT), 1) 평점 
FROM TB_GRADE 
WHERE STUDENT_NO = 'A517178'; 



--학과별 학생수를 구하여 학과번호 학생수(명)의 형태로 결과 조회 
SELECT DEPARTMENT_NO 학과번호 --, COUNT(*) "학생수(명)"
FROM TB_DEPARTMENT ;


--지도 교수를 배정받지 못한 학생의 수는 몇 명 정도 되는지 
SELECT COUNT(*)
FROM TB_STUDENT 
WHERE COACH_PROFESSOR_NO IS NULL;


-- 학번이 A112113인 김고운 학생의 년도 별 평점
-- TERM_NO 년도// POINT 년도 별 평점  
SELECT SUBSTR(TERM_NO, 1, 4) 년도, AVG(POINT) "년도 별 평점"
FROM TB_GRADE 
WHERE STUDENT_NO = 'A112113' 
GROUP BY POINT ; 


-- 학과별 휴학생 수 
-- 학과 코드명 / 휴학생 수 

SELECT DISTINCT DEPARTMENT_NO "학과 코드명", COUNT(*) "휴학생 수"
FROM TB_STUDENT 
WHERE ABSENCE_YN = 'Y'
GROUP BY DEPARTMENT_NO 
ORDER BY DEPARTMENT_NO ; 


-- 14동명이인 학생들의 이름을 찾기 
-- 동일 이름 / 동명인 수 

SELECT STUDENT_NAME, COUNT(*)
FROM TB_STUDENT 
WHERE 
GROUP BY STUDENT_NAME ; 


--학번이 A112113인 김고운 학생의 년도, 학기별 평점과 년도 별 누적 평점 총 평점 
-- 년도 / 학기 / 평점 





















---------------------------------------------------------------------------------------------

-->>>>3번 
-- 남자 교수들의 이름과 나이 
--나이가 적은 사람 -> 많은 사람
SELECT PROFESSOR_NAME 교수이름, 
FLOOR(MONTHS_BETWEEN(SYSDATE, TO_DATE('19' || SUBSTR(PROFESSOR_SSN, 1, 6), 'YYYYMMDD' ))/12) 나이			 
FROM TB_PROFESSOR 
WHERE SUBSTR(PROFESSOR_SSN, 8, 1) = '1' 
ORDER BY 나이;
--주민번호 앞자리 -> 날짜 형식 -> 오늘날짜와 개월수 차이 -> 년도로 바꾸고 -> 내림 


-->>>> 5번 
SELECT STUDENT_NO, STUDENT_NAME
FROM TB_STUDENT 
WHERE EXTRACT (YEAR FROM ENTRANCE_DATE)
- EXTRACT(YEAR FROM TO_DATE('19'||SUBSTR(STUDENT_SSN, 1, 6), 'YYYYMMDD')) > 19; 


-->>>>6번 
--'DAY':X요일  //  'DY' : X   //  'D' : 2
																-- 1 : 일 ~ 7 : 토

-->>>> 12번 
-- 연도별 평점 
SELECT SUBSTR(TERM_NO, 1, 4) AS 년도, 
ROUND(AVG(POINT), 1) AS "년도 별 평점" 
FROM TB_GRADE 
WHERE STUDENT_NO = 'A112113'
GROUP BY SUBSTR(TERM_NO, 1, 4) -- 년도만 잘라서 묶음
ORDER BY 년도; 


-->>> 13번 
SELECT DEPARTMENT_NO "학과코드명", 
SUM(DECODE(ABSENCE_YN, 'Y', 1, 0) ) "휴학생 수"
FROM TB_STUDENT 
GROUP BY DEPARTMENT_NO
ORDER BY 1 ; 


-->>>> 14번 
-- 동명이인 
SELECT STUDENT_NAME 동일이름, COUNT(*) "동명인 수"
FROM TB_STUDENT 
GROUP BY STUDENT_NAME 
HAVING COUNT(*) > 1 
ORDER BY 1; 


-->>> 15번 
-- 년도, 학기 별 평점, 총 평점 
SELECT NVL (SUBSTR(TERM_NO, 1, 4), ' ') 년도, 
NVL(SUBSTR(TERM_NO, 5, 2), ' ') 학기, 
ROUND(AVG(POINT),1) 평점
FROM TB_GRADE 
WHERE STUDENT_NO = 'A112113'
GROUP BY ROLLUP(SUBSTR(TERM_NO, 1, 4), SUBSTR(TERM_NO, 5, 2)) ;
























