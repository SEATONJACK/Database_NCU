WITH UniqueTeachers AS (
    SELECT DISTINCT ct.course_no, t.teacher_name
    FROM CourseTeacher ct
    JOIN Teacher t ON ct.teacher_id = t.teacher_id
),
CourseFeedback AS (
    SELECT 
        cs.course_no,
        c.course_name,
        cs.feedback_rank
    FROM CourseSelection cs
    JOIN Course c ON cs.course_no = c.course_no
    WHERE (cs.select_result = N'中選' OR cs.select_result = N'人工加選') AND cs.feedback_rank IS NOT NULL
    GROUP BY cs.course_no, c.course_name, cs.student_id, cs.feedback_rank
),
AggregatedFeedback AS (
    SELECT 
        cf.course_no,
        cf.course_name,
        SUM(cf.feedback_rank) AS total_feedback,
        AVG(cf.feedback_rank * 1.0) AS avg_feedback
    FROM CourseFeedback cf
    GROUP BY cf.course_no, cf.course_name
)
SELECT 
    af.course_no AS 課程編號,
    af.course_name AS 課稱名稱,
    STRING_AGG(ut.teacher_name, ',') AS 授課教師,
    af.total_feedback AS 評量總分,
    ROUND(af.avg_feedback, 2) AS 評量平均分數
FROM AggregatedFeedback af
LEFT JOIN UniqueTeachers ut ON af.course_no = ut.course_no
GROUP BY af.course_no, af.course_name, af.total_feedback, af.avg_feedback
ORDER BY af.avg_feedback DESC;