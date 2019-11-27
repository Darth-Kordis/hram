/* sys_dict_authen_type */
INSERT INTO sys_dict_authen_type (uuid, name, label, code, description, is_relevant)
VALUES (uuid_generate_v4(), 'login', 'Логин', 1, 'Логин/пароль', TRUE);
INSERT INTO sys_dict_authen_type (uuid, name, label, code, description, is_relevant)
VALUES (uuid_generate_v4(), 'google', 'Логин', 2, 'Логин/пароль', TRUE);
INSERT INTO sys_dict_authen_type (uuid, name, label, code, description, is_relevant)
VALUES (uuid_generate_v4(), 'facebook', 'Логин', 3, 'Логин/пароль', TRUE);

/* sys_users */
INSERT INTO sys_users (uuid, surname, firstname, middlename, is_deleted, is_relevant)
VALUES (uuid_generate_v4(), 'Система', '', '', FALSE, TRUE);
INSERT INTO sys_users (uuid, surname, firstname, middlename, is_deleted, is_relevant)
VALUES (uuid_generate_v4(), 'Администратор', '', '', FALSE, TRUE);

/* sys_cat_roles */
INSERT INTO sys_cat_roles (uuid, name, label, code, is_relevant, author, modifier)
VALUES (uuid_generate_v4(), 'administrator', 'Администратор', 1, TRUE, 1, 1);
INSERT INTO sys_cat_roles (uuid, name, label, code, is_relevant, author, modifier)
VALUES (uuid_generate_v4(), 'administrator_structure', 'Администратор организационной единицы', 2, TRUE, 1, 1);
INSERT INTO sys_cat_roles (uuid, name, label, code, is_relevant, author, modifier)
VALUES (uuid_generate_v4(), 'administrator_hram', 'Администратор храма(Настоятель)', 3, TRUE, 1, 1);
INSERT INTO sys_cat_roles (uuid, name, label, code, is_relevant, author, modifier)
VALUES (uuid_generate_v4(), 'priest', 'Священнослужитель', 4, TRUE, 1, 1);
INSERT INTO sys_cat_roles (uuid, name, label, code, is_relevant, author, modifier)
VALUES (uuid_generate_v4(), 'assistant', 'Помощник', 5, TRUE, 1, 1);
INSERT INTO sys_cat_roles (uuid, name, label, code, is_relevant, author, modifier)
VALUES (uuid_generate_v4(), 'user', 'Мирянин', 6, TRUE, 1, 1);

/* sys_link_users_roles_gb */
INSERT INTO sys_link_users_roles_gb (description, user_ref, role_ref)
VALUES ('Связь системного пользователя с ролью администратор', 1, 1);
INSERT INTO sys_link_users_roles_gb (description, user_ref, role_ref)
VALUES ('Связь пользователя root с ролью администратор', 2, 1);

/* sys_functions */
INSERT INTO sys_functions (uuid, code, name, label, description, is_relevant, author, modifier)
VALUES (uuid_generate_v4(), 1, 'administration_global_modifier',
        'Доступ Администратору к модулю Системные настройки',
        'Доступ Администратору к модулю Системные настройки',
        TRUE, 1, 1);
INSERT INTO sys_functions (uuid, code, name, label, description, is_relevant, author, modifier)
VALUES (uuid_generate_v4(), 2, 'administrator_hram_claim_view',
        'Доступ настоятеля к модулю заявок на просмотр',
        'Просмотр информации о заявках настоятелем (в пределах храма)',
        TRUE, 1, 1);
INSERT INTO sys_functions (uuid, code, name, label, description, is_relevant, author, modifier)
VALUES (uuid_generate_v4(), 3, 'administration_user_modifier',
        'Доступ администратора к модулю Пользователи на модификацию',
        'Может создавать пользователей с любой ролью, в том числе Администратор', TRUE, 1, 1);
