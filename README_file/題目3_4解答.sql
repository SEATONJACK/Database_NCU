WITH TotalByDept AS (
    SELECT 
        d.dept_name,
        COUNT(cs.student_id) AS total_count
    FROM CourseSelection cs
    JOIN Student s ON cs.student_id = s.student_id
    JOIN Department d ON s.dept_id = d.dept_id
    WHERE cs.select_result = '中選' OR cs.slect_result = '人工加選'
    GROUP BY d.dept_name
)
SELECT 
    d.dept_name AS 學生系所,
    cf.field_name AS 課程領域,
    COUNT(cs.student_id) AS 人次,
    ROUND(
        COUNT(cs.student_id) * 100.0 / t.total_count, 
        2
    ) AS 佔比
FROM CourseSelection cs
JOIN Student s ON cs.student_id = s.student_id
JOIN Department d ON s.dept_id = d.dept_id
JOIN CurriculumField cf ON cs.course_no = cf.course_no
JOIN TotalByDept t ON d.dept_name = t.dept_name
WHERE cs.select_result = '中選' OR cs.slect_result = '人工加選'
GROUP BY d.dept_name, cf.field_name
ORDER BY d.dept_name, 佔比 DESC;
