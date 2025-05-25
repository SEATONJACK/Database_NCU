BEGIN TRANSACTION;

-- Department 表：儲存系所資訊
CREATE TABLE IF NOT EXISTS Department (
    dept_id CHAR(6) PRIMARY KEY, -- 系所代碼，主鍵
    dept_name VARCHAR(50) UNIQUE NOT NULL -- 系所名稱
);

-- Teacher 表：儲存教師資訊
CREATE TABLE IF NOT EXISTS Teacher (
    teacher_id CHAR(6) PRIMARY KEY, -- 教師代碼，主鍵
    teacher_name VARCHAR(50) UNIQUE NOT NULL -- 教師姓名
);

-- Building 表：儲存大樓資訊
CREATE TABLE IF NOT EXISTS Building (
    building_id CHAR(4) PRIMARY KEY, -- 大樓代碼，主鍵
    building_name VARCHAR(50) UNIQUE NOT NULL -- 大樓名稱
);

-- Room 表：儲存教室資訊
CREATE TABLE IF NOT EXISTS Room (
    room_code VARCHAR(10) PRIMARY KEY, -- 教室編碼，主鍵
    building_id CHAR(4) NOT NULL, -- 所屬大樓代碼，外鍵
    FOREIGN KEY (building_id) REFERENCES Building(building_id) -- 外鍵，參考 Building 表
);

-- Student 表：儲存學生基本資料，與 Department 表關聯
CREATE TABLE IF NOT EXISTS Student (
    student_id CHAR(8) PRIMARY KEY, -- 學號，主鍵
    student_name VARCHAR(30) NOT NULL, -- 學生姓名
    dept_id CHAR(6) NOT NULL, -- 系所代碼，外鍵
    grade TINYINT NOT NULL, -- 年級
    status ENUM('Enrolled', 'Suspended', 'Dropped') NOT NULL, -- 在學狀態：已註冊、休學、退學
    class_code CHAR(2) NOT NULL, -- 班別
    FOREIGN KEY (dept_id) REFERENCES Department(dept_id) -- 外鍵，參考 Department 表
);

-- Course 表：儲存課程基本資訊
CREATE TABLE IF NOT EXISTS Course (
    course_no CHAR(5) PRIMARY KEY, -- 課程編號，主鍵
    course_name VARCHAR(50) NOT NULL, -- 課程名稱
    course_type ENUM('Required', 'Elective') NOT NULL, -- 課程類型：必修或選修
    credit TINYINT NOT NULL, -- 學分數
    capacity SMALLINT NOT NULL, -- 人數上限
    status ENUM('Open', 'Cancelled') NOT NULL -- 開課狀態：開課或取消
);

-- CourseSchedule 表：儲存課程的單一上課時段和教室資訊
CREATE TABLE IF NOT EXISTS CourseSchedule (
    schedule_id BIGINT AUTO_INCREMENT PRIMARY KEY, -- 時段流水號，主鍵，自增
    course_no CHAR(5) NOT NULL, -- 課程編號，外鍵
    room_code VARCHAR(10) NOT NULL, -- 教室編碼，外鍵
    time_slot VARCHAR(10) NOT NULL, -- 上課時段
    FOREIGN KEY (course_no) REFERENCES Course(course_no), -- 外鍵，參考 Course 表
    FOREIGN KEY (room_code) REFERENCES Room(room_code) -- 外鍵，參考 Room 表
);

-- CourseTeacher 表：處理課程與教師的多對多關係
CREATE TABLE IF NOT EXISTS CourseTeacher (
    course_no CHAR(5), -- 課程編號，主鍵+外鍵
    teacher_id CHAR(6), -- 教師代碼，主鍵+外鍵
    PRIMARY KEY (course_no, teacher_id), -- 複合主鍵
    FOREIGN KEY (course_no) REFERENCES Course(course_no), -- 外鍵，參考 Course 表
    FOREIGN KEY (teacher_id) REFERENCES Teacher(teacher_id) -- 外鍵，參考 Teacher 表
);

-- CurriculumField 表：處理課程與領域的多對多關係
CREATE TABLE IF NOT EXISTS CurriculumField (
    course_no CHAR(5), -- 課程編號，主鍵+外鍵
    field_name VARCHAR(50), -- 課程領域，主鍵
    PRIMARY KEY (course_no, field_name), -- 複合主鍵
    FOREIGN KEY (course_no) REFERENCES Course(course_no) -- 外鍵，參考 Course 表
);

