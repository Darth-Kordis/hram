SET TIME ZONE 'Europe/Samara';

CREATE EXTENSION "uuid-ossp";

--Создание функции генерации идентификаторов UUIDv4
CREATE OR REPLACE FUNCTION uuid_generate_v4()
  RETURNS UUID AS
'$libdir/uuid-ossp', 'uuid_generate_v4'
LANGUAGE C VOLATILE STRICT
COST 1;
ALTER FUNCTION uuid_generate_v4()
OWNER TO monkey_user;


-- Генерация Системных таблиц и функций
-- Prefix: sys_

-- Функция генерации ФИО
-- Function: user_fullname()

CREATE OR REPLACE FUNCTION user_fullname()
  RETURNS TRIGGER AS
$BODY$
BEGIN
  new.fullname := concat_ws(' ', new.surname, new.firstname, new.middlename);
  RETURN new;
END;
$BODY$
LANGUAGE plpgsql VOLATILE
COST 100;
ALTER FUNCTION user_fullname()
OWNER TO monkey_user;

-- Функция вычисления Инициалов
-- Function: user_initials()
CREATE OR REPLACE FUNCTION user_initials()
  RETURNS trigger AS
  $BODY$
BEGIN
  new.surname_initials := concat_ws(' ', new.surname,   substring( new.firstname from 1 for 1), substring( new.middlename from 1 for 1));
  RETURN new;
END;
$BODY$
LANGUAGE plpgsql VOLATILE
COST 100;
ALTER FUNCTION user_initials()
OWNER TO monkey_user;


-- Словарь "Сан"
-- Table: sys_dict_san

CREATE TABLE sys_dict_san
(
  unique_id          BIGSERIAL                NOT NULL, -- Идентификатор записи. Первичный ключ
  uuid               UUID                     NOT NULL, -- UUID
  name               CHARACTER VARYING, -- Мнемоника
  code               BIGINT, -- Код записи словарного значения
  label              CHARACTER VARYING        NOT NULL, -- Наименование
  description        CHARACTER VARYING, -- Описание
  created_timestamp  TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT statement_timestamp(), -- Дата и время создания записи
  modified_timestamp TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT statement_timestamp(), -- Дата и время изменения записи
  is_deleted         BOOLEAN                           DEFAULT FALSE, -- Признак удалённой записи
  is_relevant        BOOLEAN DEFAULT TRUE, -- Признак активности записи
  CONSTRAINT sys_dict_san_pkey PRIMARY KEY (unique_id),
  CONSTRAINT sys_dict_san_code_key UNIQUE (code)
)
WITH (
OIDS = FALSE
);
ALTER TABLE sys_dict_san
  OWNER TO monkey_user;
COMMENT ON TABLE sys_dict_san
IS 'Таблица, содержащая атрибуты объекта - Сан священослужителя';
COMMENT ON COLUMN sys_dict_san.unique_id IS 'Идентификатор записи. Первичный ключ';
COMMENT ON COLUMN sys_dict_san.uuid IS 'uuid объекта';
COMMENT ON COLUMN sys_dict_san.name IS 'Мнемоника';
COMMENT ON COLUMN sys_dict_san.name IS 'Код записи';
COMMENT ON COLUMN sys_dict_san.label IS 'Наименование';
COMMENT ON COLUMN sys_dict_san.description IS 'Описание';
COMMENT ON COLUMN sys_dict_san.created_timestamp IS 'Дата и время создания записи';
COMMENT ON COLUMN sys_dict_san.modified_timestamp IS 'Дата и время последнего изменения записи';
COMMENT ON COLUMN sys_dict_san.is_deleted IS 'Признак удалённой записи';
COMMENT ON COLUMN sys_dict_san.is_relevant IS 'Признак активности записи';


-- Словарь "Специализация священослужителя"
-- Table: sys_dict_specialization

CREATE TABLE sys_dict_specialization
(
  unique_id          BIGSERIAL                NOT NULL, -- Идентификатор записи. Первичный ключ
  uuid               UUID                     NOT NULL, -- UUID
  name               CHARACTER VARYING, -- Мнемоника
  code               BIGINT, -- Код записи словарного значения
  label              CHARACTER VARYING        NOT NULL, -- Наименование
  description        CHARACTER VARYING, -- Описание
  created_timestamp  TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT statement_timestamp(), -- Дата и время создания записи
  modified_timestamp TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT statement_timestamp(), -- Дата и время изменения записи
  is_deleted         BOOLEAN                           DEFAULT FALSE, -- Признак удалённой записи
  is_relevant        BOOLEAN DEFAULT TRUE, -- Признак активности записи
  CONSTRAINT sys_dict_specialization_pkey PRIMARY KEY (unique_id),
  CONSTRAINT sys_dict_specialization_code_key UNIQUE (code)
)
WITH (
OIDS = FALSE
);
ALTER TABLE sys_dict_specialization
  OWNER TO monkey_user;
COMMENT ON TABLE sys_dict_specialization
IS 'Таблица, содержащая атрибуты объекта - Специализация священослужителя ';
COMMENT ON COLUMN sys_dict_specialization.unique_id IS 'Идентификатор записи. Первичный ключ';
COMMENT ON COLUMN sys_dict_specialization.uuid IS 'uuid объекта';
COMMENT ON COLUMN sys_dict_specialization.name IS 'Мнемоника';
COMMENT ON COLUMN sys_dict_specialization.code IS 'Код записи';
COMMENT ON COLUMN sys_dict_specialization.label IS 'Наименование';
COMMENT ON COLUMN sys_dict_specialization.description IS 'Описание';
COMMENT ON COLUMN sys_dict_specialization.created_timestamp IS 'Дата и время создания записи';
COMMENT ON COLUMN sys_dict_specialization.modified_timestamp IS 'Дата и время последнего изменения записи';
COMMENT ON COLUMN sys_dict_specialization.is_deleted IS 'Признак удалённой записи';
COMMENT ON COLUMN sys_dict_specialization.is_relevant IS 'Признак активности записи';


-- Учетные записи пользователей Системы
-- Table: sys_users

CREATE TABLE sys_users
(
  unique_id           BIGSERIAL NOT NULL, -- Идентификатор записи. Первичный ключ
  uuid                uuid NOT NULL, -- UUID записи
  name                character varying, -- Мнемоника
  surname             character varying NOT NULL, -- Фамилия
  firstname           character varying NOT NULL, -- Имя
  middlename          character varying, -- Отчество
  fullname            character varying, -- Фамилия Имя Отчество (для поиска)
  surname_initials    character varying, -- Фамилия Инициалы (для журналов)
  accost              character varying, -- Обращение
  birthday            date, -- Дата рождения
  hirotonyday         date, -- Дата хиротонии
  is_send_email       boolean DEFAULT TRUE, -- Признак получения уведомлений по email
  is_send_message        boolean DEFAULT TRUE, -- Признак получения уведомлений через МП
  photo               character varying, -- Ссылка на фотографию пользователя
  san_ref             BIGINT, -- Сан священослужителя
  specialization_ref  BIGINT, -- Специализация священослужителя
  author              bigint, -- Пользователь, создавший объект
  created_timestamp   timestamp with time zone NOT NULL DEFAULT statement_timestamp(), -- Дата и время создания записи
  modifier            bigint, -- Пользователь, последним изменивший объект
  modified_timestamp  timestamp with time zone NOT NULL DEFAULT statement_timestamp(), -- Дата и время последнего изменения записи
  is_deleted          boolean DEFAULT false, -- Признак удалённой записи
  is_relevant         boolean DEFAULT TRUE, -- Признак активности записи
  is_active_login             BOOLEAN, -- Активный пользователь
  is_user             boolean, -- Признак учетной записи Мирянина
  is_check_personal_data boolean, -- Согласие на обработку ПДн
  CONSTRAINT sys_users_pkey PRIMARY KEY (unique_id),
  CONSTRAINT sys_users_author_fkey FOREIGN KEY (author)
      REFERENCES sys_users (unique_id) MATCH SIMPLE
      ON UPDATE RESTRICT ON DELETE RESTRICT,
  CONSTRAINT sys_users_modifier_fkey FOREIGN KEY (modifier)
      REFERENCES sys_users (unique_id) MATCH SIMPLE
      ON UPDATE RESTRICT ON DELETE RESTRICT,
  CONSTRAINT sys_users_san_ref_fkey FOREIGN KEY (san_ref)
  REFERENCES sys_dict_san (code) MATCH SIMPLE
  ON UPDATE RESTRICT ON DELETE RESTRICT,
  CONSTRAINT sys_users_specialization_ref_fkey FOREIGN KEY (specialization_ref)
  REFERENCES sys_dict_specialization (code) MATCH SIMPLE
  ON UPDATE RESTRICT ON DELETE RESTRICT
)
WITH (
  OIDS=FALSE
);
ALTER TABLE sys_users
  OWNER TO monkey_user;
COMMENT ON TABLE sys_users
  IS 'Таблица, содержащая атрибуты объекта - пользователи системы';
COMMENT ON COLUMN sys_users.unique_id IS 'Идентификатор записи. Первичный ключ';
COMMENT ON COLUMN sys_users.uuid IS 'UUID записи';
COMMENT ON COLUMN sys_users.name IS 'Мнемоника';
COMMENT ON COLUMN sys_users.surname IS 'Фамилия';
COMMENT ON COLUMN sys_users.firstname IS 'Имя';
COMMENT ON COLUMN sys_users.middlename IS 'Отчество';
COMMENT ON COLUMN sys_users.fullname IS 'Фамилия Имя Отчество (для поиска)';
COMMENT ON COLUMN sys_users.surname_initials IS 'Фамилия Инициалы (для журналов)';
COMMENT ON COLUMN sys_users.accost IS 'Обращение';
COMMENT ON COLUMN sys_users.birthday IS 'Дата рождения';
COMMENT ON COLUMN sys_users.hirotonyday IS 'Дата хиротонии';
COMMENT ON COLUMN sys_users.is_send_email IS 'Признак получения уведомлений по email';
COMMENT ON COLUMN sys_users.is_send_message IS 'Признак получения уведомлений через МП';
COMMENT ON COLUMN sys_users.photo IS 'Фотография';
COMMENT ON COLUMN sys_users.san_ref IS 'Сан';
COMMENT ON COLUMN sys_users.specialization_ref IS 'Специализация';
COMMENT ON COLUMN sys_users.author IS 'Пользователь, создавший объект';
COMMENT ON COLUMN sys_users.created_timestamp IS 'Дата и время создания записи';
COMMENT ON COLUMN sys_users.modifier IS 'Пользователь, последним изменивший объект';
COMMENT ON COLUMN sys_users.modified_timestamp IS 'Дата и время последнего изменения записи';
COMMENT ON COLUMN sys_users.is_deleted IS 'Признак удалённой записи';
COMMENT ON COLUMN sys_users.is_relevant IS 'Признак активности записи';
COMMENT ON COLUMN sys_users.is_active_login IS 'Активный пользователь';
COMMENT ON COLUMN sys_users.is_user IS 'Признак что учетная запись принадлежит Мирянину';
COMMENT ON COLUMN sys_users.is_check_personal_data IS 'Согласие на обработку ПДн';


-- связь помощников и священослужителей
-- Table: sys_link_users_users_gb

CREATE TABLE sys_link_users_users_gb
(
  unique_id   BIGSERIAL NOT NULL, -- Идентификатор записи. Первичный ключ
  user_ref    BIGINT    NOT NULL, -- Ссылка на священослужителя
  sub_user_ref    BIGINT    NOT NULL, -- Ссылка на помощника
  CONSTRAINT sys_link_users_users_gb_pkey PRIMARY KEY (unique_id),
  CONSTRAINT sys_link_users_users_gb_user_ref_fkey FOREIGN KEY (user_ref)
  REFERENCES sys_users (unique_id) MATCH SIMPLE
  ON UPDATE RESTRICT ON DELETE RESTRICT,
  CONSTRAINT sys_link_users_users_gb_ref_fkey FOREIGN KEY (sub_user_ref)
  REFERENCES sys_users (unique_id) MATCH SIMPLE
  ON UPDATE RESTRICT ON DELETE RESTRICT
)
WITH (
OIDS = FALSE
);
ALTER TABLE sys_link_users_users_gb
  OWNER TO monkey_user;
COMMENT ON TABLE sys_link_users_users_gb
IS 'Таблица, содержащая атрибуты объекта - Таблица связи Священослужителя и помощника';
COMMENT ON COLUMN sys_link_users_users_gb.unique_id IS 'Идентификатор записи. Первичный ключ';
COMMENT ON COLUMN sys_link_users_users_gb.user_ref IS 'Священослужитель';
COMMENT ON COLUMN sys_link_users_users_gb.sub_user_ref IS 'Помощник';

-- Trigger: user_fullname on public.sys_users

CREATE TRIGGER user_fullname
  BEFORE INSERT OR UPDATE OF surname, firstname, middlename
  ON sys_users
  FOR EACH ROW
  EXECUTE PROCEDURE user_fullname();

-- Trigger: user_initials on public.sys_users

CREATE TRIGGER user_initials
  BEFORE INSERT OR UPDATE OF surname, firstname, middlename
  ON sys_users
  FOR EACH ROW
  EXECUTE PROCEDURE user_initials();


-- Словарь "Типы аутентификации"
-- Table: sys_dict_authen_type

CREATE TABLE sys_dict_authen_type
(
  unique_id          BIGSERIAL                NOT NULL, -- Идентификатор записи. Первичный ключ
  uuid               UUID                     NOT NULL, -- UUID
  name               CHARACTER VARYING, -- Мнемоника
  code               BIGINT, -- Код записи словарного значения
  label              CHARACTER VARYING        NOT NULL, -- Наименование
  description        CHARACTER VARYING, -- Описание
  created_timestamp  TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT statement_timestamp(), -- Дата и время создания записи
  modified_timestamp TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT statement_timestamp(), -- Дата и время изменения записи
  is_deleted         BOOLEAN                           DEFAULT FALSE, -- Признак удалённой записи
  is_relevant        BOOLEAN DEFAULT TRUE, -- Признак активности записи
  CONSTRAINT sys_dict_authen_type_pkey PRIMARY KEY (unique_id),
  CONSTRAINT sys_dict_authen_type_code_key UNIQUE (code)
)
WITH (
OIDS = FALSE
);
ALTER TABLE sys_dict_authen_type
  OWNER TO monkey_user;
COMMENT ON TABLE sys_dict_authen_type
IS 'Таблица, содержащая атрибуты объекта - Типы аутентификации';
COMMENT ON COLUMN sys_dict_authen_type.unique_id IS 'Идентификатор записи. Первичный ключ';
COMMENT ON COLUMN sys_dict_authen_type.uuid IS 'uuid объекта';
COMMENT ON COLUMN sys_dict_authen_type.name IS 'Мнемоника';
COMMENT ON COLUMN sys_dict_authen_type.code IS 'Код записи';
COMMENT ON COLUMN sys_dict_authen_type.label IS 'Наименование';
COMMENT ON COLUMN sys_dict_authen_type.description IS 'Описание';
COMMENT ON COLUMN sys_dict_authen_type.created_timestamp IS 'Дата и время создания записи';
COMMENT ON COLUMN sys_dict_authen_type.modified_timestamp IS 'Дата и время последнего изменения записи';
COMMENT ON COLUMN sys_dict_authen_type.is_deleted IS 'Признак удалённой записи';
COMMENT ON COLUMN sys_dict_authen_type.is_relevant IS 'Признак активности записи';

-- Таблица "Данные аутентификации"
-- Table: sys_authen

CREATE TABLE sys_authen
(
  unique_id          BIGSERIAL                NOT NULL, -- Идентификатор записи. Первичный ключ
  uuid               UUID                     NOT NULL, -- UUID
  name               CHARACTER VARYING, -- Идентификационное имя учётной записи. Зависит от способа аутентификации. Для пары логин/пароль - логин
  type_ref           BIGINT                   NOT NULL, -- Тип аутентификации. Ссылка на словарь
  user_ref           BIGINT                   NOT NULL, -- Ссылка на пользователя
  start_timestamp    TIMESTAMP WITH TIME ZONE          DEFAULT now(), -- Дата и время, начиная с которого учётная запись становится действительной
  expire_timestamp   TIMESTAMP WITH TIME ZONE          DEFAULT 'infinity' :: TIMESTAMP WITH TIME ZONE, -- Дата и время, начиная с которого учётная запись становится недействительной
  author             BIGINT NOT NULL, -- Пользователь, создавший объект
  created_timestamp  TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT statement_timestamp(), -- Дата и время создания записи
  modifier           BIGINT NOT NULL, -- Пользователь, последним изменивший объект
  modified_timestamp TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT statement_timestamp(), -- Дата и время изменения записи
  is_deleted         BOOLEAN                           DEFAULT FALSE, -- Признак удалённой записи
  is_relevant        BOOLEAN DEFAULT TRUE, -- Признак активности записи
  CONSTRAINT sys_authen_pkey PRIMARY KEY (unique_id),
  CONSTRAINT sys_authen_author_fkey FOREIGN KEY (author)
  REFERENCES sys_users (unique_id) MATCH SIMPLE
  ON UPDATE RESTRICT ON DELETE RESTRICT,
  CONSTRAINT sys_authen_modifier_fkey FOREIGN KEY (modifier)
  REFERENCES sys_users (unique_id) MATCH SIMPLE
  ON UPDATE RESTRICT ON DELETE RESTRICT,
  CONSTRAINT sys_authen_type_ref_fkey FOREIGN KEY (type_ref)
  REFERENCES sys_dict_authen_type (code) MATCH SIMPLE
  ON UPDATE RESTRICT ON DELETE RESTRICT,
  CONSTRAINT sys_authen_user_ref_fkey FOREIGN KEY (user_ref)
  REFERENCES sys_users (unique_id) MATCH SIMPLE
  ON UPDATE RESTRICT ON DELETE RESTRICT
)
WITH (
OIDS = FALSE
);
ALTER TABLE sys_authen
  OWNER TO monkey_user;
