WITH TeacherList AS (
    SELECT DISTINCT ct.course_no, t.teacher_name
    FROM CourseTeacher ct
    INNER JOIN Teacher t ON ct.teacher_id = t.teacher_id
)
SELECT 
    c.course_name AS '課名',
    STRING_AGG(tl.teacher_name, ' / ') AS '授課教師',
    SUM(CASE WHEN cs.score < 60 AND s.dept_name like '%系'THEN 1 ELSE 0 END)+SUM(CASE WHEN cs.score < 70 AND s.dept_name not like '%系'THEN 1 ELSE 0 END) AS '不及格人次',
    SUM(CASE WHEN cs.score IS NOT NULL THEN 1 ELSE 0 END) AS '修課人次',
    ROUND(
        SUM(CASE WHEN cs.score < 60 AND s.dept_name like '%系'THEN 1 ELSE 0 END)+SUM(CASE WHEN cs.score < 70 AND s.dept_name not like '%系'THEN 1 ELSE 0 END) * 100.0 / 
        NULLIF(SUM(CASE WHEN cs.score IS NOT NULL THEN 1 ELSE 0 END), 0), 
        2
    ) AS '不及格比例'
FROM CourseSelection cs
INNER JOIN Course c ON cs.course_no = c.course_no
INNER JOIN Student s ON cs.student_id=s.student_id
INNER JOIN TeacherList tl ON cs.course_no = tl.course_no
WHERE cs.select_result = N'中選'
GROUP BY c.course_no, c.course_name
HAVING SUM(CASE WHEN cs.score IS NOT NULL THEN 1 ELSE 0 END) > 0
ORDER BY ['不及格比例']DESC;