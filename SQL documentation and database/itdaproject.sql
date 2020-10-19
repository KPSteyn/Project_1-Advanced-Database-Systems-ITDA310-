-- phpMyAdmin SQL Dump
-- version 4.8.3
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1:3306
-- Generation Time: Jun 14, 2020 at 05:57 PM
-- Server version: 5.7.23
-- PHP Version: 7.2.10

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET AUTOCOMMIT = 0;
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `itdaproject`
--

DELIMITER $$
--
-- Procedures
--
DROP PROCEDURE IF EXISTS `CHWWorkList_Today`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `CHWWorkList_Today` (IN `CHW_Staff_ID` INT(12))  NO SQL
BEGIN
    DECLARE finished int default 0;
    DECLARE PatientID INTEGER(12);    
    DECLARE ScheduledByStaffId INTEGER(12);
    DECLARE TypeOfAppointment INTEGER(12);
    DECLARE TimeOfTodaysAppointment TIME;
    
  DECLARE findTodaysAppointmnet CURSOR for Select `PatientIdentifier`, `ScheduledBy`, `AppointmentType`, `AppointmentTime` FROM appointment WHERE appointment.`StaffIdentifier` = CHW_Staff_ID AND appointment.`AppointmentDate` = CURRENT_DATE();
DECLARE CONTINUE HANDLER FOR NOT FOUND SET finished = 1;
open findTodaysAppointmnet;

Select count(*) AS 'Total Number of Appointments Today' FROM appointment WHERE appointment.`StaffIdentifier` = CHW_Staff_ID AND appointment.`AppointmentDate` = CURRENT_DATE();

get_appointment_information_loop :LOOP

FETCH findTodaysAppointmnet INTO PatientID, ScheduledByStaffId, TypeOfAppointment, TimeOfTodaysAppointment;

IF finished = 1
  THEN LEAVE get_appointment_information_loop;
end if;

select TimeOfTodaysAppointment, PatientID, ScheduledByStaffId, TypeOfAppointment;

end loop get_appointment_information_loop;

close findTodaysAppointmnet;

             
END$$

DROP PROCEDURE IF EXISTS `CHWWorkList_Tomorrow`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `CHWWorkList_Tomorrow` (IN `CHW_Staff_ID` INT(12))  NO SQL
BEGIN


    DECLARE finished int default 0;
    DECLARE PatientID INTEGER(12);    
    DECLARE ScheduledByStaffId INTEGER(12);
    DECLARE TypeOfAppointment INTEGER(12);
    DECLARE TimeOfTomorrowsAppointment TIME;
    
  
  DECLARE findTomorrowsAppointmnet CURSOR for Select `PatientIdentifier`, `ScheduledBy`, `AppointmentType`, `AppointmentTime` FROM appointment WHERE appointment.`StaffIdentifier` = CHW_Staff_ID AND appointment.`AppointmentDate` = CURRENT_DATE() + 1;
DECLARE CONTINUE HANDLER FOR NOT FOUND SET finished = 1;
open findTomorrowsAppointmnet;

Select count(*) AS 'Total Number of Appointments Tomorrow' FROM appointment WHERE appointment.`StaffIdentifier` = CHW_Staff_ID AND appointment.`AppointmentDate` = CURRENT_DATE() + 1;

get_appointment_information_loop :LOOP

FETCH findTomorrowsAppointmnet INTO PatientID, ScheduledByStaffId, TypeOfAppointment, TimeOfTomorrowsAppointment;

IF finished = 1
  THEN LEAVE get_appointment_information_loop;
end if;

select TimeOfTomorrowsAppointment, PatientID, ScheduledByStaffId, TypeOfAppointment;

end loop get_appointment_information_loop;

close findTomorrowsAppointmnet;

             
END$$

DROP PROCEDURE IF EXISTS `CHWWorkList_Yesterday`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `CHWWorkList_Yesterday` (IN `CHW_Staff_ID` INT(12))  NO SQL
BEGIN


    DECLARE finished int default 0;
    DECLARE PatientID INTEGER(12);    
    DECLARE ScheduledByStaffId INTEGER(12);
    DECLARE TypeOfAppointment INTEGER(12);
    DECLARE TimeOfYesterdaysAppointment TIME;
    
  
  DECLARE findYesterdaysAppointmnet CURSOR for Select `PatientIdentifier`, `ScheduledBy`, `AppointmentType`, `AppointmentTime` FROM appointment WHERE appointment.`StaffIdentifier` = CHW_Staff_ID AND appointment.`AppointmentDate` = CURRENT_DATE() - 1;
DECLARE CONTINUE HANDLER FOR NOT FOUND SET finished = 1;
open findYesterdaysAppointmnet;

Select count(*) AS 'Total Number of Appointments Yesterday' FROM appointment WHERE appointment.`StaffIdentifier` = CHW_Staff_ID AND appointment.`AppointmentDate` = CURRENT_DATE() - 1;

get_appointment_information_loop :LOOP

FETCH findYesterdaysAppointmnet INTO PatientID, ScheduledByStaffId, TypeOfAppointment, TimeOfYesterdaysAppointment;

IF finished = 1
  THEN LEAVE get_appointment_information_loop;
end if;

select TimeOfYesterdaysAppointment, PatientID, ScheduledByStaffId, TypeOfAppointment;

end loop get_appointment_information_loop;

close findYesterdaysAppointmnet;

             
END$$

DROP PROCEDURE IF EXISTS `FindPatientOnSystemByID`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `FindPatientOnSystemByID` (IN `ID_of_Patient` VARCHAR(13))  NO SQL
BEGIN Select * from patient where patient.`IDNumber` = `ID_of_Patient`; END$$

DROP PROCEDURE IF EXISTS `FindPatientOnSystemByName`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `FindPatientOnSystemByName` (IN `Name_of_Patient` VARCHAR(30), IN `Surname_of_Patient` VARCHAR(30))  NO SQL
BEGIN Select * from patient where patient.`PatientName` = `Name_of_Patient` AND patient.`PatientSurname` = `Surname_of_Patient`; END$$

--
-- Functions
--
DROP FUNCTION IF EXISTS `AddedToMCMessage`$$
CREATE DEFINER=`root`@`localhost` FUNCTION `AddedToMCMessage` (`ID_of_Patient` INT(12)) RETURNS VARCHAR(200) CHARSET utf8 NO SQL
BEGIN DECLARE FirstN VARCHAR(30); DECLARE LastN VARCHAR(30); DECLARE message VARCHAR(160) default ' you are receiving this confirmation message to notify you that you have been registered on the BroadReach MomConnect system.'; DECLARE findPatientInfo CURSOR for Select `PatientName`, `PatientSurname` FROM patient WHERE patient.`PatientIdentifier` = ID_of_Patient; open findPatientInfo; FETCH findPatientInfo into FirstN,LastN; close findPatientInfo; return concat('Dear ',FirstN,' ', LastN, message); END$$

DROP FUNCTION IF EXISTS `AppointmentConfirmationMessage`$$
CREATE DEFINER=`root`@`localhost` FUNCTION `AppointmentConfirmationMessage` (`ID_of_Patient` INT(13), `ADate` DATE, `ATime` TIME) RETURNS VARCHAR(200) CHARSET utf8 NO SQL
BEGIN DECLARE FirstN VARCHAR(30); DECLARE LastN VARCHAR(30); DECLARE messagePart1 VARCHAR(160) default ' your requested appointment for '; DECLARE messagePart2 VARCHAR(160) default ' at BroadReach has been confirmed.'; DECLARE findPatientInfo CURSOR for Select `PatientName`, `PatientSurname` FROM patient WHERE patient.`PatientIdentifier` = ID_of_Patient; DECLARE findAppointmentInfo CURSOR for Select * FROM patient; open findPatientInfo; FETCH findPatientInfo into FirstN,LastN; close findPatientInfo; return concat('Dear ',FirstN,' ', LastN, messagePart1, ADate,' at ' ,ATime, messagePart2); END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `appointment`
--

DROP TABLE IF EXISTS `appointment`;
CREATE TABLE IF NOT EXISTS `appointment` (
  `AppointmentIdentifier` int(12) NOT NULL AUTO_INCREMENT,
  `PatientIdentifier` int(12) NOT NULL,
  `StaffIdentifier` int(12) NOT NULL,
  `ScheduledBy` int(12) NOT NULL,
  `AppointmentType` int(12) NOT NULL,
  `Description` varchar(300) DEFAULT NULL,
  `Attendence` tinyint(1) NOT NULL DEFAULT '1',
  `ClinicalFindings` varchar(300) DEFAULT NULL,
  `Location` varchar(60) NOT NULL,
  `AppointmentDate` date NOT NULL,
  `AppointmentTime` time NOT NULL,
  PRIMARY KEY (`AppointmentIdentifier`),
  KEY `PatientIdentifier` (`PatientIdentifier`),
  KEY `StaffIdentifier` (`StaffIdentifier`),
  KEY `ScheduledBy` (`ScheduledBy`),
  KEY `AppointmentType` (`AppointmentType`)
) ENGINE=InnoDB AUTO_INCREMENT=64 DEFAULT CHARSET=utf8;

--
-- Dumping data for table `appointment`
--

