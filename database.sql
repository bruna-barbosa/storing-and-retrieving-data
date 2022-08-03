-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema mydb
-- -----------------------------------------------------
-- -----------------------------------------------------
-- Schema doctor
-- -----------------------------------------------------

-- -----------------------------------------------------
-- Schema doctor
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `doctor` DEFAULT CHARACTER SET utf8 ;
USE `doctor` ;

-- -----------------------------------------------------
-- Table `doctor`.`clinic`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `doctor`.`clinic` (
  `clinic_id` INT NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(45) NOT NULL,
  `door` VARCHAR(5) NOT NULL,
  `street` VARCHAR(45) NOT NULL,
  `zipcode` VARCHAR(8) NOT NULL,
  `district` VARCHAR(15) NOT NULL,
  PRIMARY KEY (`clinic_id`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb3;


-- -----------------------------------------------------
-- Table `doctor`.`patient`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `doctor`.`patient` (
  `health_number` INT NOT NULL,
  `name` VARCHAR(45) NOT NULL,
  `sex` ENUM('F', 'M') NOT NULL COMMENT 'F-female, M-male',
  `cell_phone` INT NOT NULL,
  `home_phone` INT NULL DEFAULT NULL,
  `emergency_contact` INT NULL DEFAULT NULL,
  `birthdate` DATE NOT NULL,
  `ssn` VARCHAR(11) NOT NULL COMMENT 'social security number',
  `nif` INT NOT NULL,
  `door` VARCHAR(5) NOT NULL,
  `street` VARCHAR(45) NOT NULL,
  `zipcode` VARCHAR(8) NOT NULL,
  `district` VARCHAR(15) NOT NULL,
  PRIMARY KEY (`health_number`),
  UNIQUE INDEX `ssn_UNIQUE` (`ssn` ASC) VISIBLE)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb3;


-- -----------------------------------------------------
-- Table `doctor`.`rating`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `doctor`.`rating` (
  `rating_id` INT NOT NULL AUTO_INCREMENT,
  `rating_appointment` INT NULL DEFAULT NULL COMMENT 'Rates the appointment between 1 and 5',
  `rating_clinic` INT NULL DEFAULT NULL COMMENT 'Rates the clinic between 1 and 5',
  PRIMARY KEY (`rating_id`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb3;


-- -----------------------------------------------------
-- Table `doctor`.`appointment`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `doctor`.`appointment` (
  `appointment_id` INT NOT NULL AUTO_INCREMENT,
  `date` DATE NOT NULL,
  `start_time` TIME NOT NULL,
  `end_time` TIME NOT NULL,
  `status` ENUM('S', 'F') NOT NULL COMMENT 'S-scheduled, F-finished',
  `clinic_clinic_id` INT NOT NULL,
  `doctor_health_number` INT NOT NULL,
  `patient_health_number` INT NOT NULL,
  `rating_id` INT NOT NULL,
  PRIMARY KEY (`appointment_id`, `clinic_clinic_id`, `doctor_health_number`, `patient_health_number`, `rating_id`),
  INDEX `fk_appointment_clinic1_idx` (`clinic_clinic_id` ASC) VISIBLE,
  INDEX `fk_appointment_patient1_idx` (`patient_health_number` ASC) VISIBLE,
  INDEX `fk_appointment_rating1_idx` (`rating_id` ASC) VISIBLE,
  CONSTRAINT `fk_appointment_clinic1`
    FOREIGN KEY (`clinic_clinic_id`)
    REFERENCES `doctor`.`clinic` (`clinic_id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `fk_appointment_patient1`
    FOREIGN KEY (`patient_health_number`)
    REFERENCES `doctor`.`patient` (`health_number`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `fk_appointment_rating1`
    FOREIGN KEY (`rating_id`)
    REFERENCES `doctor`.`rating` (`rating_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb3;


-- -----------------------------------------------------
-- Table `doctor`.`doctor`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `doctor`.`doctor` (
  `health_number` INT NOT NULL,
  `doctor_number` INT NOT NULL,
  `name` VARCHAR(30) NOT NULL,
  `sex` ENUM('F', 'M') NOT NULL COMMENT ' F-female, M-male',
  PRIMARY KEY (`health_number`),
  UNIQUE INDEX `doctor_number_UNIQUE` (`doctor_number` ASC) VISIBLE)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb3;


-- -----------------------------------------------------
-- Table `doctor`.`clinic_has_doctor`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `doctor`.`clinic_has_doctor` (
  `clinic_clinic_id` INT NOT NULL,
  `doctor_health_number` INT NOT NULL,
  PRIMARY KEY (`clinic_clinic_id`, `doctor_health_number`),
  INDEX `fk_clinic_has_doctor_doctor1_idx` (`doctor_health_number` ASC) VISIBLE,
  INDEX `fk_clinic_has_doctor_clinic1_idx` (`clinic_clinic_id` ASC) VISIBLE,
  CONSTRAINT `fk_clinic_has_doctor_clinic1`
    FOREIGN KEY (`clinic_clinic_id`)
    REFERENCES `doctor`.`clinic` (`clinic_id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `fk_clinic_has_doctor_doctor1`
    FOREIGN KEY (`doctor_health_number`)
    REFERENCES `doctor`.`doctor` (`health_number`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb3;


-- -----------------------------------------------------
-- Table `doctor`.`invoice`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `doctor`.`invoice` (
  `invoice_id` INT NOT NULL AUTO_INCREMENT,
  `price` DECIMAL(4,2) NOT NULL,
  `date` DATETIME NOT NULL,
  `appointment_appointment_id` INT NOT NULL,
  `appointment_clinic_clinic_id` INT NOT NULL COMMENT 'Get\'s the address of the clinic',
  `appointment_doctor_health_number` INT NOT NULL COMMENT 'Get\'s the name and doctor\' number of the doctor',
  `appointment_patient_health_number` INT NOT NULL COMMENT 'Get\'s the name, the address and the nif of the pacient',
  PRIMARY KEY (`invoice_id`, `appointment_appointment_id`, `appointment_clinic_clinic_id`, `appointment_doctor_health_number`, `appointment_patient_health_number`),
  INDEX `fk_invoice_appointment1_idx` (`appointment_appointment_id` ASC, `appointment_clinic_clinic_id` ASC, `appointment_doctor_health_number` ASC, `appointment_patient_health_number` ASC) VISIBLE,
  CONSTRAINT `fk_invoice_appointment1`
    FOREIGN KEY (`appointment_appointment_id` , `appointment_clinic_clinic_id` , `appointment_doctor_health_number` , `appointment_patient_health_number`)
    REFERENCES `doctor`.`appointment` (`appointment_id` , `clinic_clinic_id` , `doctor_health_number` , `patient_health_number`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb3;


-- -----------------------------------------------------
-- Table `doctor`.`log`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `doctor`.`log` (
  `id_log` INT NOT NULL AUTO_INCREMENT,
  `user` VARCHAR(45) NOT NULL,
  `database_name` VARCHAR(30) NOT NULL COMMENT 'The name of the database that has been changed.',
  `event_type` VARCHAR(50) NOT NULL,
  `event_date` DATETIME NOT NULL,
  
  PRIMARY KEY (`id_log`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb3;


-- -----------------------------------------------------
-- Table `doctor`.`prescription`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `doctor`.`prescription` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `date` DATE NOT NULL,
  `medic_prescription` VARCHAR(300) NOT NULL COMMENT 'Contains the prescriptions and quantity that the doctor prescript',
  `appointment_appointment_id` INT NOT NULL,
  `appointment_clinic_clinic_id` INT NOT NULL COMMENT 'Get\'s the address of the clinic',
  `appointment_doctor_health_number` INT NOT NULL COMMENT 'Get\'s the name and doctor\' number of the doctor',
  `appointment_patient_health_number` INT NOT NULL COMMENT 'Get\'s the name, the address and the nif of the pacient',
  PRIMARY KEY (`id`, `appointment_appointment_id`, `appointment_clinic_clinic_id`, `appointment_doctor_health_number`, `appointment_patient_health_number`),
  INDEX `fk_prescription_appointment1_idx` (`appointment_appointment_id` ASC, `appointment_clinic_clinic_id` ASC, `appointment_doctor_health_number` ASC, `appointment_patient_health_number` ASC) VISIBLE,
  CONSTRAINT `fk_prescription_appointment1`
    FOREIGN KEY (`appointment_appointment_id` , `appointment_clinic_clinic_id` , `appointment_doctor_health_number` , `appointment_patient_health_number`)
    REFERENCES `doctor`.`appointment` (`appointment_id` , `clinic_clinic_id` , `doctor_health_number` , `patient_health_number`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb3;


-- -----------------------------------------------------
-- Table `doctor`.`speciality`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `doctor`.`speciality` (
  `slug` VARCHAR(5) NOT NULL,
  `name` VARCHAR(20) NOT NULL,
  `description` TEXT NULL DEFAULT NULL,
  PRIMARY KEY (`slug`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb3;


-- -----------------------------------------------------
-- Table `doctor`.`speciality_has_doctor`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `doctor`.`speciality_has_doctor` (
  `speciality_slug` VARCHAR(5) NOT NULL,
  `doctor_health_number` INT NOT NULL,
  PRIMARY KEY (`speciality_slug`, `doctor_health_number`),
  INDEX `doctor_health_number` (`doctor_health_number` ASC) VISIBLE,
  CONSTRAINT `speciality_has_doctor_ibfk_1`
    FOREIGN KEY (`speciality_slug`)
    REFERENCES `doctor`.`speciality` (`slug`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `speciality_has_doctor_ibfk_2`
    FOREIGN KEY (`doctor_health_number`)
    REFERENCES `doctor`.`doctor` (`health_number`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb3;






-- -----------------------------------------------------
-- SQL Injections for 'patient'
-- -----------------------------------------------------
INSERT INTO patient VALUES 
('53737214', 'Mónica Lara', 'F', '966579312', '212971375', '931676178', '1978-11-08', '62718904532', '271646767', '48', 'Rua dos Meus Amores', '2820-348', 'Setúbal'),
('52127531', 'Joana Barbosa', 'F', '926579312', '212871375', '966579313', '2003-05-05', '62750504532', '271646505', '10', 'Rua Elisa Pedroso', '2820-341', 'Setúbal'),
('40437214', 'Luís de Almeida', 'M', '916579312', '222971375', '934676178', '1998-03-14', '28918904532', '278234567', '12', 'Rua dos Bacalhoeiros', '1100-069', 'Lisboa'),
('20227531', 'José Bernardino', 'M', '945679312', '278971375', '924579313', '1942-09-08', '38480504532', '271646505', '1', 'Rua da Calçada', '3510-605', 'Viseu'),
('11237214', 'Luís Pedro', 'M', '966519302', '212971375', '928496178', '1978-11-08', '62718290532', '271626767', '48', 'Rua dos Meus Amores', '2820-348', 'Setúbal'),
('53327531', 'Marilda Figueiredo', 'F', '926579312', '212871375', '966579313', '2003-05-05', '62750504531', '271646505', '10', 'Rua Elisa Pedroso', '2820-341', 'Setúbal'),
('244372148', 'Zanni Xylon', 'M', '976579312', '222971375', '912676178', '1995-09-28', '62348904532', '261646767', '7', 'Travessa do Carmo', '4700-309', 'Braga'),
('51683572', 'Pedro Rúben', 'M', '973619312', '226282375', '931676178', '1984-05-28', '84768904532', '837646767', '51', 'Largo Carlos Amarante', '4700-308', 'Braga'),
('51688374', 'Lívia Batalha', 'F', '923619312', '226271375', '931674249', '1999-08-31', '84768901232', '837648967', '72', 'Avenida 1º de Maio', '6215-517', 'Castelo Branco'),
('51688355', 'Sérgio Duarte', 'M', '918419312', '233271375', '931693849', '1982-08-05', '23168901232', '893948967', '3', 'Largo 1º de Dezembro', '4049-019', 'Porto'),
('53548355', 'Sofia Fraga', 'F', '934419312', '220271375', '921093849', '1982-08-05', '23168901234', '893948969', '3', 'Largo 1º de Dezembro', '4049-019', 'Porto'),
('51699355', 'Fernando Pereira', 'M', '918419312', '233271375', '931693849', '1942-09-10', '23168901238', '893948967', '24', 'Rua Ribatejo', '2765-273', 'Lisboa'),
('58948355', 'Carolina Sá', 'F', '934419312', '220271375', '921093849', '1999-08-05', '23168901230', '893948969', '7', '1º Beco da Rua de São Sebastião', '3060-038', 'Coimbra'),
('51873355', 'Gonçalo Lopes', 'M', '92679312', '266671375', '931345849', '1999-09-10', '23168345232', '893948234', '24', '1ª Travessa da Rua dos Condados', '3080-220', 'Coimbra'),
('51699315', 'Rosa Maria', 'F', '919919312', '233271375', '931693849', '1942-09-10', '23486801232', '893948967', '24', 'Rua Ribatejo', '2765-273', 'Lisboa');


-- -----------------------------------------------------
-- SQL Injections for 'speciality'
-- -----------------------------------------------------

INSERT INTO speciality VALUES
('CARD', 'Cardiologia', 'Diagnóstico e tratamento das doenças que acometem o coração bem como os outros componentes do sistema circulatório'),
('DERM', 'Dermatologia', 'Diagnóstico e tratamento clínico-cirúrgico das enfermidades relacionados à pele e aos anexos cutâneos'),
('GINE', 'Ginecologia', 'A ginecologia é a prática da medicina que lida diretamente com a saúde do aparelho reprodutor feminino.'),
('OFTA', 'Oftalmologia', 'Especialidade da medicina que estuda e trata as doenças relacionadas ao olho, à refração e aos olhos e seus anexos'),
('NEURO', 'Neurologia', 'Especialidade médica que trata dos distúrbios estruturais do sistema nervoso'),
('ORTO', 'Ortopedia', 'Especialidade médica que cuida da saúde relacionadas aos elementos do aparelho locomotor, como ossos, músculos, ligamentos e articulações'),
('PEDI', 'Pediatria', 'Especialidade médica dedicada à assistência à criança e ao adolescente, nos seus diversos aspectos, sejam eles preventivos ou curativos'),
('PSQ', 'Psiquiatria', 'Responsável pelo diagnóstico e tratamento dos chamados Transtornos Mentais e de Comportamento');

-- -----------------------------------------------------
-- SQL Injections for 'doctor'
-- -----------------------------------------------------

INSERT INTO doctor VALUES 
('53737531', '20232 ', 'Maria Silva Borges', 'F'),
('65954546', '33251 ', 'Rui Magalhães Pereira', 'M'),
('17102907', '28350 ','José Domingos de Sousa', 'M'),
('32073538', '37314 ', 'Carla Ribeiro dos Santos', 'F'),
('28456355', '60426 ', 'Mariana Garcia Rodrigues', 'F'),
('86998125', '11909 ', 'António João Damásio', 'M'),
('31388273', '12972 ', 'Álvaro Gomes Pacheco', 'M'),
('61325549', '70177 ', 'Cláudia Dinis Antunes', 'F'),
('08733214', '20374 ', 'Maria Coutinho Silva', 'F'),
('78510892 ','41001 ',  'João Borges Costa', 'M'),
('06050966', '17798 ', 'Luís Ferraz Silva', 'M'),
('76516274', '59436 ', 'Susana Martins Fernandes', 'F'),
('71932437', '67672 ', 'André Filipe Marques', 'M'),
('38002244', '22977 ', 'António Carlos Domingos', 'M');

-- -----------------------------------------------------
-- SQL Injections for 'specialty_has_doctor'
-- -----------------------------------------------------

INSERT INTO speciality_has_doctor VALUES 
('DERM', '53737531'), 
('ORTO', '65954546'),
('PSQ', '17102907'),
('OFTA', '32073538'),
('GINE', '28456355'),
('NEURO', '86998125'),
('PEDI', '31388273'), 
('OFTA', '61325549'),
('PSQ', '08733214'),
('ORTO', '78510892'),
('NEURO', '06050966'),
('DERM', '76516274'),
('DERM', '71932437'),
('PEDI', '38002244');

-- -----------------------------------------------------
-- SQL Injections for 'clinic'
-- -----------------------------------------------------

INSERT INTO clinic ( `name`, `door`,  `street`, `zipcode`, `district`) VALUES 
/*1*/('Clinica António Lobo Antunes','74','Rua Capitão Leitão','2800-136','Almada'),  
/*2*/('Clinica José Saramago','6','Rua Monsenhor Henrique Ferreira da Silva','8005-329','Faro'),
/*3*/('Clinica Luís de Camões','9','Avenida S. João de Deus','8500-508','Portimão'), 
/*4*/('Clinica Fernando Pessoa','4','Rua Manuel António de Brito','7800-544','Beja'), 
/*5*/('Clinica Antero de Quental','144','R. das Carmelitas','4050-161','Porto'), 
/*6*/('Clinica Almeida Garrett','3 B','Rua do Colégio','3640-233','Sernancelhe'), 
/*7*/('Clinica Eça de Queiroz','183','Av. dos Bombeiros Voluntários','5370-206','Mirandela'), 
/*8*/('Clinica Florbela Espanca','111','Praça Marechal Humberto Delgado','1549-004','Lisboa');

-- -----------------------------------------------------
-- SQL Injections for 'clinic_has_doctor'
-- -----------------------------------------------------

INSERT INTO clinic_has_doctor VALUES
/*DERM*/
(1,'53737531'),
(1,'76516274'),
(1,'71932437'),
/*NEURO*/
(2,'86998125'),
(2,'06050966'),
/*OFTA*/
(3,'61325549'),
(3,'32073538'), 
/*PSQ*/
(4,'17102907'),
(4,'08733214'),
/*CARD*/
/*ORTO*/
(6,'78510892'), 
(6,'65954546'), 
/*PEDI*/
(7,'31388273'),
(7,'38002244'),
/*GINE*/
(8,'28456355');


-- -----------------------------------------------------
-- SQL Injections for 'rating'
-- -----------------------------------------------------
INSERT INTO rating (`rating_appointment`, `rating_clinic`) VALUES 
('1', '2'),
('5', '4'),
('2', '3'),
('3', '3'),
('2', '3'),
('4', '7'),
('5', '4'),
('5', '4'),
('5', '8'),
('3', '2'),
('2', '1'),
('5', '4'),
('1', '2'),
('2', '1'),
('4', '4'),
('3', '4'),
('2', '4'),
('3', '4'),
('5', '4'),
('4', '3'),
('5', '8'),
('4', '4'),
('2', '3'),
('3', '2'),
('4', '4'),
('2', '3'),
('3', '1'),
('4', '6'),
('3', '4'),
('5', '2'),
('4', '4');


-- -----------------------------------------------------
-- SQL Injections for 'appointment'
-- -----------------------------------------------------
INSERT INTO `doctor`.`appointment` ( date, start_time, end_time, clinic_clinic_id, doctor_health_number, patient_health_number, rating_id) VALUES
/*1*/('2021-05-23', '18:14', '19:10', 1, '53737531', '53737214',1),
/*2*/( '2020-06-09', '15:19', '19:05', 1, '53737531', '51699315',2), 
/*3*/( '2020-02-25', '17:28', '17:35', 1 , '53737531', '51873355',3), 
  
/*4*/( '2020-05-22', '8:34', '8:38', 6, '65954546', '52127531',4),
/*5*/('2021-04-05', '18:09', '11:23', 6, '65954546', '53737214',5),
/*6*/( '2020-11-23', '15:04', '15:45', 6, '65954546', '51699315',6),
 
/*7*/( '2020-12-24', '13:57', '12:28', 4, '17102907', '40437214',7),
/*8*/('2020-07-26', '14:37', '13:14', 4, '17102907', '52127531',8),
 
/*9*/( '2021-03-14', '14:15', '13:28', 3, '32073538','20227531',9),
/*10*/( '2020-05-20', '18:22', '21:54', 3, '32073538', '40437214',10),

/*11*/('2020-12-22', '14:14', '13:20', 8, '28456355', '11237214',11),
/*12*/( '2021-02-19', '15:16', '10:02', 8, '28456355', '20227531',12),
 
/*13*/( '2020-08-20', '15:50', '8:38', 2, '86998125', '53327531',13),
/*14*/('2020-06-17', '16:38', '10:21', 2, '86998125', '11237214',14),
 
/*15*/( '2020-03-08', '16:09', '20:01', 7, '31388273', '244372148',15),
/*16*/( '2021-06-01', '13:03', '8:51', 7, '31388273', '53327531',16),
 
/*17*/( '2020-05-31', '17:18', '12:42', 3, '61325549', '51683572',17),
/*18*/( '2020-09-09', '16:00', '19:04', 3, '61325549', '244372148',18),
 
/*19*/( '2020-09-30', '11:00', '13:59', 4, '08733214', '51688374',19),
/*20*/('2020-09-26', '16:32', '11:45', 4, '08733214', '51683572',20),
  
/*21*/( '2020-08-22', '19:02', '15:08', 6, '78510892', '51688355',21),
/*22*/( '2020-06-05', '16:19', '19:36', 6, '78510892', '51688374',22),
 
/*23*/( '2020-10-11', '11:02', '9:43', 2, '06050966', '53548355',23),
/*24*/( '2019-12-26', '9:08', '17:24', 2, '06050966', '51688355',24),
 
/*25*/( '2020-10-16', '8:46', '18:42', 1, '76516274','51699355',25),
/*26*/( '2020-09-22', '17:48', '13:17', 1, '76516274', '53548355',26),
  
/*27*/( '2020-01-18', '16:40', '18:34', 1, '71932437', '58948355',27),
/*28*/( '2019-12-10', '10:29', '12:14', 1, '71932437', '51699355',28),
  
/*29*/( '2020-02-24', '21:46', '19:19', 7, '38002244', '51873355',29),
/*30*/( '2020-07-24', '8:23', '8:34', 7, '38002244', '58948355',30);

-- -----------------------------------------------------
-- SQL Injections for 'appointment' in the future
-- -----------------------------------------------------
/*
INSERT INTO `doctor`.`appointment` ( date, start_time, end_time, clinic_clinic_id, doctor_health_number, patient_health_number, rating_id) VALUES
 ('2022-02-15', '11:30', '12:30', 1, '71932437', '40437214', ''),
 ('2022-01-24', '12:00', '13:15', 7, '38002244', '51699355', ''),
 ('2022-04-12', '9:45', '10:30', 7, '38002244', '51699355', '');
 */
 -- -----------------------------------------------------
-- SQL Injections for 'prescription'
-- -----------------------------------------------------

INSERT INTO `doctor`.`prescription` ( date, medic_prescription, appointment_appointment_id, appointment_clinic_clinic_id, appointment_doctor_health_number, appointment_patient_health_number) VALUES 
/*1*/( '2021-05-23', 'Alcohol', 1, 1, '53737531', '53737214'),
/*2*/( '2020-06-09', 'Kalium aceticum comp. 6', 2,  1, '53737531', '51699315'),
/*3*/( '2020-02-25', 'cetirizine Hydrochloride', 3, 1 , '53737531', '51873355'),

/*4*/( '2020-05-22', 'NAPROXEN SODIUM', 4, 6, '65954546', '52127531'),
/*5*/( '2021-04-05', 'Menthol', 5,  6, '65954546', '53737214'),
/*6*/( '2020-11-23', 'Berberis Populus', 6, 6, '65954546', '51699315'),

/*7*/( '2020-12-24', 'Ranitidine', 7, 4, '17102907', '40437214'),
/*8*/( '2020-07-26', 'Latanoprost', 8, 4, '17102907', '52127531'),

/*9*/( '2021-03-14', 'Omega-3 Fatty Acids, Doconexent, Icosapent, Linolenic Acid, Calcium Ascorbate, Calcium Threonate, Cholecalciferol, .Alpha.-Tocopherol Acetate, DL-, Riboflavin, Niacinamide, Pyridoxine Hydrochloride, F',9,  3, '32073538','20227531'),
/*10*/( '2020-05-20', 'AMITRIPTYLINE HYDROCHLORIDE', 10,  3, '32073538', '40437214'),

/*11*/( '2020-12-22', 'Clonidine Hydrochloride', 11, 8, '28456355', '11237214'),
/*12*/( '2021-02-19', 'Oxcarbazepine', 12, 8, '28456355', '20227531'),

/*13*/( '2020-08-20', 'cysteamine bitartrate', 13, 2, '86998125', '53327531'),
/*14*/( '2020-06-17', 'ROPIVACAINE HYDROCHLORIDE', 14, 2, '86998125', '11237214'),

/*15*/( '2020-03-08', 'OCTINOXATE, OXYBENZONE', 15, 7, '31388273', '244372148'),
/*16*/( '2021-06-01', 'Dextromethorphan HBr',16, 7, '31388273', '53327531'),

/*17*/( '2020-05-31', 'Ritonavir', 17, 3, '61325549', '51683572'),
/*18*/( '2020-09-09', 'BUPIVACAINE HYDROCHLORIDE', 18, 3, '61325549', '244372148'),

/*19*/( '2020-09-30', 'Alcohol swabstick', 19, 4, '08733214', '51688374'),
/*20*/( '2020-09-26', 'Etomidate', 20, 4, '08733214', '51683572'),

/*21*/( '2020-08-22', 'Oxygen', 21, 6, '78510892', '51688355'),
/*22*/( '2020-06-05', 'Tramadol Hydrochloride and Acetaminophen', 22, 6, '78510892', '51688374'),

/*23*/( '2020-10-11', 'MENTHOL', 23, 2, '06050966', '53548355'),
/*24*/( '2019-12-26', 'Brompheniramine Maleate, Dextromethorphan Hydrobromide and Phenylephrine Hydrochloride', 24, 2, '06050966', '51688355'),

/*25*/(  '2020-10-16', 'Acebutolol Hydrochloride', 25, 1, '76516274','51699355'),
/*26*/( '2020-09-22', 'Alcohol', 26, 1, '76516274', '53548355'),

/*27*/( '2020-01-18', 'mechlorethamine hydrochloride', 27, 1, '71932437', '58948355'),
/*28*/( '2019-12-10', 'Chrysolith Retina', 28, 1, '71932437', '51699355'),

/*29*/( '2020-02-24', 'DIMETHICONE', 29, 7, '38002244', '51873355'),
/*30*/( '2020-07-24', 'Acetaminophen, Dextromethorphan HBr, Doxylamine succinate, Phenylephrine HCl', 30,7, '38002244', '58948355');


-- -----------------------------------------------------
-- SQL Injections for 'invoice'
-- -----------------------------------------------------
INSERT INTO `doctor`.`invoice` (appointment_appointment_id, price, date, appointment_clinic_clinic_id, appointment_doctor_health_number, appointment_patient_health_number) VALUES 
/*1*/(1,60,'2021-05-23', 1, '53737531', '53737214'),
/*2*/(2,65, '2020-06-09', 1, '53737531', '51699315'), 
/*3*/(3,30, '2020-02-25', 1 , '53737531', '51873355'), 
  
/*4*/( 4,70,'2020-05-22', 6, '65954546', '52127531'),
/*5*/(5,60,'2021-04-05', 6, '65954546', '53737214'),
/*6*/( 6,60,'2020-11-23', 6, '65954546', '51699315'),
 
/*7*/(7,50, '2020-12-24', 4, '17102907', '40437214'),
/*8*/(8,65,'2020-07-26',  4, '17102907', '52127531'),
 
/*9*/( 9,70,'2021-03-14', 3, '32073538','20227531'),
/*10*/( 10,60,'2020-05-20', 3, '32073538', '40437214'),

/*11*/(11,55,'2020-12-22', 8, '28456355', '11237214'),
/*12*/( 12,60,'2021-02-19', 8, '28456355', '20227531'),
 
/*13*/(13,60, '2020-08-20', 2, '86998125', '53327531'),
/*14*/(14,70,'2020-06-17', 2, '86998125', '11237214'),
 
/*15*/(15,60, '2020-03-08', 7, '31388273', '244372148'),
/*16*/( 16,70,'2021-06-01', 7, '31388273', '53327531'),
 
/*17*/(17,50, '2020-05-31', 3, '61325549', '51683572'),
/*18*/( 18,70,'2020-09-09', 3, '61325549', '244372148'),
 
/*19*/( 19,65,'2020-09-30', 4, '08733214', '51688374'),
/*20*/(20,60,'2020-09-26', 4, '08733214', '51683572'),
  
/*21*/( 21,70,'2020-08-22', 6, '78510892', '51688355'),
/*22*/(22,70, '2020-06-05', 6, '78510892', '51688374'),
 
/*23*/(23,80, '2020-10-11', 2, '06050966', '53548355'),
/*24*/( 24,50,'2019-12-26', 2, '06050966', '51688355'),
 
/*25*/( 25,50,'2020-10-16', 1, '76516274','51699355'),
/*26*/( 26,80,'2020-09-22', 1, '76516274', '53548355'),
  
/*27*/( 27,50,'2020-01-18', 1, '71932437', '58948355'),
/*28*/( 28,70,'2019-12-10', 1, '71932437', '51699355'),
  
/*29*/( 29,50,'2020-02-24', 7, '38002244', '51873355'),
/*30*/( 30,80,'2020-07-24', 7, '38002244', '58948355');








-- -----------------------------------------------------
-- VIEW Invoice Details
-- -----------------------------------------------------
CREATE VIEW INVOICE_DETAILS AS
SELECT D.NAME, D.DOCTOR_NUMBER, S.SPECIALITY_SLUG, P.medic_prescription
FROM INVOICE AS I
JOIN APPOINTMENT AS A
ON A.APPOINTMENT_ID = I.APPOINTMENT_APPOINTMENT_ID
JOIN DOCTOR AS D
ON D.health_number = A.doctor_health_number
JOIN SPECIALITY_HAS_DOCTOR AS S
ON S.doctor_health_number = D.health_number
JOIN PRESCRIPTION AS P
ON P.APPOINTMENT_APPOINTMENT_ID = A.APPOINTMENT_ID;

-- -----------------------------------------------------
-- VIEW Invoice Head
-- -----------------------------------------------------
CREATE VIEW INVOICE_HEAD AS
SELECT I.INVOICE_ID, I.DATE, I.PRICE,
		  C.NAME AS CLIENT_NAME, C.STREET AS CLINIC_STREET, C.DOOR AS CLINIC_DOOR, C.ZIPCODE AS CLINIC_ZIPCODE, C.DISTRICT AS CLINIC_DISTRIC,
          P.NAME AS PATIENT_NAME, P.STREET AS PATIENT_STREET, P.DOOR AS PATIENT_DOOR, P.ZIPCODE AS PATIENT_ZIPCODE, P.DISTRICT AS PATIENT_DISTRICT
FROM INVOICE AS I
JOIN CLINIC AS C 
ON C.CLINIC_ID = I.APPOINTMENT_CLINIC_CLINIC_ID
JOIN APPOINTMENT AS A
ON A.APPOINTMENT_ID = I.APPOINTMENT_APPOINTMENT_ID
JOIN PATIENT AS P
ON P.HEALTH_NUMBER = A.PATIENT_HEALTH_NUMBER;







-- -----------------------------------------------------
-- Trigger Insert log
-- -----------------------------------------------------
DELIMITER $$
CREATE TRIGGER APPOINTMENT_LOG_INSERT
AFTER INSERT
ON appointment
FOR EACH ROW
	BEGIN
		INSERT INTO log (user, database_name, event_type, event_date) VALUE
		(USER(), 'Appointment', 'Insert', NOW());
	END$$
DELIMITER ;

-- -----------------------------------------------------
-- Trigger Update log
-- -----------------------------------------------------
DELIMITER $$
CREATE TRIGGER APPOINTMENT_LOG_UPDATE
AFTER UPDATE
ON appointment
FOR EACH ROW
	BEGIN
		INSERT INTO log (user, database_name, event_type, event_date) VALUE
		(USER(), 'Appointment', 'Update', NOW());
	END$$
DELIMITER ;


-- -----------------------------------------------------
-- Trigger Delete log
-- -----------------------------------------------------
DELIMITER $$
CREATE TRIGGER APPOINTMENT_LOG_DELETE
AFTER DELETE
ON appointment
FOR EACH ROW
	BEGIN
		INSERT INTO log (user, database_name, event_type, event_date) VALUE
		(USER(), 'Appointment', 'Delete', NOW());
	END$$
DELIMITER ;

-- -----------------------------------------------------
-- Trigger Update for invoice
-- -----------------------------------------------------
/* This trigger was created in order to fulfill the Point C, a trigger update.
This trigger change the status of an appointment to "Finished" whenever a invoice
related to that specific appointment is created. */
DELIMITER $$
CREATE TRIGGER CHANGE_APPOINTMENT_STATUS
AFTER INSERT 
ON invoice
FOR EACH ROW
	BEGIN
		UPDATE appointment
		JOIN invoice AS I
		SET status = 'F'
		WHERE appointment_id = i.appointment_appointment_id;
	END$$
DELIMITER ;





-- -----------------------------------------------------
-- Example of triggers in the log table
-- -----------------------------------------------------
/*This example shows the triggers of the log tables working when an insert, update and delete are done*/
INSERT INTO `doctor`.`appointment` ( date, start_time, end_time, clinic_clinic_id, doctor_health_number, patient_health_number, rating_id) VALUES
/*31*/('2022-05-20', '18:14', '19:10', 1, '53737531', '53737214',31);
UPDATE appointment SET date='2022-12-14' WHERE appointment_id=31;
DELETE FROM appointment WHERE appointment_id=31;
SELECT * FROM log;


-- -----------------------------------------------------
-- Example of triggers when an invoice is created
-- -----------------------------------------------------
/*As is possible to see when an appointment is created the status of this appointment start as an 'S' - Schedual
and after inserting the invoice of this appointment this changes to 'F' -Finished*/
INSERT INTO `doctor`.`appointment` ( date, start_time, end_time, clinic_clinic_id, doctor_health_number, patient_health_number, rating_id) VALUES
/*32*/('2022-05-20', '18:14', '19:10', 1, '53737531', '53737214',32);
INSERT INTO `doctor`.`invoice` (appointment_appointment_id, price, date, appointment_clinic_clinic_id, appointment_doctor_health_number, appointment_patient_health_number) VALUES 
/*32*/(32,60,'2021-05-23', 1, '53737531', '53737214');
SELECT status FROM appointment WHERE appointment_id=32;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
SET SQL_SAFE_UPDATES = 0;