-- CourseSelection 表：儲存學生選課結果、成績和教學評量
CREATE TABLE IF NOT EXISTS CourseSelection (
    student_id CHAR(8), -- 學號，主鍵+外鍵
    course_no CHAR(5), -- 課程編號，主鍵+外鍵
    semester CHAR(4), -- 學期，主鍵
    select_result ENUM('Selected', 'Manual', 'Dropped') NOT NULL, -- 選課結果：中選、人工加選、落選
    score DECIMAL(4,1), -- 成績
    feedback_rank TINYINT, -- 教學評量
    PRIMARY KEY (student_id, course_no, semester), -- 複合主鍵
    FOREIGN KEY (student_id) REFERENCES Student(student_id), -- 外鍵，參考 Student 表
    FOREIGN KEY (course_no) REFERENCES Course(course_no) -- 外鍵，參考 Course 表
);

-- 插入 Department 表數據：從原始資料的 student_dept 提取唯一系所
INSERT INTO Department (dept_id, dept_name) VALUES
('D001', '數學系'),
('D002', '資訊工程系'),
('D003', '資訊管理系'),
('D004', '資訊工程研究所'),
('D005', '數學系碩士班');

-- 插入 Teacher 表數據：從原始資料的 teacher_name 提取唯一教師
INSERT INTO Teacher (teacher_id, teacher_name) VALUES
('T001', '岳飛'),
('T002', '陸羽'),
('T003', '劉邦'),
('T004', '項羽'),
('T005', '孔丘'),
('T006', '莊周'),
('T007', '巴哈'),
('T008', '達文西');

-- 插入 Building 表數據：從原始資料的 course_building 提取唯一大樓
INSERT INTO Building (building_id, building_name) VALUES
('B001', '綜教館'),
('B002', '工程五館'),
('B003', '鴻經館'),
('B004', '管理二館');

-- 插入 Room 表數據：從原始資料的 course_room 和 course_building 配對
INSERT INTO Room (room_code, building_id) VALUES
('O313', 'B001'), -- O313 屬於綜教館
('L102', 'B002'), -- L102 屬於工程五館
('M-605', 'B003'), -- M-605 屬於鴻經館
('I1-018', 'B004'), -- I1-018 屬於管理二館
('I1-304', 'B004'), -- I1-304 屬於管理二館
('O-214', 'B001'); -- O-214 屬於綜教館

-- 插入 Student 表數據：從原始資料提取學生資訊，映射系所到 dept_id
INSERT INTO Student (student_id, student_name, dept_id, grade, status, class_code) VALUES
('S001', '張飛', 'D001', 1, 'Enrolled', 'A'),
('S002', '孫尚香', 'D001', 1, 'Suspended', 'A'),
('S003', '周瑜', 'D001', 1, 'Enrolled', 'A'),
('S004', '黃蓋', 'D001', 1, 'Enrolled', 'A'),
('S005', '趙雲', 'D001', 1, 'Enrolled', 'A'),
('S006', '關興', 'D001', 1, 'Enrolled', 'A'),
('S007', '夏侯惇', 'D001', 1, 'Enrolled', 'A'),
('S008', '龐統', 'D002', 1, 'Suspended', 'A'),
('S009', '關羽', 'D002', 1, 'Enrolled', 'A'),
('S010', '華雄', 'D004', 1, 'Dropped', 'A'),
('S011', '華陀', 'D004', 1, 'Enrolled', 'A'),
('S012', '劉備', 'D003', 1, 'Enrolled', 'A'),
('S013', '呂布', 'D004', 1, 'Enrolled', 'A'),
('S014', '諸葛亮', 'D004', 1, 'Enrolled', 'A'),
('S015', '呂蒙', 'D004', 1, 'Enrolled', 'A'),
('S016', '圖靈', 'D005', 1, 'Enrolled', 'A'),
('S017', '巴斯卡', 'D005', 1, 'Enrolled', 'A'),
('S018', '大喬', 'D002', 1, 'Enrolled', 'A'),
('S019', '甘寧', 'D002', 1, 'Enrolled', 'A'),
('S020', '司馬昭', 'D002', 1, 'Enrolled', 'A'),
('S021', '馬超', 'D002', 1, 'Enrolled', 'A'),
('S022', '郭嘉', 'D004', 1, 'Enrolled', 'A');

