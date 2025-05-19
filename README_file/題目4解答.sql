BEGIN TRANSACTION;

-- 1. rooms 表：儲存教室與大樓資訊
CREATE TABLE IF NOT EXISTS rooms (
    room_no VARCHAR(20) PRIMARY KEY,
    building VARCHAR(20) NOT NULL
);

-- 2. teachers 表：儲存教師資訊
CREATE TABLE IF NOT EXISTS teachers (
    teacher_id VARCHAR(10) PRIMARY KEY,
    teacher_name VARCHAR(20) NOT NULL
);

-- 3. courses 表：儲存課程資訊，course_room 設為 NOT NULL
CREATE TABLE IF NOT EXISTS courses (
    semester VARCHAR(7),
    course_no VARCHAR(10),
    course_name VARCHAR(255) NOT NULL,
    course_type VARCHAR(10) NOT NULL,
    course_room VARCHAR(20) NOT NULL,
    course_time VARCHAR(20) NOT NULL,
    course_credit INTEGER NOT NULL,
    course_limit INTEGER NOT NULL,
    course_status VARCHAR(10) NOT NULL,
    PRIMARY KEY (semester, course_no),
    FOREIGN KEY (course_room) REFERENCES rooms(room_no)
);

-- 4. course_teacher 表：儲存課程與教師關聯，使用 teacher_id
CREATE TABLE IF NOT EXISTS course_teacher (
    semester VARCHAR(7),
    course_no VARCHAR(10),
    teacher_id VARCHAR(10),
    PRIMARY KEY (semester, course_no, teacher_id),
    FOREIGN KEY (semester, course_no) REFERENCES courses(semester, course_no),
    FOREIGN KEY (teacher_id) REFERENCES teachers(teacher_id)
);

-- 5. course_field 表：儲存課程領域
CREATE TABLE IF NOT EXISTS course_field (
    semester VARCHAR(7),
    course_no VARCHAR(10),
    field TEXT NOT NULL,
    PRIMARY KEY (semester, course_no, field),
    FOREIGN KEY (semester, course_no) REFERENCES courses(semester, course_no)
);

-- 6. students 表：儲存學生資訊，使用 student_id
CREATE TABLE IF NOT EXISTS students (
    student_id VARCHAR(10) PRIMARY KEY,
    student_name VARCHAR(20) NOT NULL,
    student_dept VARCHAR(30) NOT NULL,
    student_grade INTEGER NOT NULL,
    student_status VARCHAR(10) NOT NULL,
    student_class VARCHAR(1) NOT NULL
);

-- 7. enrollments 表：儲存選課記錄，使用 student_id
CREATE TABLE IF NOT EXISTS enrollments (
    semester VARCHAR(7),
    course_no VARCHAR(10),
    student_id VARCHAR(10),
    select_result VARCHAR(10) NOT NULL,
    course_score NUMERIC,
    feedback_rank INTEGER,
    PRIMARY KEY (semester, course_no, student_id),
    FOREIGN KEY (semester, course_no) REFERENCES courses(semester, course_no),
    FOREIGN KEY (student_id) REFERENCES students(student_id)
);

-- 插入 rooms 資料
INSERT INTO rooms (room_no, building) VALUES
('O313', '綜教館'),
('L102', '工程五館'),
('M-605', '鴻經館'),
('I1-018', '管理二館'),
('I1-304', '管理二館'),
('O-214', '綜教館');

-- 插入 teachers 資料（假設教師 ID 為 T001 起）
INSERT INTO teachers (teacher_id, teacher_name) VALUES
('T001', '岳飛'),
('T002', '陸羽'),
('T003', '劉邦'),
('T004', '項羽'),
('T005', '孔丘'),
('T006', '莊周'),
('T007', '巴哈'),
('T008', '達文西');

