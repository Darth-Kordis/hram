-- View: view_journal_claim_objects

-- DROP VIEW view_journal_claim_objects ;
CREATE OR REPLACE VIEW view_journal_claim_objects AS
  SELECT
    claim_object.unique_id,--Номер заявки
    claim_object.uuid,--uuid заявки
    claim_object.created_timestamp,--Дата создания заявки
    action.label as common_action, --Категория таинства
    claim_object.is_hram,--Признак проведения в храме да/нет
    CASE WHEN is_hram=true THEN 'Да'
            WHEN is_hram=false THEN 'Нет'
            ELSE 'Не указано'
           END as is_hram_text,--Признак проведения в храме
    users.fullname as user_full_name, --ФИО Мирянина
    contacts.content as phone,-- Телефон Мирянина
    claim_object.description, --Описание
    claim_object.comment,
    claim_object.user_address,-- Адрес указания требы
    claim_object.first_timestamp,--Желаемая дата начала
    claim_object.end_timestamp,-- Желаемая дата окончания
    link.hram_ref,--id храма (для поиска в пределах храма)
    claim_object.is_free,--Признак свободной заявки (для подменю)
    CASE WHEN is_free=true THEN 'Да'
            WHEN is_free=false THEN 'Нет'
            ELSE 'Не указано'
           END as is_free_text,--Признак свободной заявки (для подменю) да/нет
    claim_object.claim_status as status_id,
    users.unique_id as user_id,
    concat_ws(' - '::text, to_char(claim_object.first_timestamp, 'DD.MM.YYYY HH24:MI:SS'::text), to_char(claim_object.end_timestamp, 'DD.MM.YYYY HH24:MI:SS'::text)) AS range_event_timestamp
  FROM claim_object
    LEFT JOIN sys_users users ON claim_object.user_id = users.unique_id
    LEFT JOIN sys_users_contact contacts ON contacts.user_ref = users.unique_id
    LEFT JOIN common_action action ON action.code = claim_object.object_type
    LEFT JOIN claim_link_users_performer_gb link ON link.hram_ref = claim_object.unique_id
  WHERE claim_object.is_deleted IS FALSE AND claim_object.is_relevant IS TRUE AND (contacts.type_ref = 2 OR contacts.type_ref is null);

ALTER TABLE view_journal_claim_objects
  OWNER TO monkey_user;

COMMENT ON VIEW view_journal_claim_objects
IS 'Представление журнала Заявлений';


-- View: view_journal_users

-- DROP VIEW view_journal_users ;

CREATE OR REPLACE VIEW view_journal_users AS
SELECT users.unique_id,
       users.uuid,
       users.accost,
       users.fullname as full_name,
       member.unique_id as member_id,
       member.label     as member_name,
       contacts.content as phone,
       role.code       as code_role,
       role.label       as role
FROM sys_users users
       LEFT JOIN structure_member member ON users.member_ref = member.unique_id
       LEFT JOIN sys_users_contact contacts ON users.unique_id = contacts.user_ref
       LEFT JOIN sys_link_users_roles_gb slurg on users.unique_id = slurg.user_ref
       LEFT JOIN sys_cat_roles role on role.unique_id = slurg.role_ref
WHERE users.is_deleted IS FALSE
  AND users.is_relevant IS TRUE
  AND (contacts.type_ref = 2 OR contacts.type_ref is null)--только телефон
  AND role.code <> 6                                      --исключение мирян
ORDER BY users.surname_initials DESC;

ALTER TABLE view_journal_users
  OWNER TO monkey_user;

COMMENT ON VIEW view_journal_users
  IS 'Представление журнала пользователей';


-- View: view_journal_members

-- DROP VIEW view_journal_members;

CREATE OR REPLACE VIEW view_journal_members AS
SELECT member.unique_id,
       member.uuid,
       member.label,
       type.label as type,
       type.code as type_code,
       member.address,
       parent.unique_id as parent_id,
       parent.label as parent_label
FROM structure_member member
       LEFT JOIN structure_dict_type type on member.type_ref = type.code
       LEFT JOIN structure_member parent on member.parent_id = parent.unique_id
WHERE member.is_deleted IS FALSE
  AND member.is_relevant IS TRUE
ORDER BY member.label DESC;

ALTER TABLE view_journal_members
  OWNER TO monkey_user;

COMMENT ON VIEW view_journal_members
  IS 'Представление журнала храмов';

--View: view_journal_library

--DROP VIEW view_journal_library;

CREATE OR REPLACE VIEW view_journal_library AS
SELECT library.unique_id,
       library.uuid,
       library.label,
       library.author_ref,
       library.published as is_published,
       type.code as type_code,
       type.label as type,
       CASE WHEN library.published=true THEN 'Да'
            WHEN library.published=false THEN 'Нет'
            ELSE 'Не указано'
           END as published,
       creator.unique_id as creator_id,
       creator.fullname,
       library.created_timestamp,
       library.file_ref