-- 插入 Course 表數據：從原始資料提取課程基本資訊
INSERT INTO Course (course_no, course_name, course_type, credit, capacity, status) VALUES
('A0001', '日文', 'Elective', 2, 50, 'Open'),
('A0002', '計算機概論', 'Required', 3, 50, 'Open'),
('A0003', '統計學習', 'Elective', 3, 50, 'Open'),
('A0004', '經濟學', 'Required', 3, 50, 'Open'),
('A0005', '統計學', 'Elective', 3, 50, 'Open'),
('A0006', '音樂欣賞', 'Elective', 2, 100, 'Open'),
('A0007', '演算法', 'Elective', 3, 50, 'Open');

-- 插入 CourseSchedule 表數據：將 course_time 拆分成單一時段
INSERT INTO CourseSchedule (course_no, room_code, time_slot) VALUES
('A0001', 'O313', '一5'), -- A0001 (日文) 的時間一567
('A0001', 'O313', '一6'),
('A0001', 'O313', '一7'),
('A0002', 'L102', '二3'), -- A0002 (計算機概論) 的時間二34,五4 
('A0002', 'L102', '二4'),
('A0002', 'L102', '五4'),
('A0003', 'M-605', '四5'), -- A0003 (統計學習) 的時間四567 
('A0003', 'M-605', '四6'),
('A0003', 'M-605', '四7'),
('A0004', 'I1-018', '四5'), -- A0004 (經濟學) 的時間四567 
('A0004', 'I1-018', '四6'),
('A0004', 'I1-018', '四7'),
('A0005', 'I1-304', '五2'), -- A0005 (統計學) 的時間五234 
('A0005', 'I1-304', '五3'),
('A0005', 'I1-304', '五4'),
('A0006', 'O-214', '三5'), -- A0006 (音樂欣賞) 的時間三56 
('A0006', 'O-214', '三6'),
('A0007', 'L102', '三2'), -- A0007 (演算法) 的時間三234 
('A0007', 'L102', '三3'),
('A0007', 'L102', '三4');

-- 插入 CourseTeacher 表數據：處理課程與教師的多對多關係
INSERT INTO CourseTeacher (course_no, teacher_id) VALUES
('A0001', 'T001'), -- A0001 (日文) 由岳飛教授
('A0002', 'T002'), -- A0002 (計算機概論) 由陸羽教授
('A0003', 'T003'), -- A0003 (統計學習) 由劉邦和項羽教授
('A0003', 'T004'),
('A0004', 'T005'), -- A0004 (經濟學) 由孔丘教授
('A0005', 'T006'), -- A0005 (統計學) 由莊周教授
('A0006', 'T007'), -- A0006 (音樂欣賞) 由巴哈教授
('A0007', 'T008'); -- A0007 (演算法) 由達文西教授

-- 插入 CurriculumField 表數據：處理課程與領域的多對多關係
INSERT INTO CurriculumField (course_no, field_name) VALUES
('A0001', '理論數學'), -- A0001 (日文) 屬於理論數學
('A0002', '基礎知識'), -- A0002 (計算機概論) 屬於基礎知識和人工智慧
('A0002', '人工智慧'),
('A0003', '財務工程'), -- A0003 (統計學習) 屬於財務工程和統計推論
('A0003', '統計推論'),
('A0004', '基礎知識'), -- A0004 (經濟學) 屬於基礎知識
('A0005', '基礎知識'), -- A0005 (統計學) 屬於基礎知識
('A0006', '人文思想'), -- A0006 (音樂欣賞) 屬於人文思想
('A0007', '人工智慧'), -- A0007 (演算法) 屬於人工智慧和資料科學
('A0007', '資料科學');

