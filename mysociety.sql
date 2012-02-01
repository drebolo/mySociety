-- DROP TABLE IF EXISTS

DROP TABLE IF EXISTS `parties_for_constituencies`;
DROP TABLE IF EXISTS `votes`;
DROP TABLE IF EXISTS `parties`;
DROP TABLE IF EXISTS `constituencies`;



-- Table 'parties'

CREATE TABLE `parties` (
  `id` INTEGER(20) UNSIGNED NOT NULL AUTO_INCREMENT,
  `party_name` VARCHAR(64) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

-- Table 'constituencies'

CREATE TABLE `constituencies` (
  `id` INTEGER(20) UNSIGNED NOT NULL AUTO_INCREMENT,
  `constituency_name` VARCHAR(64) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

-- Table 'parties_for_constituencies'

CREATE TABLE `parties_for_constituencies` (
  `party_id` INTEGER(20) UNSIGNED NULL,
  `constituency_id` INTEGER(20) UNSIGNED NOT NULL,
  PRIMARY KEY (`party_id`,`constituency_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;


-- Table 'votes'

CREATE TABLE `votes` (
  `id` INTEGER(20) UNSIGNED NOT NULL AUTO_INCREMENT,
  `constituency_id` INTEGER(20) UNSIGNED NOT NULL,
  `user_is_voting` INTEGER(1) UNSIGNED NOT NULL,
  `party_id` INTEGER(20) UNSIGNED NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;


-- Foreign Keys 

ALTER TABLE `parties_for_constituencies` ADD FOREIGN KEY (constituency_id) REFERENCES `constituencies` (`id`);
ALTER TABLE `parties_for_constituencies` ADD FOREIGN KEY (party_id) REFERENCES `parties` (`id`);
ALTER TABLE `votes` ADD FOREIGN KEY (constituency_id) REFERENCES `constituencies` (`id`);
ALTER TABLE `votes` ADD FOREIGN KEY (party_id) REFERENCES `parties` (`id`);

-- data

INSERT INTO `parties` (`party_name`) VALUES ('Conservative');
INSERT INTO `parties` (`party_name`) VALUES ('Labour');
INSERT INTO `parties` (`party_name`) VALUES ('Liberal Democrat');
INSERT INTO `parties` (`party_name`) VALUES ('Green');
INSERT INTO `parties` (`party_name`) VALUES ('Speaker');
INSERT INTO `parties` (`party_name`) VALUES ('United Kingdom Independence Party');
INSERT INTO `parties` (`party_name`) VALUES ('British National Party');
INSERT INTO `parties` (`party_name`) VALUES ('Respect-Unity Coalition');
INSERT INTO `parties` (`party_name`) VALUES ('Independent Community and Health Concern');
INSERT INTO `parties` (`party_name`) VALUES ('Others');