INSERT INTO sys_functions (uuid, code, name, label, description, is_relevant, author, modifier)
VALUES (uuid_generate_v4(), 4, 'administrator_structure_user_modifier',
        'Доступ администратора организационной единицы к модулю Пользователи на модификацию',
        'Может создавать пользователей Настоятель, с обязательным указанием Храма. Видит только пользователей Епархии, администратором которой он является',
        TRUE, 1, 1);
INSERT INTO sys_functions (uuid, code, name, label, description, is_relevant, author, modifier)
VALUES (uuid_generate_v4(), 5, 'administrator_hram_user_modifier',
        'Доступ администратора храма(Настоятель) к модулю Пользователи на модификацию',
        'Может создавать пользователей с ролями:Священнослужитель,Помощник. Храм проставляется автоматически.Видит только пользователей Храма.',
        TRUE, 1, 1);
INSERT INTO sys_functions (uuid, code, name, label, description, is_relevant, author, modifier)
VALUES (uuid_generate_v4(), 6, 'administrator_member_modifier',
        'Доступ администратора к модулю Церкви на модификацию',
        'Может редактировать карточку Храма (объекта типа «Храм»)',
        TRUE, 1, 1);
INSERT INTO sys_functions (uuid, code, name, label, description, is_relevant, author, modifier)
VALUES (uuid_generate_v4(), 7, 'administrator_structure_member_modifier',
        'Доступ администратора организационной единицы к модулю Церкви на модификацию',
        'Может редактировать карточку Храма',
        TRUE, 1, 1);
INSERT INTO sys_functions (uuid, code, name, label, description, is_relevant, author, modifier)
VALUES (uuid_generate_v4(), 8, 'administrator_hram_member_modifier',
        'Доступ администратора храма(Настоятель) к модулю Церкви на модификацию',
        'Просмотр информации о храме, служителем которого является пользователь Может редактировать карточку Храма',
        TRUE, 1, 1);
INSERT INTO sys_functions (uuid, code, name, label, description, is_relevant, author, modifier)
VALUES (uuid_generate_v4(), 9, 'priest_member_view',
        'Доступ Священослужителя к модулю Церкви на модификацию',
        'Просмотр информации о храме, служителем которого является пользователь',
        TRUE, 1, 1);
INSERT INTO sys_functions (uuid, code, name, label, description, is_relevant, author, modifier)
VALUES (uuid_generate_v4(), 10, 'administrator_hram_ministration_modifier',
        'Доступ Администратору храма к модулю Богослужения',
        'Доступ Администратору храма к модулю Богослужения',
        TRUE, 1, 1);
INSERT INTO sys_functions (uuid, code, name, label, description, is_relevant, author, modifier)
VALUES (uuid_generate_v4(), 11, 'administrator_hram_schedule_modifier',
        'Доступ Администратору храма к модулю Расписание',
        'Доступ Администратору храма к модулю Расписание',
        TRUE, 1, 1);
INSERT INTO sys_functions (uuid, code, name, label, description, is_relevant, author, modifier)
VALUES (uuid_generate_v4(), 12, 'priest_hram_schedule_view',
        'Доступ Священнослужителю к модулю Расписание на чтение',
        'Доступ Священнослужителю к модулю Расписание на чтение',
        TRUE, 1, 1);
INSERT INTO sys_functions (uuid, code, name, label, description, is_relevant, author, modifier)
VALUES (uuid_generate_v4(), 13, 'assistant_hram_schedule_view',
        'Доступ Помошнику к модулю Расписание на чтение',
        'Доступ Помошнику к модулю Расписание на чтение',
        TRUE, 1, 1);
INSERT INTO sys_functions (uuid, code, name, label, description, is_relevant, author, modifier)
VALUES (uuid_generate_v4(), 14, 'administration_directory_modifier',
        'Доступ Администратора к модулю Справочники на модификацию',
        'Может редактировать карточку справочника',
        TRUE, 1, 1);
INSERT INTO sys_functions (uuid, code, name, label, description, is_relevant, author, modifier)
VALUES (uuid_generate_v4(), 15, 'administrator_library_modifier',
        'Доступ Администратора к модулю Библиотеки на модификацию',
        'Может редактировать карточку библиотеки',
        TRUE, 1, 1);