-- 插入 courses 資料
INSERT INTO courses (semester, course_no, course_name, course_type, course_room, course_time, course_credit, course_limit, course_status) VALUES
('1132', 'A0001', '日文', '選修', 'O313', '一567', 2, 50, '開課'),
('1132', 'A0002', '計算機概論', '必修', 'L102', '二34,五4', 3, 50, '開課'),
('1132', 'A0003', '統計學習', '選修', 'M-605', '四567', 3, 50, '開課'),
('1132', 'A0004', '經濟學', '必修', 'I1-018', '四567', 3, 50, '開課'),
('1132', 'A0005', '統計學', '選修', 'I1-304', '五234', 3, 50, '開課'),
('1132', 'A0006', '音樂欣賞', '選修', 'O-214', '三56', 2, 100, '開課'),
('1132', 'A0007', '演算法', '選修', 'L102', '三234', 3, 50, '開課');

-- 插入 course_teacher 資料
INSERT INTO course_teacher (semester, course_no, teacher_id) VALUES
('1132', 'A0001', 'T001'),
('1132', 'A0002', 'T002'),
('1132', 'A0003', 'T003'),
('1132', 'A0003', 'T004'),
('1132', 'A0004', 'T005'),
('1132', 'A0005', 'T006'),
('1132', 'A0006', 'T007'),
('1132', 'A0007', 'T008');

-- 插入 course_field 資料
INSERT INTO course_field (semester, course_no, field) VALUES
('1132', 'A0001', '理論數學'),
('1132', 'A0002', '基礎知識'),
('1132', 'A0002', '人工智慧'),
('1132', 'A0003', '財務工程'),
('1132', 'A0003', '統計推論'),
('1132', 'A0004', '基礎知識'),
('1132', 'A0005', '基礎知識'),
('1132', 'A0006', '人文思想'),
('1132', 'A0007', '人工智慧'),
('1132', 'A0007', '資料科學');

-- 插入 students 資料（假設學生 ID 為 S001 起）
INSERT INTO students (student_id, student_name, student_dept, student_grade, student_status, student_class) VALUES
('S001', '張飛', '數學系', 1, '在學', 'A'),
('S002', '孫尚香', '數學系', 1, '休學', 'A'),
('S003', '周瑜', '數學系', 1, '在學', 'A'),
('S004', '黃蓋', '數學系', 1, '在學', 'A'),
('S005', '趙雲', '數學系', 1, '在學', 'A'),
('S006', '關興', '數學系', 1, '在學', 'A'),
('S007', '夏侯惇', '數學系', 1, '在學', 'A'),
('S008', '龐統', '資訊工程系', 1, '休學', 'A'),
('S009', '關羽', '資訊工程系', 1, '在學', 'A'),
('S010', '華雄', '資訊工程研究所', 1, '退學', 'A'),
('S011', '華陀', '資訊工程研究所', 1, '在學', 'A'),
('S012', '劉備', '資訊管理系', 1, '在學', 'A'),
('S013', '呂布', '資訊工程研究所', 1, '在學', 'A'),
('S014', '諸葛亮', '資訊工程研究所', 1, '在學', 'A'),
('S015', '呂蒙', '資訊工程研究所', 1, '在學', 'A'),
('S016', '圖靈', '數學系碩士班', 1, '在學', 'A'),
('S017', '巴斯卡', '數學系碩士班', 1, '在學', 'A'),
('S018', '大喬', '資訊工程系', 1, '在學', 'A'),
('S019', '甘寧', '資訊工程系', 1, '在學', 'A'),
('S020', '司馬昭', '資訊工程系', 1, '在學', 'A'),
('S021', '馬超', '資訊工程系', 1, '在學', 'A'),
('S022', '郭嘉', '資訊工程研究所', 1, '在學', 'A');