COMMENT ON TABLE sys_authen
IS 'Таблица, содержащая атрибуты объекта - данные для аутентификации пользователей системы';
COMMENT ON COLUMN sys_authen.unique_id IS 'Идентификатор записи. Первичный ключ';
COMMENT ON COLUMN sys_authen.uuid IS 'uuid объекта';
COMMENT ON COLUMN sys_authen.name IS 'Идентификационное имя учётной записи. Зависит от способа аутентификации. Для пары логин/пароль - логин';
COMMENT ON COLUMN sys_authen.type_ref IS 'Тип аутентификации. Ссылка на словарь';
COMMENT ON COLUMN sys_authen.user_ref IS 'Ссылка на пользователя';
COMMENT ON COLUMN sys_authen.start_timestamp IS 'Дата и время, начиная с которого учётная запись становится действительной';
COMMENT ON COLUMN sys_authen.expire_timestamp IS 'Дата и время, начиная с которого учётная запись становится недействительной';
COMMENT ON COLUMN sys_authen.author IS 'Пользователь, создавший объект';
COMMENT ON COLUMN sys_authen.created_timestamp IS 'Дата и время создания записи';
COMMENT ON COLUMN sys_authen.modifier IS 'Пользователь, последним изменивший объект';
COMMENT ON COLUMN sys_authen.modified_timestamp IS 'Дата и время последнего изменения записи';
COMMENT ON COLUMN sys_authen.is_deleted IS 'Признак удалённой записи';
COMMENT ON COLUMN sys_authen.is_relevant IS 'Признак активности записи';


-- Содержит пароли для метода Аутентификации Логин/Пароль
-- Table: sys_passwords

CREATE TABLE sys_passwords
(
  unique_id          BIGSERIAL                NOT NULL, -- Идентификатор записи. Первичный ключ
  uuid               UUID                     NOT NULL, -- UUID
  name               CHARACTER VARYING, -- Мнемоника
  content            CHARACTER VARYING        NOT NULL, -- Хэш пароля
  authen_ref         BIGINT                   NOT NULL, -- Ссылка на логин
  salt               CHARACTER VARYING, -- "Соль" для хэширования пароля
  author             BIGINT NOT NULL, -- Пользователь, создавший объект
  created_timestamp  TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT statement_timestamp(), -- Дата и время создания записи
  modifier           BIGINT NOT NULL, -- Пользователь, последним изменивший объект
  modified_timestamp TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT statement_timestamp(), -- Дата и время изменения записи
  is_deleted         BOOLEAN                           DEFAULT FALSE, -- Признак удалённой записи
  is_relevant        BOOLEAN DEFAULT TRUE, -- Признак активности записи
  CONSTRAINT sys_passwords_pkey PRIMARY KEY (unique_id),
  CONSTRAINT sys_passwords_authen_ref_fkey FOREIGN KEY (authen_ref)
  REFERENCES sys_authen (unique_id) MATCH SIMPLE
  ON UPDATE RESTRICT ON DELETE RESTRICT,
  CONSTRAINT sys_passwords_author_fkey FOREIGN KEY (author)
  REFERENCES sys_users (unique_id) MATCH SIMPLE
  ON UPDATE RESTRICT ON DELETE RESTRICT,
  CONSTRAINT sys_passwords_modifier_fkey FOREIGN KEY (modifier)
  REFERENCES sys_users (unique_id) MATCH SIMPLE
  ON UPDATE RESTRICT ON DELETE RESTRICT
)
WITH (
OIDS = FALSE
);
ALTER TABLE sys_passwords
  OWNER TO monkey_user;
COMMENT ON TABLE sys_passwords
IS 'Таблица, содержащая атрибуты объекта - Пароли для аутентификации по логину и паролю';
COMMENT ON COLUMN sys_passwords.unique_id IS 'Идентификатор записи. Первичный ключ';
COMMENT ON COLUMN sys_passwords.uuid IS 'uuid объекта';
COMMENT ON COLUMN sys_passwords.name IS 'Мнемоника';
COMMENT ON COLUMN sys_passwords.content IS 'Хэш пароля';
COMMENT ON COLUMN sys_passwords.authen_ref IS 'Ссылка на логин';
COMMENT ON COLUMN sys_passwords.salt IS '"Соль" для хэширования пароля';
COMMENT ON COLUMN sys_passwords.author IS 'Пользователь, создавший объект';
COMMENT ON COLUMN sys_passwords.created_timestamp IS 'Дата и время создания записи';
COMMENT ON COLUMN sys_passwords.modifier IS 'Пользователь, последним изменивший объект';
COMMENT ON COLUMN sys_passwords.modified_timestamp IS 'Дата и время последнего изменения записи';
COMMENT ON COLUMN sys_passwords.is_deleted IS 'Признак удалённой записи';
COMMENT ON COLUMN sys_passwords.is_relevant IS 'Признак активности записи';

-- Тип контактов пользователя
-- Table: sys_dict_contact_type

CREATE TABLE sys_dict_contact_type
(
  unique_id          BIGSERIAL                NOT NULL, -- Идентификатор записи. Первичный ключ
  uuid               UUID                     NOT NULL, -- UUID
  name               CHARACTER VARYING, -- Мнемоника
  code               BIGINT, -- Код записи словарного значения
  label              CHARACTER VARYING        NOT NULL, -- Наименование
  description        CHARACTER VARYING, -- Описание
  created_timestamp  TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT statement_timestamp(), -- Дата и время создания записи
  modified_timestamp TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT statement_timestamp(), -- Дата и время изменения записи
  is_deleted         BOOLEAN                           DEFAULT FALSE, -- Признак удалённой записи
  is_relevant        BOOLEAN DEFAULT TRUE, -- Признак активности записи
  CONSTRAINT sys_dict_contact_type_pkey PRIMARY KEY (unique_id),
  CONSTRAINT sys_dict_contact_type_code_key UNIQUE (code)
)
WITH (
OIDS = FALSE
);
ALTER TABLE sys_dict_contact_type
  OWNER TO monkey_user;
COMMENT ON TABLE sys_dict_contact_type
IS 'Таблица, содержащая атрибуты объекта - Словарь типов контактной информации';
COMMENT ON COLUMN sys_dict_contact_type.unique_id IS 'Идентификатор записи. Первичный ключ';
COMMENT ON COLUMN sys_dict_contact_type.uuid IS 'uuid объекта';
COMMENT ON COLUMN sys_dict_contact_type.name IS 'Мнемоника';
COMMENT ON COLUMN sys_dict_contact_type.code IS 'Код записи словарного значения';
COMMENT ON COLUMN sys_dict_contact_type.label IS 'Наименование';
COMMENT ON COLUMN sys_dict_contact_type.description IS 'Описание';
COMMENT ON COLUMN sys_dict_contact_type.created_timestamp IS 'Дата и время создания записи';
COMMENT ON COLUMN sys_dict_contact_type.modified_timestamp IS 'Дата и время последнего изменения записи';
COMMENT ON COLUMN sys_dict_contact_type.is_deleted IS 'Признак удалённой записи';
COMMENT ON COLUMN sys_dict_contact_type.is_relevant IS 'Признак активности записи';


-- Контакты пользователя
-- Table: sys_users_contact

CREATE TABLE sys_users_contact
(
  unique_id          BIGSERIAL                NOT NULL, -- Идентификатор записи. Первичный ключ
  uuid               UUID                     NOT NULL, -- UUID
  name               CHARACTER VARYING, -- Мнемоника
  content            CHARACTER VARYING        NOT NULL, -- Значение/содержимое
  description        CHARACTER VARYING, -- Описание
  type_ref           BIGINT                   NOT NULL, -- Тип контактной информации. Ссылка на словарь
  user_ref           BIGINT                   NOT NULL, -- Ссылка на пользователя
  author             BIGINT NOT NULL, -- Пользователь, создавший объект
  created_timestamp  TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT statement_timestamp(), -- Дата и время создания записи
  modifier           BIGINT NOT NULL, -- Пользователь, последним изменивший объект
  modified_timestamp TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT statement_timestamp(), -- Дата и время изменения записи
  is_deleted         BOOLEAN                           DEFAULT FALSE, -- Признак удалённой записи
  is_relevant        BOOLEAN DEFAULT TRUE, -- Признак активности записи
  CONSTRAINT sys_users_contact_pkey PRIMARY KEY (unique_id),
  CONSTRAINT sys_users_contact_author_fkey FOREIGN KEY (author)
  REFERENCES sys_users (unique_id) MATCH SIMPLE
  ON UPDATE RESTRICT ON DELETE RESTRICT,
  CONSTRAINT sys_users_contact_modifier_fkey FOREIGN KEY (modifier)
  REFERENCES sys_users (unique_id) MATCH SIMPLE
  ON UPDATE RESTRICT ON DELETE RESTRICT,
  CONSTRAINT sys_users_contact_type_ref_fkey FOREIGN KEY (type_ref)
  REFERENCES sys_dict_contact_type (code) MATCH SIMPLE
  ON UPDATE RESTRICT ON DELETE RESTRICT,
  CONSTRAINT sys_users_contact_user_ref_fkey FOREIGN KEY (user_ref)
  REFERENCES sys_users (unique_id) MATCH SIMPLE
  ON UPDATE RESTRICT ON DELETE RESTRICT
)
WITH (
OIDS = FALSE
);
ALTER TABLE sys_users_contact
  OWNER TO monkey_user;
COMMENT ON TABLE sys_users_contact
IS 'Таблица, содержащая атрибуты объекта - Контакты пользователей';
COMMENT ON COLUMN sys_users_contact.unique_id IS 'Идентификатор записи. Первичный ключ';
COMMENT ON COLUMN sys_users_contact.uuid IS 'uuid объекта';
COMMENT ON COLUMN sys_users_contact.name IS 'Мнемоника';
COMMENT ON COLUMN sys_users_contact.content IS 'Значение/содержимое';
COMMENT ON COLUMN sys_users_contact.description IS 'Описание';
COMMENT ON COLUMN sys_users_contact.type_ref IS 'Тип контактной информации. Ссылка на словарь';
COMMENT ON COLUMN sys_users_contact.user_ref IS 'Ссылка на пользователя';
COMMENT ON COLUMN sys_users_contact.author IS 'Пользователь, создавший объект';
COMMENT ON COLUMN sys_users_contact.created_timestamp IS 'Дата и время создания записи';
COMMENT ON COLUMN sys_users_contact.modifier IS 'Пользователь, последним изменивший объект';
COMMENT ON COLUMN sys_users_contact.modified_timestamp IS 'Дата и время последнего изменения записи';
COMMENT ON COLUMN sys_users_contact.is_deleted IS 'Признак удалённой записи';
COMMENT ON COLUMN sys_users_contact.is_relevant IS 'Признак активности записи';

-- Таблица, содержащая общесистемные настройки
-- Table: sys_system_config

CREATE TABLE sys_system_config
(
  unique_id          BIGSERIAL                NOT NULL, -- Автоинкрементный идентификатор записи. Первичный ключ
  uuid               UUID                     NOT NULL, -- UUID
  name               CHARACTER VARYING(64)    NOT NULL, -- Уникальное имя параметра. Ключ по которому происходит модификация данных
  code               BIGINT, -- Код записи словарного значения
  label              CHARACTER VARYING(255), -- Наименование параметра. То что отображается в интерфейсе
  description        CHARACTER VARYING(2048), -- Описание параметра
  value_of_attribute CHARACTER VARYING, -- Значение параметра
  author             BIGINT NOT NULL, -- Пользователь, создавший объект
  created_timestamp  TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT statement_timestamp(), -- Дата и время создания записи
  modifier           BIGINT NOT NULL, -- Пользователь, последним изменивший объект
  modified_timestamp TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT statement_timestamp(), -- Дата и время изменения записи
  is_deleted         BOOLEAN                           DEFAULT FALSE, -- Признак удалённой записи
  is_relevant        BOOLEAN, -- Признак активности записи
  CONSTRAINT sys_system_config_pkey PRIMARY KEY (unique_id),
  CONSTRAINT sys_system_config_author_fkey FOREIGN KEY (author)
  REFERENCES sys_users (unique_id) MATCH SIMPLE
  ON UPDATE NO ACTION ON DELETE NO ACTION,
  CONSTRAINT sys_system_config_modifier_fkey FOREIGN KEY (modifier)
  REFERENCES sys_users (unique_id) MATCH SIMPLE
  ON UPDATE NO ACTION ON DELETE NO ACTION,
  CONSTRAINT sys_system_config_name_key UNIQUE (name),
  CONSTRAINT sys_system_config_code_key UNIQUE (code)
)
WITH (
OIDS = FALSE
);
ALTER TABLE sys_system_config
  OWNER TO monkey_user;
COMMENT ON TABLE sys_system_config
IS 'Таблица, содержащая атрибуты объекта - Таблица настроек Системы';
COMMENT ON COLUMN sys_system_config.unique_id IS 'Автоинкрементный идентификатор записи. Первичный ключ';
COMMENT ON COLUMN sys_system_config.uuid IS 'uuid объекта';
COMMENT ON COLUMN sys_system_config.name IS 'Уникальное имя параметра. Ключ по которому происходит модификация данных';
COMMENT ON COLUMN sys_system_config.code IS 'Код записи словарного значения';
COMMENT ON COLUMN sys_system_config.label IS 'Наименование параметра. То что отображается в интерфейсе';
COMMENT ON COLUMN sys_system_config.description IS 'Описание параметра';
COMMENT ON COLUMN sys_system_config.value_of_attribute IS 'Значение параметра';
COMMENT ON COLUMN sys_system_config.author IS 'Пользователь, создавший объект';
COMMENT ON COLUMN sys_system_config.created_timestamp IS 'Дата и время создания записи';
COMMENT ON COLUMN sys_system_config.modifier IS 'Пользователь, последним изменивший объект';
COMMENT ON COLUMN sys_system_config.modified_timestamp IS 'Дата и время последнего изменения записи';
COMMENT ON COLUMN sys_system_config.is_deleted IS 'Признак удалённой записи';
COMMENT ON COLUMN sys_system_config.is_relevant IS 'Признак активности записи';

-- Функциональные роли в системе
-- Table: sys_cat_roles

CREATE TABLE sys_cat_roles
(
  unique_id          BIGSERIAL                NOT NULL, -- Идентификатор записи. Первичный ключ
  uuid               UUID                     NOT NULL, -- UUID
  name               CHARACTER VARYING, -- Мнемоника
  code               BIGINT, -- Код записи словарного значения
  label              CHARACTER VARYING        NOT NULL, -- Наименование
  description        CHARACTER VARYING, -- Описание
  author             BIGINT NOT NULL, -- Пользователь, создавший объект
  created_timestamp  TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT statement_timestamp(), -- Дата и время создания записи
  modifier           BIGINT NOT NULL, -- Пользователь, последним изменивший объект
  modified_timestamp TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT statement_timestamp(), -- Дата и время изменения записи
  is_deleted         BOOLEAN                           DEFAULT FALSE, -- Признак удалённой записи
  is_relevant        BOOLEAN DEFAULT TRUE, -- Признак активности записи
  CONSTRAINT sys_cat_roles_pkey PRIMARY KEY (unique_id),
  CONSTRAINT sys_cat_roles_author_fkey FOREIGN KEY (author)
  REFERENCES sys_users (unique_id) MATCH SIMPLE
  ON UPDATE RESTRICT ON DELETE RESTRICT,
  CONSTRAINT sys_cat_roles_modifier_fkey FOREIGN KEY (modifier)
  REFERENCES sys_users (unique_id) MATCH SIMPLE
  ON UPDATE RESTRICT ON DELETE RESTRICT,
  CONSTRAINT sys_cat_roles_code_key UNIQUE (code)
)
WITH (
OIDS = FALSE
);
ALTER TABLE sys_cat_roles
  OWNER TO monkey_user;
COMMENT ON TABLE sys_cat_roles
IS 'Таблица, содержащая атрибуты объекта - Роли в системе';
COMMENT ON COLUMN sys_cat_roles.unique_id IS 'Идентификатор записи. Первичный ключ';
COMMENT ON COLUMN sys_cat_roles.uuid IS 'uuid объекта';
COMMENT ON COLUMN sys_cat_roles.name IS 'Мнемоника';
COMMENT ON COLUMN sys_cat_roles.code IS 'Код записи словарного значения';
COMMENT ON COLUMN sys_cat_roles.label IS 'Наименование';
COMMENT ON COLUMN sys_cat_roles.description IS 'Описание';
COMMENT ON COLUMN sys_cat_roles.author IS 'Пользователь, создавший объект';
COMMENT ON COLUMN sys_cat_roles.created_timestamp IS 'Дата и время создания записи';
COMMENT ON COLUMN sys_cat_roles.modifier IS 'Пользователь, последним изменивший объект';
COMMENT ON COLUMN sys_cat_roles.modified_timestamp IS 'Дата и время последнего изменения записи';
COMMENT ON COLUMN sys_cat_roles.is_deleted IS 'Признак удалённой записи';
COMMENT ON COLUMN sys_cat_roles.is_relevant IS 'Признак активности записи';


-- связь пользователей и функциональных ролей в системе
-- Table: sys_link_users_roles_gb

CREATE TABLE sys_link_users_roles_gb
(
  unique_id   BIGSERIAL NOT NULL, -- Идентификатор записи. Первичный ключ
  description CHARACTER VARYING, -- Описание
  user_ref    BIGINT    NOT NULL, -- Ссылка на пользователя
  role_ref    BIGINT    NOT NULL, -- Ссылка на роль
  CONSTRAINT sys_link_users_roles_gb_pkey PRIMARY KEY (unique_id),
  CONSTRAINT sys_link_users_roles_gb_role_ref_fkey FOREIGN KEY (role_ref)
  REFERENCES sys_cat_roles (unique_id) MATCH SIMPLE
  ON UPDATE RESTRICT ON DELETE RESTRICT,
  CONSTRAINT sys_link_users_roles_gb_user_ref_fkey FOREIGN KEY (user_ref)
  REFERENCES sys_users (unique_id) MATCH SIMPLE
  ON UPDATE RESTRICT ON DELETE RESTRICT
)
WITH (
OIDS = FALSE
);
ALTER TABLE sys_link_users_roles_gb
  OWNER TO monkey_user;
