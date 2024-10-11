CREATE TABLE `mms_marketlicense` (
	`id` INT(11) NOT NULL AUTO_INCREMENT,
	`identifier` VARCHAR(50) NOT NULL COLLATE 'armscii8_general_ci',
	`charidentifier` VARCHAR(50) NOT NULL COLLATE 'armscii8_general_ci',
	`firstname` VARCHAR(50) NOT NULL COLLATE 'armscii8_general_ci',
	`lastname` VARCHAR(50) NOT NULL COLLATE 'armscii8_general_ci',
	`lincense` INT(11) NOT NULL,
	`listings` INT(11) NULL DEFAULT NULL,
	`marketmoney` FLOAT NULL DEFAULT NULL,
	PRIMARY KEY (`id`) USING BTREE
)
COLLATE='armscii8_general_ci'
ENGINE=InnoDB
AUTO_INCREMENT=3
;


CREATE TABLE `mms_market` (
	`id` INT(11) NOT NULL AUTO_INCREMENT,
	`identifier` VARCHAR(50) NOT NULL DEFAULT '0' COLLATE 'armscii8_general_ci',
	`charidentifier` VARCHAR(50) NOT NULL DEFAULT '0' COLLATE 'armscii8_general_ci',
	`firstname` VARCHAR(50) NOT NULL DEFAULT '0' COLLATE 'armscii8_general_ci',
	`lastname` VARCHAR(50) NOT NULL DEFAULT '0' COLLATE 'armscii8_general_ci',
	`itemname` VARCHAR(50) NOT NULL DEFAULT '0' COLLATE 'armscii8_general_ci',
	`itemlabel` VARCHAR(50) NOT NULL DEFAULT '0' COLLATE 'armscii8_general_ci',
	`amount` INT(11) NOT NULL DEFAULT '0',
	`price` FLOAT NOT NULL DEFAULT '0',
	PRIMARY KEY (`id`) USING BTREE
)
COLLATE='armscii8_general_ci'
ENGINE=InnoDB
AUTO_INCREMENT=22
;