INSERT INTO sys_functions (uuid, code, name, label, description, is_relevant, author, modifier)
VALUES (uuid_generate_v4(), 16, 'administrator_structure_library_modifier',
        'Доступ Администратора организационной единицы к модулю Библиотеки на модификацию',
        'Может редактировать карточку библиотеки',
        TRUE, 1, 1);
INSERT INTO sys_functions (uuid, code, name, label, description, is_relevant, author, modifier)
VALUES (uuid_generate_v4(), 17, 'administrator_hram_library_modifier',
        'Доступ Администратора храма(Настоятель) к модулю Библиотеки на модификацию',
        'Может редактировать карточку библиотеки',
        TRUE, 1, 1);
INSERT INTO sys_functions (uuid, code, name, label, description, is_relevant, author, modifier)
VALUES (uuid_generate_v4(), 18, 'priest_library_modifier',
        'Доступ Священнослужителя к модулю Библиотеки на модификацию',
        'Может редактировать карточку библиотеки',
        TRUE, 1, 1);
INSERT INTO sys_functions (uuid, code, name, label, description, is_relevant, author, modifier)
VALUES (uuid_generate_v4(), 19, 'assistant_library_modifier',
        'Доступ Помощника к модулю Библиотеки на модификацию',
        'Может редактировать карточку библиотеки',
        TRUE, 1, 1);
INSERT INTO sys_functions (uuid, code, name, label, description, is_relevant, author, modifier)
VALUES (uuid_generate_v4(), 20, 'administrator_hram_slots_modifier',
        'Доступ Администратора храма(Настоятель) к модулю слотов',
        'Может редактировать свои слоты, те что is_report, те что создал author',
        TRUE, 1, 1);
INSERT INTO sys_functions (uuid, code, name, label, description, is_relevant, author, modifier)
VALUES (uuid_generate_v4(), 21, 'priest_slots_modifier',
        'Доступ Священнослужителя к модулю слотов',
        'Может редактировать свои слоты',
        TRUE, 1, 1);
INSERT INTO sys_functions (uuid, code, name, label, description, is_relevant, author, modifier)
VALUES (uuid_generate_v4(), 22, 'assistant_slots_modifier',
        'Доступ Помощника к модулю слотов',
        'Может редактировать слоты своего священослужителя',
        TRUE, 1, 1);
INSERT INTO sys_functions (uuid, code, name, label, description, is_relevant, author, modifier)
VALUES (uuid_generate_v4(), 23, 'priest_claim_view',
        'Доступ священнослужителя к модулю заявок на просмотр',
        'Просмотр информации о заявках священослужителем(в пределах храма)',
        TRUE, 1, 1);
INSERT INTO sys_functions (uuid, code, name, label, description, is_relevant, author, modifier)
VALUES (uuid_generate_v4(), 24, 'assistant_claim_view',
        'Доступ помощника к модулю заявок на просмотр',
        'Просмотр информации о заявках помощьнику (в пределах храма. От имени священнослужителя)',
        TRUE, 1, 1);
INSERT INTO sys_functions (uuid, code, name, label, description, is_relevant, author, modifier)
VALUES (uuid_generate_v4(), 25, 'user_claim_create',
        'Доступ к созданию заявки',
        'Доступ к созданию заявки на таинство',
        TRUE, 1, 1);


