-- 更新 CourseSchedule 表中的 room_code
UPDATE CourseSchedule
SET room_code = 'A201'
WHERE course_no = 'A0001' AND room_code = 'O313';

-- 更新 Room 表，插入新的教室記錄（若 A201 不存在）
INSERT INTO Room (room_code, building_name)
SELECT 'A201', '教研大樓'
WHERE NOT EXISTS (SELECT 1 FROM Room WHERE room_code = 'A201');

--刪除原本Room 資料
DELETE FROM Room
WHERE NOT EXISTS (
SELECT [room_code] FROM CourseSchedule 
WHERE CourseSchedule.room_code = Room.room_code
);