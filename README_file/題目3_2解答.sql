SELECT 
    c.course_no AS course_id,
    c.course_name,
    s.student_id,
    s.student_name,
    d.dept_name AS department,
    '' AS attendance
FROM CourseSelection cs
JOIN Course c ON cs.course_no = c.course_no
JOIN Student s ON cs.student_id = s.student_id
JOIN Department d ON s.dept_id = d.dept_id
WHERE cs.course_no = 'A0002'
	AND s.status='在學'
    AND cs.select_result <> '落選' 
    AND cs.semester='1132'
ORDER BY s.student_id;