/* sys_link_functions_roles_gb */
INSERT INTO sys_link_functions_roles_gb (description, role_ref, function_ref)
VALUES (NULL, 1, 3);
INSERT INTO sys_link_functions_roles_gb (description, role_ref, function_ref)
VALUES (NULL, 2, 4);
INSERT INTO sys_link_functions_roles_gb (description, role_ref, function_ref)
VALUES (NULL, 3, 5);
INSERT INTO sys_link_functions_roles_gb (description, role_ref, function_ref)
VALUES (NULL, 1, 6);
INSERT INTO sys_link_functions_roles_gb (description, role_ref, function_ref)
VALUES (NULL, 2, 7);
INSERT INTO sys_link_functions_roles_gb (description, role_ref, function_ref)
VALUES (NULL, 3, 8);
INSERT INTO sys_link_functions_roles_gb (description, role_ref, function_ref)
VALUES (NULL, 4, 9);
INSERT INTO sys_link_functions_roles_gb (description, role_ref, function_ref)
VALUES (NULL, 1, 1);
INSERT INTO sys_link_functions_roles_gb (description, role_ref, function_ref)
VALUES (NULL, 3, 2);
INSERT INTO sys_link_functions_roles_gb (description, role_ref, function_ref)
VALUES (NULL, 3, 10);
INSERT INTO sys_link_functions_roles_gb (description, role_ref, function_ref)
VALUES (NULL, 3, 11);
INSERT INTO sys_link_functions_roles_gb (description, role_ref, function_ref)
VALUES (NULL, 4, 12);
INSERT INTO sys_link_functions_roles_gb (description, role_ref, function_ref)
VALUES (NULL, 5, 13);
INSERT INTO sys_link_functions_roles_gb (description, role_ref, function_ref)
VALUES (NULL, 1, 14);
INSERT INTO sys_link_functions_roles_gb (description, role_ref, function_ref)
VALUES (NULL, 1, 15);
INSERT INTO sys_link_functions_roles_gb (description, role_ref, function_ref)
VALUES (NULL, 2, 16);
INSERT INTO sys_link_functions_roles_gb (description, role_ref, function_ref)
VALUES (NULL, 3, 17);
INSERT INTO sys_link_functions_roles_gb (description, role_ref, function_ref)
VALUES (NULL, 4, 18);
INSERT INTO sys_link_functions_roles_gb (description, role_ref, function_ref)
VALUES (NULL, 5, 19);
INSERT INTO sys_link_functions_roles_gb (description, role_ref, function_ref)
VALUES (NULL, 3, 20);
INSERT INTO sys_link_functions_roles_gb (description, role_ref, function_ref)
VALUES (NULL, 4, 21);
INSERT INTO sys_link_functions_roles_gb (description, role_ref, function_ref)
VALUES (NULL, 5, 22);
INSERT INTO sys_link_functions_roles_gb (description, role_ref, function_ref)
VALUES (NULL, 4, 23);
INSERT INTO sys_link_functions_roles_gb (description, role_ref, function_ref)
VALUES (NULL, 5, 24);
INSERT INTO sys_link_functions_roles_gb (description, role_ref, function_ref)
VALUES (NULL, 6, 25);

/* sys_authen */
INSERT INTO sys_authen (uuid, name, type_ref, user_ref, is_relevant, author, modifier)
VALUES (uuid_generate_v4(), '+7(111) 111-11-11', 1, 2, TRUE, 1, 1);

/* sys_passwords */
INSERT INTO sys_passwords (uuid, content, authen_ref, is_relevant, author, modifier)
VALUES (uuid_generate_v4(), '{bcrypt}$2a$10$SjZ4iWx/Ep7MaxWrU/PPeeqDMNJyFSQoM1N.rx8yoz2JoTKL24FK.', 1, TRUE, 1, 1);

/* sys_dict_contact_type */
INSERT INTO sys_dict_contact_type (uuid, name, code, label, description, is_deleted, is_relevant)
VALUES (uuid_generate_v4(), 'email', 1, 'E-mail', 'Электронная почта', false, true);
INSERT INTO sys_dict_contact_type (uuid, name, code, label, description, is_deleted, is_relevant)
VALUES (uuid_generate_v4(), 'phone', 2, 'Телефон', 'Номер мобильного телефона', false, true);

