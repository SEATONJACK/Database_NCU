 SELECT 
    c.course_no AS 課程編號,
    c.course_name AS 課程名稱,
    STRING_AGG(t.teacher_name, ',') AS 授課教師,
    SUM(cs.feedback_rank) AS 評量總分,
    ROUND(AVG(cs.feedback_rank), 2) AS 評量平均分數
FROM CourseSelection cs
JOIN Course c ON cs.course_no = c.course_no
JOIN CourseTeacher ct ON c.course_no = ct.course_no
JOIN Teacher t ON ct.teacher_id = t.teacher_id
WHERE (cs.select_result = '中選' OR cs.slect_result = '人工加選') AND cs.feedback_rank IS NOT NULL
GROUP BY c.course_no, c.course_name
ORDER BY 評量平均分數 DESC;