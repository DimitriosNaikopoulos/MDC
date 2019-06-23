-- phpMyAdmin SQL Dump
-- version 4.9.0.1
-- https://www.phpmyadmin.net/
--
-- Φιλοξενητής: 127.0.0.1
-- Χρόνος δημιουργίας: 23 Ιουν 2019 στις 23:51:23
-- Έκδοση διακομιστή: 10.3.16-MariaDB
-- Έκδοση PHP: 7.3.6

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET AUTOCOMMIT = 0;
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Βάση δεδομένων: `mdc`
--

-- --------------------------------------------------------

--
-- Δομή πίνακα για τον πίνακα `questions`
--

CREATE TABLE `questions` (
  `IDquestion` int(11) NOT NULL,
  `IDquiz` int(11) NOT NULL,
  `QuestionText` varchar(50) NOT NULL,
  `Answers` varchar(200) NOT NULL,
  `Correct` varchar(50) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Άδειασμα δεδομένων του πίνακα `questions`
--

INSERT INTO `questions` (`IDquestion`, `IDquiz`, `QuestionText`, `Answers`, `Correct`) VALUES
(1, 1, 'This is the first question?', 'answer1;answer2;answer3;answer4', 'answer1'),
(2, 1, 'This is the second question?', 'answer1;answer2;answer3;answer4', 'answer4');

-- --------------------------------------------------------

--
-- Δομή πίνακα για τον πίνακα `quiz`
--

CREATE TABLE `quiz` (
  `IDquiz` int(11) NOT NULL,
  `title` varchar(50) NOT NULL,
  `description` text NOT NULL,
  `total_tries` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Άδειασμα δεδομένων του πίνακα `quiz`
--

INSERT INTO `quiz` (`IDquiz`, `title`, `description`, `total_tries`) VALUES
(1, 'Test1', 'Test1 Test1 Test1', 0),
(2, 'Test2', 'Test2 Test2 Test2', 0);

-- --------------------------------------------------------

--
-- Δομή πίνακα για τον πίνακα `results`
--

CREATE TABLE `results` (
  `IDresult` int(11) NOT NULL,
  `Score` float NOT NULL,
  `UserAnswers` text NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Δομή πίνακα για τον πίνακα `user`
--

CREATE TABLE `user` (
  `email` varchar(50) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Άδειασμα δεδομένων του πίνακα `user`
--

INSERT INTO `user` (`email`) VALUES
('test@test.com');

-- --------------------------------------------------------

--
-- Δομή πίνακα για τον πίνακα `user_has_results`
--

CREATE TABLE `user_has_results` (
  `IDquiz` int(11) NOT NULL,
  `IDresult` int(11) NOT NULL,
  `email` varchar(50) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Ευρετήρια για άχρηστους πίνακες
--

--
-- Ευρετήρια για πίνακα `questions`
--
ALTER TABLE `questions`
  ADD PRIMARY KEY (`IDquestion`),
  ADD KEY `IDquiz` (`IDquiz`);

--
-- Ευρετήρια για πίνακα `quiz`
--
ALTER TABLE `quiz`
  ADD PRIMARY KEY (`IDquiz`);

--
-- Ευρετήρια για πίνακα `results`
--
ALTER TABLE `results`
  ADD PRIMARY KEY (`IDresult`);

--
-- Ευρετήρια για πίνακα `user`
--
ALTER TABLE `user`
  ADD PRIMARY KEY (`email`);

--
-- Ευρετήρια για πίνακα `user_has_results`
--
ALTER TABLE `user_has_results`
  ADD KEY `IDquiz` (`IDquiz`),
  ADD KEY `IDresult` (`IDresult`),
  ADD KEY `email` (`email`);

--
-- AUTO_INCREMENT για άχρηστους πίνακες
--

--
-- AUTO_INCREMENT για πίνακα `questions`
--
ALTER TABLE `questions`
  MODIFY `IDquestion` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT για πίνακα `quiz`
--
ALTER TABLE `quiz`
  MODIFY `IDquiz` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT για πίνακα `results`
--
ALTER TABLE `results`
  MODIFY `IDresult` int(11) NOT NULL AUTO_INCREMENT;

--
-- Περιορισμοί για άχρηστους πίνακες
--

--
-- Περιορισμοί για πίνακα `questions`
--
ALTER TABLE `questions`
  ADD CONSTRAINT `questions_ibfk_1` FOREIGN KEY (`IDquiz`) REFERENCES `quiz` (`IDquiz`);

--
-- Περιορισμοί για πίνακα `user_has_results`
--
ALTER TABLE `user_has_results`
  ADD CONSTRAINT `user_has_results_ibfk_1` FOREIGN KEY (`IDquiz`) REFERENCES `quiz` (`IDquiz`),
  ADD CONSTRAINT `user_has_results_ibfk_2` FOREIGN KEY (`IDresult`) REFERENCES `results` (`IDresult`),
  ADD CONSTRAINT `user_has_results_ibfk_3` FOREIGN KEY (`email`) REFERENCES `user` (`email`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