/* sys_system_config */
-- Синхронизация православного календаря
INSERT INTO sys_system_config (uuid, name, description, value_of_attribute, is_relevant, author, modifier)
VALUES (uuid_generate_v4(), 'sync_server_host', 'Адрес сервиса', NULL, TRUE, 1, 1);
INSERT INTO sys_system_config (uuid, name, description, value_of_attribute, is_relevant, author, modifier)
VALUES (uuid_generate_v4(), 'sync_frequency_cron', 'Частота синхронизации', NULL, TRUE, 1, 1);
-- Параметры сервиса email уведомлений
INSERT INTO sys_system_config (uuid, name, description, value_of_attribute, is_relevant, author, modifier)
VALUES (uuid_generate_v4(), 'mail_server_host', 'Адрес сервиса', NULL, TRUE, 1, 1);
INSERT INTO sys_system_config (uuid, name, description, value_of_attribute, is_relevant, author, modifier)
VALUES (uuid_generate_v4(), 'mail_server_port', 'Порт сервиса', NULL, TRUE, 1, 1);
INSERT INTO sys_system_config (uuid, name, description, value_of_attribute, is_relevant, author, modifier)
VALUES (uuid_generate_v4(), 'mail_server_username', 'Имя учетной записи', NULL, TRUE, 1, 1);
INSERT INTO sys_system_config (uuid, name, description, value_of_attribute, is_relevant, author, modifier)
VALUES (uuid_generate_v4(), 'mail_server_password', 'Пароль учетной записи', NULL, TRUE, 1, 1);
INSERT INTO sys_system_config (uuid, name, description, value_of_attribute, is_relevant, author, modifier)
VALUES (uuid_generate_v4(), 'mail_server_auth', 'Требуется авторизация', 'false', TRUE, 1, 1);
INSERT INTO sys_system_config (uuid, name, description, value_of_attribute, is_relevant, author, modifier)
VALUES (uuid_generate_v4(), 'mail_server_ssl', 'SSL/TLS', 'false', TRUE, 1, 1);
INSERT INTO sys_system_config (uuid, name, description, value_of_attribute, is_relevant, author, modifier)
VALUES (uuid_generate_v4(), 'mail_delivery_from_personal', 'Подпись в рассылке', NULL, TRUE, 1, 1);
INSERT INTO sys_system_config (uuid, name, description, value_of_attribute, is_relevant, author, modifier)
VALUES (uuid_generate_v4(), 'mail_delivery_from_address', 'E-mail системы', NULL, TRUE, 1, 1);
-- Блок настройки частоты уведомлений
INSERT INTO sys_system_config (uuid, name, description, value_of_attribute, is_relevant, author, modifier)
VALUES (uuid_generate_v4(), 'notification_frequency_event', 'О дате события', NULL, TRUE, 1, 1);
INSERT INTO sys_system_config (uuid, name, description, value_of_attribute, is_relevant, author, modifier)
VALUES (uuid_generate_v4(), 'notification_frequency_raw_claim', 'О необработанных заявках (дней)', 10, TRUE, 1, 1);
-- Анкетирование
INSERT INTO sys_system_config (uuid, name, description, value_of_attribute, is_relevant, author, modifier)
VALUES (uuid_generate_v4(), 'questioning_baptism', 'Крещение', NULL, TRUE, 1, 1);
INSERT INTO sys_system_config (uuid, name, description, value_of_attribute, is_relevant, author, modifier)
VALUES (uuid_generate_v4(), 'questioning_wedding', 'Венчание', NULL, TRUE, 1, 1);
-- Работа с беседами
INSERT INTO sys_system_config (uuid, name, description, value_of_attribute, is_relevant, author, modifier)
VALUES (uuid_generate_v4(), 'conversation_frequency_recording_person',
        'Частота записи мирянина на беседу (не чаще чем)', NULL, TRUE, 1, 1);
-- Работа с заявками
INSERT INTO sys_system_config (uuid, name, description, value_of_attribute, is_relevant, author, modifier)
VALUES (uuid_generate_v4(), 'claim_not_less_days', 'Не менее X с текущей даты', NULL, TRUE, 1, 1);
INSERT INTO sys_system_config (uuid, name, description, value_of_attribute, is_relevant, author, modifier)
VALUES (uuid_generate_v4(), 'claim_not_more_days', 'Не более Y дней с текущей даты', NULL, TRUE, 1, 1);
INSERT INTO sys_system_config (uuid, name, description, value_of_attribute, is_relevant, author, modifier)
VALUES (uuid_generate_v4(), 'claim_auto_remove', 'Количество дней для автоматического удаление заявки', 30, TRUE, 1, 1);
INSERT INTO sys_system_config (uuid, name, description, value_of_attribute, is_relevant, author, modifier)
VALUES (uuid_generate_v4(), 'claim_auto_transfer_to_free',
        'Количество дней для автоматического перевода заявки в статус свободная', 15, TRUE, 1, 1);