COMMENT ON TABLE sys_link_users_roles_gb
IS 'Таблица, содержащая атрибуты объекта - Таблица связи Роли и пользователя';
COMMENT ON COLUMN sys_link_users_roles_gb.unique_id IS 'Идентификатор записи. Первичный ключ';
COMMENT ON COLUMN sys_link_users_roles_gb.description IS 'Описание';
COMMENT ON COLUMN sys_link_users_roles_gb.user_ref IS 'Ссылка на пользователя';
COMMENT ON COLUMN sys_link_users_roles_gb.role_ref IS 'Ссылка на роль';

-- Перечень функциоанальностей
-- Table: sys_functions

CREATE TABLE sys_functions
(
  unique_id          BIGSERIAL                NOT NULL, -- Идентификатор записи. Первичный ключ
  uuid               UUID                     NOT NULL, -- UUID
  name               CHARACTER VARYING, -- Мнемоника
  code               BIGINT, -- Код записи словарного значения
  label              CHARACTER VARYING        NOT NULL, -- Наименование
  description        CHARACTER VARYING, -- Описание
  author             BIGINT NOT NULL, -- Пользователь, создавший объект
  created_timestamp  TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT statement_timestamp(), -- Дата и время создания записи
  modifier           BIGINT NOT NULL, -- Пользователь, последним изменивший объект
  modified_timestamp TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT statement_timestamp(), -- Дата и время изменения записи
  is_deleted         BOOLEAN                           DEFAULT FALSE, -- Признак удалённой записи
  is_relevant        BOOLEAN, -- Признак активности записи
  CONSTRAINT sys_functions_pkey PRIMARY KEY (unique_id),
  CONSTRAINT sys_functions_author_fkey FOREIGN KEY (author)
  REFERENCES sys_users (unique_id) MATCH SIMPLE
  ON UPDATE RESTRICT ON DELETE RESTRICT,
  CONSTRAINT sys_functions_modifier_fkey FOREIGN KEY (modifier)
  REFERENCES sys_users (unique_id) MATCH SIMPLE
  ON UPDATE RESTRICT ON DELETE RESTRICT,
  CONSTRAINT sys_functions_code_key UNIQUE (code)
)
WITH (
OIDS = FALSE
);
ALTER TABLE sys_functions
  OWNER TO monkey_user;
COMMENT ON TABLE sys_functions
IS 'Таблица, содержащая перечень функциональностей';
COMMENT ON COLUMN sys_functions.unique_id IS 'Идентификатор записи. Первичный ключ';
COMMENT ON COLUMN sys_functions.uuid IS 'uuid объекта';
COMMENT ON COLUMN sys_functions.name IS 'Мнемоника';
COMMENT ON COLUMN sys_functions.code IS 'Код записи словарного значения';
COMMENT ON COLUMN sys_functions.label IS 'Наименование';
COMMENT ON COLUMN sys_functions.description IS 'Описание';
COMMENT ON COLUMN sys_functions.created_timestamp IS 'Дата и время создания записи';
COMMENT ON COLUMN sys_functions.modified_timestamp IS 'Дата и время последнего изменения записи';
COMMENT ON COLUMN sys_functions.is_deleted IS 'Признак удалённой записи';
COMMENT ON COLUMN sys_functions.is_relevant IS 'Признак активности записи';


-- Связь функциональностей и функциональных ролей в Системе
-- Table: sys_link_functions_roles_gb

CREATE TABLE sys_link_functions_roles_gb
(
  unique_id   BIGSERIAL NOT NULL, -- Идентификатор записи. Первичный ключ
  description CHARACTER VARYING, -- Описание
  function_ref    BIGINT    NOT NULL, -- Ссылка на пользователя
  role_ref    BIGINT    NOT NULL, -- Ссылка на роль
  CONSTRAINT sys_link_functions_roles_gb_pkey PRIMARY KEY (unique_id),
  CONSTRAINT sys_link_functions_roles_gb_role_ref_fkey FOREIGN KEY (role_ref)
  REFERENCES sys_cat_roles (code) MATCH SIMPLE
  ON UPDATE RESTRICT ON DELETE RESTRICT,
  CONSTRAINT sys_link_functions_roles_gb_functions_ref_fkey FOREIGN KEY (function_ref)
  REFERENCES sys_functions (code) MATCH SIMPLE
  ON UPDATE RESTRICT ON DELETE RESTRICT
)
WITH (
OIDS = FALSE
);
ALTER TABLE sys_link_functions_roles_gb
  OWNER TO monkey_user;
COMMENT ON TABLE sys_link_functions_roles_gb
IS 'Таблица, содержащая атрибуты объекта - Таблица связи Роли и функциональности';
COMMENT ON COLUMN sys_link_functions_roles_gb.unique_id IS 'Идентификатор записи. Первичный ключ';
COMMENT ON COLUMN sys_link_functions_roles_gb.description IS 'Описание';
COMMENT ON COLUMN sys_link_functions_roles_gb.function_ref IS 'Ссылка на функциональность';
COMMENT ON COLUMN sys_link_functions_roles_gb.role_ref IS 'Ссылка на роль';


-- Типы событий генерируемых в Системе
-- Table: sys_dict_event_types

CREATE TABLE sys_dict_event_types
(
  unique_id          BIGSERIAL                NOT NULL, -- Идентификатор записи. Первичный ключ
  uuid               UUID                     NOT NULL, -- UUID
  name               CHARACTER VARYING, -- Мнемоника
  code               BIGINT, -- Код записи словарного значения
  label              CHARACTER VARYING        NOT NULL, -- Наименование
  description        CHARACTER VARYING, -- Описание
  created_timestamp  TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT statement_timestamp(), -- Дата и время создания записи
  modified_timestamp TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT statement_timestamp(), -- Дата и время изменения записи
  is_deleted         BOOLEAN                           DEFAULT FALSE, -- Признак удалённой записи
  is_relevant        BOOLEAN DEFAULT TRUE, -- Признак активности записи
  CONSTRAINT sys_dict_event_types_pkey PRIMARY KEY (unique_id),
  CONSTRAINT sys_dict_event_types_code_key UNIQUE (code)
)
WITH (
OIDS = FALSE
);
ALTER TABLE sys_dict_event_types
  OWNER TO monkey_user;
COMMENT ON TABLE sys_dict_event_types
IS 'Таблица, содержащая атрибуты объекта - Словарь типов событий';
COMMENT ON COLUMN sys_dict_event_types.unique_id IS 'Идентификатор записи. Первичный ключ';
COMMENT ON COLUMN sys_dict_event_types.uuid IS 'uuid объекта';
COMMENT ON COLUMN sys_dict_event_types.name IS 'Мнемоника';
COMMENT ON COLUMN sys_dict_event_types.code IS 'Код записи словарного значения';
COMMENT ON COLUMN sys_dict_event_types.label IS 'Наименивание типа события';
COMMENT ON COLUMN sys_dict_event_types.description IS 'Описание';
COMMENT ON COLUMN sys_dict_event_types.created_timestamp IS 'Дата и время создания записи';
COMMENT ON COLUMN sys_dict_event_types.modified_timestamp IS 'Дата и время последнего изменения записи';
COMMENT ON COLUMN sys_dict_event_types.is_deleted IS 'Признак удалённой записи';
COMMENT ON COLUMN sys_dict_event_types.is_relevant IS 'Признак активности записи';


-- Генерация "Общих" таблиц
-- Prefix: common_

-- История модификации объектов
-- Table: common_history

CREATE TABLE common_history
(
  unique_id          BIGSERIAL                NOT NULL, -- Идентификатор записи. Первичный ключ
  uuid               UUID                     NOT NULL, -- UUID записи
  name               CHARACTER VARYING, -- Мнемоника
  object_id          UUID                     NOT NULL, -- Идентификатор объекта
  text               CHARACTER VARYING, -- Описание
  event_type_ref     BIGINT                   NOT NULL, -- Ссылка на тип события
  init_user          CHARACTER VARYING, -- ФИО пользователя инициировавшего событие
  author             BIGINT NOT NULL, -- Пользователь, создавший объект
  created_timestamp  TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT statement_timestamp(), -- Дата и время создания записи
  modifier           BIGINT NOT NULL, -- Пользователь, последним изменивший объект
  modified_timestamp TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT statement_timestamp(), -- Дата и время изменения записи
  is_deleted         BOOLEAN                           DEFAULT FALSE, -- Признак удалённой записи
  is_relevant        BOOLEAN DEFAULT TRUE, -- Признак активности записи
  CONSTRAINT common_history_pkey PRIMARY KEY (unique_id),
  CONSTRAINT common_history_author_fkey FOREIGN KEY (author)
  REFERENCES sys_users (unique_id) MATCH SIMPLE
  ON UPDATE RESTRICT ON DELETE RESTRICT,
  CONSTRAINT common_history_event_type_fkey FOREIGN KEY (event_type_ref)
  REFERENCES sys_dict_event_types (code) MATCH SIMPLE
  ON UPDATE RESTRICT ON DELETE RESTRICT,
  CONSTRAINT common_history_modifier_fkey FOREIGN KEY (modifier)
  REFERENCES sys_users (unique_id) MATCH SIMPLE
  ON UPDATE RESTRICT ON DELETE RESTRICT
)
WITH (
OIDS = FALSE
);
ALTER TABLE common_history
  OWNER TO monkey_user;
COMMENT ON TABLE common_history
IS 'История изменений объектов системы';
COMMENT ON COLUMN common_history.unique_id IS 'Идентификатор записи. Первичный ключ';
COMMENT ON COLUMN common_history.uuid IS 'uuid записи';
COMMENT ON COLUMN common_history.name IS 'Мнемоника';
COMMENT ON COLUMN common_history.object_id IS 'Идентификатор измененного объекта';
COMMENT ON COLUMN common_history.text IS 'Описание';
COMMENT ON COLUMN common_history.event_type_ref IS 'Ссылка на тип события';
COMMENT ON COLUMN common_history.init_user IS 'ФИО пользователя инициировавшего событие';
COMMENT ON COLUMN common_history.author IS 'Пользователь, создавший объект|Ссылка на инициатора события';
COMMENT ON COLUMN common_history.created_timestamp IS 'Дата и время создания записи';
COMMENT ON COLUMN common_history.modifier IS 'Пользователь, последним изменивший объект';
COMMENT ON COLUMN common_history.modified_timestamp IS 'Дата и время последнего изменения записи';
COMMENT ON COLUMN common_history.is_deleted IS 'Признак удалённой записи';
COMMENT ON COLUMN common_history.is_relevant IS 'Признак активности записи';

-- Хранение и работа с файлами
-- Table: common_files

CREATE TABLE common_files
(
  unique_id          BIGSERIAL                NOT NULL, -- Идентификатор записи. Первичный ключ
  uuid               UUID                     NOT NULL, -- uuid объекта
  name               CHARACTER VARYING, -- Мнемоника
  file_data          BYTEA, -- Файл с данными. Поле бинарного типа (raw bytes)
  file_link          OID, -- Ссылка на данные, хранящиеся в Binary Large Object. Поле типа OID
  author             BIGINT NOT NULL, -- Пользователь, создавший объект
  created_timestamp  TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT statement_timestamp(), -- Дата и время создания записи
  modifier           BIGINT NOT NULL, -- Пользователь, последним изменивший объект
  modified_timestamp TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT statement_timestamp(), -- Дата и время последнего изменения записи
  is_deleted         BOOLEAN                           DEFAULT FALSE, -- Признак удалённой записи
  is_relevant        BOOLEAN DEFAULT TRUE, -- Признак активности записи
  CONSTRAINT common_files_pkey PRIMARY KEY (unique_id),
  CONSTRAINT common_files_author_fkey FOREIGN KEY (author)
  REFERENCES sys_users (unique_id) MATCH SIMPLE
  ON UPDATE RESTRICT ON DELETE RESTRICT,
  CONSTRAINT common_files_modifier_fkey FOREIGN KEY (modifier)
  REFERENCES sys_users (unique_id) MATCH SIMPLE
  ON UPDATE RESTRICT ON DELETE RESTRICT
)
WITH (
OIDS = FALSE
);
ALTER TABLE common_files
  OWNER TO monkey_user;
COMMENT ON TABLE common_files
IS 'Таблица, содержащая атрибуты объекта - объект ссылка на файлы Системы';
COMMENT ON COLUMN common_files.unique_id IS 'Идентификатор записи. Первичный ключ';
COMMENT ON COLUMN common_files.uuid IS 'uuid объекта';
COMMENT ON COLUMN common_files.name IS 'Мнемоника';
COMMENT ON COLUMN common_files.author IS 'Пользователь, создавший объект';
COMMENT ON COLUMN common_files.created_timestamp IS 'Дата и время создания записи';
COMMENT ON COLUMN common_files.modifier IS 'Пользователь, последним изменивший объект';
COMMENT ON COLUMN common_files.modified_timestamp IS 'Дата и время последнего изменения записи';
COMMENT ON COLUMN common_files.is_deleted IS 'Признак удалённой записи';
COMMENT ON COLUMN common_files.is_relevant IS 'Признак активности записи';
COMMENT ON COLUMN common_files.file_data IS 'Файл с данными. Поле бинарного типа (raw bytes)';
COMMENT ON COLUMN common_files.file_link IS 'Ссылка на данные, хранящиеся в Binary Large Object. Поле типа OID';

-- Журналирование событий
-- Table: common_log_request

CREATE TABLE common_log_request
(
  unique_id          BIGSERIAL                NOT NULL, -- Идентификатор записи. Первичный ключ
  uuid               UUID                     NOT NULL, -- uuid объекта
  name               CHARACTER VARYING, -- Мнемоника
  text               CHARACTER VARYING, -- Описание
  ip_address         CHARACTER VARYING, -- IP адрес
  os                 CHARACTER VARYING, -- Операционная система
  browser            CHARACTER VARYING, -- Браузер
  event_type_ref     BIGINT                   NOT NULL, -- Ссылка на тип события
  init_user          CHARACTER VARYING, -- ФИО пользователя инициировавшего событие
  author             BIGINT NOT NULL, -- Пользователь, создавший объект
  created_timestamp  TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT statement_timestamp(), -- Дата и время создания записи
  modifier           BIGINT NOT NULL, -- Пользователь, последним изменивший объект
  modified_timestamp TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT statement_timestamp(), -- Дата и время последнего изменения записи
  is_deleted         BOOLEAN                           DEFAULT FALSE, -- Признак удалённой записи
  is_relevant        BOOLEAN DEFAULT TRUE, -- Признак активности записи
  object_id          UUID                     NOT NULL, -- Идентификатор измененного объекта
  CONSTRAINT common_log_request_pkey PRIMARY KEY (unique_id),
  CONSTRAINT common_log_request_author_fkey FOREIGN KEY (author)
  REFERENCES sys_users (unique_id) MATCH SIMPLE
  ON UPDATE RESTRICT ON DELETE RESTRICT,
  CONSTRAINT ccommon_log_request_type_fkey FOREIGN KEY (event_type_ref)
  REFERENCES sys_dict_event_types (code) MATCH SIMPLE
  ON UPDATE RESTRICT ON DELETE RESTRICT,
  CONSTRAINT common_log_request_modifier_fkey FOREIGN KEY (modifier)
  REFERENCES sys_users (unique_id) MATCH SIMPLE
  ON UPDATE RESTRICT ON DELETE RESTRICT
)
WITH (
OIDS = FALSE
);
ALTER TABLE common_log_request
  OWNER TO monkey_user;
COMMENT ON TABLE common_log_request
IS 'Таблица, содержащая атрибуты объекта - лог журнала взаимодействия';
COMMENT ON COLUMN common_log_request.unique_id IS 'Идентификатор записи. Первичный ключ';
COMMENT ON COLUMN common_log_request.uuid IS 'uuid объекта';
COMMENT ON COLUMN common_log_request.name IS 'Мнемоника';
COMMENT ON COLUMN common_log_request.text IS 'Описание';
COMMENT ON COLUMN common_log_request.ip_address IS 'IP адрес';
COMMENT ON COLUMN common_log_request.os IS 'Операционная система';
COMMENT ON COLUMN common_log_request.browser IS 'Браузер';
COMMENT ON COLUMN common_log_request.init_user IS 'ФИО пользователя инициировавшего событие';
COMMENT ON COLUMN common_log_request.author IS 'Пользователь, создавший объект|Ссылка на инициатора события';
COMMENT ON COLUMN common_log_request.author IS 'Пользователь, создавший объект';
COMMENT ON COLUMN common_log_request.created_timestamp IS 'Дата и время создания записи';
COMMENT ON COLUMN common_log_request.modifier IS 'Пользователь, последним изменивший объект';
COMMENT ON COLUMN common_log_request.modified_timestamp IS 'Дата и время последнего изменения записи';
COMMENT ON COLUMN common_log_request.is_deleted IS 'Признак удалённой записи';
COMMENT ON COLUMN common_log_request.is_relevant IS 'Признак активности записи';
COMMENT ON COLUMN common_log_request.object_id IS 'Идентификатор измененного объекта';


-- Таблица содержащая описание типов события для бизнес процессов в храме
-- Table: common_action

