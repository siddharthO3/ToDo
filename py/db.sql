CREATE SCHEMA IF NOT EXISTS `todo` DEFAULT CHARACTER SET utf8 ;

CREATE TABLE IF NOT EXISTS `person`(
  `person_id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(45) DEFAULT NULL,
  `password` varchar(45) NOT NULL,
  PRIMARY KEY (`person_id`),
  UNIQUE KEY `name_UNIQUE` (`name`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS `tasks`(
  `task_id` int NOT NULL AUTO_INCREMENT,
  `person_id` int NOT NULL,
  `task` text,
  PRIMARY KEY (`task_id`),
  KEY `fk_Tasks_Person_idx` (`person_id`),
  CONSTRAINT `fk_Tasks_Person` FOREIGN KEY (`person_id`) REFERENCES `person` (`person_id`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8mb4;