-- Параметры СМС сервиса
INSERT INTO sys_system_config (uuid, name, description, value_of_attribute, is_relevant, author, modifier)
VALUES (uuid_generate_v4(), 'sms_server_host', 'Адрес сервиса', NULL, TRUE, 1, 1);
INSERT INTO sys_system_config (uuid, name, description, value_of_attribute, is_relevant, author, modifier)
VALUES (uuid_generate_v4(), 'sms_database_login', 'Логин', NULL, TRUE, 1, 1);
INSERT INTO sys_system_config (uuid, name, description, value_of_attribute, is_relevant, author, modifier)
VALUES (uuid_generate_v4(), 'sms_database_password', 'Пароль', NULL, TRUE, 1, 1);
-- Иное
INSERT INTO sys_system_config (uuid, name, description, value_of_attribute, is_relevant, author, modifier)
VALUES (uuid_generate_v4(), 'other_count_lock', 'Количество блокировок', NULL, TRUE, 1, 1);
INSERT INTO sys_system_config (uuid, name, description, value_of_attribute, is_relevant, author, modifier)
VALUES (uuid_generate_v4(), 'other_disclaimer_text', 'Текст дисклеймера', NULL, TRUE, 1, 1);
INSERT INTO sys_system_config (uuid, name, description, value_of_attribute, is_relevant, author, modifier)
VALUES (uuid_generate_v4(), 'other_disclaimer_enable', 'Активация дисклеймера', 'false', TRUE, 1, 1);

-- Логотоип храма на главной странице
INSERT INTO sys_system_config (uuid, name, description, value_of_attribute, is_relevant, author, modifier)
VALUES (uuid_generate_v4(), 'default_custom_hram_photo', 'Настраиваемое дефолтное фото храма', '', TRUE, 1, 1);
INSERT INTO sys_system_config (uuid, name, description, value_of_attribute, is_relevant, author, modifier)
VALUES (uuid_generate_v4(), 'default_inproject_hram_photo', 'Дефолтное фото храма, входящее в проект', '/images/hrams/default.jpg', TRUE, 1, 1);
INSERT INTO sys_system_config (uuid, name, description, value_of_attribute, is_relevant, author, modifier)
VALUES (uuid_generate_v4(), 'destination', 'Расстояние между храмами', '5', TRUE, 1, 1);

/* sys_dict_event_types */
INSERT INTO sys_dict_event_types (uuid, name, code, label, is_relevant)
VALUES (uuid_generate_v4(), 'create_object', 1, 'Создание объекта', TRUE);
INSERT INTO sys_dict_event_types (uuid, name, code, label, is_relevant)
VALUES (uuid_generate_v4(), 'change_object', 2, 'Изменение объекта', TRUE);
INSERT INTO sys_dict_event_types (uuid, name, code, label, is_relevant)
VALUES (uuid_generate_v4(), 'object_delete', 3, 'Удаление объекта', TRUE);


/* claim_dict_status */
INSERT INTO claim_dict_status (uuid, name, code, label, description, is_deleted, is_relevant)
VALUES (uuid_generate_v4(), 'new', 1, 'Новая', 'Новая заявка', false, true);
INSERT INTO claim_dict_status (uuid, name, code, label, description, is_deleted, is_relevant)
VALUES (uuid_generate_v4(), 'in_progress', 2, 'В работе', 'Заявка в работе', false, true);
INSERT INTO claim_dict_status (uuid, name, code, label, description, is_deleted, is_relevant)
VALUES (uuid_generate_v4(), 'closed', 3, 'Подтвержденная', 'Подтвержденная заявка', false, true);