INSERT INTO `appointment` (`AppointmentIdentifier`, `PatientIdentifier`, `StaffIdentifier`, `ScheduledBy`, `AppointmentType`, `Description`, `Attendence`, `ClinicalFindings`, `Location`, `AppointmentDate`, `AppointmentTime`) VALUES
(1, 1, 1, 2, 3, NULL, 0, NULL, 'Patient Home Address', '2020-01-04', '12:00:00'),
(2, 5, 3, 2, 3, NULL, 0, NULL, 'Patient Home Address', '2020-01-05', '12:30:00'),
(3, 3, 4, 2, 3, NULL, 1, NULL, 'Patient Home Address', '2020-01-06', '15:00:00'),
(4, 4, 5, 2, 3, NULL, 1, NULL, 'Patient Home Address', '2020-01-07', '15:30:00'),
(5, 1, 1, 2, 3, NULL, 1, NULL, 'Patient Home Address', '2020-02-08', '17:00:00'),
(6, 5, 3, 2, 3, NULL, 1, NULL, 'Patient Home Address', '2020-02-09', '17:30:00'),
(7, 3, 4, 2, 3, NULL, 1, NULL, 'Patient Home Address', '2020-02-10', '16:00:00'),
(8, 4, 5, 2, 3, NULL, 1, NULL, 'Patient Home Addressl', '2020-02-11', '16:30:00'),
(9, 5, 3, 2, 3, NULL, 1, NULL, 'Patient Home Address', '2020-03-12', '12:00:00'),
(10, 3, 4, 2, 3, NULL, 1, NULL, 'Patient Home Address', '2020-03-13', '12:30:00'),
(11, 1, 8, 2, 4, NULL, 1, NULL, 'Hospital', '2019-06-18', '14:00:00'),
(12, 2, 1, 2, 3, NULL, 1, NULL, 'Patient Home Address', '2020-06-04', '10:00:00'),
(13, 3, 4, 2, 3, NULL, 1, NULL, 'Patient Home Address', '2020-06-05', '13:30:00'),
(14, 4, 5, 2, 3, NULL, 1, NULL, 'Patient Home Address', '2020-06-06', '12:00:00'),
(15, 5, 3, 2, 3, NULL, 1, NULL, 'Patient Home Address', '2020-06-07', '12:30:00'),
(16, 6, 1, 2, 3, NULL, 1, NULL, 'Patient Home Address', '2020-06-08', '13:00:00'),
(17, 7, 9, 2, 10, NULL, 1, NULL, 'Hospital', '2020-06-09', '13:30:00'),
(18, 8, 8, 2, 4, NULL, 1, NULL, 'Hospital', '2019-06-10', '14:00:00'),
(19, 9, 8, 2, 4, NULL, 1, NULL, 'Hospital', '2019-06-11', '14:30:00'),
(20, 10, 9, 2, 4, NULL, 1, NULL, 'Hospital', '2019-06-12', '15:00:00'),
(21, 11, 8, 2, 4, NULL, 1, NULL, 'Hospital', '2019-06-13', '15:30:00'),
(22, 13, 9, 9, 8, NULL, 1, NULL, 'Hospital', '2020-06-14', '17:00:00'),
(23, 12, 8, 2, 8, NULL, 1, NULL, 'Hospital', '2020-06-15', '18:30:00'),
(24, 14, 9, 2, 9, NULL, 1, NULL, 'Hospital', '2020-06-01', '14:00:00'),
(25, 15, 8, 8, 9, NULL, 1, NULL, 'Hospital', '2020-06-01', '16:00:00'),
(26, 5, 8, 2, 5, NULL, 1, NULL, 'Hospital', '2020-08-17', '14:00:00'),
(27, 16, 8, 2, 8, NULL, 1, NULL, 'Hospital', '2020-09-15', '12:00:00'),
(28, 17, 7, 2, 3, NULL, 1, NULL, 'Patient Home Address', '2020-09-15', '12:00:00'),
(29, 19, 12, 2, 3, NULL, 1, NULL, 'Patient Home Address', '2020-09-16', '08:00:00'),
(30, 18, 11, 2, 3, NULL, 1, NULL, 'Patient Home Address', '2020-09-15', '12:00:00'),
(31, 20, 13, 2, 3, NULL, 1, NULL, 'Patient Home Address', '2020-09-17', '13:00:00'),
(32, 22, 15, 2, 3, NULL, 1, NULL, 'Patient Home Address', '2020-09-20', '12:00:00'),
(33, 21, 14, 2, 3, NULL, 1, NULL, 'Patient Home Address', '2020-09-15', '10:00:00'),
(34, 2, 8, 2, 4, NULL, 1, NULL, 'Hospital', '2020-01-16', '08:00:00'),
(35, 3, 8, 2, 4, NULL, 1, NULL, 'Hospital', '2020-01-15', '12:00:00'),
(36, 6, 9, 2, 4, NULL, 1, NULL, 'Hospital', '2020-01-17', '13:00:00'),
(37, 7, 9, 2, 4, NULL, 1, NULL, 'Hospital', '2020-01-20', '12:00:00'),
(38, 14, 8, 2, 4, NULL, 1, NULL, 'Hospital', '2020-01-15', '10:00:00'),
(39, 1, 1, 2, 3, NULL, 1, NULL, 'Patient Home Address', '2020-06-03', '16:00:00'),
(40, 2, 1, 2, 3, NULL, 1, NULL, 'Patient Home Address', '2020-06-03', '12:00:00'),
(41, 1, 1, 2, 3, NULL, 1, NULL, 'Patient Home Address', '2020-06-04', '15:00:00'),
(42, 2, 1, 2, 3, NULL, 1, NULL, 'Patient Home Address', '2020-06-05', '11:00:00'),
(43, 1, 1, 2, 3, NULL, 1, NULL, 'Patient Home Address', '2020-06-05', '14:00:00'),
(44, 2, 1, 2, 3, NULL, 1, NULL, 'Patient Home Address', '2020-06-05', '17:00:00'),
(45, 1, 1, 2, 3, NULL, 0, NULL, 'Patient Home Address', '2020-06-06', '09:00:00'),
(46, 2, 1, 2, 3, NULL, 1, NULL, 'Patient Home Address', '2020-06-06', '15:00:00'),
(47, 1, 1, 2, 3, NULL, 1, NULL, 'Patient Home Address', '2020-06-07', '16:00:00'),
(48, 2, 1, 2, 3, NULL, 1, NULL, 'Patient Home Address', '2020-06-07', '12:00:00'),
(49, 1, 1, 2, 3, NULL, 1, NULL, 'Patient Home Address', '2020-06-08', '15:00:00'),
(50, 2, 1, 2, 3, NULL, 1, NULL, 'Patient Home Address', '2020-06-09', '11:00:00'),
(51, 1, 1, 2, 3, NULL, 1, NULL, 'Patient Home Address', '2020-06-10', '14:00:00'),
(52, 2, 1, 2, 3, NULL, 1, NULL, 'Patient Home Address', '2020-06-11', '17:00:00'),
(53, 1, 1, 2, 3, NULL, 0, NULL, 'Patient Home Address', '2020-06-12', '09:00:00'),
(54, 2, 1, 2, 3, NULL, 1, NULL, 'Patient Home Address', '2020-06-13', '15:00:00'),
(55, 1, 1, 2, 3, NULL, 1, NULL, 'Patient Home Address', '2020-06-14', '15:00:00'),
(56, 2, 1, 2, 3, NULL, 1, NULL, 'Patient Home Address', '2020-06-14', '11:00:00'),
(57, 1, 1, 2, 3, NULL, 1, NULL, 'Patient Home Address', '2020-06-15', '14:00:00'),
(58, 2, 1, 2, 3, NULL, 1, NULL, 'Patient Home Address', '2020-06-15', '10:00:00'),
(59, 1, 1, 2, 3, NULL, 1, NULL, 'Patient Home Address', '2020-06-16', '13:00:00'),
(60, 2, 1, 2, 3, NULL, 1, NULL, 'Patient Home Address', '2020-06-16', '16:00:00'),
(61, 1, 1, 2, 3, NULL, 0, NULL, 'Patient Home Address', '2020-06-17', '10:00:00'),
(62, 2, 1, 2, 3, NULL, 1, NULL, 'Patient Home Address', '2020-06-17', '14:00:00'),
(63, 1, 1, 2, 3, NULL, 0, NULL, 'Patient Home Address', '2020-06-19', '09:30:00');

--
-- Triggers `appointment`
--
DROP TRIGGER IF EXISTS `AppointmentConfirmationMessageTrigger`;
DELIMITER $$
CREATE TRIGGER `AppointmentConfirmationMessageTrigger` AFTER INSERT ON `appointment` FOR EACH ROW BEGIN Insert INTO message (`MessageIdentifier`, `MessageContent`, `StaffMessageRecipient`, `PatientMessageRecipient`) Values (NULL, AppointmentConfirmationMessage(NEW.PatientIdentifier, NEW.AppointmentDate, NEW.AppointmentTime),Null, NEW.PatientIdentifier); END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `appointmenttype`
--

