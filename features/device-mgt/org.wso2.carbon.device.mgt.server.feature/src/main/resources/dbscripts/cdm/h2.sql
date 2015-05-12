CREATE TABLE IF NOT EXISTS DM_DEVICE_TYPE (
     ID   INT auto_increment NOT NULL,
     NAME VARCHAR(300) NULL DEFAULT NULL,
     PRIMARY KEY (ID)
);

CREATE TABLE IF NOT EXISTS DM_DEVICE (
     ID                    INTEGER auto_increment NOT NULL,
     DESCRIPTION           TEXT NULL DEFAULT NULL,
     NAME                  VARCHAR(100) NULL DEFAULT NULL,
     DATE_OF_ENROLLMENT    BIGINT NULL DEFAULT NULL,
     DATE_OF_LAST_UPDATE   BIGINT NULL DEFAULT NULL,
     OWNERSHIP             VARCHAR(45) NULL DEFAULT NULL,
     STATUS                VARCHAR(15) NULL DEFAULT NULL,
     DEVICE_TYPE_ID        INT(11) NULL DEFAULT NULL,
     DEVICE_IDENTIFICATION VARCHAR(300) NULL DEFAULT NULL,
     OWNER                 VARCHAR(45) NULL DEFAULT NULL,
     TENANT_ID INTEGER DEFAULT 0,
     PRIMARY KEY (ID),
     CONSTRAINT fk_DM_DEVICE_DM_DEVICE_TYPE2 FOREIGN KEY (DEVICE_TYPE_ID )
     REFERENCES DM_DEVICE_TYPE (ID) ON DELETE NO ACTION ON UPDATE NO ACTION
);

CREATE TABLE IF NOT EXISTS DM_OPERATION (
    ID INTEGER AUTO_INCREMENT NOT NULL,
    TYPE VARCHAR(50) NOT NULL,
    CREATED_TIMESTAMP TIMESTAMP NOT NULL,
    RECEIVED_TIMESTAMP TIMESTAMP NULL,
    STATUS VARCHAR(50) NULL,
    OPERATION_CODE VARCHAR(25) NOT NULL,
    PRIMARY KEY (ID)
);

CREATE TABLE IF NOT EXISTS DM_CONFIG_OPERATION (
    OPERATION_ID INTEGER NOT NULL,
    PRIMARY KEY (OPERATION_ID),
    CONSTRAINT fk_dm_operation_config FOREIGN KEY (OPERATION_ID) REFERENCES
    DM_OPERATION (ID) ON DELETE NO ACTION ON UPDATE NO ACTION
);

CREATE TABLE IF NOT EXISTS DM_COMMAND_OPERATION (
    OPERATION_ID INTEGER NOT NULL,
    ENABLED BOOLEAN NOT NULL DEFAULT FALSE,
    PRIMARY KEY (OPERATION_ID),
    CONSTRAINT fk_dm_operation_command FOREIGN KEY (OPERATION_ID) REFERENCES
    DM_OPERATION (ID) ON DELETE NO ACTION ON UPDATE NO ACTION
);

CREATE TABLE IF NOT EXISTS DM_PROFILE_OPERATION (
    OPERATION_ID INTEGER NOT NULL,
    ENABLED INTEGER NOT NULL DEFAULT 0,
    OPERATION_DETAILS BLOB DEFAULT NULL,
    PRIMARY KEY (OPERATION_ID),
    CONSTRAINT fk_dm_operation_profile FOREIGN KEY (OPERATION_ID) REFERENCES
    DM_OPERATION (ID) ON DELETE NO ACTION ON UPDATE NO ACTION
);

CREATE TABLE IF NOT EXISTS DM_DEVICE_OPERATION_MAPPING (
    ID INTEGER AUTO_INCREMENT NOT NULL,
    DEVICE_ID INTEGER NOT NULL,
    OPERATION_ID INTEGER NOT NULL,
    PRIMARY KEY (ID),
    CONSTRAINT fk_dm_device_operation_mapping_device FOREIGN KEY (DEVICE_ID) REFERENCES
    DM_DEVICE (ID) ON DELETE NO ACTION ON UPDATE NO ACTION,
    CONSTRAINT fk_dm_device_operation_mapping_operation FOREIGN KEY (OPERATION_ID) REFERENCES
    DM_OPERATION (ID) ON DELETE NO ACTION ON UPDATE NO ACTION
);


--- POLICY RELATED TABLES ----

CREATE  TABLE IF NOT EXISTS DM_PROFILE (
  ID INT NOT NULL AUTO_INCREMENT ,
  PROFILE_NAME VARCHAR(45) NOT NULL ,
  TENANT_ID INT NOT NULL ,
  DEVICE_TYPE_ID INT NOT NULL ,
  CREATED_TIME DATETIME NOT NULL ,
  UPDATED_TIME DATETIME NOT NULL ,
  PRIMARY KEY (ID) ,
  CONSTRAINT DM_PROFILE_DEVICE_TYPE FOREIGN KEY (DEVICE_TYPE_ID ) REFERENCES DM_DEVICE_TYPE (ID )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
);