/* common_dict_message_direction */
INSERT INTO common_dict_message_direction (uuid, name, code, label, description, is_deleted, is_relevant)
VALUES (uuid_generate_v4(), 'from_priest', 1, 'От Священнослужителя',
        'Направление сообщения от священнослужителя мирянину', false, true);
INSERT INTO common_dict_message_direction (uuid, name, code, label, description, is_deleted, is_relevant)
VALUES (uuid_generate_v4(), 'from_user', 2, 'От Мирянина', 'Направление сообщения от мирянина священнослужителя', false,
        true);


/*message_dict_template*/
INSERT INTO message_dict_template (uuid, name, code, label, description, is_deleted, is_relevant)
VALUES (uuid_generate_v4(), 'registration', 1, 'Уведомление с СМС кодом', 'Для продолжения регистрации укажите код:',
        false, true);
INSERT INTO message_dict_template (uuid, name, code, label, description, is_deleted, is_relevant)
VALUES (uuid_generate_v4(), 'newclaim', 2, 'Уведомление о создании новой заявки',
        'На Вас была сформированная новая заявка. Для продолжения работы перейдите в карточку Заявки:', false, true);
INSERT INTO message_dict_template (uuid, name, code, label, description, is_deleted, is_relevant)
VALUES (uuid_generate_v4(), 'newmessage', 3, 'Уведомление о вхоядщем сообщении',
        'Вы получили новое сообшение. Для продолжения работы перейдите в блок сообшений:', false, true);
INSERT INTO message_dict_template (uuid, name, code, label, description, is_deleted, is_relevant)
VALUES (uuid_generate_v4(), 'deleteclaim', 4, 'Уведомление об автоматическом удалении заявки',
        'Ваша заявка была автоматически удалена', false, true);
INSERT INTO message_dict_template (uuid, name, code, label, description, is_deleted, is_relevant)
VALUES (uuid_generate_v4(), 'enatimeclaim', 5, 'Уведомление нарушении срока обработки заявки',
        'Заявка не была рассмотрена священослужителем в указанный срок. Для продолжения работы перейдите в карточку Заявки:',
        false, true);
INSERT INTO message_dict_template (uuid, name, code, label, description, is_deleted, is_relevant)
VALUES (uuid_generate_v4(), 'newslots', 6, 'Уведомление о создании объекта Беседы',
        'На Вас были сформированны новые объекты беседы', false, true);
INSERT INTO message_dict_template (uuid, name, code, label, description, is_deleted, is_relevant)
VALUES (uuid_generate_v4(), 'annulslots', 7, 'Уведомление об аннулировании объекта Беседы',
        'Ваша запись на беседу была отменена по инициативе священослужителя', false, true);
INSERT INTO message_dict_template (uuid, name, code, label, description, is_deleted, is_relevant)
VALUES (uuid_generate_v4(), 'reservslots', 8, 'Уведомление бронировании объекта беседы',
        'Произошло бронирование. Для продолжения работы перейдите в карточку Беседы:', false, true);
INSERT INTO message_dict_template (uuid, name, code, label, description, is_deleted, is_relevant)
VALUES (uuid_generate_v4(), 'checkslots', 9, 'Уведомление подтверждении бронирования',
        'Ваша встреча со священослужителем подтверждена', false, true);
INSERT INTO message_dict_template (uuid, name, code, label, description, is_deleted, is_relevant)
VALUES (uuid_generate_v4(), 'toendslots', 10, 'Уведомление необходимости указания результата встречи',
        'Вам необходимо указать результат встречи. Для продолжения работы перейдите в карточку Беседы:', false, true);
INSERT INTO message_dict_template (uuid, name, code, label, description, is_deleted, is_relevant)
VALUES (uuid_generate_v4(), 'newwork', 11, 'Уведомление создании дела',
        'Создано новое Дело. Для продолжения работы перейдите в карточку Дела:', false, true);