DROP TABLE IF EXISTS `appointmenttype`;
CREATE TABLE IF NOT EXISTS `appointmenttype` (
  `TypeIdentifier` int(12) NOT NULL AUTO_INCREMENT,
  `AppointmentType` varchar(30) NOT NULL,
  `TypeDescription` varchar(60) DEFAULT NULL,
  PRIMARY KEY (`TypeIdentifier`)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8;

--
-- Dumping data for table `appointmenttype`
--

INSERT INTO `appointmenttype` (`TypeIdentifier`, `AppointmentType`, `TypeDescription`) VALUES
(1, 'PMTCT', 'Prevention of mother-to-child transmission '),
(2, 'Diabetic', 'Arrange blood test to check blood sugar.'),
(3, 'HomeVisit', 'Visit Patient At home'),
(4, 'On-Premise Checkup', 'General Checkup conducted at the hospital'),
(5, 'Circumcision', ''),
(6, 'Laminectomy', ''),
(7, 'Chemo', 'Cancer Treatment'),
(8, 'Ultrasound', 'Also known as sonography'),
(9, 'Cesarean section', ''),
(10, 'Spinal Fusion', '');

-- --------------------------------------------------------

--
-- Stand-in structure for view `chwdetailedbloodsugarresults`
-- (See below for the actual view)
--
DROP VIEW IF EXISTS `chwdetailedbloodsugarresults`;
CREATE TABLE IF NOT EXISTS `chwdetailedbloodsugarresults` (
`CHWTestIdentifier` int(12)
,`StaffIdentifier` int(12)
,`AppointmentIdentifier` int(12)
,`PatientIdentifier` int(12)
,`PatientName` varchar(30)
,`PatientSurname` varchar(30)
,`AppointmentDate` date
,`AppointmentTime` time
,`BloodSugarLevelmmolPerL` double(5,2)
);

-- --------------------------------------------------------

--
-- Stand-in structure for view `chwdetaileddrugadministration`
-- (See below for the actual view)
--
DROP VIEW IF EXISTS `chwdetaileddrugadministration`;
CREATE TABLE IF NOT EXISTS `chwdetaileddrugadministration` (
`AdministrationIdentifier` int(12)
,`CHWTestIdentifier` int(12)
,`StaffIdentifier` int(12)
,`AppointmentDate` date
,`AppointmentTime` time
,`PatientName` varchar(30)
,`PatientSurname` varchar(30)
,`BloodSugarLevelmmolPerL` double(5,2)
,`DrugAdministered` varchar(60)
,`DrugDosageINmg` double(8,2)
);

-- --------------------------------------------------------

--
-- Stand-in structure for view `chwdetailedpatientassignment`
-- (See below for the actual view)
--
DROP VIEW IF EXISTS `chwdetailedpatientassignment`;
CREATE TABLE IF NOT EXISTS `chwdetailedpatientassignment` (
`StaffIdentifier` int(12)
,`PatientIdentifier` int(12)
,`PatientName` varchar(30)
,`PatientSurname` varchar(30)
,`Address` varchar(60)
,`PhoneNumber` varchar(10)
,`EmailAddress` varchar(30)
,`Age` int(3)
,`Gender` varchar(30)
);

-- --------------------------------------------------------

--
-- Table structure for table `chwdrugadministration`
--

DROP TABLE IF EXISTS `chwdrugadministration`;
CREATE TABLE IF NOT EXISTS `chwdrugadministration` (
  `AdministrationIdentifier` int(12) NOT NULL AUTO_INCREMENT,
  `CHWTestIdentifier` int(12) NOT NULL,
  `DrugAdministered` varchar(60) NOT NULL,
  `DrugDosageINmg` double(8,2) NOT NULL,
  PRIMARY KEY (`AdministrationIdentifier`),
  KEY `CHWTestIdentifier` (`CHWTestIdentifier`)
) ENGINE=InnoDB AUTO_INCREMENT=14 DEFAULT CHARSET=utf8;

--
-- Dumping data for table `chwdrugadministration`
--

INSERT INTO `chwdrugadministration` (`AdministrationIdentifier`, `CHWTestIdentifier`, `DrugAdministered`, `DrugDosageINmg`) VALUES
(1, 1, 'Drug_Type_1', 10.00),
(2, 2, 'Drug_Type_1', 10.00),
(3, 3, 'Drug_Type_2', 15.00),
(4, 4, 'Drug_Type_1', 10.00),
(5, 5, 'Drug_Type_2', 15.00),
(6, 6, 'Drug_Type_2', 15.00),
(7, 7, 'Drug_Type_2', 15.00),
(8, 8, 'Drug_Type_1', 10.00),
(9, 9, 'Drug_Type_1', 20.00),
(10, 10, 'Drug_Type_2', 15.00);

-- --------------------------------------------------------

--
-- Table structure for table `chwstafflogindetails`
--

DROP TABLE IF EXISTS `chwstafflogindetails`;
CREATE TABLE IF NOT EXISTS `chwstafflogindetails` (
  `StaffIdentifier` int(12) NOT NULL,
  `StaffUsername` varchar(60) NOT NULL,
  `StaffPassword` varchar(40) NOT NULL,
  PRIMARY KEY (`StaffIdentifier`),
  UNIQUE KEY `StaffUsername` (`StaffUsername`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `chwstafflogindetails`
--

INSERT INTO `chwstafflogindetails` (`StaffIdentifier`, `StaffUsername`, `StaffPassword`) VALUES
(1, 'scolding532', '11584.scold'),
(3, 'lakes442', '2962.lakes'),
(4, 'spawell132', '54546.spawell'),
(5, 'mathers41', '84523.math'),
(7, 'seger156', '45631.seger'),
(11, 'seger12', '46123.seger'),
(12, 'rackley114', '56423.rackley'),
(13, 'becks142', '87878.becks'),
(14, 'barrowcliffe64', '12318.barrow'),
(15, 'tift15', '94552.tift');

-- --------------------------------------------------------

--
-- Stand-in structure for view `chwstaffviewappointment`
-- (See below for the actual view)
--
DROP VIEW IF EXISTS `chwstaffviewappointment`;
CREATE TABLE IF NOT EXISTS `chwstaffviewappointment` (
`StaffIdentifier` int(12)
,`PatientIdentifier` int(12)
,`AppointmentIdentifier` int(12)
,`AppointmentDate` date
,`AppointmentTime` time
,`PatientName` varchar(30)
,`PatientSurname` varchar(30)
,`Address` varchar(60)
,`PhoneNumber` varchar(10)
,`EmailAddress` varchar(30)
,`Gender` varchar(30)
,`Age` int(3)
);

-- --------------------------------------------------------

--
-- Stand-in structure for view `chwstaffviewhouseholdmembers`
-- (See below for the actual view)
--
DROP VIEW IF EXISTS `chwstaffviewhouseholdmembers`;
CREATE TABLE IF NOT EXISTS `chwstaffviewhouseholdmembers` (
`StaffIdentifier` int(12)
,`PatientIdentifier` int(12)
,`PatientName` varchar(30)
,`PatientSurname` varchar(30)
,`Address` varchar(60)
,`patientPhoneNumber` varchar(10)
,`patientEmailAddress` varchar(30)
,`HMIdentifier` int(12)
,`MemberName` varchar(30)
,`MemberSurname` varchar(30)
,`RelationshipWithPatient` varchar(30)
,`householdMemberPhoneNumber` varchar(10)
,`householdMemberEmailAddress` varchar(30)
,`ExistingMedicalConditions` varchar(30)
);

-- --------------------------------------------------------

--
-- Table structure for table `chwtest`
--

DROP TABLE IF EXISTS `chwtest`;
CREATE TABLE IF NOT EXISTS `chwtest` (
  `CHWTestIdentifier` int(12) NOT NULL AUTO_INCREMENT,
  `AppointmentIdentifier` int(12) NOT NULL,
  `BloodSugarLevelmmolPerL` double(5,2) NOT NULL,
  PRIMARY KEY (`CHWTestIdentifier`),
  KEY `AppointmentIdentifier` (`AppointmentIdentifier`)
) ENGINE=InnoDB AUTO_INCREMENT=14 DEFAULT CHARSET=utf8;

--
-- Dumping data for table `chwtest`
--

INSERT INTO `chwtest` (`CHWTestIdentifier`, `AppointmentIdentifier`, `BloodSugarLevelmmolPerL`) VALUES
(1, 1, 10.20),
(2, 2, 12.20),
(3, 3, 14.20),
(4, 4, 9.20),
(5, 5, 10.90),
(6, 6, 12.00),
(7, 7, 10.70),
(8, 8, 9.50),
(9, 9, 11.80),
(10, 10, 10.50);

-- --------------------------------------------------------

--
-- Table structure for table `chwtopatientassignments`
--

DROP TABLE IF EXISTS `chwtopatientassignments`;
CREATE TABLE IF NOT EXISTS `chwtopatientassignments` (
  `GroupingIdentifier` int(12) NOT NULL AUTO_INCREMENT,
  `StaffIdentifier` int(12) NOT NULL,
  `PatientIdentifier` int(12) NOT NULL,
  PRIMARY KEY (`GroupingIdentifier`),
  KEY `StaffIdentifier` (`StaffIdentifier`),
  KEY `PatientIdentifier` (`PatientIdentifier`)
) ENGINE=InnoDB AUTO_INCREMENT=13 DEFAULT CHARSET=utf8;

--
-- Dumping data for table `chwtopatientassignments`
--

INSERT INTO `chwtopatientassignments` (`GroupingIdentifier`, `StaffIdentifier`, `PatientIdentifier`) VALUES
(1, 1, 1),
(2, 1, 2),
(3, 3, 5),
(4, 4, 3),
(5, 5, 4),
(6, 1, 6),
(7, 7, 17),
(8, 11, 18),
(9, 12, 19),
(10, 13, 20),
(11, 14, 21),
(12, 15, 22);

-- --------------------------------------------------------

--
-- Table structure for table `diagnostictest`
--

DROP TABLE IF EXISTS `diagnostictest`;
CREATE TABLE IF NOT EXISTS `diagnostictest` (
  `TestIdentifier` int(12) NOT NULL AUTO_INCREMENT,
  `AppointmentIdentifier` int(12) NOT NULL,
  `TestType` varchar(120) NOT NULL,
  `TestResult` varchar(600) NOT NULL,
  `StaffIdentifier` int(12) NOT NULL,
  PRIMARY KEY (`TestIdentifier`),
  KEY `AppointmentIdentifier` (`AppointmentIdentifier`),
  KEY `StaffIdentifier` (`StaffIdentifier`)
) ENGINE=InnoDB AUTO_INCREMENT=27 DEFAULT CHARSET=utf8;

--
-- Dumping data for table `diagnostictest`
--

INSERT INTO `diagnostictest` (`TestIdentifier`, `AppointmentIdentifier`, `TestType`, `TestResult`, `StaffIdentifier`) VALUES
(1, 11, 'Diabetic Blood Test', 'Positive', 6),
(2, 11, 'HIV Antibody test (blood/oral fluid)', 'Negative', 6),
(3, 18, 'Pregnancy Test', 'Positive', 18),
(4, 18, 'Diabetic Blood Test', 'Negative', 18),
(5, 18, 'HIV Antibody test (blood/oral fluid)', 'Negative', 18),
(6, 19, 'Pregnancy Test', 'Positive', 18),
(7, 19, 'Diabetic Blood Test', 'Negative', 18),
(8, 19, 'HIV Antibody test (blood/oral fluid)', 'Positive', 18),
(9, 20, 'Pregnancy Test', 'Positive', 6),
(10, 20, 'Diabetic Blood Test', 'Negative', 6),
(11, 20, 'HIV Antibody test (blood/oral fluid)', 'Negative', 6),
(12, 21, 'Pregnancy Test', 'Positive', 6),
(13, 21, 'Diabetic Blood Test', 'Negative', 6),
(14, 21, 'HIV Antibody test (blood/oral fluid)', 'Negative', 6),
(15, 34, 'Pregnancy Test', 'Positive', 18),
(16, 34, 'Diabetic Blood Test', 'Positive', 18),
(17, 34, 'HIV Antibody test (blood/oral fluid)', 'Negative', 18),
(18, 35, 'Diabetic Blood Test', 'Positive', 18),
(19, 36, 'Diabetic Blood Test', 'Positive', 6),
(20, 36, 'HIV Antibody test (blood/oral fluid)', 'Positive', 6),
(21, 37, 'HIV Antibody test (blood/oral fluid)', 'Negative', 6),
(22, 37, 'Pregnancy Test', 'Positive', 18),
(23, 37, 'Diabetic Blood Test', 'Negative', 18),
(24, 38, 'HIV Antibody test (blood/oral fluid)', 'Negative', 6),
(25, 38, 'Pregnancy Test', 'Positive', 18),
(26, 38, 'Diabetic Blood Test', 'Negative', 18);

-- --------------------------------------------------------

--
-- Table structure for table `educationalvideo`
--

DROP TABLE IF EXISTS `educationalvideo`;
CREATE TABLE IF NOT EXISTS `educationalvideo` (
  `VideoIdentifier` int(12) NOT NULL AUTO_INCREMENT,
  `VideoTitle` varchar(300) NOT NULL,
  `ProducedBy` varchar(60) DEFAULT NULL,
  `DateOfRelease` date DEFAULT NULL,
  `ReferenceToVideoUrl` varchar(60) DEFAULT NULL,
  `RuntimeInMinutes` int(4) DEFAULT NULL,
  PRIMARY KEY (`VideoIdentifier`)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8;

--
-- Dumping data for table `educationalvideo`
--

INSERT INTO `educationalvideo` (`VideoIdentifier`, `VideoTitle`, `ProducedBy`, `DateOfRelease`, `ReferenceToVideoUrl`, `RuntimeInMinutes`) VALUES
(1, ' The Power of Nutrition', 'UCLA Health', '2018-11-19', 'https://www.youtube.com/watch?v=krIgKr3IC7s', 37),
(2, '10 Healthy Tips to Improve Your Digestive System', 'Apollo Hospitals', '2018-08-14', 'https://www.youtube.com/watch?v=DQniWOTizpA', 2),
(3, 'How your digestive system works', 'TED-Ed', '2017-12-14', 'https://www.youtube.com/watch?v=Og5xAdC8EUI', 4),
(4, '10 FOODS TO BOOST YOUR IMMUNITY', 'MEDSimplified', '2020-03-22', 'https://www.youtube.com/watch?v=b_wxaHwJ0aM', 9),
(5, 'TOP 10 HABITS THAT DAMAGE YOUR IMMUNITY', 'MEDSimplified', '2020-03-28', 'https://www.youtube.com/watch?v=FpJx4zGpsmI', 10),
(6, 'How Exercise Makes you Smarter and a Better Student', 'Med School Insiders', '2017-01-21', 'https://www.youtube.com/watch?v=dwMMn2FdBFQ', 5),
(7, 'What happens inside your body when you exercise?', 'British Heart Foundation', '2017-04-03', 'https://www.youtube.com/watch?v=wWGulLAa0O0', 2),
(8, 'Diabetes Exercises At Home Workout', 'Caroline Jordan', '2019-09-02', 'https://www.youtube.com/watch?v=ePylP2XmNRs', 14),
(9, 'Kids Exercise - Kids Workout At Home', 'Robertas Gym', '2018-06-22', 'https://www.youtube.com/watch?v=8uUawnM-FD8', 11),
(10, 'Diabetes and Exercise - Decide to Move', 'Johns Hopkins Medicine', '2012-02-24', 'https://www.youtube.com/watch?v=z-UfMvBoGVU', 14);

-- --------------------------------------------------------

--
-- Stand-in structure for view `hospitalclinicialappointments`
-- (See below for the actual view)
--
DROP VIEW IF EXISTS `hospitalclinicialappointments`;
CREATE TABLE IF NOT EXISTS `hospitalclinicialappointments` (
`ScheduledBy` int(12)
,`Description` varchar(300)
,`Attendence` tinyint(1)
,`ClinicalFindings` varchar(300)
,`AppointmentDate` date
,`AppointmentTime` time
,`PatientName` varchar(30)
,`PatientSurname` varchar(30)
,`Gender` varchar(30)
,`Age` int(3)
,`Pregnant` tinyint(1)
,`Diabetic` tinyint(1)
,`HIVPositive` tinyint(1)
,`AppointmentType` varchar(30)
,`PatientIdentifier` int(12)
,`StaffIdentifier` int(12)
);

-- --------------------------------------------------------

--
-- Table structure for table `householdmember`
--

DROP TABLE IF EXISTS `householdmember`;
CREATE TABLE IF NOT EXISTS `householdmember` (
  `HMIdentifier` int(12) NOT NULL AUTO_INCREMENT,
  `PatientIdentifier` int(12) NOT NULL,
  `MemberName` varchar(30) NOT NULL,
  `MemberSurname` varchar(30) NOT NULL,
  `CellphoneNumber` varchar(10) DEFAULT NULL,
  `EmailAddress` varchar(30) DEFAULT NULL,
  `ExistingMedicalConditions` varchar(30) DEFAULT NULL,
  `RelationshipWithPatient` varchar(30) NOT NULL,
  PRIMARY KEY (`HMIdentifier`),
  UNIQUE KEY `CellphoneNumber` (`CellphoneNumber`),
  UNIQUE KEY `EmailAddress` (`EmailAddress`),
  KEY `PatientIdentifier` (`PatientIdentifier`)
) ENGINE=InnoDB AUTO_INCREMENT=13 DEFAULT CHARSET=utf8;

--
-- Dumping data for table `householdmember`
--

INSERT INTO `householdmember` (`HMIdentifier`, `PatientIdentifier`, `MemberName`, `MemberSurname`, `CellphoneNumber`, `EmailAddress`, `ExistingMedicalConditions`, `RelationshipWithPatient`) VALUES
(2, 1, 'Sam', 'Bathoe', '0744994112', 'samwolf@gmail.com', 'HIV Positive', 'Roommate'),
(3, 5, 'Yolanda', 'Bobbins', '0754990002', 'dseakingd@geocities.com', NULL, 'Daughter'),
(4, 3, 'Avrit', 'Chapman', '0123494652', 'acrayke9@independent.co.uk', NULL, 'Spouse'),
(5, 4, 'Virge', 'Muller', '0794994659', 'clongina0@vk.com', NULL, 'Father'),
(6, 6, 'Samantha', 'Seven', '0744991122', 'rwhild0@imdb.com', NULL, 'Mother'),
(7, 17, 'Simon', 'Bunton', '0744920252', 'yglasscoef@trellian.com', 'Diabetic', 'Spouse'),
(8, 18, 'Emlyn', 'Casero', '0777994672', 'rtapping8@t.co', NULL, 'Roommate'),
(10, 3, 'Brian', 'Chapman', '0844991159', 'didela@unc.edu', 'Diabetic', 'Son');

-- --------------------------------------------------------

--
-- Stand-in structure for view `labtechnicianandhospitalclinicialdetaileddiagnostictest`
-- (See below for the actual view)
--
DROP VIEW IF EXISTS `labtechnicianandhospitalclinicialdetaileddiagnostictest`;
CREATE TABLE IF NOT EXISTS `labtechnicianandhospitalclinicialdetaileddiagnostictest` (
`TestType` varchar(120)
,`TestResult` varchar(600)
,`StaffName` varchar(30)
,`StaffSurname` varchar(30)
,`PatientName` varchar(30)
,`PatientSurname` varchar(30)
,`AppointmentDate` date
,`AppointmentTime` time
);

-- --------------------------------------------------------

--
-- Table structure for table `medicine`
--

DROP TABLE IF EXISTS `medicine`;
CREATE TABLE IF NOT EXISTS `medicine` (
  `MedicineIdentifier` int(12) NOT NULL AUTO_INCREMENT,
  `MedicineName` varchar(60) NOT NULL,
  `MedicineDescription` varchar(300) DEFAULT NULL,
  PRIMARY KEY (`MedicineIdentifier`)
) ENGINE=InnoDB AUTO_INCREMENT=12 DEFAULT CHARSET=utf8;

--
-- Dumping data for table `medicine`
--

INSERT INTO `medicine` (`MedicineIdentifier`, `MedicineName`, `MedicineDescription`) VALUES
(1, 'abacavir (Ziagen)', 'Nucleoside/nucleotide reverse transcriptase inhibitor (NRTI)'),
(2, 'dolutegravir (Tivicay)', 'Integrase strand transfer inhibitor (INSTI)'),
(3, 'lamivudine and zidovudine (Combivir)', 'Combination NRTI'),
(4, 'regular insulin (Humulin and Novolin)', 'Short-acting insulin'),
(5, 'insulin detemir (Levemir)', 'Long-acting insulin'),
(6, 'Humalog Mix 50/50', 'Combination insulin'),
(7, 'alogliptin (Nesina)', 'Dipeptidyl peptidase-4 (DPP-4) inhibitor'),
(8, 'exenatide (Byetta)', 'Glucagon-like peptide-1 receptor agonist'),
(9, 'Ketorolac', 'Anti-inflammatory drug'),
(10, 'Oxycodone', 'Given to a mother immediately following a cesarean birth'),
(11, 'Ibuprofen', 'Used in breast-feeding mothers');

-- --------------------------------------------------------

--
-- Table structure for table `message`
--

DROP TABLE IF EXISTS `message`;
CREATE TABLE IF NOT EXISTS `message` (
  `MessageIdentifier` int(12) NOT NULL AUTO_INCREMENT,
  `MessageContent` varchar(500) NOT NULL,
  `StaffMessageRecipient` int(12) DEFAULT NULL,
  `PatientMessageRecipient` int(12) DEFAULT NULL,
  PRIMARY KEY (`MessageIdentifier`),
  KEY `StaffMessageRecipient` (`StaffMessageRecipient`),
  KEY `PatientMessageRecipient` (`PatientMessageRecipient`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8;

--
-- Dumping data for table `message`
--

INSERT INTO `message` (`MessageIdentifier`, `MessageContent`, `StaffMessageRecipient`, `PatientMessageRecipient`) VALUES
(1, 'This is a notification that Bobby Brown has missed his appointment that was scheduled at 12:00:00 on 2020-01-04', 1, NULL),
(2, 'This is a notification that Bill Bobbins has missed his appointment that was scheduled at 12:30:00 on 2020-01-05', 3, NULL),
(3, 'This is a notification that Bobby Brown has missed his appointment that was scheduled at 9:00:00 on 2020-06-06', 1, NULL),
(4, 'You have an appointment scheduled for Tomorrow (2020-06-15) at 10:00:00', 1, NULL),
(5, 'You have an appointment scheduled for Tomorrow (2020-06-15) at 14:00:00', 1, NULL),
(6, 'Dear Mandy Muller you are receiving this confirmation message to notify you that you have been registered on the BroadReach MomConnect system.', NULL, 4),
(7, 'Dear Bobby Brown your requested appointment for 2020-06-19 at 09:30:00 at BroadReach has been confirmed.', NULL, 1);

-- --------------------------------------------------------

--
-- Table structure for table `momconnect`
--

DROP TABLE IF EXISTS `momconnect`;
CREATE TABLE IF NOT EXISTS `momconnect` (
  `MCIdentifier` int(12) NOT NULL AUTO_INCREMENT,
  `StageOfPregnancy` int(2) DEFAULT NULL,
  `PatientIdentifier` int(12) NOT NULL,
  PRIMARY KEY (`MCIdentifier`),
  KEY `PatientIdentifier` (`PatientIdentifier`),
  KEY `StageOfPregnancy` (`StageOfPregnancy`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8;

--
-- Dumping data for table `momconnect`
--

INSERT INTO `momconnect` (`MCIdentifier`, `StageOfPregnancy`, `PatientIdentifier`) VALUES
(2, NULL, 4);

--
-- Triggers `momconnect`
--
DROP TRIGGER IF EXISTS `MomConnectMessageTrigger`;
DELIMITER $$
CREATE TRIGGER `MomConnectMessageTrigger` AFTER INSERT ON `momconnect` FOR EACH ROW BEGIN Insert INTO message (`MessageIdentifier`, `MessageContent`, `StaffMessageRecipient`, `PatientMessageRecipient`) Values (NULL, AddedToMCMessage(NEW.PatientIdentifier),Null, NEW.PatientIdentifier); END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `patient`
--

DROP TABLE IF EXISTS `patient`;
CREATE TABLE IF NOT EXISTS `patient` (
  `PatientIdentifier` int(12) NOT NULL AUTO_INCREMENT,
  `RegisteredOn` date NOT NULL,
  `PhoneNumber` varchar(10) NOT NULL,
  `Address` varchar(60) NOT NULL,
  `PatientName` varchar(30) NOT NULL,
  `PatientSurname` varchar(30) NOT NULL,
  `EmailAddress` varchar(30) NOT NULL,
  `Gender` varchar(30) NOT NULL,
  `Age` int(3) NOT NULL,
  `Pregnant` tinyint(1) NOT NULL,
  `Diabetic` tinyint(1) NOT NULL,
  `HIVPositive` tinyint(1) NOT NULL,
  `IDNumber` varchar(13) NOT NULL,
  PRIMARY KEY (`PatientIdentifier`),
  UNIQUE KEY `PhoneNumber` (`PhoneNumber`),
  UNIQUE KEY `EmailAddress` (`EmailAddress`),
  UNIQUE KEY `IDNumber` (`IDNumber`)
) ENGINE=InnoDB AUTO_INCREMENT=23 DEFAULT CHARSET=utf8;

--
-- Dumping data for table `patient`
--

INSERT INTO `patient` (`PatientIdentifier`, `RegisteredOn`, `PhoneNumber`, `Address`, `PatientName`, `PatientSurname`, `EmailAddress`, `Gender`, `Age`, `Pregnant`, `Diabetic`, `HIVPositive`, `IDNumber`) VALUES
(1, '2017-01-14', '0123456799', '012 StrStreet NeighNeigh Prov', 'Bobby', 'Brown', 'BobBrown@bobmail.com', 'Male', 30, 0, 1, 0, '9004096789123'),
(2, '2017-02-14', '0114368889', '021 StreetStr NeighNeighNeigh Prv', 'Sally', 'Sand', 'SallyySS@sandmail.com', 'Female', 30, 1, 1, 1, '9009078912312'),
(3, '2017-03-14', '0198796782', '55 Stir Nei Pavilian', 'Charles', 'Chapman', 'chch@chap.com', 'Male', 50, 0, 1, 0, '7030596785153'),
(4, '2017-04-14', '0779765871', '59 Strigo ApmohNeigh Cape Town', 'Mandy', 'Muller', 'mandym@mully.com', 'Female', 25, 1, 1, 0, '9809075582199'),
(5, '2017-05-14', '9123946189', '17 Main Heathfield Cape Town', 'Bill', 'Bobbins', 'Billbob91@bobmail.com', 'Male', 40, 0, 1, 0, '8009053789122'),
(6, '2017-06-14', '8212885879', '89 Seinmor Close Salvator Cape Town', 'Sigmus', 'Seven', 'Siegma@sandmail.com', 'Male', 19, 0, 1, 1, '0109017912312'),
(7, '2017-07-14', '0123456689', '11 Greenfield Beverly Pretoria', 'Emma', 'Smith', 'Imco@omonomail.com', 'Female', 29, 1, 0, 0, '9103056789123'),
(8, '2017-08-14', '0214465879', '51 StreetStr NeighNeighNeigh Prv', 'Olivia', 'Johnson', 'OliviaJ@sandmail.com', 'Female', 30, 1, 0, 0, '9006078915552'),
(9, '2017-09-14', '0111451789', '9 StrStreet NeighNeigh Prov', 'Ava', 'Jones', 'avajo@yahoo.com', 'Female', 31, 1, 0, 1, '8934596789123'),
(10, '2017-10-01', '0214365879', '111 StreetStr NeighNeighNeigh Prv', 'Isabella', 'Davis', 'issabee@damail.com', 'Female', 35, 1, 0, 0, '8509078911112'),
(11, '2017-10-08', '0224368821', '91 StreetStr NeighNeighNeigh Prv', 'Mila', 'Moo', 'Mila@moomail.com', 'Female', 40, 1, 0, 0, '8004078215552'),
(12, '2017-10-14', '0103159989', '9 StrStreet NeighNeigh Prov', 'Ella', 'James', 'ella97@yahoo.com', 'Female', 31, 1, 0, 0, '8904099157123'),
(13, '2017-10-18', '0211135879', '191 StreetStr NeighNeighNeigh Prv', 'Sofia', 'Sunflower', 'sofie@gmail.com', 'Female', 35, 1, 0, 0, '8509078910012'),
(14, '2017-10-24', '0214315879', '22 StreetStr NeighNeighNeigh Proa', 'Camila', 'Jonas', 'Cammy@jonasmail.com', 'Female', 32, 1, 0, 0, '8801075585752'),
(15, '2017-10-28', '0123477789', '3 StrStreet NeighNeigh Prov', 'Hannah', 'Abley', 'abley@yahoo.com', 'Female', 31, 1, 0, 0, '8904044449123'),
(16, '2017-10-30', '0789315879', '1 StreetStr NeighNeighNeigh Prv', 'Valentina', 'Piken', 'valentina@gmail.com', 'Female', 35, 1, 0, 0, '8509078911192'),
(17, '2017-11-04', '0293100079', '1 Glacier Hill Parkway', 'Howie', 'Bunten', 'pwoolaghan3@sfgate.com', 'Male', 35, 0, 1, 1, '8510178919112'),
(18, '2017-11-14', '0718812872', '0 Truax Way', 'Andre', 'Casero', 'bhancorn1@sphinn.com', 'Male', 32, 0, 1, 1, '8801175585250'),
(19, '2017-11-18', '0121477771', '2 Derek Pass', 'Bunny', 'Tomisch', 'sgranthama@yelp.com', 'Male', 31, 0, 1, 1, '8911043349121'),
(20, '2017-11-19', '0729215229', '97176 Buena Vista Street', 'Andre', 'Tomisch', 'clamonte@nymag.com', 'Male', 35, 0, 1, 1, '8509218954191'),
(21, '2017-11-19', '0121411101', '0 Tennessee Hill', 'Etienne', 'Cow', 'moomoo@yelp.com', 'Male', 89, 0, 1, 1, '3111043341121'),
(22, '2017-12-28', '0779256069', '2925 Maryland Place', 'Irita', 'Glancey', 'fglancey8@instagram.com', 'Male', 80, 0, 1, 1, '4009218920191');

--
-- Triggers `patient`
--
DROP TRIGGER IF EXISTS `NewPregnantPatient`;
DELIMITER $$
CREATE TRIGGER `NewPregnantPatient` AFTER INSERT ON `patient` FOR EACH ROW BEGIN IF(NEW.Pregnant = 1) THEN Insert INTO momconnect (`MCIdentifier`,`StageOfPregnancy`, `PatientIdentifier`) Values (NULL, NULL, NEW.PatientIdentifier); END IF; END
$$
DELIMITER ;
DROP TRIGGER IF EXISTS `PatientNoLongerPregnant`;
DELIMITER $$
CREATE TRIGGER `PatientNoLongerPregnant` AFTER UPDATE ON `patient` FOR EACH ROW BEGIN IF(OLD.Pregnant = 1 AND NEW.Pregnant = 0) THEN Delete FROM `momconnect` WHERE `momconnect`.`PatientIdentifier` = NEW.`PatientIdentifier`; 
END IF; END
$$
DELIMITER ;
DROP TRIGGER IF EXISTS `PatientNowPregnant`;
DELIMITER $$
CREATE TRIGGER `PatientNowPregnant` AFTER UPDATE ON `patient` FOR EACH ROW BEGIN IF(OLD.Pregnant = 0 AND NEW.Pregnant = 1) THEN Insert INTO momconnect (`MCIdentifier`,`StageOfPregnancy`, `PatientIdentifier`) Values (NULL, NULL, NEW.PatientIdentifier); END IF; END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `patientdiagnosis`
--

DROP TABLE IF EXISTS `patientdiagnosis`;
CREATE TABLE IF NOT EXISTS `patientdiagnosis` (
  `DiagnosisIdentifier` int(12) NOT NULL AUTO_INCREMENT,
  `AppointmentIdentifier` int(12) NOT NULL,
  `DeterminedDiagnosis` varchar(60) NOT NULL,
  `DiagnosisDescription` varchar(300) DEFAULT NULL,
  PRIMARY KEY (`DiagnosisIdentifier`),
  KEY `AppointmentIdentifier` (`AppointmentIdentifier`)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8;

--
-- Dumping data for table `patientdiagnosis`
--

INSERT INTO `patientdiagnosis` (`DiagnosisIdentifier`, `AppointmentIdentifier`, `DeterminedDiagnosis`, `DiagnosisDescription`) VALUES
(1, 11, 'Diabetic', 'The patient was found to be a diabetic.'),
(2, 18, 'Pregnant', 'The patient was found to be a pregnant.'),
(3, 19, 'Pregnant & HIV Positive', 'The patient was found to be both pregnant and HIV+.'),
(4, 20, 'Pregnant', 'The patient was found to be a pregnant.'),
(5, 21, 'Pregnant', 'The patient was found to be a pregnant.'),
(6, 34, 'Pregnant & Diabetic', 'The patient was found to be both pregnant and diabetic.'),
(7, 35, 'Diabetic', 'The patient was found to be diabetic.'),
(8, 36, 'Diabetic & HIV Positive', 'The patient was found to be diabetic and tested HIV positive.'),
(9, 37, 'Pregnant', 'The patient was found to be pregnant.'),
(10, 38, 'Pregnant', 'The patient was found to be pregnant.');

-- --------------------------------------------------------

--
-- Table structure for table `patientprescription`
--

DROP TABLE IF EXISTS `patientprescription`;
CREATE TABLE IF NOT EXISTS `patientprescription` (
  `PrescriptionIdentifier` int(12) NOT NULL AUTO_INCREMENT,
  `TreatmentIdentifier` int(12) NOT NULL,
  `MedicineIdentifier` int(12) NOT NULL,
  `MedicineDosage` varchar(120) NOT NULL,
  PRIMARY KEY (`PrescriptionIdentifier`),
  KEY `TreatmentIdentifier` (`TreatmentIdentifier`),
  KEY `MedicineIdentifier` (`MedicineIdentifier`)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8;

--
-- Dumping data for table `patientprescription`
--

INSERT INTO `patientprescription` (`PrescriptionIdentifier`, `TreatmentIdentifier`, `MedicineIdentifier`, `MedicineDosage`) VALUES
(1, 1, 5, '10mL'),
(2, 2, 2, '50mg'),
(3, 3, 5, '10mL'),
(4, 4, 4, '10mL'),
(5, 5, 5, '10mL'),
(6, 6, 1, '300mg'),
(7, 7, 9, '30mL'),
(8, 8, 10, '30mg'),
(9, 9, 9, '30mL'),
(10, 10, 10, '30mg');

-- --------------------------------------------------------

--
-- Table structure for table `patienttreatment`
--

DROP TABLE IF EXISTS `patienttreatment`;
CREATE TABLE IF NOT EXISTS `patienttreatment` (
  `TreatmentIdentifier` int(12) NOT NULL AUTO_INCREMENT,
  `TreatmentDescription` varchar(300) DEFAULT NULL,
  `AppointmentIdentifier` int(12) NOT NULL,
  PRIMARY KEY (`TreatmentIdentifier`),
  KEY `AppointmentIdentifier` (`AppointmentIdentifier`)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8;

--
-- Dumping data for table `patienttreatment`
--

INSERT INTO `patienttreatment` (`TreatmentIdentifier`, `TreatmentDescription`, `AppointmentIdentifier`) VALUES
(1, 'The patient will receive insulin to help control their blood sugar levels.', 11),
(2, 'The patient will receive medication to help treat HIV/AIDS.', 19),
(3, 'The patient will receive insulin to help control their blood sugar levels.', 34),
(4, 'The patient will receive insulin to help control their blood sugar levels.', 35),
(5, 'The patient will receive insulin to help control their blood sugar levels.', 36),
(6, 'The patient will receive medication to help treat HIV/AIDS.', 36),
(7, 'The patient will receive medication to help with inflimation.', 24),
(8, 'The patient will receive medication to help with pain following their cesarian.', 24),
(9, 'The patient will receive medication to help with inflimation.', 25),
(10, 'The patient will receive medication to help with pain following their cesarian.', 25);

-- --------------------------------------------------------

--
-- Stand-in structure for view `pharmasistandhospitalclinicialprescriptions`
-- (See below for the actual view)
--
DROP VIEW IF EXISTS `pharmasistandhospitalclinicialprescriptions`;
CREATE TABLE IF NOT EXISTS `pharmasistandhospitalclinicialprescriptions` (
`MedicineDosage` varchar(120)
,`medicineName` varchar(60)
,`medicineDescription` varchar(300)
,`TreatmentDescription` varchar(300)
,`AppointmentIdentifier` int(12)
);

-- --------------------------------------------------------

--
-- Table structure for table `pregnancystages`
--

DROP TABLE IF EXISTS `pregnancystages`;
CREATE TABLE IF NOT EXISTS `pregnancystages` (
  `StageIdentifier` int(2) NOT NULL AUTO_INCREMENT,
  `StageName` varchar(60) NOT NULL,
  `StageDescription` varchar(300) DEFAULT NULL,
  PRIMARY KEY (`StageIdentifier`)
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=utf8;

--
-- Dumping data for table `pregnancystages`
--

INSERT INTO `pregnancystages` (`StageIdentifier`, `StageName`, `StageDescription`) VALUES
(1, 'Month_1', 'Start of 1st trimester, embryo is just 2 cells. '),
(2, 'Month_2', 'The heart of the baby is beating and its brain is formed.'),
(3, 'Month_3', 'Embryo becomes a fetus that is about the size of a plum.'),
(4, 'Month_4', 'Start of the 2nd trimester, the bones of the baby will start hardening and show up on x-rays.'),
(5, 'Month_5', 'The hearing of the baby should start developing and the baby should start kicking.'),
(6, 'Month_6', 'The baby will almost be fully formed at the end of this month. '),
(7, 'Month_7', 'The brain of the baby will develop to start processing sounds and sight.'),
(8, 'Month_8', 'The baby will further develop its lungs and otherwsie be fully formed. '),
(9, 'Month_9', 'The mother may experience discomfort in the form of pelvic pressure, contractions and difficulty sleeping');

-- --------------------------------------------------------

--
-- Stand-in structure for view `receptionistviewofappointments`
-- (See below for the actual view)
--
DROP VIEW IF EXISTS `receptionistviewofappointments`;
CREATE TABLE IF NOT EXISTS `receptionistviewofappointments` (
`AppointmentDate` date
,`AppointmentTime` time
,`PatientName` varchar(30)
,`PatientSurname` varchar(30)
,`StaffName` varchar(30)
,`StaffSurname` varchar(30)
,`AppointmentType` varchar(30)
,`Attendence` tinyint(1)
,`Location` varchar(60)
,`PatientIdentifier` int(12)
,`StaffIdentifier` int(12)
);

-- --------------------------------------------------------

--
-- Table structure for table `staff`
--

DROP TABLE IF EXISTS `staff`;
CREATE TABLE IF NOT EXISTS `staff` (
  `StaffIdentifier` int(12) NOT NULL AUTO_INCREMENT,
  `PhoneNumber` varchar(10) NOT NULL,
  `Address` varchar(60) NOT NULL,
  `StaffType` varchar(20) NOT NULL,
  `StaffName` varchar(30) NOT NULL,
  `StaffSurname` varchar(30) NOT NULL,
  `EmailAddress` varchar(30) NOT NULL,
  `Gender` varchar(30) NOT NULL,
  `Age` int(3) NOT NULL,
  `CurrentlyEmployed` tinyint(1) NOT NULL,
  `IDNumber` varchar(13) NOT NULL,
  PRIMARY KEY (`StaffIdentifier`),
  UNIQUE KEY `PhoneNumber` (`PhoneNumber`),
  UNIQUE KEY `EmailAddress` (`EmailAddress`),
  UNIQUE KEY `IDNumber` (`IDNumber`)
) ENGINE=InnoDB AUTO_INCREMENT=19 DEFAULT CHARSET=utf8;

--
-- Dumping data for table `staff`
--

INSERT INTO `staff` (`StaffIdentifier`, `PhoneNumber`, `Address`, `StaffType`, `StaffName`, `StaffSurname`, `EmailAddress`, `Gender`, `Age`, `CurrentlyEmployed`, `IDNumber`) VALUES
(1, '0976485213', '10 Bultman Plaza', 'CHW', 'Humfrey', 'Scolding', 'hscoll@sakura.net', 'Male', 52, 1, '6804073162581'),
(2, '0779485213', '85 Leroy Terrace', 'Receptionist', 'Paige', 'Hillan', 'paige@gmail.com', 'Female', 32, 1, '8804070062589'),
(3, '0976412313', '1747 5th Crossing', 'CHW', 'Chic', 'Lakes', 'lakes@gmail.com', 'Male', 50, 1, '7004073162589'),
(4, '0998545213', '92 Tomscot Drive', 'CHW', 'Leshia', 'Spawell', 'spawell@sakura.net', 'Female', 52, 1, '6804073162583'),
(5, '0976433313', '9 Bultman Plaza', 'CHW', 'Brendan', 'Mathers', 'brendan95@gmail.com', 'Male', 37, 1, '8080673162589'),
(6, '0978985213', '91 Morning Street', 'Lab Technician', 'Nickie', 'Muddle', 'nickie@sakura.net', 'Male', 41, 1, '7904073162589'),
(7, '0976405210', '18 Bultman Plaza', 'CHW', 'Lydon', 'Seger', 'lydon@yahoo.com', 'Male', 42, 1, '7804073162589'),
(8, '0786485213', '26122 Elgar Place', 'Hospital Clinician', 'Calla', 'McQuin', 'calla@gmail.com', 'Female', 52, 1, '6804033162589'),
(9, '0976485111', '02532 Cordelia Alley', 'Hospital Clinician', 'Byrle', 'Gawith', 'byrle@sakura.net', 'Male', 33, 1, '8704073162589'),
(10, '0978455213', '7 Bultman Plaza', 'Pharmacist', 'Kore', 'Banallack', 'koreba@gmail.com', 'Male', 37, 1, '8304073162589'),
(11, '0933385213', '7 Scofield Street', 'CHW', 'Loella', 'Seger', 'Loella@economist.net', 'Female', 28, 1, '9204073102589'),
(12, '0976485200', '897 Everett Center', 'CHW', 'Kevin', 'Rackley', 'rackley95@sakura.net', 'Male', 39, 1, '8104073162589'),
(13, '0976487513', '892 Carberry Parkway', 'CHW', 'Selina', 'Becks', 'selin@gmail.com', 'Female', 50, 1, '7001073162589'),
(14, '0976222213', '15 Leroy Terrace', 'CHW', 'Fredric', 'Barrowcliffe', 'fredric@gaku.net', 'Male', 29, 1, '9104073162589'),
(15, '0976485000', '763 Linden Street', 'CHW', 'Carlos', 'Tift', 'cartift@sakura.net', 'Male', 54, 1, '6604073162589'),
(16, '0176122113', '61 Del Mar Avenue', 'CHW', 'Fredric', 'Gunson', 'fredricgun@gaku.net', 'Male', 29, 0, '9104129111519'),
(17, '0916411200', '72435 Carioca Junction', 'CHW', 'Goldia', 'Tift', 'ggilbeyc@msu.edu', 'Female', 54, 0, '6604173162580'),
(18, '0928111293', '12 Morning Street', 'Lab Technician', 'Derick', 'Rose', 'rose@sakura.net', 'Male', 29, 1, '9104113162589');

-- --------------------------------------------------------

--
-- Structure for view `chwdetailedbloodsugarresults`
--
DROP TABLE IF EXISTS `chwdetailedbloodsugarresults`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `chwdetailedbloodsugarresults`  AS  select `chwtest`.`CHWTestIdentifier` AS `CHWTestIdentifier`,`appointment`.`StaffIdentifier` AS `StaffIdentifier`,`appointment`.`AppointmentIdentifier` AS `AppointmentIdentifier`,`appointment`.`PatientIdentifier` AS `PatientIdentifier`,`patient`.`PatientName` AS `PatientName`,`patient`.`PatientSurname` AS `PatientSurname`,`appointment`.`AppointmentDate` AS `AppointmentDate`,`appointment`.`AppointmentTime` AS `AppointmentTime`,`chwtest`.`BloodSugarLevelmmolPerL` AS `BloodSugarLevelmmolPerL` from ((`appointment` join `chwtest` on((`appointment`.`AppointmentIdentifier` = `chwtest`.`AppointmentIdentifier`))) join `patient` on((`appointment`.`PatientIdentifier` = `patient`.`PatientIdentifier`))) order by `appointment`.`AppointmentDate` desc ;

-- --------------------------------------------------------

--
-- Structure for view `chwdetaileddrugadministration`
--
DROP TABLE IF EXISTS `chwdetaileddrugadministration`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `chwdetaileddrugadministration`  AS  select `chwdrugadministration`.`AdministrationIdentifier` AS `AdministrationIdentifier`,`chwdetailedbloodsugarresults`.`CHWTestIdentifier` AS `CHWTestIdentifier`,`chwdetailedbloodsugarresults`.`StaffIdentifier` AS `StaffIdentifier`,`chwdetailedbloodsugarresults`.`AppointmentDate` AS `AppointmentDate`,`chwdetailedbloodsugarresults`.`AppointmentTime` AS `AppointmentTime`,`chwdetailedbloodsugarresults`.`PatientName` AS `PatientName`,`chwdetailedbloodsugarresults`.`PatientSurname` AS `PatientSurname`,`chwdetailedbloodsugarresults`.`BloodSugarLevelmmolPerL` AS `BloodSugarLevelmmolPerL`,`chwdrugadministration`.`DrugAdministered` AS `DrugAdministered`,`chwdrugadministration`.`DrugDosageINmg` AS `DrugDosageINmg` from (`chwdrugadministration` join `chwdetailedbloodsugarresults` on((`chwdetailedbloodsugarresults`.`CHWTestIdentifier` = `chwdrugadministration`.`CHWTestIdentifier`))) order by `chwdetailedbloodsugarresults`.`CHWTestIdentifier` desc ;

-- --------------------------------------------------------

--
-- Structure for view `chwdetailedpatientassignment`
--
DROP TABLE IF EXISTS `chwdetailedpatientassignment`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `chwdetailedpatientassignment`  AS  select `chwtopatientassignments`.`StaffIdentifier` AS `StaffIdentifier`,`patient`.`PatientIdentifier` AS `PatientIdentifier`,`patient`.`PatientName` AS `PatientName`,`patient`.`PatientSurname` AS `PatientSurname`,`patient`.`Address` AS `Address`,`patient`.`PhoneNumber` AS `PhoneNumber`,`patient`.`EmailAddress` AS `EmailAddress`,`patient`.`Age` AS `Age`,`patient`.`Gender` AS `Gender` from (`patient` join `chwtopatientassignments` on((`patient`.`PatientIdentifier` = `chwtopatientassignments`.`PatientIdentifier`))) order by `chwtopatientassignments`.`StaffIdentifier` ;

-- --------------------------------------------------------

--
-- Structure for view `chwstaffviewappointment`
--
DROP TABLE IF EXISTS `chwstaffviewappointment`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `chwstaffviewappointment`  AS  select `appointment`.`StaffIdentifier` AS `StaffIdentifier`,`patient`.`PatientIdentifier` AS `PatientIdentifier`,`appointment`.`AppointmentIdentifier` AS `AppointmentIdentifier`,`appointment`.`AppointmentDate` AS `AppointmentDate`,`appointment`.`AppointmentTime` AS `AppointmentTime`,`patient`.`PatientName` AS `PatientName`,`patient`.`PatientSurname` AS `PatientSurname`,`patient`.`Address` AS `Address`,`patient`.`PhoneNumber` AS `PhoneNumber`,`patient`.`EmailAddress` AS `EmailAddress`,`patient`.`Gender` AS `Gender`,`patient`.`Age` AS `Age` from (`appointment` join `patient` on((`appointment`.`PatientIdentifier` = `patient`.`PatientIdentifier`))) where (`appointment`.`AppointmentType` = 3) ;

-- --------------------------------------------------------

--
-- Structure for view `chwstaffviewhouseholdmembers`
--
DROP TABLE IF EXISTS `chwstaffviewhouseholdmembers`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `chwstaffviewhouseholdmembers`  AS  select `chwtopatientassignments`.`StaffIdentifier` AS `StaffIdentifier`,`patient`.`PatientIdentifier` AS `PatientIdentifier`,`patient`.`PatientName` AS `PatientName`,`patient`.`PatientSurname` AS `PatientSurname`,`patient`.`Address` AS `Address`,`patient`.`PhoneNumber` AS `patientPhoneNumber`,`patient`.`EmailAddress` AS `patientEmailAddress`,`householdmember`.`HMIdentifier` AS `HMIdentifier`,`householdmember`.`MemberName` AS `MemberName`,`householdmember`.`MemberSurname` AS `MemberSurname`,`householdmember`.`RelationshipWithPatient` AS `RelationshipWithPatient`,`householdmember`.`CellphoneNumber` AS `householdMemberPhoneNumber`,`householdmember`.`EmailAddress` AS `householdMemberEmailAddress`,`householdmember`.`ExistingMedicalConditions` AS `ExistingMedicalConditions` from ((`patient` join `householdmember` on((`patient`.`PatientIdentifier` = `householdmember`.`PatientIdentifier`))) join `chwtopatientassignments` on((`patient`.`PatientIdentifier` = `chwtopatientassignments`.`PatientIdentifier`))) order by `patient`.`PatientIdentifier` ;

-- --------------------------------------------------------

--
-- Structure for view `hospitalclinicialappointments`
--
DROP TABLE IF EXISTS `hospitalclinicialappointments`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `hospitalclinicialappointments`  AS  select `appointment`.`ScheduledBy` AS `ScheduledBy`,`appointment`.`Description` AS `Description`,`appointment`.`Attendence` AS `Attendence`,`appointment`.`ClinicalFindings` AS `ClinicalFindings`,`appointment`.`AppointmentDate` AS `AppointmentDate`,`appointment`.`AppointmentTime` AS `AppointmentTime`,`patient`.`PatientName` AS `PatientName`,`patient`.`PatientSurname` AS `PatientSurname`,`patient`.`Gender` AS `Gender`,`patient`.`Age` AS `Age`,`patient`.`Pregnant` AS `Pregnant`,`patient`.`Diabetic` AS `Diabetic`,`patient`.`HIVPositive` AS `HIVPositive`,`appointmenttype`.`AppointmentType` AS `AppointmentType`,`appointment`.`PatientIdentifier` AS `PatientIdentifier`,`appointment`.`StaffIdentifier` AS `StaffIdentifier` from ((`appointment` join `patient` on((`appointment`.`PatientIdentifier` = `patient`.`PatientIdentifier`))) join `appointmenttype` on((`appointment`.`AppointmentType` = `appointmenttype`.`TypeIdentifier`))) ;

-- --------------------------------------------------------

--
-- Structure for view `labtechnicianandhospitalclinicialdetaileddiagnostictest`
--
DROP TABLE IF EXISTS `labtechnicianandhospitalclinicialdetaileddiagnostictest`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `labtechnicianandhospitalclinicialdetaileddiagnostictest`  AS  select `diagnostictest`.`TestType` AS `TestType`,`diagnostictest`.`TestResult` AS `TestResult`,`staff`.`StaffName` AS `StaffName`,`staff`.`StaffSurname` AS `StaffSurname`,`patient`.`PatientName` AS `PatientName`,`patient`.`PatientSurname` AS `PatientSurname`,`appointment`.`AppointmentDate` AS `AppointmentDate`,`appointment`.`AppointmentTime` AS `AppointmentTime` from (((`diagnostictest` join `staff` on((`staff`.`StaffIdentifier` = `diagnostictest`.`StaffIdentifier`))) join `appointment` on((`appointment`.`AppointmentIdentifier` = `diagnostictest`.`AppointmentIdentifier`))) join `patient` on((`appointment`.`PatientIdentifier` = `patient`.`PatientIdentifier`))) ;

-- --------------------------------------------------------

--
-- Structure for view `pharmasistandhospitalclinicialprescriptions`
--
DROP TABLE IF EXISTS `pharmasistandhospitalclinicialprescriptions`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `pharmasistandhospitalclinicialprescriptions`  AS  select `patientprescription`.`MedicineDosage` AS `MedicineDosage`,`medicine`.`MedicineName` AS `medicineName`,`medicine`.`MedicineDescription` AS `medicineDescription`,`patienttreatment`.`TreatmentDescription` AS `TreatmentDescription`,`patienttreatment`.`AppointmentIdentifier` AS `AppointmentIdentifier` from ((`patientprescription` join `patienttreatment` on((`patientprescription`.`TreatmentIdentifier` = `patienttreatment`.`TreatmentIdentifier`))) join `medicine` on((`patientprescription`.`MedicineIdentifier` = `medicine`.`MedicineIdentifier`))) ;

-- --------------------------------------------------------

--
-- Structure for view `receptionistviewofappointments`
--
DROP TABLE IF EXISTS `receptionistviewofappointments`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `receptionistviewofappointments`  AS  select `appointment`.`AppointmentDate` AS `AppointmentDate`,`appointment`.`AppointmentTime` AS `AppointmentTime`,`patient`.`PatientName` AS `PatientName`,`patient`.`PatientSurname` AS `PatientSurname`,`staff`.`StaffName` AS `StaffName`,`staff`.`StaffSurname` AS `StaffSurname`,`appointmenttype`.`AppointmentType` AS `AppointmentType`,`appointment`.`Attendence` AS `Attendence`,`appointment`.`Location` AS `Location`,`appointment`.`PatientIdentifier` AS `PatientIdentifier`,`appointment`.`StaffIdentifier` AS `StaffIdentifier` from (((`appointment` join `patient` on((`appointment`.`PatientIdentifier` = `patient`.`PatientIdentifier`))) join `staff` on((`appointment`.`StaffIdentifier` = `staff`.`StaffIdentifier`))) join `appointmenttype` on((`appointment`.`AppointmentType` = `appointmenttype`.`TypeIdentifier`))) ;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `appointment`
--
ALTER TABLE `appointment`
  ADD CONSTRAINT `appointment_ibfk_1` FOREIGN KEY (`PatientIdentifier`) REFERENCES `patient` (`PatientIdentifier`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `appointment_ibfk_2` FOREIGN KEY (`StaffIdentifier`) REFERENCES `staff` (`StaffIdentifier`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `appointment_ibfk_3` FOREIGN KEY (`ScheduledBy`) REFERENCES `staff` (`StaffIdentifier`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `appointment_ibfk_4` FOREIGN KEY (`AppointmentType`) REFERENCES `appointmenttype` (`TypeIdentifier`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `chwdrugadministration`
--
ALTER TABLE `chwdrugadministration`
  ADD CONSTRAINT `chwdrugadministration_ibfk_1` FOREIGN KEY (`CHWTestIdentifier`) REFERENCES `chwtest` (`CHWTestIdentifier`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `chwstafflogindetails`
--
ALTER TABLE `chwstafflogindetails`
  ADD CONSTRAINT `chwstafflogindetails_ibfk_1` FOREIGN KEY (`StaffIdentifier`) REFERENCES `staff` (`StaffIdentifier`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `chwtest`
--
ALTER TABLE `chwtest`
  ADD CONSTRAINT `chwtest_ibfk_1` FOREIGN KEY (`AppointmentIdentifier`) REFERENCES `appointment` (`AppointmentIdentifier`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `chwtopatientassignments`
--
ALTER TABLE `chwtopatientassignments`
  ADD CONSTRAINT `chwtopatientassignments_ibfk_1` FOREIGN KEY (`StaffIdentifier`) REFERENCES `staff` (`StaffIdentifier`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `chwtopatientassignments_ibfk_2` FOREIGN KEY (`PatientIdentifier`) REFERENCES `patient` (`PatientIdentifier`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `diagnostictest`
--
ALTER TABLE `diagnostictest`
  ADD CONSTRAINT `diagnostictest_ibfk_1` FOREIGN KEY (`AppointmentIdentifier`) REFERENCES `appointment` (`AppointmentIdentifier`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `diagnostictest_ibfk_2` FOREIGN KEY (`StaffIdentifier`) REFERENCES `staff` (`StaffIdentifier`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `householdmember`
--
ALTER TABLE `householdmember`
  ADD CONSTRAINT `householdmember_ibfk_1` FOREIGN KEY (`PatientIdentifier`) REFERENCES `patient` (`PatientIdentifier`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `message`
--
ALTER TABLE `message`
  ADD CONSTRAINT `message_ibfk_1` FOREIGN KEY (`StaffMessageRecipient`) REFERENCES `staff` (`StaffIdentifier`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `message_ibfk_2` FOREIGN KEY (`PatientMessageRecipient`) REFERENCES `patient` (`PatientIdentifier`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `momconnect`
--
ALTER TABLE `momconnect`
  ADD CONSTRAINT `momconnect_ibfk_1` FOREIGN KEY (`PatientIdentifier`) REFERENCES `patient` (`PatientIdentifier`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `momconnect_ibfk_2` FOREIGN KEY (`StageOfPregnancy`) REFERENCES `pregnancystages` (`StageIdentifier`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `patientdiagnosis`
--
ALTER TABLE `patientdiagnosis`
  ADD CONSTRAINT `patientdiagnosis_ibfk_1` FOREIGN KEY (`AppointmentIdentifier`) REFERENCES `appointment` (`AppointmentIdentifier`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `patientprescription`
--
ALTER TABLE `patientprescription`
  ADD CONSTRAINT `patientprescription_ibfk_1` FOREIGN KEY (`TreatmentIdentifier`) REFERENCES `patienttreatment` (`TreatmentIdentifier`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `patientprescription_ibfk_2` FOREIGN KEY (`MedicineIdentifier`) REFERENCES `medicine` (`MedicineIdentifier`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `patienttreatment`
--
ALTER TABLE `patienttreatment`
  ADD CONSTRAINT `patienttreatment_ibfk_1` FOREIGN KEY (`AppointmentIdentifier`) REFERENCES `appointment` (`AppointmentIdentifier`) ON DELETE CASCADE ON UPDATE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