CREATE TABLE common_action
(
  unique_id             BIGSERIAL                NOT NULL, -- Идентификатор записи. Первичный ключ
  uuid                  UUID                     NOT NULL, -- UUID
  author                BIGINT NOT NULL, -- Пользователь, создавший объект
  created_timestamp     TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT statement_timestamp(), -- Дата и время создания записи
  modifier              BIGINT NOT NULL, -- Пользователь, последним изменивший объект
  modified_timestamp    TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT statement_timestamp(), -- Дата и время изменения записи
  is_deleted            BOOLEAN                           DEFAULT FALSE, -- Признак удалённой записи
  is_relevant           BOOLEAN DEFAULT TRUE, -- Признак активности записи
  code                  BIGINT, -- Код записи справочного значения
  name                  CHARACTER VARYING, -- Мнемоника события
  label                 CHARACTER VARYING, -- Наименование события
  description           CHARACTER VARYING, -- Описание
  is_claim              BOOLEAN, -- Признак, возможность использования в Заявках
  is_slot               BOOLEAN, -- Признак, возможность использования в Слотах
  is_work               BOOLEAN, -- Признак, возможность использования в Делах
  is_ministration       BOOLEAN, -- Признак, возможность использования в Богослужениях
  long_time             CHARACTER VARYING, -- Длительность в минутах
  CONSTRAINT common_action_pkey PRIMARY KEY (unique_id),
  CONSTRAINT common_action_author_fkey FOREIGN KEY (author)
  REFERENCES sys_users (unique_id) MATCH SIMPLE
  ON UPDATE RESTRICT ON DELETE RESTRICT,
  CONSTRAINT common_action_modifier_fkey FOREIGN KEY (modifier)
  REFERENCES sys_users (unique_id) MATCH SIMPLE
  ON UPDATE RESTRICT ON DELETE RESTRICT,
  CONSTRAINT common_action_code_key UNIQUE (code)
)
WITH (
OIDS = FALSE
);
ALTER TABLE common_action
  OWNER TO monkey_user;
COMMENT ON TABLE common_action
IS 'Таблица, содержащая информацию об типах событий (требы, таинства, беседы, богослужения)';
COMMENT ON COLUMN common_action.unique_id IS 'Идентификатор записи. Первичный ключ';
COMMENT ON COLUMN common_action.uuid IS 'UUID записи';
COMMENT ON COLUMN common_action.author IS 'Пользователь, создавший объект';
COMMENT ON COLUMN common_action.created_timestamp IS 'Дата и время создания записи';
COMMENT ON COLUMN common_action.modifier IS 'Пользователь, последним изменивший объект';
COMMENT ON COLUMN common_action.modified_timestamp IS 'Дата и время последнего изменения записи';
COMMENT ON COLUMN common_action.is_deleted IS 'Признак удалённой записи';
COMMENT ON COLUMN common_action.is_relevant IS 'Признак активности записи';
COMMENT ON COLUMN common_action.code IS 'Код записи';
COMMENT ON COLUMN common_action.name IS 'Мнемоника';
COMMENT ON COLUMN common_action.description IS 'Описание';
COMMENT ON COLUMN common_action.label IS 'Наименование';
COMMENT ON COLUMN common_action.is_claim IS 'Для заявок';
COMMENT ON COLUMN common_action.is_slot IS 'Для слотов';
COMMENT ON COLUMN common_action.is_work IS 'Для дел';
COMMENT ON COLUMN common_action.is_ministration IS 'Для богослужений';
COMMENT ON COLUMN common_action.long_time IS 'Длительность по умолчанию';


-- Словарь направление взаимодействия
-- Table: common_dict_message_direction

CREATE TABLE common_dict_message_direction
(
  unique_id          BIGSERIAL                NOT NULL, -- Идентификатор записи. Первичный ключ
  uuid               UUID                     NOT NULL, -- UUID
  name               CHARACTER VARYING, -- Мнемоника
  code               BIGINT, -- Код записи словарного значения
  label              CHARACTER VARYING        NOT NULL, -- Наименование
  description        CHARACTER VARYING, -- Описание
  created_timestamp  TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT statement_timestamp(), -- Дата и время создания записи
  modified_timestamp TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT statement_timestamp(), -- Дата и время изменения записи
  is_deleted         BOOLEAN                           DEFAULT FALSE, -- Признак удалённой записи
  is_relevant        BOOLEAN, -- Признак активности записи
  CONSTRAINT common_dict_message_direction_dict__pkey PRIMARY KEY (unique_id),
  CONSTRAINT common_dict_message_direction_dict__code_key UNIQUE (code)
)
WITH (
OIDS = FALSE
);
ALTER TABLE common_dict_message_direction
  OWNER TO monkey_user;
COMMENT ON TABLE common_dict_message_direction
IS 'Таблица, содержащая атрибуты объекта - направление взаимодействия';
COMMENT ON COLUMN common_dict_message_direction.unique_id IS 'Идентификатор записи. Первичный ключ';
COMMENT ON COLUMN common_dict_message_direction.uuid IS 'uuid объекта';
COMMENT ON COLUMN common_dict_message_direction.name IS 'Мнемоника';
COMMENT ON COLUMN common_dict_message_direction.name IS 'Код записи';
COMMENT ON COLUMN common_dict_message_direction.label IS 'Наименование';
COMMENT ON COLUMN common_dict_message_direction.description IS 'Описание';
COMMENT ON COLUMN common_dict_message_direction.created_timestamp IS 'Дата и время создания записи';
COMMENT ON COLUMN common_dict_message_direction.modified_timestamp IS 'Дата и время последнего изменения записи';
COMMENT ON COLUMN common_dict_message_direction.is_deleted IS 'Признак удалённой записи';
COMMENT ON COLUMN common_dict_message_direction.is_relevant IS 'Признак активности записи';

-- Генерация "Структура церкви" таблиц
-- Prefix: structure_

-- Словарь Тип структуры церкви
-- Table: structure_dict_type

CREATE TABLE structure_dict_type
(
  unique_id          BIGSERIAL                NOT NULL, -- Идентификатор записи. Первичный ключ
  uuid               UUID                     NOT NULL, -- UUID
  name               CHARACTER VARYING, -- Мнемоника
  code               BIGINT, -- Код записи словарного значения
  label              CHARACTER VARYING        NOT NULL, -- Наименование
  description        CHARACTER VARYING, -- Описание
  created_timestamp  TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT statement_timestamp(), -- Дата и время создания записи
  modified_timestamp TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT statement_timestamp(), -- Дата и время изменения записи
  is_deleted         BOOLEAN                           DEFAULT FALSE, -- Признак удалённой записи
  is_relevant        BOOLEAN DEFAULT TRUE, -- Признак активности записи
  CONSTRAINT structure_dict_type_pkey PRIMARY KEY (unique_id),
  CONSTRAINT structure_dict_type_code_key UNIQUE (code)
)
WITH (
OIDS = FALSE
);
ALTER TABLE structure_dict_type
  OWNER TO monkey_user;
COMMENT ON TABLE structure_dict_type
IS 'Таблица, содержащая атрибуты объекта - тип структуры';
COMMENT ON COLUMN structure_dict_type.unique_id IS 'Идентификатор записи. Первичный ключ';
COMMENT ON COLUMN structure_dict_type.uuid IS 'uuid объекта';
COMMENT ON COLUMN structure_dict_type.name IS 'Мнемоника';
COMMENT ON COLUMN structure_dict_type.code IS 'Код записи';
COMMENT ON COLUMN structure_dict_type.label IS 'Наименование';
COMMENT ON COLUMN structure_dict_type.description IS 'Описание';
COMMENT ON COLUMN structure_dict_type.created_timestamp IS 'Дата и время создания записи';
COMMENT ON COLUMN structure_dict_type.modified_timestamp IS 'Дата и время последнего изменения записи';
COMMENT ON COLUMN structure_dict_type.is_deleted IS 'Признак удалённой записи';
COMMENT ON COLUMN structure_dict_type.is_relevant IS 'Признак активности записи';

-- Словарь Город
-- Table: structure_dict_town

CREATE TABLE structure_dict_town
(
  unique_id          BIGSERIAL                NOT NULL, -- Идентификатор записи. Первичный ключ
  uuid               UUID                     NOT NULL, -- UUID
  name               CHARACTER VARYING, -- Мнемоника
  code               BIGINT, -- Код записи словарного значения
  label              CHARACTER VARYING        NOT NULL, -- Наименование
  description        CHARACTER VARYING, -- Описание
  created_timestamp  TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT statement_timestamp(), -- Дата и время создания записи
  modified_timestamp TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT statement_timestamp(), -- Дата и время изменения записи
  is_deleted         BOOLEAN                           DEFAULT FALSE, -- Признак удалённой записи
  is_relevant        BOOLEAN DEFAULT TRUE, -- Признак активности записи
  CONSTRAINT structure_dict_town_pkey PRIMARY KEY (unique_id),
  CONSTRAINT structure_dict_town_code_key UNIQUE (code)
)
WITH (
OIDS = FALSE
);
ALTER TABLE structure_dict_town
  OWNER TO monkey_user;
COMMENT ON TABLE structure_dict_town
IS 'Таблица, содержащая атрибуты объекта - Город';
COMMENT ON COLUMN structure_dict_town.unique_id IS 'Идентификатор записи. Первичный ключ';
COMMENT ON COLUMN structure_dict_town.uuid IS 'uuid объекта';
COMMENT ON COLUMN structure_dict_town.name IS 'Мнемоника';
COMMENT ON COLUMN structure_dict_town.code IS 'Код записи';
COMMENT ON COLUMN structure_dict_town.label IS 'Наименование';
COMMENT ON COLUMN structure_dict_town.description IS 'Описание';
COMMENT ON COLUMN structure_dict_town.created_timestamp IS 'Дата и время создания записи';
COMMENT ON COLUMN structure_dict_town.modified_timestamp IS 'Дата и время последнего изменения записи';
COMMENT ON COLUMN structure_dict_town.is_deleted IS 'Признак удалённой записи';
COMMENT ON COLUMN structure_dict_town.is_relevant IS 'Признак активности записи';

-- Словарь Метро
-- Table: structure_dict_metro

CREATE TABLE structure_dict_metro
(
  unique_id          BIGSERIAL                NOT NULL, -- Идентификатор записи. Первичный ключ
  uuid               UUID                     NOT NULL, -- UUID
  name               CHARACTER VARYING, -- Мнемоника
  code               BIGINT, -- Код записи словарного значения
  label              CHARACTER VARYING        NOT NULL, -- Наименование
  description        CHARACTER VARYING, -- Описание
  created_timestamp  TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT statement_timestamp(), -- Дата и время создания записи
  modified_timestamp TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT statement_timestamp(), -- Дата и время изменения записи
  is_deleted         BOOLEAN                           DEFAULT FALSE, -- Признак удалённой записи
  is_relevant        BOOLEAN DEFAULT TRUE, -- Признак активности записи
  town_ref           BIGINT, -- ссылка на объект Город
  CONSTRAINT structure_dict_metro_pkey PRIMARY KEY (unique_id),
  CONSTRAINT structure_dict_metro_code_key UNIQUE (code),
  CONSTRAINT structure_metro_town_fkey FOREIGN KEY (town_ref)
  REFERENCES structure_dict_town (code) MATCH SIMPLE
  ON UPDATE RESTRICT ON DELETE RESTRICT
)
WITH (
OIDS = FALSE
);
ALTER TABLE structure_dict_metro
  OWNER TO monkey_user;
COMMENT ON TABLE structure_dict_metro
IS 'Таблица, содержащая атрибуты объекта - Метро';
COMMENT ON COLUMN structure_dict_metro.unique_id IS 'Идентификатор записи. Первичный ключ';
COMMENT ON COLUMN structure_dict_metro.uuid IS 'uuid объекта';
COMMENT ON COLUMN structure_dict_metro.name IS 'Мнемоника';
COMMENT ON COLUMN structure_dict_metro.code IS 'Код записи';
COMMENT ON COLUMN structure_dict_metro.label IS 'Наименование';
COMMENT ON COLUMN structure_dict_metro.description IS 'Описание';
COMMENT ON COLUMN structure_dict_metro.created_timestamp IS 'Дата и время создания записи';
COMMENT ON COLUMN structure_dict_metro.modified_timestamp IS 'Дата и время последнего изменения записи';
COMMENT ON COLUMN structure_dict_metro.is_deleted IS 'Признак удалённой записи';
COMMENT ON COLUMN structure_dict_metro.is_relevant IS 'Признак активности записи';
COMMENT ON COLUMN structure_dict_metro.town_ref IS 'Город';

-- Таблица содержащая описание структуру Церкви
-- Table: structure_member

CREATE TABLE structure_member
(
  unique_id             BIGSERIAL                NOT NULL, -- Идентификатор записи. Первичный ключ
  uuid                  UUID                     NOT NULL, -- UUID
  name                  CHARACTER VARYING, -- Наименование объекта
  label                 CHARACTER VARYING, -- Наименование церкви
  author                BIGINT NOT NULL, -- Пользователь, создавший объект
  created_timestamp     TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT statement_timestamp(), -- Дата и время создания записи
  modifier              BIGINT NOT NULL, -- Пользователь, последним изменивший объект
  modified_timestamp    TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT statement_timestamp(), -- Дата и время изменения записи
  is_deleted            BOOLEAN                           DEFAULT FALSE, -- Признак удалённой записи
  is_relevant           BOOLEAN DEFAULT TRUE, -- Признак активности записи
  parent_id             BIGINT, -- ссылка на родительский объект
  type_ref              BIGINT NOT NULL, -- ссылка на тип структуры
  address               CHARACTER VARYING, -- Адрес
  coordination          CHARACTER VARYING, -- Геолокация
  town_ref              BIGINT, -- ссылка на объект Город
  metro_ref             BIGINT, -- ссылка на объект Метро
  coordination_latitude  double precision, -- Ширина
  coordination_longtitude double precision, -- Долгота
  CONSTRAINT structure_member_pkey PRIMARY KEY (unique_id),
  CONSTRAINT structure_member_author_fkey FOREIGN KEY (author)
  REFERENCES sys_users (unique_id) MATCH SIMPLE
  ON UPDATE RESTRICT ON DELETE RESTRICT,
  CONSTRAINT structure_member_modifier_fkey FOREIGN KEY (modifier)
  REFERENCES sys_users (unique_id) MATCH SIMPLE
  ON UPDATE RESTRICT ON DELETE RESTRICT,
  CONSTRAINT structure_member_type_fkey FOREIGN KEY (type_ref)
  REFERENCES structure_dict_type (code) MATCH SIMPLE
  ON UPDATE RESTRICT ON DELETE RESTRICT,
  CONSTRAINT structure_member_town_fkey FOREIGN KEY (town_ref)
  REFERENCES structure_dict_town (code) MATCH SIMPLE
  ON UPDATE RESTRICT ON DELETE RESTRICT,
  CONSTRAINT structure_member_metro_fkey FOREIGN KEY (metro_ref)
  REFERENCES structure_dict_metro (code) MATCH SIMPLE
  ON UPDATE RESTRICT ON DELETE RESTRICT
)
WITH (
OIDS = FALSE
);
ALTER TABLE structure_member
  OWNER TO monkey_user;
COMMENT ON TABLE structure_member
IS 'Таблица, содержащая информацию об структуре, в том числе объект храм';
COMMENT ON COLUMN structure_member.unique_id IS 'Идентификатор записи. Первичный ключ';
COMMENT ON COLUMN structure_member.uuid IS 'UUID записи';
COMMENT ON COLUMN structure_member.name IS 'Наименование';
COMMENT ON COLUMN structure_member.parent_id IS 'Ссылка на родительский объект';
COMMENT ON COLUMN structure_member.author IS 'Пользователь, создавший объект';
COMMENT ON COLUMN structure_member.created_timestamp IS 'Дата и время создания записи';
COMMENT ON COLUMN structure_member.modifier IS 'Пользователь, последним изменивший объект';
COMMENT ON COLUMN structure_member.modified_timestamp IS 'Дата и время последнего изменения записи';
COMMENT ON COLUMN structure_member.is_deleted IS 'Признак удалённой записи';
COMMENT ON COLUMN structure_member.is_relevant IS 'Признак активности записи';
COMMENT ON COLUMN structure_member.type_ref IS 'Тип сруктуры';
COMMENT ON COLUMN structure_member.address IS 'Адрес';
COMMENT ON COLUMN structure_member.coordination IS 'Геолокация';
COMMENT ON COLUMN structure_member.town_ref IS 'Город';
COMMENT ON COLUMN structure_member.coordination_latitude IS 'Ширина';
COMMENT ON COLUMN structure_member.coordination_longtitude IS 'Долгота';

--Добавление Объекта структуры Храма в учетную запись Пользователя. Для Мирянина означает привязка его к храму
alter table sys_users add column member_ref BIGINT;
alter table sys_users add  CONSTRAINT sys_users_member_fkey FOREIGN KEY (member_ref)
REFERENCES structure_member (unique_id) MATCH SIMPLE
ON UPDATE RESTRICT ON DELETE RESTRICT;

-- Таблица содержащая описание карточки Храма
-- Table: structure_hram

CREATE TABLE structure_hram
(
  unique_id             BIGSERIAL                NOT NULL, -- Идентификатор записи. Первичный ключ
  uuid                  UUID                     NOT NULL, -- UUID
  author                BIGINT NOT NULL, -- Пользователь, создавший объект
  created_timestamp     TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT statement_timestamp(), -- Дата и время создания записи
  modifier              BIGINT NOT NULL, -- Пользователь, последним изменивший объект
  modified_timestamp    TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT statement_timestamp(), -- Дата и время изменения записи
  is_deleted            BOOLEAN                           DEFAULT FALSE, -- Признак удалённой записи
  is_relevant           BOOLEAN DEFAULT TRUE, -- Признак активности записи
  structure_ref         BIGINT, -- Ссылка на структуру
  photo                 CHARACTER VARYING, -- Ссылка на фотографию храма
  description           CHARACTER VARYING, -- Описание храма
  web_url               CHARACTER VARYING, -- Веб страница
  contacts              CHARACTER VARYING, -- Контакты Храма
  history               CHARACTER VARYING, -- История Храма
  religion              CHARACTER VARYING, -- Святыни Храма
  start_work_time       time without time zone NOT NULL,
  finish_work_time      time without time zone NOT NULL,
  visible_priests       BOOLEAN, -- Святыни Храма
  CONSTRAINT structure_hram_pkey PRIMARY KEY (unique_id),
  CONSTRAINT structure_hram_author_fkey FOREIGN KEY (author)
  REFERENCES sys_users (unique_id) MATCH SIMPLE
  ON UPDATE RESTRICT ON DELETE RESTRICT,
  CONSTRAINT structure_hram_modifier_fkey FOREIGN KEY (modifier)
  REFERENCES sys_users (unique_id) MATCH SIMPLE
  ON UPDATE RESTRICT ON DELETE RESTRICT,
  CONSTRAINT structure_hram_mstructure_fkey FOREIGN KEY (structure_ref)
  REFERENCES structure_member (unique_id) MATCH SIMPLE
  ON UPDATE RESTRICT ON DELETE RESTRICT
)
WITH (
OIDS = FALSE
);
ALTER TABLE structure_hram
  OWNER TO monkey_user;
