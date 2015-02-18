CREATE DATABASE `quiz_website`;

USE `quiz_website`

DROP TABLE IF EXISTS `quizzes`;
CREATE TABLE `quizzes` (
  `quiz_id` INT NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(50) NOT NULL,
  PRIMARY KEY (`quiz_id`)
);

-- Example quizzes to work with 
INSERT INTO `quizzes` VALUES
(NULL, 'General knowledge'),
(NULL, 'History knowledge'),
(NULL, 'Random things');

DROP TABLE IF EXISTS `questions`;
CREATE TABLE `questions` (
  `question_id` INT NOT NULL AUTO_INCREMENT,
  `question` VARCHAR(50) NOT NULL, 
  `ans1` VARCHAR(50) NOT NULL,
  `ans2` VARCHAR(50) NOT NULL,
  `ans3` VARCHAR(50),
  `ans4` VARCHAR(50),
  `ans5` VARCHAR(50),
  `ans6` VARCHAR(50),
  `correct` INT NOT NULL,
  `quiz_id` INT NOT NULL,
  PRIMARY KEY (`question_id`),
  FOREIGN KEY (`quiz_id`) REFERENCES `quizzes`(`quiz_id`)
);

-- Inserting questions for the first quiz
INSERT INTO `questions` VALUES
(NULL, 'When was Bulgaria founded?', '681', '861', '680', '682', NULL, NULL, 1, 1),
(NULL, 'Where is the Eiffel Tower situated?', 'NYC', 'Berlin', 'Madrid', 'Tokyo', 'Paris', 'LA', 5, 1), 
(NULL, 'Who wrote 1984?', 'Stephen King', 'George Orwell', 'Charles Dickens', NULL, NULL, NULL, 2, 1);

-- Inserting questions for the second quiz
INSERT INTO `questions` VALUES
(NULL, 'When was the Treaty of Tilsit signed?', '1583', '1805', '1807', '1808', NULL, NULL, 3, 2),
(NULL, 'When was the Nazi party founded?', '1920', '1915', '1925', NULL, NULL, NULL, 1, 2);

-- Select the questions and the answers for a given quiz 
SELECT 
	questions.question, 
	questions.ans1,
	questions.ans2,
	questions.ans3,
	questions.ans4,
	questions.ans5,
	questions.ans6,
	questions.correct
FROM 
	quizzes
INNER JOIN
	questions
ON
	quizzes.quiz_id = questions.quiz_id
WHERE 
	quizzes.quiz_id = 1;

CREATE TABLE `scores` (
  `score_id` INT NOT NULL AUTO_INCREMENT,
  `score` INT NOT NULL,
  `quiz_id` INT NOT NULL,
  PRIMARY KEY (`score_id`),
  FOREIGN KEY (`quiz_id`) REFERENCES `quizzes`(`quiz_id`)
);

-- Populating with garbage
INSERT INTO `scores` VALUES
(NULL, 100, 1),
(NULL, 50, 1),
(NULL, 85, 1),
(NULL, 85, 2),
(NULL, 100, 3);

-- Select the highest 10 scores for a given quiz
SELECT 
	quizzes.name, 
	scores.score
FROM
	scores
INNER JOIN
	quizzes
ON
	scores.quiz_id = quizzes.quiz_id
WHERE
	quizzes.quiz_id = 2
ORDER BY 
	scores.score DESC 
LIMIT 10;