-- 插入 CourseSelection 表數據：記錄學生選課、成績和評量
INSERT INTO CourseSelection (student_id, course_no, semester, select_result, score, feedback_rank) VALUES
('S001', 'A0001', '1132', 'Selected', 77.7, 6), 
('S002', 'A0001', '1132', 'Selected', NULL, NULL), 
('S003', 'A0001', '1132', 'Selected', 56, 2), 
('S004', 'A0001', '1132', 'Selected', 34, 5), 
('S005', 'A0001', '1132', 'Selected', 98, 7), 
('S006', 'A0001', '1132', 'Selected', 55, 10), 
('S007', 'A0001', '1132', 'Selected', 67, 2), 
('S008', 'A0001', '1132', 'Selected', NULL, NULL),
('S009', 'A0002', '1132', 'Selected', 66, 5), 
('S008', 'A0002', '1132', 'Selected', NULL, NULL),
('S003', 'A0002', '1132', 'Selected', 93, 7), 
('S004', 'A0002', '1132', 'Selected', 44, 3), 
('S005', 'A0002', '1132', 'Selected', 49, 10), 
('S007', 'A0002', '1132', 'Selected', 78, 5), 
('S010', 'A0002', '1132', 'Selected', NULL, NULL), 
('S011', 'A0002', '1132', 'Selected', 74, 10), 
('S008', 'A0003', '1132', 'Selected', NULL, NULL), 
('S001', 'A0003', '1132', 'Selected', 46, 10), 
('S004', 'A0003', '1132', 'Selected', 76, 7), 
('S006', 'A0003', '1132', 'Selected', 87, 10), 
('S012', 'A0003', '1132', 'Dropped', NULL, NULL), 
('S010', 'A0003', '1132', 'Selected', NULL, NULL), 
('S013', 'A0003', '1132', 'Selected', 76, 7), 
('S011', 'A0003', '1132', 'Selected', 80, 10), 
('S014', 'A0003', '1132', 'Selected', 78, 5), 
('S015', 'A0003', '1132', 'Selected', 65, 7), 
('S016', 'A0003', '1132', 'Selected', 99, 5), 
('S017', 'A0003', '1132', 'Manual', 69, 1), 
('S008', 'A0004', '1132', 'Dropped', NULL, NULL), 
('S001', 'A0004', '1132', 'Selected', 56.5, 5), 
('S002', 'A0004', '1132', 'Selected', NULL, NULL), 
('S004', 'A0004', '1132', 'Selected', 67.5, 10), 
('S005', 'A0004', '1132', 'Selected', 78, 7), 
('S007', 'A0004', '1132', 'Selected', 89, 2), 
('S013', 'A0004', '1132', 'Selected', 45, 7), 
('S009', 'A0005', '1132', 'Selected', 68.7, 1), 
('S018', 'A0005', '1132', 'Selected', 63, 7), 
('S019', 'A0005', '1132', 'Selected', 31, 10), 
('S002', 'A0005', '1132', 'Selected', NULL, NULL), 
('S003', 'A0005', '1132', 'Selected', 78, 2), 
('S004', 'A0005', '1132', 'Selected', 87, 10), 
('S012', 'A0005', '1132', 'Selected', 96, 2), 
('S009', 'A0006', '1132', 'Selected', 76, 7), 
('S008', 'A0006', '1132', 'Selected', NULL, NULL), 
('S020', 'A0006', '1132', 'Dropped', NULL, NULL), 
('S021', 'A0006', '1132', 'Dropped', NULL, NULL), 
('S001', 'A0006', '1132', 'Selected', 34, 5), 
('S002', 'A0006', '1132', 'Dropped', NULL, NULL), 
('S003', 'A0006', '1132', 'Dropped', NULL, NULL), 
('S004', 'A0006', '1132', 'Selected', 80, 7), 
('S006', 'A0006', '1132', 'Selected', 62, 10), 
('S007', 'A0006', '1132', 'Selected', 44, 5), 
('S012', 'A0006', '1132', 'Selected', 56, 10), 
('S010', 'A0006', '1132', 'Selected', NULL, NULL), 
('S011', 'A0006', '1132', 'Selected', 98, 7), 
('S014', 'A0006', '1132', 'Selected', 55, 10), 
('S015', 'A0006', '1132', 'Selected', 78, 9), 
('S001', 'A0007', '1132', 'Dropped', NULL, NULL), 
('S010', 'A0007', '1132', 'Selected', NULL, NULL), 
('S013', 'A0007', '1132', 'Selected', 79, 8), 
('S022', 'A0007', '1132', 'Selected', 87, 7), 
('S011', 'A0007', '1132', 'Selected', 68, 5), 
('S008', 'A0007', '1132', 'Selected', NULL, NULL),
('S016', 'A0007', '1132', 'Selected', 99, 5), 
('S017', 'A0007', '1132', 'Selected', 69.5, 10); 

COMMIT;