COMMENT ON TABLE structure_hram
IS 'Таблица, содержащая информацию о карточке Храма';
COMMENT ON COLUMN structure_hram.unique_id IS 'Идентификатор записи. Первичный ключ';
COMMENT ON COLUMN structure_hram.uuid IS 'UUID записи';
COMMENT ON COLUMN structure_hram.author IS 'Пользователь, создавший объект';
COMMENT ON COLUMN structure_hram.created_timestamp IS 'Дата и время создания записи';
COMMENT ON COLUMN structure_hram.modifier IS 'Пользователь, последним изменивший объект';
COMMENT ON COLUMN structure_hram.modified_timestamp IS 'Дата и время последнего изменения записи';
COMMENT ON COLUMN structure_hram.is_deleted IS 'Признак удалённой записи';
COMMENT ON COLUMN structure_hram.is_relevant IS 'Признак активности записи';
COMMENT ON COLUMN structure_hram.structure_ref IS 'Ссылка на объект структуры';
COMMENT ON COLUMN structure_hram.photo IS 'Фотография';
COMMENT ON COLUMN structure_hram.description IS 'Описание храма';
COMMENT ON COLUMN structure_hram.web_url IS 'Web url';
COMMENT ON COLUMN structure_hram.contacts IS 'Контакты';
COMMENT ON COLUMN structure_hram.history IS 'История храма';
COMMENT ON COLUMN structure_hram.religion IS 'Святыни храма';
COMMENT ON COLUMN structure_hram.start_work_time IS 'Время начало работы Храма';
COMMENT ON COLUMN structure_hram.finish_work_time IS 'Время окончания работы Храма';
COMMENT ON COLUMN structure_hram.visible_priests IS 'Отображение священнослужителей при записи на беседу';

-- Словарь тип деятельности
-- Table: structure_dict_activity

CREATE TABLE structure_dict_activity
(
  unique_id          BIGSERIAL                NOT NULL, -- Идентификатор записи. Первичный ключ
  uuid               UUID                     NOT NULL, -- UUID
  name               CHARACTER VARYING, -- Мнемоника
  code               BIGINT, -- Код записи словарного значения
  label              CHARACTER VARYING        NOT NULL, -- Наименование
  description        CHARACTER VARYING, -- Описание
  created_timestamp  TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT statement_timestamp(), -- Дата и время создания записи
  modified_timestamp TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT statement_timestamp(), -- Дата и время изменения записи
  is_deleted         BOOLEAN                           DEFAULT FALSE, -- Признак удалённой записи
  is_relevant        BOOLEAN DEFAULT TRUE, -- Признак активности записи
  CONSTRAINT structure_dict_activity_pkey PRIMARY KEY (unique_id),
  CONSTRAINT structure_dict_activity_code_key UNIQUE (code)
)
WITH (
OIDS = FALSE
);
ALTER TABLE structure_dict_activity
  OWNER TO monkey_user;
COMMENT ON TABLE structure_dict_activity
IS 'Таблица, содержащая атрибуты объекта - Тип деятельности';
COMMENT ON COLUMN structure_dict_activity.unique_id IS 'Идентификатор записи. Первичный ключ';
COMMENT ON COLUMN structure_dict_activity.uuid IS 'uuid объекта';
COMMENT ON COLUMN structure_dict_activity.name IS 'Мнемоника';
COMMENT ON COLUMN structure_dict_activity.name IS 'Код записи';
COMMENT ON COLUMN structure_dict_activity.label IS 'Наименование';
COMMENT ON COLUMN structure_dict_activity.description IS 'Описание';
COMMENT ON COLUMN structure_dict_activity.created_timestamp IS 'Дата и время создания записи';
COMMENT ON COLUMN structure_dict_activity.modified_timestamp IS 'Дата и время последнего изменения записи';
COMMENT ON COLUMN structure_dict_activity.is_deleted IS 'Признак удалённой записи';
COMMENT ON COLUMN structure_dict_activity.is_relevant IS 'Признак активности записи';

-- Связь храма и деятельности храма
-- Table: structure_link_hram_activity_gb

CREATE TABLE structure_link_hram_activity_gb
(
  unique_id             BIGSERIAL NOT NULL, -- Идентификатор записи. Первичный ключ
  description           CHARACTER VARYING, -- Описание
  hram_ref              BIGINT    NOT NULL, -- Ссылка на храм
  activity_ref          BIGINT    NOT NULL, -- Ссылка на тип деятельности
  CONSTRAINT structure_link_hram_activity_gb_pkey PRIMARY KEY (unique_id),
  CONSTRAINT structure_link_hram_ref_fkey FOREIGN KEY (hram_ref)
  REFERENCES structure_hram (unique_id) MATCH SIMPLE
  ON UPDATE RESTRICT ON DELETE RESTRICT,
  CONSTRAINT structure_link_activity_ref_fkey FOREIGN KEY (activity_ref)
  REFERENCES structure_dict_activity (code) MATCH SIMPLE
  ON UPDATE RESTRICT ON DELETE RESTRICT
)
WITH (
OIDS = FALSE
);
ALTER TABLE structure_link_hram_activity_gb
  OWNER TO monkey_user;
COMMENT ON TABLE structure_link_hram_activity_gb
IS 'Таблица, содержащая атрибуты объекта - Таблица связи храма и деятельности храма';
COMMENT ON COLUMN structure_link_hram_activity_gb.unique_id IS 'Идентификатор записи. Первичный ключ';
COMMENT ON COLUMN structure_link_hram_activity_gb.description IS 'Описание';
COMMENT ON COLUMN structure_link_hram_activity_gb.hram_ref IS 'Ссылка на храм';
COMMENT ON COLUMN structure_link_hram_activity_gb.activity_ref IS 'Ссылка на тип деятельности';


-- Связь храма и дежурного и рабочего дня
-- Table: structure_link_users_duty_gb

CREATE TABLE structure_link_users_duty_gb
(
  unique_id             BIGSERIAL NOT NULL, -- Идентификатор записи. Первичный ключ
  description           CHARACTER VARYING, -- Описание
  hram_ref              BIGINT    NOT NULL, -- Ссылка на храм
  user_ref              BIGINT    NOT NULL, -- Ссылка на тип деятельности
  date_ref              DATE      NOT NULL, -- Дата на которую назначен дежурный
  CONSTRAINT structure_link_users_duty_gb_pkey PRIMARY KEY (unique_id),
  CONSTRAINT structure_link_users_duty_gb_hram_ref_fkey FOREIGN KEY (hram_ref)
  REFERENCES structure_hram (unique_id) MATCH SIMPLE
  ON UPDATE RESTRICT ON DELETE RESTRICT,
  CONSTRAINT structure_link_users_duty_gb_user_fkey FOREIGN KEY (user_ref)
  REFERENCES sys_users (unique_id) MATCH SIMPLE
  ON UPDATE RESTRICT ON DELETE RESTRICT
)
WITH (
OIDS = FALSE
);
ALTER TABLE structure_link_users_duty_gb
  OWNER TO monkey_user;
COMMENT ON TABLE structure_link_users_duty_gb
IS 'Таблица, содержащая атрибуты объекта - Таблица связи храма и дежурного на день';
COMMENT ON COLUMN structure_link_users_duty_gb.unique_id IS 'Идентификатор записи. Первичный ключ';
COMMENT ON COLUMN structure_link_users_duty_gb.description IS 'Описание';
COMMENT ON COLUMN structure_link_users_duty_gb.hram_ref IS 'Ссылка на храм';
COMMENT ON COLUMN structure_link_users_duty_gb.user_ref IS 'Ссылка на дежурного';
COMMENT ON COLUMN structure_link_users_duty_gb.date_ref IS 'Дата дежурства';

-- Генерация таблиц для описания объектов библиотеки
-- Prefix: library_

-- Словарь Тематика библиотеки
-- Table: library_dict_type

CREATE TABLE library_dict_type
(
  unique_id          BIGSERIAL                NOT NULL, -- Идентификатор записи. Первичный ключ
  uuid               UUID                     NOT NULL, -- UUID
  name               CHARACTER VARYING, -- Мнемоника
  code               BIGINT, -- Код записи словарного значения
  label              CHARACTER VARYING        NOT NULL, -- Наименование
  description        CHARACTER VARYING, -- Описание
  created_timestamp  TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT statement_timestamp(), -- Дата и время создания записи
  modified_timestamp TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT statement_timestamp(), -- Дата и время изменения записи
  is_deleted         BOOLEAN                           DEFAULT FALSE, -- Признак удалённой записи
  is_relevant        BOOLEAN DEFAULT TRUE, -- Признак активности записи
  CONSTRAINT library_dict_type_pkey PRIMARY KEY (unique_id),
  CONSTRAINT library_dict_type_code_key UNIQUE (code)
)
WITH (
OIDS = FALSE
);
ALTER TABLE library_dict_type
  OWNER TO monkey_user;
COMMENT ON TABLE library_dict_type
IS 'Таблица, содержащая атрибуты объекта - Тематика библиотеки';
COMMENT ON COLUMN library_dict_type.unique_id IS 'Идентификатор записи. Первичный ключ';
COMMENT ON COLUMN library_dict_type.uuid IS 'uuid объекта';
COMMENT ON COLUMN library_dict_type.name IS 'Мнемоника';
COMMENT ON COLUMN library_dict_type.name IS 'Код записи';
COMMENT ON COLUMN library_dict_type.label IS 'Наименование';
COMMENT ON COLUMN library_dict_type.description IS 'Описание';
COMMENT ON COLUMN library_dict_type.created_timestamp IS 'Дата и время создания записи';
COMMENT ON COLUMN library_dict_type.modified_timestamp IS 'Дата и время последнего изменения записи';
COMMENT ON COLUMN library_dict_type.is_deleted IS 'Признак удалённой записи';
COMMENT ON COLUMN library_dict_type.is_relevant IS 'Признак активности записи';


-- Таблица содержащая описание карточки записи библиотеки
-- Table: library_object

CREATE TABLE library_object
(
  unique_id             BIGSERIAL                NOT NULL, -- Идентификатор записи. Первичный ключ
  uuid                  UUID                     NOT NULL, -- UUID
  author                BIGINT NOT NULL, -- Пользователь, создавший объект
  created_timestamp     TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT statement_timestamp(), -- Дата и время создания записи
  modifier              BIGINT NOT NULL, -- Пользователь, последним изменивший объект
  modified_timestamp    TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT statement_timestamp(), -- Дата и время изменения записи
  is_deleted            BOOLEAN                           DEFAULT FALSE, -- Признак удалённой записи
  is_relevant           BOOLEAN DEFAULT TRUE, -- Признак активности записи
  type_ref              BIGINT NOT NULL, -- Ссылка на тематику записи библиотеки
  name                  CHARACTER VARYING, -- Мнемоника
  url                   CHARACTER VARYING, -- Ссылка на внешний ресурс
  description           CHARACTER VARYING, -- Описание
  author_ref            CHARACTER VARYING, -- Автор
  published             BOOLEAN, -- Признак публикации записи
  file_ref              CHARACTER VARYING, -- Адрес файла в хранилище
  label                 CHARACTER VARYING, -- Наименование записи библиотеки
  CONSTRAINT library_object_pkey PRIMARY KEY (unique_id),
  CONSTRAINT library_object_author_fkey FOREIGN KEY (author)
  REFERENCES sys_users (unique_id) MATCH SIMPLE
  ON UPDATE RESTRICT ON DELETE RESTRICT,
  CONSTRAINT library_object_modifier_fkey FOREIGN KEY (modifier)
  REFERENCES sys_users (unique_id) MATCH SIMPLE
  ON UPDATE RESTRICT ON DELETE RESTRICT,
  CONSTRAINT library_object_type_fkey FOREIGN KEY (type_ref)
  REFERENCES library_dict_type (code) MATCH SIMPLE
  ON UPDATE RESTRICT ON DELETE RESTRICT
)
WITH (
OIDS = FALSE
);
ALTER TABLE library_object
  OWNER TO monkey_user;
COMMENT ON TABLE library_object
IS 'Таблица, содержащая информацию об объекте библиотеки';
COMMENT ON COLUMN library_object.unique_id IS 'Идентификатор записи. Первичный ключ';
COMMENT ON COLUMN library_object.uuid IS 'UUID записи';
COMMENT ON COLUMN library_object.author IS 'Пользователь, создавший объект';
COMMENT ON COLUMN library_object.created_timestamp IS 'Дата и время создания записи';
COMMENT ON COLUMN library_object.modifier IS 'Пользователь, последним изменивший объект';
COMMENT ON COLUMN library_object.modified_timestamp IS 'Дата и время последнего изменения записи';
COMMENT ON COLUMN library_object.is_deleted IS 'Признак удалённой записи';
COMMENT ON COLUMN library_object.is_relevant IS 'Признак активности записи';
COMMENT ON COLUMN library_object.type_ref IS 'Тематика';
COMMENT ON COLUMN library_object.name IS 'Мнемоника';
COMMENT ON COLUMN library_object.url IS 'Ссылка на внешний ресурс';
COMMENT ON COLUMN library_object.description IS 'Описание';
COMMENT ON COLUMN library_object.author_ref IS 'Автор';
COMMENT ON COLUMN library_object.published IS 'Публикация';
COMMENT ON COLUMN library_object.file_ref IS 'Ссылка на файл';
COMMENT ON COLUMN library_object.label IS 'Наименование записи библиотеки';


-- Генерация таблиц для описания объектов уведомлений
-- Prefix: message_

-- Таблица содержащая типы уведомлений (способов доставки)
-- Table: message_dict_type

CREATE TABLE message_dict_type
(
  unique_id          BIGSERIAL                NOT NULL, -- Идентификатор записи. Первичный ключ
  uuid               UUID                     NOT NULL, -- UUID
  name               CHARACTER VARYING, -- Мнемоника
  code               BIGINT, -- Код записи словарного значения
  label              CHARACTER VARYING        NOT NULL, -- Наименование
  description        CHARACTER VARYING, -- Описание
  created_timestamp  TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT statement_timestamp(), -- Дата и время создания записи
  modified_timestamp TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT statement_timestamp(), -- Дата и время изменения записи
  is_deleted         BOOLEAN                           DEFAULT FALSE, -- Признак удалённой записи
  is_relevant        BOOLEAN DEFAULT TRUE, -- Признак активности записи
  CONSTRAINT message_dict_type_pkey PRIMARY KEY (unique_id),
  CONSTRAINT message_dict_type_code_key UNIQUE (code)
)
WITH (
OIDS = FALSE
);
ALTER TABLE message_dict_type
  OWNER TO monkey_user;
COMMENT ON TABLE message_dict_type
IS 'Таблица, содержащая атрибуты объекта - Способы доставки уведомлений';
COMMENT ON COLUMN message_dict_type.unique_id IS 'Идентификатор записи. Первичный ключ';
COMMENT ON COLUMN message_dict_type.uuid IS 'uuid объекта';
COMMENT ON COLUMN message_dict_type.name IS 'Мнемоника';
COMMENT ON COLUMN message_dict_type.name IS 'Код записи';
COMMENT ON COLUMN message_dict_type.label IS 'Наименование';
COMMENT ON COLUMN message_dict_type.description IS 'Описание';
COMMENT ON COLUMN message_dict_type.created_timestamp IS 'Дата и время создания записи';
COMMENT ON COLUMN message_dict_type.modified_timestamp IS 'Дата и время последнего изменения записи';
COMMENT ON COLUMN message_dict_type.is_deleted IS 'Признак удалённой записи';
COMMENT ON COLUMN message_dict_type.is_relevant IS 'Признак активности записи';

-- Таблица содержащая шаблоны уведомлений
-- Table: message_dict_template

CREATE TABLE message_dict_template
(
  unique_id          BIGSERIAL                NOT NULL, -- Идентификатор записи. Первичный ключ
  uuid               UUID                     NOT NULL, -- UUID
  name               CHARACTER VARYING, -- Мнемоника
  code               BIGINT, -- Код записи словарного значения
  label              CHARACTER VARYING        NOT NULL, -- Наименование
  description        CHARACTER VARYING, -- Текст уведомления
  created_timestamp  TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT statement_timestamp(), -- Дата и время создания записи
  modified_timestamp TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT statement_timestamp(), -- Дата и время изменения записи
  is_deleted         BOOLEAN                           DEFAULT FALSE, -- Признак удалённой записи
  is_relevant        BOOLEAN DEFAULT TRUE, -- Признак активности записи
  CONSTRAINT message_dict_template_pkey PRIMARY KEY (unique_id),
  CONSTRAINT message_dict_template_code_key UNIQUE (code)
)
WITH (
OIDS = FALSE
);
ALTER TABLE message_dict_template
  OWNER TO monkey_user;
COMMENT ON TABLE message_dict_template
IS 'Таблица, содержащая атрибуты объекта - Шаблоны уведомлений';
COMMENT ON COLUMN message_dict_template.unique_id IS 'Идентификатор записи. Первичный ключ';
COMMENT ON COLUMN message_dict_template.uuid IS 'uuid объекта';
COMMENT ON COLUMN message_dict_template.name IS 'Мнемоника';
COMMENT ON COLUMN message_dict_template.name IS 'Код записи';
COMMENT ON COLUMN message_dict_template.label IS 'Наименование';
COMMENT ON COLUMN message_dict_template.description IS 'Текст уведомления';
COMMENT ON COLUMN message_dict_template.created_timestamp IS 'Дата и время создания записи';
COMMENT ON COLUMN message_dict_template.modified_timestamp IS 'Дата и время последнего изменения записи';
COMMENT ON COLUMN message_dict_template.is_deleted IS 'Признак удалённой записи';
COMMENT ON COLUMN message_dict_template.is_relevant IS 'Признак активности записи';


-- Таблица содержащая объекты уведомления
-- Table: message_object