INSERT INTO message_dict_template (uuid, name, code, label, description, is_deleted, is_relevant)
VALUES (uuid_generate_v4(), 'checkTime', 12, 'Уведомление о приближении события',
        'Напоминание о скором времени события. Для продолжения работы перейдите в карточку События:', false, true);
INSERT INTO message_dict_template (uuid, name, code, label, description, is_deleted, is_relevant)
VALUES (uuid_generate_v4(), 'newAction', 13, 'Уведомление о создании Богослужения',
        'Вы указаны в качестве участника Богослужения. Для продолжения работы перейдите в карточку Богослужения:',
        false, true);
INSERT INTO message_dict_template (uuid, name, code, label, description, is_deleted, is_relevant)
VALUES (uuid_generate_v4(), 'checkAction', 14, 'Уведомление о конфликте в календаре Событий',
        'Было создано новое событие, в котором Вы указаны в качестве участника. В системе уже есть событие пересекающееся с данным временным интервалом. Для продолжения работы перейдите в карточку События:',
        false, true);


/*message_dict_type*/
INSERT INTO message_dict_type (uuid, name, code, label, description, is_deleted, is_relevant)
VALUES (uuid_generate_v4(), 'email', 1, 'Email', 'Email', false, true);
INSERT INTO message_dict_type (uuid, name, code, label, description, is_deleted, is_relevant)
VALUES (uuid_generate_v4(), 'sms', 2, 'СМС', 'СМС', false, true);
INSERT INTO message_dict_type (uuid, name, code, label, description, is_deleted, is_relevant)
VALUES (uuid_generate_v4(), 'inner', 3, 'Внутриссистемный', 'Внутриссистемный', false, true);

/*slots_dict_status*/
INSERT INTO slots_dict_status (uuid, name, code, label, description, is_deleted, is_relevant)
VALUES (uuid_generate_v4(), 'new', 1, 'Свободный', 'Свободный', false, true);
INSERT INTO slots_dict_status (uuid, name, code, label, description, is_deleted, is_relevant)
VALUES (uuid_generate_v4(), 'reserv', 2, 'Забронированный', 'Забронированный', false, true);
INSERT INTO slots_dict_status (uuid, name, code, label, description, is_deleted, is_relevant)
VALUES (uuid_generate_v4(), 'end', 3, 'Завершенный', 'Завершенный', false, true);

/*structure_dict_activity*/
INSERT INTO structure_dict_activity (uuid, name, code, label, description, is_deleted, is_relevant)
VALUES (uuid_generate_v4(), 'school', 1, 'Образовательная', 'Образовательная', false, true);
INSERT INTO structure_dict_activity (uuid, name, code, label, description, is_deleted, is_relevant)
VALUES (uuid_generate_v4(), 'social', 2, 'Социальная', 'Социальная', false, true);
INSERT INTO structure_dict_activity (uuid, name, code, label, description, is_deleted, is_relevant)
VALUES (uuid_generate_v4(), 'missionary', 3, 'Миссионерская', 'Миссионерская', false, true);
INSERT INTO structure_dict_activity (uuid, name, code, label, description, is_deleted, is_relevant)
VALUES (uuid_generate_v4(), 'else', 4, 'Другая', 'Другая', false, true);

/*structure_dict_type*/
INSERT INTO structure_dict_type (uuid, name, code, label, description, is_deleted, is_relevant)
VALUES (uuid_generate_v4(), 'EPARCHY', 1, 'Епархия', 'Епархия', false, true);
INSERT INTO structure_dict_type (uuid, name, code, label, description, is_deleted, is_relevant)
VALUES (uuid_generate_v4(), 'VICARIATE', 2, 'Викариаство', 'Викариаство', false, true);
INSERT INTO structure_dict_type (uuid, name, code, label, description, is_deleted, is_relevant)
VALUES (uuid_generate_v4(), 'DEANERY', 3, 'Благочиние', 'Благочиние', false, true);
INSERT INTO structure_dict_type (uuid, name, code, label, description, is_deleted, is_relevant)
VALUES (uuid_generate_v4(), 'HRAM', 4, 'Храм', 'Храм', false, true);