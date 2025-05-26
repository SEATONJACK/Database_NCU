-- 更新 Building 表，插入新的教室記錄（若 A201 不存在）
INSERT INTO Building (building_id, building_name)
SELECT 
    'B' + RIGHT('000' + CAST(COALESCE(MAX(CAST(SUBSTRING(building_id, 2, LEN(building_id)-1) AS INT)), 0) + 1 AS VARCHAR), 3),
    N'教研大樓'
FROM Building
WHERE NOT EXISTS (SELECT building_id FROM Building WHERE building_name = N'教研大樓');

-- 更新 Room 表，插入新的教室記錄（若 A201 不存在）
INSERT INTO Room (room_code, building_id)
SELECT 
    'A201',
    building_id
FROM Building
WHERE building_name = N'教研大樓'
AND NOT EXISTS (SELECT 1 FROM Room WHERE room_code = 'A201')

UPDATE CourseSchedule
SET room_code = 'A201'
WHERE course_no = 'A0001' AND room_code = 'O313';