CREATE TABLE message_object
(
  unique_id             BIGSERIAL                NOT NULL, -- Идентификатор записи. Первичный ключ
  uuid                  UUID                     NOT NULL, -- UUID
  author                BIGINT NOT NULL, -- Пользователь, создавший объект
  created_timestamp     TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT statement_timestamp(), -- Дата и время создания записи
  modifier              BIGINT NOT NULL, -- Пользователь, последним изменивший объект
  modified_timestamp    TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT statement_timestamp(), -- Дата и время изменения записи
  is_deleted            BOOLEAN                           DEFAULT FALSE, -- Признак удалённой записи
  is_relevant           BOOLEAN DEFAULT TRUE, -- Признак активности записи
  type_ref              BIGINT, -- Сбособ доставки уведомления
  user_ref              BIGINT, -- Получатель уведомления
  text_message          CHARACTER VARYING, -- Текст сообщения
  is_read               BOOLEAN     DEFAULT FALSE, -- Признак что сообщение прочитано
  CONSTRAINT message_object_pkey PRIMARY KEY (unique_id),
  CONSTRAINT message_object_author_fkey FOREIGN KEY (author)
  REFERENCES sys_users (unique_id) MATCH SIMPLE
  ON UPDATE RESTRICT ON DELETE RESTRICT,
  CONSTRAINT message_object_modifier_fkey FOREIGN KEY (modifier)
  REFERENCES sys_users (unique_id) MATCH SIMPLE
  ON UPDATE RESTRICT ON DELETE RESTRICT,
  CONSTRAINT message_object_user_fkey FOREIGN KEY (user_ref)
  REFERENCES sys_users (unique_id) MATCH SIMPLE
  ON UPDATE RESTRICT ON DELETE RESTRICT,
  CONSTRAINT message_object_type_fkey FOREIGN KEY (type_ref)
  REFERENCES message_dict_type (code) MATCH SIMPLE
  ON UPDATE RESTRICT ON DELETE RESTRICT
)
WITH (
OIDS = FALSE
);
ALTER TABLE message_object
  OWNER TO monkey_user;
COMMENT ON TABLE message_object
IS 'Таблица, содержащая информацию об уведомления';
COMMENT ON COLUMN message_object.unique_id IS 'Идентификатор записи. Первичный ключ';
COMMENT ON COLUMN message_object.uuid IS 'UUID записи';
COMMENT ON COLUMN message_object.author IS 'Пользователь, создавший объект';
COMMENT ON COLUMN message_object.created_timestamp IS 'Дата и время создания записи';
COMMENT ON COLUMN message_object.modifier IS 'Пользователь, последним изменивший объект';
COMMENT ON COLUMN message_object.modified_timestamp IS 'Дата и время последнего изменения записи';
COMMENT ON COLUMN message_object.is_deleted IS 'Признак удалённой записи';
COMMENT ON COLUMN message_object.is_relevant IS 'Признак активности записи';
COMMENT ON COLUMN message_object.type_ref IS 'Способ доставки уведомления';
COMMENT ON COLUMN message_object.user_ref IS 'Получатель';
COMMENT ON COLUMN message_object.text_message IS 'Текст сообщения';
COMMENT ON COLUMN message_object.is_read IS 'Признак чтения';


-- Генерация таблиц для описания объектов связанного с календарем
-- Prefix: calendar_


-- Таблица содержащая описание общехрамового календаря
-- Table: calendar_full

CREATE TABLE calendar_full
(
  unique_id             BIGSERIAL                NOT NULL, -- Идентификатор записи. Первичный ключ
  uuid                  UUID                     NOT NULL, -- UUID
  author                BIGINT NOT NULL, -- Пользователь, создавший объект
  created_timestamp     TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT statement_timestamp(), -- Дата и время создания записи
  modifier              BIGINT NOT NULL, -- Пользователь, последним изменивший объект
  modified_timestamp    TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT statement_timestamp(), -- Дата и время изменения записи
  is_deleted            BOOLEAN                           DEFAULT FALSE, -- Признак удалённой записи
  is_relevant           BOOLEAN, -- Признак активности записи
  date_ref              DATE, -- Дата события
  description           CHARACTER VARYING, -- Текст события
  CONSTRAINT calendar_full_pkey PRIMARY KEY (unique_id)
)
WITH (
OIDS = FALSE
);
ALTER TABLE calendar_full
  OWNER TO monkey_user;
COMMENT ON TABLE calendar_full
IS 'Таблица, содержащая информацию об общехрамовом календаре';
COMMENT ON COLUMN calendar_full.unique_id IS 'Идентификатор записи. Первичный ключ';
COMMENT ON COLUMN calendar_full.uuid IS 'UUID записи';
COMMENT ON COLUMN calendar_full.author IS 'Пользователь, создавший объект';
COMMENT ON COLUMN calendar_full.created_timestamp IS 'Дата и время создания записи';
COMMENT ON COLUMN calendar_full.modifier IS 'Пользователь, последним изменивший объект';
COMMENT ON COLUMN calendar_full.modified_timestamp IS 'Дата и время последнего изменения записи';
COMMENT ON COLUMN calendar_full.is_deleted IS 'Признак удалённой записи';
COMMENT ON COLUMN calendar_full.is_relevant IS 'Признак активности записи';
COMMENT ON COLUMN calendar_full.date_ref IS 'Дата события';
COMMENT ON COLUMN calendar_full.description IS 'Текст события';


-- Таблица содержащая описание храмового календаря
-- Table: calendar_hram

CREATE TABLE calendar_hram
(
  unique_id             BIGSERIAL                NOT NULL, -- Идентификатор записи. Первичный ключ
  uuid                  UUID                     NOT NULL, -- UUID
  created_timestamp     TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT statement_timestamp(), -- Дата и время создания записи
  modified_timestamp    TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT statement_timestamp(), -- Дата и время изменения записи
  is_deleted            BOOLEAN                           DEFAULT FALSE, -- Признак удалённой записи
  is_relevant           BOOLEAN DEFAULT TRUE, -- Признак активности записи
  date_ref              DATE, -- Дата события
  description           CHARACTER VARYING, -- Текст события
  author                BIGINT NOT NULL, -- Пользователь, создавший объект
  modifier              BIGINT NOT NULL, -- Пользователь, последним изменивший объект
  hram_ref				BIGINT, --Храм
  CONSTRAINT calendar_hram_pkey PRIMARY KEY (unique_id),
  CONSTRAINT calendar_hram_author_fkey FOREIGN KEY (author)
  REFERENCES sys_users (unique_id) MATCH SIMPLE
  ON UPDATE RESTRICT ON DELETE RESTRICT,
  CONSTRAINT calendar_hram_modifier_fkey FOREIGN KEY (modifier)
  REFERENCES sys_users (unique_id) MATCH SIMPLE
  ON UPDATE RESTRICT ON DELETE RESTRICT,
  CONSTRAINT calendar_hram_hram_fkey FOREIGN KEY (hram_ref)
  REFERENCES structure_hram (unique_id) MATCH SIMPLE
  ON UPDATE RESTRICT ON DELETE RESTRICT
)
WITH (
OIDS = FALSE
);
ALTER TABLE calendar_hram
  OWNER TO monkey_user;
COMMENT ON TABLE calendar_hram
IS 'Таблица, содержащая информацию о календаре храма';
COMMENT ON COLUMN calendar_hram.unique_id IS 'Идентификатор записи. Первичный ключ';
COMMENT ON COLUMN calendar_hram.uuid IS 'UUID записи';
COMMENT ON COLUMN calendar_hram.created_timestamp IS 'Дата и время создания записи';
COMMENT ON COLUMN calendar_hram.modified_timestamp IS 'Дата и время последнего изменения записи';
COMMENT ON COLUMN calendar_hram.is_deleted IS 'Признак удалённой записи';
COMMENT ON COLUMN calendar_hram.is_relevant IS 'Признак активности записи';
COMMENT ON COLUMN calendar_hram.date_ref IS 'Дата события';
COMMENT ON COLUMN calendar_hram.description IS 'Текст события';
COMMENT ON COLUMN calendar_hram.author IS 'Пользователь, создавший объект';
COMMENT ON COLUMN calendar_hram.modifier IS 'Пользователь, последним изменивший объект';


-- Таблица содержащая описание календаря мирянина
-- Table: calendar_person

CREATE TABLE calendar_person
(
  unique_id             BIGSERIAL                NOT NULL, -- Идентификатор записи. Первичный ключ
  uuid                  UUID                     NOT NULL, -- UUID
  created_timestamp     TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT statement_timestamp(), -- Дата и время создания записи
  modified_timestamp    TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT statement_timestamp(), -- Дата и время изменения записи
  is_deleted            BOOLEAN                           DEFAULT FALSE, -- Признак удалённой записи
  is_relevant           BOOLEAN, -- Признак активности записи
  date_ref              TIMESTAMP, -- Дата события
  description           CHARACTER VARYING, -- Текст события
  author                BIGINT NOT NULL, -- Пользователь, создавший объект
  modifier              BIGINT NOT NULL, -- Пользователь, последним изменивший объект
  CONSTRAINT calendar_person_pkey PRIMARY KEY (unique_id),
  CONSTRAINT calendar_person_author_fkey FOREIGN KEY (author)
  REFERENCES sys_users (unique_id) MATCH SIMPLE
  ON UPDATE RESTRICT ON DELETE RESTRICT,
  CONSTRAINT calendar_hram_modifier_fkey FOREIGN KEY (modifier)
  REFERENCES sys_users (unique_id) MATCH SIMPLE
  ON UPDATE RESTRICT ON DELETE RESTRICT
  )
WITH (
OIDS = FALSE
);
ALTER TABLE calendar_person
  OWNER TO monkey_user;
COMMENT ON TABLE calendar_person
IS 'Таблица, содержащая информацию о календаре мирянина';
COMMENT ON COLUMN calendar_person.unique_id IS 'Идентификатор записи. Первичный ключ';
COMMENT ON COLUMN calendar_person.uuid IS 'UUID записи';
COMMENT ON COLUMN calendar_person.created_timestamp IS 'Дата и время создания записи';
COMMENT ON COLUMN calendar_person.modified_timestamp IS 'Дата и время последнего изменения записи';
COMMENT ON COLUMN calendar_person.is_deleted IS 'Признак удалённой записи';
COMMENT ON COLUMN calendar_person.is_relevant IS 'Признак активности записи';
COMMENT ON COLUMN calendar_person.date_ref IS 'Дата события';
COMMENT ON COLUMN calendar_person.description IS 'Текст события';
COMMENT ON COLUMN calendar_person.author IS 'Пользователь, создавший объект';
COMMENT ON COLUMN calendar_person.modifier IS 'Пользователь, последним изменивший объект';


-- Генерация таблиц для описания объектов бесед (слотов)
-- Prefix: slots_

-- Словарь статусов для объектов бронирования
-- Table: slots_dict_status

CREATE TABLE slots_dict_status
(
  unique_id          BIGSERIAL                NOT NULL, -- Идентификатор записи. Первичный ключ
  uuid               UUID                     NOT NULL, -- UUID
  name               CHARACTER VARYING, -- Мнемоника
  code               BIGINT, -- Код записи словарного значения
  label              CHARACTER VARYING        NOT NULL, -- Наименование
  description        CHARACTER VARYING, -- Описание
  created_timestamp  TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT statement_timestamp(), -- Дата и время создания записи
  modified_timestamp TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT statement_timestamp(), -- Дата и время изменения записи
  is_deleted         BOOLEAN                           DEFAULT FALSE, -- Признак удалённой записи
  is_relevant        BOOLEAN DEFAULT TRUE, -- Признак активности записи
  CONSTRAINT slots_dict_status_pkey PRIMARY KEY (unique_id),
  CONSTRAINT slots_dict_status_code_key UNIQUE (code)
)
WITH (
OIDS = FALSE
);
ALTER TABLE slots_dict_status
  OWNER TO monkey_user;
COMMENT ON TABLE slots_dict_status
IS 'Таблица, содержащая атрибуты объекта - Статус процесса бронирования';
COMMENT ON COLUMN slots_dict_status.unique_id IS 'Идентификатор записи. Первичный ключ';
COMMENT ON COLUMN slots_dict_status.uuid IS 'uuid объекта';
COMMENT ON COLUMN slots_dict_status.name IS 'Мнемоника';
COMMENT ON COLUMN slots_dict_status.name IS 'Код записи';
COMMENT ON COLUMN slots_dict_status.label IS 'Наименование';
COMMENT ON COLUMN slots_dict_status.description IS 'Описание';
COMMENT ON COLUMN slots_dict_status.created_timestamp IS 'Дата и время создания записи';
COMMENT ON COLUMN slots_dict_status.modified_timestamp IS 'Дата и время последнего изменения записи';
COMMENT ON COLUMN slots_dict_status.is_deleted IS 'Признак удалённой записи';
COMMENT ON COLUMN slots_dict_status.is_relevant IS 'Признак активности записи';



-- Таблица содержащая описание объекта Слотов времени (беседа)
-- Table: slots_object

CREATE TABLE slots_object
(
  unique_id             BIGSERIAL                NOT NULL, -- Идентификатор записи. Первичный ключ
  uuid                  UUID                     NOT NULL, -- UUID
  author                BIGINT NOT NULL, -- Пользователь, создавший объект
  created_timestamp     TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT statement_timestamp(), -- Дата и время создания записи
  modifier              BIGINT NOT NULL, -- Пользователь, последним изменивший объект
  modified_timestamp    TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT statement_timestamp(), -- Дата и время изменения записи
  is_deleted            BOOLEAN                           DEFAULT FALSE, -- Признак удалённой записи
  is_relevant           BOOLEAN DEFAULT TRUE, -- Признак активности записи
  performer             BIGINT, -- Пользователь, являющийся исполнителем по слоту
  hram                  BIGINT, -- Ссылка на объект Храма
  status                BIGINT, -- Статус процесса бронирования
  object_type           BIGINT, -- Тип объекта - беседа
  auto_create           BOOLEAN                           DEFAULT FALSE, -- Признак, что запись создана автоматически (Дежурство)
  from_timestamp        TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT statement_timestamp(), -- Дата и время начала слота
  to_timestamp          TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT statement_timestamp(), -- Дата и время окончания слота
  is_report             BOOLEAN                           DEFAULT TRUE, -- Признак указания в отчете
  comment               CHARACTER VARYING, -- Комментарий к беседе
  result                BOOLEAN, -- Признак была проведена встреча или нет
  result_comment        CHARACTER VARYING, -- Комментарицй к результату
  CONSTRAINT slots_object_pkey PRIMARY KEY (unique_id),
  CONSTRAINT slots_object_author_fkey FOREIGN KEY (author)
  REFERENCES sys_users (unique_id) MATCH SIMPLE
  ON UPDATE RESTRICT ON DELETE RESTRICT,
  CONSTRAINT slots_object_modifier_fkey FOREIGN KEY (modifier)
  REFERENCES sys_users (unique_id) MATCH SIMPLE
  ON UPDATE RESTRICT ON DELETE RESTRICT,
  CONSTRAINT slots_object_performer_fkey FOREIGN KEY (performer)
  REFERENCES sys_users (unique_id) MATCH SIMPLE
  ON UPDATE RESTRICT ON DELETE RESTRICT,
  CONSTRAINT slots_object_hram_fkey FOREIGN KEY (hram)
  REFERENCES structure_member (unique_id) MATCH SIMPLE
  ON UPDATE RESTRICT ON DELETE RESTRICT,
  CONSTRAINT slots_object_status_fkey FOREIGN KEY (status)
  REFERENCES slots_dict_status (unique_id) MATCH SIMPLE
  ON UPDATE RESTRICT ON DELETE RESTRICT,
  CONSTRAINT slots_object_type_fkey FOREIGN KEY (object_type)
  REFERENCES common_action (code) MATCH SIMPLE
  ON UPDATE RESTRICT ON DELETE RESTRICT
)
WITH (
OIDS = FALSE
);
ALTER TABLE slots_object
  OWNER TO monkey_user;
COMMENT ON TABLE slots_object
IS 'Таблица, содержащая информацию слотах';
COMMENT ON COLUMN slots_object.unique_id IS 'Идентификатор записи. Первичный ключ';
COMMENT ON COLUMN slots_object.uuid IS 'UUID записи';
COMMENT ON COLUMN slots_object.author IS 'Пользователь, создавший объект';
COMMENT ON COLUMN slots_object.created_timestamp IS 'Дата и время создания записи';
COMMENT ON COLUMN slots_object.modifier IS 'Пользователь, последним изменивший объект';
COMMENT ON COLUMN slots_object.modified_timestamp IS 'Дата и время последнего изменения записи';
COMMENT ON COLUMN slots_object.is_deleted IS 'Признак удалённой записи';
COMMENT ON COLUMN slots_object.is_relevant IS 'Признак активности записи';
COMMENT ON COLUMN slots_object.performer IS 'Исполнитель';
COMMENT ON COLUMN slots_object.hram IS 'Ссылка на храм';
COMMENT ON COLUMN slots_object.status IS 'Статус процесса бронирования';
COMMENT ON COLUMN slots_object.object_type IS 'Тип объекта';
COMMENT ON COLUMN slots_object.auto_create IS 'Создан через процесс дежурства';
COMMENT ON COLUMN slots_object.from_timestamp IS 'Время начало слота';
COMMENT ON COLUMN slots_object.to_timestamp IS 'Время окончания слота';
COMMENT ON COLUMN slots_object.is_report IS 'Включить в отчет';
COMMENT ON COLUMN slots_object.comment IS 'Комментарий к беседе';
COMMENT ON COLUMN slots_object.result IS 'Признак была проведена встреча или нет';
COMMENT ON COLUMN slots_object.result_comment IS 'Комментарицй к результату';

-- Таблица содержащая описание данных о бронирующем
-- Table: slots_reservation

