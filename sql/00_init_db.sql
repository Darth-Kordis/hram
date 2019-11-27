-- Database: hram

-- DROP DATABASE monkey_db;


CREATE DATABASE hram
  WITH OWNER = monkey_user
       ENCODING = 'UTF8'
       TABLESPACE = pg_default
       LC_COLLATE = 'en_US.UTF-8'
       LC_CTYPE = 'en_US.UTF-8'
       CONNECTION LIMIT = -1
	   TEMPLATE template0;