FROM library_object library
  LEFT JOIN library_dict_type type on library.type_ref = type.code
  LEFT JOIN sys_users creator on library.author = creator.unique_id
WHERE library.is_deleted IS FALSE
  AND library.is_relevant IS TRUE
ORDER BY type.label ASC, library.label ASC;

ALTER TABLE view_journal_library
  OWNER TO monkey_user;

COMMENT ON VIEW view_journal_library
IS 'Представление журнала библиотеки';

-- View: view_journal_action

-- DROP VIEW view_journal_action;

CREATE OR REPLACE VIEW view_journal_action AS
SELECT unique_id,
       uuid,
       label,
       CASE WHEN is_work=true THEN 'Да'
            WHEN is_work=false THEN 'Нет'
            ELSE 'Не указано'
           END as is_work,
       CASE WHEN is_ministration=true THEN 'Да'
            WHEN is_ministration=false THEN 'Нет'
            ELSE 'Не указано'
           END as is_ministration,
       CASE WHEN is_claim=true THEN 'Да'
            WHEN is_claim=false THEN 'Нет'
            ELSE 'Не указано'
           END as is_claim
FROM common_action
WHERE is_deleted IS FALSE AND is_relevant IS TRUE
ORDER BY label;

ALTER TABLE view_journal_action
    OWNER TO monkey_user;

COMMENT ON VIEW view_journal_action
    IS 'Представление журнала Типов событий';


CREATE OR REPLACE VIEW view_members_search AS
SELECT member.unique_id,
       member.uuid,
       member.label,
       member.address,
       hram.visible_priests,
       member.town_ref,
       member.metro_ref,
       member.coordination_latitude,
       member.coordination_longtitude,
       member.type_ref
 FROM structure_member member
 LEFT JOIN structure_hram hram on member.unique_id = hram.structure_ref
 WHERE member.is_deleted IS FALSE
  AND member.is_relevant IS TRUE
ORDER BY member.label DESC;
COMMENT ON VIEW view_journal_action
    IS 'Поиск храма для мобильного приложения';

CREATE OR REPLACE VIEW view_slots_search AS
SELECT  slots.unique_id,
        slots.performer,
       	slots.hram,
       	slots.from_timestamp,
       	slots.to_timestamp,
       	slots.uuid
 FROM slots_object slots
 WHERE slots.is_deleted IS FALSE
  AND slots.is_relevant IS TRUE
  AND  slots.status = 1
  AND  slots.from_timestamp > now()
ORDER BY slots.from_timestamp ASC;
COMMENT ON VIEW view_slots_search
    IS 'Слоты времени для бронирования';


--View: view_journal_library_mobile

-- DROP VIEW view_journal_claim_objects_mobile ;
CREATE OR REPLACE VIEW view_journal_claim_objects_mobile AS
  SELECT
    claim_object.uuid,--uuid заявки
    claim_object.user_address as address,-- Адрес указания требы
    action.label as common_action, --Категория таинства
    users.fullname as user_full_name, --ФИО Мирянина
    claim_object.first_timestamp,--Желаемая дата начала
    claim_object.created_timestamp,--Дата создания заявки
    claim_object.unique_id,--Номер заявки
    claim_object.claim_status as status_id,
    claim_object.is_free,--Признак свободной заявки (для подменю)
    link.hram_ref--id храма (для поиска в пределах храма)
  FROM claim_object
    LEFT JOIN sys_users users ON claim_object.user_id = users.unique_id
    LEFT JOIN common_action action ON action.code = claim_object.object_type
    LEFT JOIN claim_link_users_performer_gb link ON link.hram_ref = claim_object.unique_id
  WHERE claim_object.is_deleted IS FALSE AND claim_object.is_relevant IS TRUE;

ALTER TABLE view_journal_claim_objects_mobile
  OWNER TO monkey_user;

COMMENT ON VIEW view_journal_claim_objects_mobile
IS 'Представление журнала Заявлений для мобильных разработчиков';

CREATE OR REPLACE VIEW view_journal_message_object AS
SELECT message_object.unique_id,
       message_object.uuid,
       message_object.type_ref,
       message_object.user_ref,
       message_object.text_message,
       message_object.is_read
FROM message_object
WHERE message_object.is_deleted IS FALSE AND message_object.is_relevant IS TRUE;

ALTER TABLE view_journal_message_object
    OWNER TO monkey_user;
COMMENT ON VIEW view_journal_message_object
    IS 'Представление журнала Уведомлений';