CREATE TABLE slots_reservation
(
  unique_id             BIGSERIAL                NOT NULL, -- Идентификатор записи. Первичный ключ
  uuid                  UUID                     NOT NULL, -- UUID
  author                BIGINT NOT NULL, -- Пользователь, создавший объект
  created_timestamp     TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT statement_timestamp(), -- Дата и время создания записи
  modifier              BIGINT NOT NULL, -- Пользователь, последним изменивший объект
  modified_timestamp    TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT statement_timestamp(), -- Дата и время изменения записи
  is_deleted            BOOLEAN                           DEFAULT FALSE, -- Признак удалённой записи
  is_relevant           BOOLEAN DEFAULT TRUE, -- Признак активности записи
  user_id               BIGINT, -- Ссылка на УЗ мирянина
  slot                  BIGINT, -- Ссылка на объект Слота
  is_applay             BOOLEAN DEFAULT FALSE, -- Признак, что лост подтвержден
  CONSTRAINT slots_reservation_pkey PRIMARY KEY (unique_id),
  CONSTRAINT slots_reservation_author_fkey FOREIGN KEY (author)
  REFERENCES sys_users (unique_id) MATCH SIMPLE
  ON UPDATE RESTRICT ON DELETE RESTRICT,
  CONSTRAINT slots_reservation_modifier_fkey FOREIGN KEY (modifier)
  REFERENCES sys_users (unique_id) MATCH SIMPLE
  ON UPDATE RESTRICT ON DELETE RESTRICT,
  CONSTRAINT slots_reservation_slot_fkey FOREIGN KEY (slot)
  REFERENCES slots_object (unique_id) MATCH SIMPLE
  ON UPDATE RESTRICT ON DELETE RESTRICT,
  CONSTRAINT slots_reservation_user_fkey FOREIGN KEY (user_id)
  REFERENCES sys_users (unique_id) MATCH SIMPLE
  ON UPDATE RESTRICT ON DELETE RESTRICT
)
WITH (
OIDS = FALSE
);
ALTER TABLE slots_reservation
  OWNER TO monkey_user;
COMMENT ON TABLE slots_reservation
IS 'Таблица, содержащая информацию о бронировании';
COMMENT ON COLUMN slots_reservation.unique_id IS 'Идентификатор записи. Первичный ключ';
COMMENT ON COLUMN slots_reservation.uuid IS 'UUID записи';
COMMENT ON COLUMN slots_reservation.author IS 'Пользователь, создавший объект';
COMMENT ON COLUMN slots_reservation.created_timestamp IS 'Дата и время создания записи';
COMMENT ON COLUMN slots_reservation.modifier IS 'Пользователь, последним изменивший объект';
COMMENT ON COLUMN slots_reservation.modified_timestamp IS 'Дата и время последнего изменения записи';
COMMENT ON COLUMN slots_reservation.is_deleted IS 'Признак удалённой записи';
COMMENT ON COLUMN slots_reservation.is_relevant IS 'Признак активности записи';
COMMENT ON COLUMN slots_reservation.user_id IS 'Ссылка на объект Мирянина';
COMMENT ON COLUMN slots_reservation.slot IS 'Ссылка на объект слота';
COMMENT ON COLUMN slots_reservation.is_applay IS 'Признак подтверждения записи';
COMMENT ON COLUMN slots_reservation.user_id IS 'Мирянин';

-- Таблица содержащая переписку между Священослужителем и Мирянином
-- Table: slots_message

CREATE TABLE slots_message
(
  unique_id             BIGSERIAL                NOT NULL, -- Идентификатор записи. Первичный ключ
  uuid                  UUID                     NOT NULL, -- UUID
  created_timestamp     TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT statement_timestamp(), -- Дата и время создания записи
  modified_timestamp    TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT statement_timestamp(), -- Дата и время изменения записи
  is_deleted            BOOLEAN                           DEFAULT FALSE, -- Признак удалённой записи
  is_relevant           BOOLEAN DEFAULT TRUE, -- Признак активности записи
  performer_id          BIGINT, -- Исполнитель
  user_id               BIGINT, -- Мирянин
  message               CHARACTER VARYING        NOT NULL, -- Сообщение
  destination           BIGINT, -- Направление
  slot                  BIGINT, -- Ссылка на объект слота
  author                BIGINT NOT NULL, -- Пользователь, создавший объект
  modifier              BIGINT NOT NULL, -- Пользователь, последним изменивший объект
  CONSTRAINT slots_message_pkey PRIMARY KEY (unique_id),
  CONSTRAINT slots_message_performer_fkey FOREIGN KEY (performer_id)
  REFERENCES sys_users (unique_id) MATCH SIMPLE
  ON UPDATE RESTRICT ON DELETE RESTRICT,
  CONSTRAINT slots_message_destination_fkey FOREIGN KEY (destination)
  REFERENCES common_dict_message_direction (code) MATCH SIMPLE
  ON UPDATE RESTRICT ON DELETE RESTRICT,
  CONSTRAINT slots_message_slot_fkey FOREIGN KEY (slot)
  REFERENCES slots_object (unique_id) MATCH SIMPLE
  ON UPDATE RESTRICT ON DELETE RESTRICT,
  CONSTRAINT slots_message_user_fkey FOREIGN KEY (user_id)
  REFERENCES sys_users (unique_id) MATCH SIMPLE
  ON UPDATE RESTRICT ON DELETE RESTRICT
)
WITH (
OIDS = FALSE
);
ALTER TABLE slots_message
  OWNER TO monkey_user;
COMMENT ON TABLE slots_message
IS 'Таблица, содержащая информацию о переписке в рамках слота';
COMMENT ON COLUMN slots_message.unique_id IS 'Идентификатор записи. Первичный ключ';
COMMENT ON COLUMN slots_message.uuid IS 'UUID записи';
COMMENT ON COLUMN slots_message.created_timestamp IS 'Дата и время создания записи';
COMMENT ON COLUMN slots_message.modified_timestamp IS 'Дата и время последнего изменения записи';
COMMENT ON COLUMN slots_message.is_deleted IS 'Признак удалённой записи';
COMMENT ON COLUMN slots_message.is_relevant IS 'Признак активности записи';
COMMENT ON COLUMN slots_message.performer_id IS 'Исполнитель';
COMMENT ON COLUMN slots_message.user_id IS 'Мирянин';
COMMENT ON COLUMN slots_message.message IS 'Текст сообщения';
COMMENT ON COLUMN slots_message.destination IS 'Направление';
COMMENT ON COLUMN slots_message.slot IS 'Слот';
COMMENT ON COLUMN slots_message.author IS 'Пользователь, создавший объект';
COMMENT ON COLUMN slots_message.modifier IS 'Пользователь, последним изменивший объект';

-- Генерация таблиц для описания объектов богослужений
-- Prefix: ministration_

-- Таблица содержащая данные о богослужениях
-- Table: ministration_object


CREATE TABLE ministration_object
(
  unique_id             BIGSERIAL                NOT NULL, -- Идентификатор записи. Первичный ключ
  uuid                  UUID                     NOT NULL, -- UUID
  author                BIGINT NOT NULL, -- Пользователь, создавший объект
  created_timestamp     TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT statement_timestamp(), -- Дата и время создания записи
  modifier              BIGINT NOT NULL, -- Пользователь, последним изменивший объект
  modified_timestamp    TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT statement_timestamp(), -- Дата и время изменения записи
  is_deleted            BOOLEAN                           DEFAULT FALSE, -- Признак удалённой записи
  is_relevant           BOOLEAN DEFAULT TRUE, -- Признак активности записи
  hram                  BIGINT, -- Ссылка на объект Храма
  object_type           BIGINT, -- Ссылка на тип объекта
  date_timestamp        TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT statement_timestamp(), -- Дата и время богослужения
  date_end_timestamp    TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT statement_timestamp(), -- Дата и время окончания богослужения
  description           CHARACTER VARYING, -- Описание
  is_report             BOOLEAN                           DEFAULT TRUE, -- Признак указания в отчете
  CONSTRAINT ministration_object_pkey PRIMARY KEY (unique_id),
  CONSTRAINT ministration_object_author_fkey FOREIGN KEY (author)
  REFERENCES sys_users (unique_id) MATCH SIMPLE
  ON UPDATE RESTRICT ON DELETE RESTRICT,
  CONSTRAINT ministration_object_modifier_fkey FOREIGN KEY (modifier)
  REFERENCES sys_users (unique_id) MATCH SIMPLE
  ON UPDATE RESTRICT ON DELETE RESTRICT,
  CONSTRAINT ministration_hram_fkey FOREIGN KEY (hram)
  REFERENCES structure_member (unique_id) MATCH SIMPLE
  ON UPDATE RESTRICT ON DELETE RESTRICT,
  CONSTRAINT ministration_type_fkey FOREIGN KEY (object_type)
  REFERENCES common_action (code) MATCH SIMPLE
  ON UPDATE RESTRICT ON DELETE RESTRICT
)
WITH (
OIDS = FALSE
);
ALTER TABLE ministration_object
  OWNER TO monkey_user;
COMMENT ON TABLE ministration_object
IS 'Таблица, содержащая информацию о богослужениях';
COMMENT ON COLUMN ministration_object.unique_id IS 'Идентификатор записи. Первичный ключ';
COMMENT ON COLUMN ministration_object.uuid IS 'UUID записи';
COMMENT ON COLUMN ministration_object.author IS 'Пользователь, создавший объект';
COMMENT ON COLUMN ministration_object.created_timestamp IS 'Дата и время создания записи';
COMMENT ON COLUMN ministration_object.modifier IS 'Пользователь, последним изменивший объект';
COMMENT ON COLUMN ministration_object.modified_timestamp IS 'Дата и время последнего изменения записи';
COMMENT ON COLUMN ministration_object.is_deleted IS 'Признак удалённой записи';
COMMENT ON COLUMN ministration_object.is_relevant IS 'Признак активности записи';
COMMENT ON COLUMN ministration_object.hram IS 'Объект храма';
COMMENT ON COLUMN ministration_object.object_type IS 'Тип объекта';
COMMENT ON COLUMN ministration_object.date_timestamp IS 'Дата и время богослужения';
COMMENT ON COLUMN ministration_object.date_end_timestamp IS 'Дата и время окончания богослужения';
COMMENT ON COLUMN ministration_object.description IS 'Описание';
COMMENT ON COLUMN ministration_object.is_report IS 'Включать в отчет';

-- Таблица содержащая информацию об участниках богослужения
-- Table: ministration_performer


CREATE TABLE ministration_performer
(
  unique_id             BIGSERIAL                NOT NULL, -- Идентификатор записи. Первичный ключ
  uuid                  UUID                     NOT NULL, -- UUID
  author                BIGINT NOT NULL, -- Пользователь, создавший объект
  created_timestamp     TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT statement_timestamp(), -- Дата и время создания записи
  modifier              BIGINT NOT NULL, -- Пользователь, последним изменивший объект
  modified_timestamp    TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT statement_timestamp(), -- Дата и время изменения записи
  is_deleted            BOOLEAN                           DEFAULT FALSE, -- Признак удалённой записи
  is_relevant           BOOLEAN DEFAULT TRUE, -- Признак активности записи
  ministration          BIGINT, -- Ссылка на объект богослужения
  performer_name        CHARACTER VARYING, -- Фио Участника
  performer             BIGINT, -- Участник
  is_main_performer     BOOLEAN                           DEFAULT FALSE, -- Служит
  CONSTRAINT ministration_performer_pkey PRIMARY KEY (unique_id),
  CONSTRAINT ministration_performer_author_fkey FOREIGN KEY (author)
  REFERENCES sys_users (unique_id) MATCH SIMPLE
  ON UPDATE RESTRICT ON DELETE RESTRICT,
  CONSTRAINT ministration_performer_modifier_fkey FOREIGN KEY (modifier)
  REFERENCES sys_users (unique_id) MATCH SIMPLE
  ON UPDATE RESTRICT ON DELETE RESTRICT,
  CONSTRAINT ministration_performer_ministration_modifier_fkey FOREIGN KEY (ministration)
  REFERENCES ministration_object (unique_id) MATCH SIMPLE
  ON UPDATE RESTRICT ON DELETE RESTRICT,
  CONSTRAINT ministration_performer_performer_fkey FOREIGN KEY (performer)
  REFERENCES sys_users (unique_id) MATCH SIMPLE
  ON UPDATE RESTRICT ON DELETE RESTRICT
)
WITH (
OIDS = FALSE
);
ALTER TABLE ministration_performer
  OWNER TO monkey_user;
COMMENT ON TABLE ministration_performer
IS 'Таблица, содержащая информацию о участниках богослужения';
COMMENT ON COLUMN ministration_performer.unique_id IS 'Идентификатор записи. Первичный ключ';
COMMENT ON COLUMN ministration_performer.uuid IS 'UUID записи';
COMMENT ON COLUMN ministration_performer.author IS 'Пользователь, создавший объект';
COMMENT ON COLUMN ministration_performer.created_timestamp IS 'Дата и время создания записи';
COMMENT ON COLUMN ministration_performer.modifier IS 'Пользователь, последним изменивший объект';
COMMENT ON COLUMN ministration_performer.modified_timestamp IS 'Дата и время последнего изменения записи';
COMMENT ON COLUMN ministration_performer.is_deleted IS 'Признак удалённой записи';
COMMENT ON COLUMN ministration_performer.is_relevant IS 'Признак активности записи';
COMMENT ON COLUMN ministration_performer.ministration IS 'Ссылка на объект Богослужения';
COMMENT ON COLUMN ministration_performer.performer_name IS 'ФИО Участника';
COMMENT ON COLUMN ministration_performer.performer IS 'Ссылка на объект Участника';
COMMENT ON COLUMN ministration_performer.is_main_performer IS 'Участник служит в рамках богослужения';

-- Генерация таблиц для описания объектов заявок
-- Prefix: claim_

-- Словарь статусов заявок
-- Table: claim_dict_status

CREATE TABLE claim_dict_status
(
  unique_id          BIGSERIAL                NOT NULL, -- Идентификатор записи. Первичный ключ
  uuid               UUID                     NOT NULL, -- UUID
  name               CHARACTER VARYING, -- Мнемоника
  code               BIGINT, -- Код записи словарного значения
  label              CHARACTER VARYING        NOT NULL, -- Наименование
  description        CHARACTER VARYING, -- Описание
  created_timestamp  TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT statement_timestamp(), -- Дата и время создания записи
  modified_timestamp TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT statement_timestamp(), -- Дата и время изменения записи
  is_deleted         BOOLEAN                           DEFAULT FALSE, -- Признак удалённой записи
  is_relevant        BOOLEAN DEFAULT TRUE, -- Признак активности записи
  CONSTRAINT claim_dict_status_pkey PRIMARY KEY (unique_id),
  CONSTRAINT claim_dict_status_code_key UNIQUE (code)
)
WITH (
OIDS = FALSE
);
ALTER TABLE claim_dict_status
  OWNER TO monkey_user;
COMMENT ON TABLE claim_dict_status
IS 'Таблица, содержащая атрибуты объекта - Словарь статусов заявок';
COMMENT ON COLUMN claim_dict_status.unique_id IS 'Идентификатор записи. Первичный ключ';
COMMENT ON COLUMN claim_dict_status.uuid IS 'uuid объекта';
COMMENT ON COLUMN claim_dict_status.name IS 'Мнемоника';
COMMENT ON COLUMN claim_dict_status.name IS 'Код записи';
COMMENT ON COLUMN claim_dict_status.label IS 'Наименование';
COMMENT ON COLUMN claim_dict_status.description IS 'Описание';
COMMENT ON COLUMN claim_dict_status.created_timestamp IS 'Дата и время создания записи';
COMMENT ON COLUMN claim_dict_status.modified_timestamp IS 'Дата и время последнего изменения записи';
COMMENT ON COLUMN claim_dict_status.is_deleted IS 'Признак удалённой записи';
COMMENT ON COLUMN claim_dict_status.is_relevant IS 'Признак активности записи';


-- Таблица содержащая описание объекта Заявки
-- Table: claim_object

CREATE TABLE claim_object
(
  unique_id             BIGSERIAL                NOT NULL, -- Идентификатор записи. Первичный ключ
  uuid                  UUID                     NOT NULL, -- UUID
  created_timestamp     TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT statement_timestamp(), -- Дата и время создания записи
  modified_timestamp    TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT statement_timestamp(), -- Дата и время изменения записи
  is_deleted            BOOLEAN                           DEFAULT FALSE, -- Признак удалённой записи
  is_relevant           BOOLEAN DEFAULT TRUE, -- Признак активности записи
  claim_status          BIGINT, -- Статус заявки
  is_free               BOOLEAN                           DEFAULT FALSE, -- Свободная заявка
  object_type           BIGINT, -- Ссылка на тип объекта
  user_id               BIGINT, -- Ссылка на мирянина
  performer             BIGINT, -- Ссылка на исполнителя
  user_address          CHARACTER VARYING, -- Адрес Мирянина
  description           CHARACTER VARYING, -- Описание задачи(заполняется Мирянином)
  comment               CHARACTER VARYING, -- Комментарий (Заполняется в статусе "В работе" и "подтверждена". Заполняется священнослужителем.)
  first_timestamp       TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT statement_timestamp(), -- Желаемая дата начала
  end_timestamp         TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT statement_timestamp(), -- Желаемая дата окончания
  is_hram               BOOLEAN                           DEFAULT FALSE, -- Признак проведения в храме
  author                BIGINT NOT NULL, -- Пользователь, создавший объект
  modifier              BIGINT NOT NULL, -- Пользователь, последним изменивший объект
  CONSTRAINT claim_object_pkey PRIMARY KEY (unique_id),
  CONSTRAINT claim_object_status_fkey FOREIGN KEY (claim_status)
  REFERENCES claim_dict_status (unique_id) MATCH SIMPLE
  ON UPDATE RESTRICT ON DELETE RESTRICT,
  CONSTRAINT claim_object_type_fkey FOREIGN KEY (object_type)
  REFERENCES common_action (code) MATCH SIMPLE
  ON UPDATE RESTRICT ON DELETE RESTRICT,
  CONSTRAINT claim_object_user_fkey FOREIGN KEY (user_id)
  REFERENCES sys_users (unique_id) MATCH SIMPLE
  ON UPDATE RESTRICT ON DELETE RESTRICT,
  CONSTRAINT claim_object_performer_fkey FOREIGN KEY (performer)
  REFERENCES sys_users (unique_id) MATCH SIMPLE
  ON UPDATE RESTRICT ON DELETE RESTRICT
)
WITH (
OIDS = FALSE
);
ALTER TABLE claim_object
  OWNER TO monkey_user;