-- 插入 enrollments 資料
INSERT INTO enrollments (semester, course_no, student_id, select_result, course_score, feedback_rank) VALUES
('1132', 'A0001', 'S001', '中選', 77.7, 6),
('1132', 'A0001', 'S002', '中選', NULL, NULL),
('1132', 'A0001', 'S003', '中選', 56, 2),
('1132', 'A0001', 'S004', '中選', 34, 5),
('1132', 'A0001', 'S005', '中選', 98, 7),
('1132', 'A0001', 'S006', '中選', 55, 10),
('1132', 'A0001', 'S007', '中選', 67, 2),
('1132', 'A0001', 'S008', '中選', NULL, NULL),
('1132', 'A0002', 'S009', '中選', 66, 5),
('1132', 'A0002', 'S008', '中選', NULL, NULL),
('1132', 'A0002', 'S003', '中選', 93, 7),
('1132', 'A0002', 'S004', '中選', 44, 3),
('1132', 'A0002', 'S005', '中選', 49, 10),
('1132', 'A0002', 'S007', '中選', 78, 5),
('1132', 'A0002', 'S010', '中選', NULL, NULL),
('1132', 'A0002', 'S011', '中選', 74, 10),
('1132', 'A0003', 'S008', '中選', NULL, NULL),
('1132', 'A0003', 'S001', '中選', 46, 10),
('1132', 'A0003', 'S004', '中選', 76, 7),
('1132', 'A0003', 'S006', '中選', 87, 10),
('1132', 'A0003', 'S012', '落選', NULL, NULL),
('1132', 'A0003', 'S010', '中選', NULL, NULL),
('1132', 'A0003', 'S013', '中選', 76, 7),
('1132', 'A0003', 'S011', '中選', 80, 10),
('1132', 'A0003', 'S014', '中選', 78, 5),
('1132', 'A0003', 'S015', '中選', 65, 7),
('1132', 'A0003', 'S016', '中選', 99, 5),
('1132', 'A0003', 'S017', '人工加選', 69, 1),
('1132', 'A0004', 'S008', '落選', NULL, NULL),
('1132', 'A0004', 'S001', '中選', 56.5, 5),
('1132', 'A0004', 'S002', '中選', NULL, NULL),
('1132', 'A0004', 'S004', '中選', 67.5, 10),
('1132', 'A0004', 'S005', '中選', 78, 7),
('1132', 'A0004', 'S007', '中選', 89, 2),
('1132', 'A0004', 'S013', '中選', 45, 7),
('1132', 'A0005', 'S009', '中選', 68.7, 1),
('1132', 'A0005', 'S018', '中選', 63, 7),
('1132', 'A0005', 'S019', '中選', 31, 10),
('1132', 'A0005', 'S002', '中選', NULL, NULL),
('1132', 'A0005', 'S003', '中選', 78, 2),
('1132', 'A0005', 'S004', '中選', 87, 10),
('1132', 'A0005', 'S012', '中選', 96, 2),
('1132', 'A0006', 'S009', '中選', 76, 7),
('1132', 'A0006', 'S008', '中選', NULL, NULL),
('1132', 'A0006', 'S020', '落選', NULL, NULL),
('1132', 'A0006', 'S021', '落選', NULL, NULL),
('1132', 'A0006', 'S001', '中選', 34, 5),
('1132', 'A0006', 'S002', '落選', NULL, NULL),
('1132', 'A0006', 'S003', '落選', NULL, NULL),
('1132', 'A0006', 'S004', '中選', 80, 7),
('1132', 'A0006', 'S006', '中選', 62, 10),
('1132', 'A0006', 'S007', '中選', 44, 5),
('1132', 'A0006', 'S012', '中選', 56, 10),
('1132', 'A0006', 'S010', '中選', NULL, NULL),
('1132', 'A0006', 'S011', '中選', 98, 7),
('1132', 'A0006', 'S014', '中選', 55, 10),
('1132', 'A0006', 'S015', '中選', 78, 9),
('1132', 'A0007', 'S001', '落選', NULL, NULL),
('1132', 'A0007', 'S010', '中選', NULL, NULL),
('1132', 'A0007', 'S013', '中選', 79, 8),
('1132', 'A0007', 'S022', '中選', 87, 7),
('1132', 'A0007', 'S011', '中選', 68, 5),
('1132', 'A0007', 'S008', '中選', NULL, NULL),
('1132', 'A0007', 'S016', '中選', 99, 5),
('1132', 'A0007', 'S017', '中選', 69.5, 10);

COMMIT;