CREATE  TABLE IF NOT EXISTS DM_POLICY (
  ID INT(11) NOT NULL AUTO_INCREMENT ,
  NAME VARCHAR(45) NULL DEFAULT NULL ,
  TENANT_ID INT(11) NOT NULL ,
  PROFILE_ID INT(11) NOT NULL ,
  PRIORITY INT NOT NULL ,
  PRIMARY KEY (ID) ,
  CONSTRAINT FK_DM_PROFILE_DM_POLICY FOREIGN KEY (PROFILE_ID ) REFERENCES DM_PROFILE (ID )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
);


CREATE  TABLE IF NOT EXISTS DM_DEVICE_POLICY (
  ID INT(11) NOT NULL AUTO_INCREMENT ,
  DEVICE_ID INT(11) NOT NULL ,
  POLICY_ID INT(11) NOT NULL ,
  PRIMARY KEY (ID) ,
  CONSTRAINT FK_POLICY_DEVICE_POLICY FOREIGN KEY (POLICY_ID ) REFERENCES DM_POLICY (ID )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT FK_DEVICE_DEVICE_POLICY FOREIGN KEY (DEVICE_ID ) REFERENCES DM_DEVICE (ID )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
);


CREATE  TABLE IF NOT EXISTS DM_DEVICE_TYPE_POLICY (
  ID INT(11) NOT NULL ,
  DEVICE_TYPE_ID INT(11) NOT NULL ,
  POLICY_ID INT(11) NOT NULL ,
  PRIMARY KEY (ID) ,
  CONSTRAINT FK_DEVICE_TYPE_POLICY FOREIGN KEY (POLICY_ID ) REFERENCES DM_POLICY (ID )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT FK_DEVICE_TYPE_POLICY_DEVICE_TYPE FOREIGN KEY (DEVICE_TYPE_ID ) REFERENCES DM_DEVICE_TYPE (ID )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
);


CREATE  TABLE IF NOT EXISTS DM_PROFILE_FEATURES (
  ID INT(11) NOT NULL AUTO_INCREMENT,
  PROFILE_ID INT(11) NOT NULL,
  FEATURE_CODE VARCHAR(10) NOT NULL,
  DEVICE_TYPE_ID INT NOT NULL,
  CONTENT BLOB NULL DEFAULT NULL,
  PRIMARY KEY (ID),
  CONSTRAINT FK_DM_PROFILE_DM_POLICY_FEATURES FOREIGN KEY (PROFILE_ID) REFERENCES DM_PROFILE (ID)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
);


CREATE  TABLE IF NOT EXISTS DM_ROLE_POLICY (
  ID INT(11) NOT NULL AUTO_INCREMENT ,
  ROLE_NAME VARCHAR(45) NOT NULL ,
  POLICY_ID INT(11) NOT NULL ,
  PRIMARY KEY (ID) ,
  CONSTRAINT FK_ROLE_POLICY_POLICY FOREIGN KEY (POLICY_ID ) REFERENCES DM_POLICY (ID )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
);


CREATE  TABLE IF NOT EXISTS DM_LOCATION (
  LATITUDE VARCHAR(45) NOT NULL ,
  LONGITUDE VARCHAR(45) NOT NULL ,
  POLICY_ID INT(11) NOT NULL ,
  CONSTRAINT FK_DM_POLICY_DM_LOCATION FOREIGN KEY (POLICY_ID ) REFERENCES DM_POLICY (ID )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
);


CREATE  TABLE IF NOT EXISTS DM_TIME (
  STARTING_TIME DATETIME NOT NULL ,
  ENDING_TIME DATETIME NOT NULL ,
  POLICY_ID INT(11) NOT NULL ,
  CONSTRAINT FK_DM_POLICY_DM_TIME FOREIGN KEY (POLICY_ID ) REFERENCES DM_POLICY (ID )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
);


CREATE  TABLE IF NOT EXISTS DM_DATE (
  START_DATE DATE NOT NULL ,
  END_DATE DATE NOT NULL ,
  POLICY_ID INT NOT NULL ,
  CONSTRAINT DM_DATE_POLICY FOREIGN KEY (POLICY_ID ) REFERENCES DM_POLICY (ID )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
);


CREATE  TABLE IF NOT EXISTS DM_USER_POLICY (
  ID INT NOT NULL AUTO_INCREMENT ,
  POLICY_ID INT NOT NULL ,
  USERNAME VARCHAR(45) NOT NULL ,
  PRIMARY KEY (ID) ,
  CONSTRAINT DM_POLICY_USER_POLICY FOREIGN KEY (POLICY_ID ) REFERENCES DM_POLICY (ID )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
);


-- POLICY RELATED TABLES  FINISHED --


-- TO:DO - Remove this INSERT sql statement.
--Insert into DM_DEVICE_TYPE (ID,NAME) VALUES (1, 'android');
--Insert into DM_DEVICE_TYPE (ID,NAME) VALUES (2, 'ios');