COMMENT ON TABLE claim_object
IS 'Таблица, содержащая информацию об объекте Заявки';
COMMENT ON COLUMN claim_object.unique_id IS 'Идентификатор записи. Первичный ключ';
COMMENT ON COLUMN claim_object.uuid IS 'UUID записи';
COMMENT ON COLUMN claim_object.created_timestamp IS 'Дата и время создания записи';
COMMENT ON COLUMN claim_object.modified_timestamp IS 'Дата и время последнего изменения записи';
COMMENT ON COLUMN claim_object.is_deleted IS 'Признак удалённой записи';
COMMENT ON COLUMN claim_object.is_relevant IS 'Признак активности записи';
COMMENT ON COLUMN claim_object.claim_status IS 'Статус заявки';
COMMENT ON COLUMN claim_object.is_free IS 'Признак свободной заявки';
COMMENT ON COLUMN claim_object.object_type IS 'Тип события';
COMMENT ON COLUMN claim_object.user_id IS 'Мирянин';
COMMENT ON COLUMN claim_object.performer IS 'Исполнитель';
COMMENT ON COLUMN claim_object.user_address IS 'Адрес Мирянина';
COMMENT ON COLUMN claim_object.description IS 'Описание заявки';
COMMENT ON COLUMN claim_object.comment IS 'Комментарий священнослужителя';
COMMENT ON COLUMN claim_object.first_timestamp IS 'Желаемая дата начала';
COMMENT ON COLUMN claim_object.end_timestamp IS 'Желаемая дата окончания';
COMMENT ON COLUMN claim_object.is_hram IS 'Проведение заявки в Храме';
COMMENT ON COLUMN claim_object.author IS 'Пользователь, создавший объект';
COMMENT ON COLUMN claim_object.modifier IS 'Пользователь, последним изменивший объект';


-- Связь пользователей и заявок в рамках процесса маршрутизации
-- Table: claim_link_users_performer_gb

CREATE TABLE claim_link_users_performer_gb
(
  unique_id   BIGSERIAL NOT NULL, -- Идентификатор записи. Первичный ключ
  performer_ref    BIGINT    NOT NULL, -- Ссылка на пользователя
  claim_ref   BIGINT    NOT NULL, -- Ссылка на роль
  hram_ref    BIGINT    NOT NULL, -- Ссылка на храм
  CONSTRAINT claim_link_gb_pkey PRIMARY KEY (unique_id),
  CONSTRAINT claim_link_claim_ref_fkey FOREIGN KEY (claim_ref)
  REFERENCES claim_object (unique_id) MATCH SIMPLE
  ON UPDATE RESTRICT ON DELETE RESTRICT,
  CONSTRAINT claim_link_user_ref_fkey FOREIGN KEY (performer_ref)
  REFERENCES sys_users (unique_id) MATCH SIMPLE
  ON UPDATE RESTRICT ON DELETE RESTRICT,
  CONSTRAINT claim_link_hram_ref_fkey FOREIGN KEY (hram_ref)
  REFERENCES structure_member (unique_id) MATCH SIMPLE
  ON UPDATE RESTRICT ON DELETE RESTRICT
)
WITH (
OIDS = FALSE
);
ALTER TABLE claim_link_users_performer_gb
  OWNER TO monkey_user;
COMMENT ON TABLE claim_link_users_performer_gb
IS 'Таблица, содержащая атрибуты объекта - Таблица связи пользователей и заявок';
COMMENT ON COLUMN claim_link_users_performer_gb.unique_id IS 'Идентификатор записи. Первичный ключ';
COMMENT ON COLUMN claim_link_users_performer_gb.performer_ref IS 'Сылка на пользователя';
COMMENT ON COLUMN claim_link_users_performer_gb.claim_ref IS 'Ссылка на заявку';
COMMENT ON COLUMN claim_link_users_performer_gb.hram_ref IS 'Ссылка на храм';


-- Таблица содержащая переписку между Священослужителем и Мирянином
-- Table: claim_message

CREATE TABLE claim_message
(
  unique_id             BIGSERIAL                NOT NULL, -- Идентификатор записи. Первичный ключ
  uuid                  UUID                     NOT NULL, -- UUID
  created_timestamp     TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT statement_timestamp(), -- Дата и время создания записи
  modified_timestamp    TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT statement_timestamp(), -- Дата и время изменения записи
  is_deleted            BOOLEAN                           DEFAULT FALSE, -- Признак удалённой записи
  is_relevant           BOOLEAN, -- Признак активности записи
  performer_id          BIGINT, -- Исполнитель
  user_id               BIGINT, -- Мирянин
  message               CHARACTER VARYING        NOT NULL, -- Сообщение
  destination           BIGINT, -- Направление
  claim                 BIGINT, -- Ссылка на заявку
  author                BIGINT NOT NULL, -- Пользователь, создавший объект
  modifier              BIGINT NOT NULL, -- Пользователь, последним изменивший объект
  CONSTRAINT claim_message_pkey PRIMARY KEY (unique_id),
  CONSTRAINT claim_message_performer_fkey FOREIGN KEY (performer_id)
  REFERENCES sys_users (unique_id) MATCH SIMPLE
  ON UPDATE RESTRICT ON DELETE RESTRICT,
  CONSTRAINT claim_message_destination_fkey FOREIGN KEY (destination)
  REFERENCES common_dict_message_direction (code) MATCH SIMPLE
  ON UPDATE RESTRICT ON DELETE RESTRICT,
  CONSTRAINT claim_message_claim_fkey FOREIGN KEY (claim)
  REFERENCES claim_object (unique_id) MATCH SIMPLE
  ON UPDATE RESTRICT ON DELETE RESTRICT,
  CONSTRAINT claim_message_user_fkey FOREIGN KEY (user_id)
  REFERENCES sys_users (unique_id) MATCH SIMPLE
  ON UPDATE RESTRICT ON DELETE RESTRICT
)
WITH (
OIDS = FALSE
);
ALTER TABLE claim_message
  OWNER TO monkey_user;
COMMENT ON TABLE claim_message
IS 'Таблица, содержащая информацию о переписке в рамках заявки';
COMMENT ON COLUMN claim_message.unique_id IS 'Идентификатор записи. Первичный ключ';
COMMENT ON COLUMN claim_message.uuid IS 'UUID записи';
COMMENT ON COLUMN claim_message.created_timestamp IS 'Дата и время создания записи';
COMMENT ON COLUMN claim_message.modified_timestamp IS 'Дата и время последнего изменения записи';
COMMENT ON COLUMN claim_message.is_deleted IS 'Признак удалённой записи';
COMMENT ON COLUMN claim_message.is_relevant IS 'Признак активности записи';
COMMENT ON COLUMN claim_message.performer_id IS 'Исполнитель';
COMMENT ON COLUMN claim_message.user_id IS 'Мирянин';
COMMENT ON COLUMN claim_message.message IS 'Текст сообщения';
COMMENT ON COLUMN claim_message.destination IS 'Направление';
COMMENT ON COLUMN claim_message.claim IS 'Заявка';
COMMENT ON COLUMN claim_message.author IS 'Пользователь, создавший объект';
COMMENT ON COLUMN claim_message.modifier IS 'Пользователь, последним изменивший объект';

-- Генерация таблиц для описания объектов Дело
-- Prefix: workitem_

-- Таблица с описанием обьъектов Дело
-- Table: workitem_object

CREATE TABLE workitem_object
(
  unique_id             BIGSERIAL                NOT NULL, -- Идентификатор записи. Первичный ключ
  uuid                  UUID                     NOT NULL, -- UUID
  author                BIGINT NOT NULL, -- Пользователь, создавший объект
  created_timestamp     TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT statement_timestamp(), -- Дата и время создания записи
  modifier              BIGINT NOT NULL, -- Пользователь, последним изменивший объект
  modified_timestamp    TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT statement_timestamp(), -- Дата и время изменения записи
  is_deleted            BOOLEAN                           DEFAULT FALSE, -- Признак удалённой записи
  is_relevant           BOOLEAN                           DEFAULT TRUE, -- Признак активности записи
  performer             BIGINT, -- Ссылка на исполнителя
  date_timestamp        TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT statement_timestamp(), -- Дата и время начала Дела
  date_end_timestamp    TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT statement_timestamp(), -- Дата и время окончания Дела
  user_ref              CHARACTER VARYING, -- ФИО Мирянина
  object_type           BIGINT, -- Ссылка на тип объекта
  hram_ref              BIGINT, -- Ссылка на Храм
  user_phone            CHARACTER VARYING, -- Телефон Мирянина
  user_email            CHARACTER VARYING, -- Почта Мирянина
  user_address          CHARACTER VARYING, -- Адрес Мирянина
  description           CHARACTER VARYING, -- Описание дела
  is_report             BOOLEAN                           DEFAULT FALSE, -- Признак включения в отчет
  CONSTRAINT workitem_object_pkey PRIMARY KEY (unique_id),
  CONSTRAINT workitem_object_author_fkey FOREIGN KEY (author)
  REFERENCES sys_users (unique_id) MATCH SIMPLE
  ON UPDATE RESTRICT ON DELETE RESTRICT,
  CONSTRAINT workitem_object_modifier_fkey FOREIGN KEY (modifier)
  REFERENCES sys_users (unique_id) MATCH SIMPLE
  ON UPDATE RESTRICT ON DELETE RESTRICT,
  CONSTRAINT workitem_object_type_fkey FOREIGN KEY (object_type)
  REFERENCES common_action (code) MATCH SIMPLE
  ON UPDATE RESTRICT ON DELETE RESTRICT,
  CONSTRAINT workitem_object_performer_fkey FOREIGN KEY (performer)
  REFERENCES sys_users (unique_id) MATCH SIMPLE
  ON UPDATE RESTRICT ON DELETE RESTRICT,
  CONSTRAINT workitem_object_hram_ref_fkey FOREIGN KEY (hram_ref)
  REFERENCES structure_member (unique_id) MATCH SIMPLE
  ON UPDATE RESTRICT ON DELETE RESTRICT
)
WITH (
OIDS = FALSE
);
ALTER TABLE workitem_object
  OWNER TO monkey_user;
COMMENT ON TABLE workitem_object
IS 'Таблица, содержащая информацию об объекте Дело';
COMMENT ON COLUMN workitem_object.unique_id IS 'Идентификатор записи. Первичный ключ';
COMMENT ON COLUMN workitem_object.uuid IS 'UUID записи';
COMMENT ON COLUMN workitem_object.author IS 'Пользователь, создавший объект';
COMMENT ON COLUMN workitem_object.created_timestamp IS 'Дата и время создания записи';
COMMENT ON COLUMN workitem_object.modifier IS 'Пользователь, последним изменивший объект';
COMMENT ON COLUMN workitem_object.modified_timestamp IS 'Дата и время последнего изменения записи';
COMMENT ON COLUMN workitem_object.is_deleted IS 'Признак удалённой записи';
COMMENT ON COLUMN workitem_object.is_relevant IS 'Признак активности записи';
COMMENT ON COLUMN workitem_object.performer IS 'Исполнитель';
COMMENT ON COLUMN workitem_object.date_timestamp IS 'Дата начала дела';
COMMENT ON COLUMN workitem_object.date_end_timestamp IS 'Дата окончания дела';
COMMENT ON COLUMN workitem_object.user_ref IS 'ФИО мирянина';
COMMENT ON COLUMN workitem_object.object_type IS 'Тип объекта';
COMMENT ON COLUMN workitem_object.hram_ref IS 'Храм';
COMMENT ON COLUMN workitem_object.user_phone IS 'Телефон';
COMMENT ON COLUMN workitem_object.user_email IS 'Почта';
COMMENT ON COLUMN workitem_object.user_address IS 'Адрес';
COMMENT ON COLUMN workitem_object.description IS 'Описание дела';
COMMENT ON COLUMN workitem_object.is_report IS 'Признак включения в отчет';

-- Генерация таблиц для описания результатов анкетирования
-- Prefix: anketa_

-- Таблица содержащая результата процесса анкетирования
-- Table: anketa_result

CREATE TABLE anketa_result
(
  unique_id             BIGSERIAL                NOT NULL, -- Идентификатор записи. Первичный ключ
  uuid                  UUID                     NOT NULL, -- UUID
  created_timestamp     TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT statement_timestamp(), -- Дата и время создания записи
  modified_timestamp    TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT statement_timestamp(), -- Дата и время изменения записи
  is_deleted            BOOLEAN                           DEFAULT FALSE, -- Признак удалённой записи
  is_relevant           BOOLEAN DEFAULT TRUE, -- Признак активности записи
  object_type           BIGINT, -- Ссылка на тип объекта
  user_ref              BIGINT, -- Ссылка на Мирянина
  author                BIGINT NOT NULL, -- Пользователь, создавший объект
  modifier              BIGINT NOT NULL, -- Пользователь, последним изменивший объект
  surname             character varying, -- Фамилия
  firstname           character varying, -- Имя
  middlename          character varying, -- Отчество
  email               character varying, -- email
  phone               character varying, -- телефон
  CONSTRAINT anketa_result_pkey PRIMARY KEY (unique_id),
  CONSTRAINT anketa_result_type_fkey FOREIGN KEY (object_type)
  REFERENCES common_action (code) MATCH SIMPLE
  ON UPDATE RESTRICT ON DELETE RESTRICT,
  CONSTRAINT anketa_result_user_fkey FOREIGN KEY (user_ref)
  REFERENCES sys_users (unique_id) MATCH SIMPLE
  ON UPDATE RESTRICT ON DELETE RESTRICT,
  CONSTRAINT block_result_author_fkey FOREIGN KEY (author)
  REFERENCES sys_users (unique_id) MATCH SIMPLE
  ON UPDATE RESTRICT ON DELETE RESTRICT,
  CONSTRAINT block_result_modifier_fkey FOREIGN KEY (modifier)
  REFERENCES sys_users (unique_id) MATCH SIMPLE
  ON UPDATE RESTRICT ON DELETE RESTRICT
)
WITH (
OIDS = FALSE
);
ALTER TABLE anketa_result
  OWNER TO monkey_user;
COMMENT ON TABLE anketa_result
IS 'Таблица, содержащая информацию о результатах анкетирования. Попадают только положительные результаты';
COMMENT ON COLUMN anketa_result.unique_id IS 'Идентификатор записи. Первичный ключ';
COMMENT ON COLUMN anketa_result.uuid IS 'UUID записи';
COMMENT ON COLUMN anketa_result.created_timestamp IS 'Дата и время создания записи';
COMMENT ON COLUMN anketa_result.modified_timestamp IS 'Дата и время последнего изменения записи';
COMMENT ON COLUMN anketa_result.is_deleted IS 'Признак удалённой записи';
COMMENT ON COLUMN anketa_result.is_relevant IS 'Признак активности записи';
COMMENT ON COLUMN anketa_result.author IS 'Пользователь, создавший объект';
COMMENT ON COLUMN anketa_result.modifier IS 'Пользователь, последним изменивший объект';
COMMENT ON COLUMN anketa_result.surname IS 'Фамилия';
COMMENT ON COLUMN anketa_result.firstname IS 'Имя';
COMMENT ON COLUMN anketa_result.middlename IS 'Отчество';
COMMENT ON COLUMN anketa_result.email IS 'email';
COMMENT ON COLUMN anketa_result.phone IS 'телефон';

-- Генерация таблиц для описания блокировки пользователей
-- Prefix: block_

-- Таблица содержащая описание блокировок мирян
-- Table: block_result

CREATE TABLE block_result
(
  unique_id             BIGSERIAL                NOT NULL, -- Идентификатор записи. Первичный ключ
  uuid                  UUID                     NOT NULL, -- UUID
  author                BIGINT NOT NULL, -- Пользователь, создавший объект
  created_timestamp     TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT statement_timestamp(), -- Дата и время создания записи
  modifier              BIGINT NOT NULL, -- Пользователь, последним изменивший объект
  modified_timestamp    TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT statement_timestamp(), -- Дата и время изменения записи
  is_deleted            BOOLEAN                           DEFAULT FALSE, -- Признак удалённой записи
  is_relevant           BOOLEAN DEFAULT TRUE, -- Признак активности записи
  user_ref              BIGINT, -- Мирянин, которого заблокировали
  CONSTRAINT block_result_pkey PRIMARY KEY (unique_id),
  CONSTRAINT block_result_author_fkey FOREIGN KEY (author)
  REFERENCES sys_users (unique_id) MATCH SIMPLE
  ON UPDATE RESTRICT ON DELETE RESTRICT,
  CONSTRAINT block_result_modifier_fkey FOREIGN KEY (modifier)
  REFERENCES sys_users (unique_id) MATCH SIMPLE
  ON UPDATE RESTRICT ON DELETE RESTRICT,
  CONSTRAINT block_result_user_fkey FOREIGN KEY (user_ref)
  REFERENCES sys_users (unique_id) MATCH SIMPLE
  ON UPDATE RESTRICT ON DELETE RESTRICT
)
WITH (
OIDS = FALSE
);
ALTER TABLE block_result
  OWNER TO monkey_user;
COMMENT ON TABLE block_result
IS 'Таблица, содержащая информацию о блокировки УЗ Мирян';
COMMENT ON COLUMN block_result.unique_id IS 'Идентификатор записи. Первичный ключ';
COMMENT ON COLUMN block_result.uuid IS 'UUID записи';
COMMENT ON COLUMN block_result.author IS 'Пользователь, создавший объект';
COMMENT ON COLUMN block_result.created_timestamp IS 'Дата и время создания записи';
COMMENT ON COLUMN block_result.modifier IS 'Пользователь, последним изменивший объект';
COMMENT ON COLUMN block_result.modified_timestamp IS 'Дата и время последнего изменения записи';
COMMENT ON COLUMN block_result.is_deleted IS 'Признак удалённой записи';
COMMENT ON COLUMN block_result.is_relevant IS 'Признак активности записи';
COMMENT ON COLUMN block_result.user_ref IS 'Заблокированный Мирянин';
