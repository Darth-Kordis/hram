/*Тестовые пользователи:

  Настоятель Сергий
  Настоятель Преображенского сабора.
  логин:+7(222) 222-22-22
  пароль:root

  Священнослужиель Чак
  Служит под командованием настоятеля Сергия
  логин:+7(222) 111-11-11
  пароль:root

  Священнослужиель Собчак
  Служит под командованием настоятеля Сергия
  логин:+7(222) 333-33-33
  пароль:root

  Помощник Чук (помогает Собчаку)
  логин:+7(222) 311-11-11
  пароль:root

  Помощник Гек (помогает Собчаку)
  логин:+7(222) 322-22-22
  пароль:root

  Мирянин Елисей
  логин:+7(333) 333-33-33
  пароль:root
*/

/* common_action */
INSERT INTO common_action(uuid, code, name, label, is_claim, is_slot, is_work, is_ministration, long_time, author, modifier)
VALUES (uuid_generate_v4(), 1, 'conversation', 'Беседа', true, true, true, false, 30, 1, 1);
INSERT INTO common_action(uuid, code, name, label, is_claim, is_slot, is_work, is_ministration, long_time, author, modifier)
VALUES (uuid_generate_v4(), 2, 'morning_liturgy', 'Утренняя литургия', false, false, false, true , 30, 1, 1);
INSERT INTO common_action(uuid, code, name, label, is_claim, is_slot, is_work, is_ministration, long_time, author, modifier)
VALUES (uuid_generate_v4(), 3, 'evening_liturgy', 'Вечерняя литургия', false, false, false, true, 30, 1, 1);
INSERT INTO common_action(uuid, code, name, label, is_claim, is_slot, is_work, is_ministration, long_time, author, modifier)
VALUES (uuid_generate_v4(), 4, 'wedding', 'Венчание', true, false, false, false, 30, 1, 1);
INSERT INTO common_action(uuid, code, name, label, is_claim, is_slot, is_work, is_ministration, long_time, author, modifier)
VALUES (uuid_generate_v4(), 5, 'baptism', 'Крещение', true, false, false, false, 30, 1, 1);
INSERT INTO common_action(uuid, code, name, label, is_claim, is_slot, is_work, is_ministration, long_time, author, modifier)
VALUES (uuid_generate_v4(), 6, 'funeral', 'Отпевание', true, false, true, false, 30, 1, 1);

/*library_dict_type*/
INSERT INTO library_dict_type (uuid, name, code, label, description, is_deleted, is_relevant)
VALUES (uuid_generate_v4(), 't1', 1, 'Тематика 1', 'Общая тематика', false, true);
INSERT INTO library_dict_type (uuid, name, code, label, description, is_deleted, is_relevant)
VALUES (uuid_generate_v4(), 't2', 2, 'Тематика 2', 'Спец. тематика', false, true);

/*structure_dict_town*/
INSERT INTO structure_dict_town (uuid, name, code, label, description, is_deleted, is_relevant)
VALUES (uuid_generate_v4(), 'Moscow', 1, 'Москва', 'Москва', false, true);

/*structure_dict_metro*/
INSERT INTO structure_dict_metro (uuid, name, code, label, description, is_deleted, is_relevant, town_ref)
VALUES (uuid_generate_v4(), 'Park Pobedy', 1, 'Парк Победы', 'Парк Победы', false, true, 1);
INSERT INTO structure_dict_metro (uuid, name, code, label, description, is_deleted, is_relevant, town_ref)
VALUES (uuid_generate_v4(), 'Taganskaya', 2, 'Таганская', 'Таганская', false, true, 1);
INSERT INTO structure_dict_metro (uuid, name, code, label, description, is_deleted, is_relevant, town_ref)
VALUES (uuid_generate_v4(), 'Proletarskaya', 3, 'Пролетарская', 'Пролетарская', false, true, 1);

/*sys_dict_san*/
INSERT INTO sys_dict_san (uuid, name, code, label, description, is_deleted, is_relevant)
VALUES (uuid_generate_v4(), 'patriarch', 1, 'Патриарх', 'Требуется полчения данных для справочника', false, true);
INSERT INTO sys_dict_san (uuid, name, code, label, description, is_deleted, is_relevant)
VALUES (uuid_generate_v4(), 'metropolitan', 2, 'Митрополит', '', false, true);
INSERT INTO sys_dict_san (uuid, name, code, label, description, is_deleted, is_relevant)
VALUES (uuid_generate_v4(), 'bishop', 3, 'Епископ', '', false, true);
INSERT INTO sys_dict_san (uuid, name, code, label, description, is_deleted, is_relevant)
VALUES (uuid_generate_v4(), 'archimandrite', 4, 'Архимандрит', '', false, true);
INSERT INTO sys_dict_san (uuid, name, code, label, description, is_deleted, is_relevant)
VALUES (uuid_generate_v4(), 'hegumen', 5, 'Игумен', 'Настоятель монастыря', false, true);
INSERT INTO sys_dict_san (uuid, name, code, label, description, is_deleted, is_relevant)
VALUES (uuid_generate_v4(), 'hieromonk', 6, 'Иеромонах', 'Может проводить таинства', false, true);
INSERT INTO sys_dict_san (uuid, name, code, label, description, is_deleted, is_relevant)
VALUES (uuid_generate_v4(), 'hierodeacon', 7, 'Иеродиакон', 'Помощник', false, true);
INSERT INTO sys_dict_san (uuid, name, code, label, description, is_deleted, is_relevant)
VALUES (uuid_generate_v4(), 'deacon', 8, 'Диакон', 'Помощник', false, true);

/*sys_dict_specialization*/
INSERT INTO sys_dict_specialization (uuid, name, code, label, description, is_deleted, is_relevant)
VALUES (uuid_generate_v4(), 'theologian', 1, 'Теология', 'Требуется полчения данных для справочника', false,
        true);
INSERT INTO sys_dict_specialization (uuid, name, code, label, description, is_deleted, is_relevant)
VALUES (uuid_generate_v4(), 'painter', 2, 'Живопись', '', false, true);
INSERT INTO sys_dict_specialization (uuid, name, code, label, description, is_deleted, is_relevant)
VALUES (uuid_generate_v4(), 'teacher', 3, 'Преподавание', '', false, true);
INSERT INTO sys_dict_specialization (uuid, name, code, label, description, is_deleted, is_relevant)
VALUES (uuid_generate_v4(), 'conductor', 4, 'Дирижирование', '', false, true);
INSERT INTO sys_dict_specialization (uuid, name, code, label, description, is_deleted, is_relevant)
VALUES (uuid_generate_v4(), 'it-admin', 5, 'Администрирование информационных систем', '', false, true);

/* structure_member */
INSERT INTO structure_member (uuid, name, label, author, modifier, is_deleted, is_relevant, parent_id,
                              type_ref, address,town_ref, metro_ref)
VALUES (uuid_generate_v4(), 'Преображенский сабор' , 'Собор Преображения Господня в Новоспасском монастыре',
        1, 1 ,false, true, null , 4,'Крестьянская площадь, 10, стр. 12',1,3);
INSERT INTO structure_member (uuid, name, label, author, modifier, is_deleted, is_relevant, parent_id,
                              type_ref, address,town_ref, metro_ref)
VALUES (uuid_generate_v4(), 'Церковь Симеона Столпника' , 'Храм Преподобного Симеона Столпника за Яузой',
        1, 1 ,false, true, null , 4,'Николоямская ул., 10-12с8',1,2);
INSERT INTO structure_member (uuid, name, label, author, modifier, is_deleted, is_relevant, parent_id,
                              type_ref, address,town_ref, metro_ref)
VALUES (uuid_generate_v4(), 'Георгиевский храм' , 'Храм Великомученика Георгия Победоносца',
        1, 1 ,false, true, null , 4,'площадь Победы, 3Б',1,1);

/* structure_hram */
INSERT INTO structure_hram (uuid, author,  modifier, is_deleted, is_relevant, structure_ref,
                            description, web_url, contacts, history, religion, start_work_time, finish_work_time, visible_priests)
VALUES (uuid_generate_v4(), 1, 1, false , true, 1, 'Преображенский сабор', null, '+7 (495) 676-95-70',
        'Давным-давно...', 'Отсутствуют', '07:00', '20:00', true);
INSERT INTO structure_hram (uuid, author,  modifier, is_deleted, is_relevant, structure_ref,
                            description, web_url, contacts, history, religion, start_work_time, finish_work_time, visible_priests)
VALUES (uuid_generate_v4(), 1, 1, false , true, 2, 'Церковь Симеона Столпника', null, '+7 (495) 676-95-70',
        'Давным-давно...', 'Отсутствуют', '07:00', '20:00', true);
INSERT INTO structure_hram (uuid, author,  modifier, is_deleted, is_relevant, structure_ref,
                            description, web_url, contacts, history, religion, start_work_time, finish_work_time, visible_priests)
VALUES (uuid_generate_v4(), 1, 1, false , true, 3, 'Георгиевский храм', 'altaryvic.ru', '+7 (499) 142-08-86',
        'Давным-давно...', 'Отсутствуют', '09:00', '19:00', true);

/* structure_link_hram_activity_gb */
INSERT INTO structure_link_hram_activity_gb (description, hram_ref, activity_ref)
VALUES ('Преображенский сабор c социальной активностью', 1, 2);
INSERT INTO structure_link_hram_activity_gb (description, hram_ref, activity_ref)
VALUES ('Преображенский сабор c миссионерской активностью', 1, 3);
INSERT INTO structure_link_hram_activity_gb (description, hram_ref, activity_ref)
VALUES ('Церковь Симеона Столпника c социальной активностью', 2, 2);
INSERT INTO structure_link_hram_activity_gb (description, hram_ref, activity_ref)
VALUES ('Георгиевский храм c социальной активностью', 3, 2);

/* sys_users */
INSERT INTO sys_users (uuid, surname, firstname, middlename, member_ref, is_deleted, is_relevant)
VALUES (uuid_generate_v4(), 'Настоятель', 'Сергий', '',1, FALSE, TRUE);
INSERT INTO sys_users (uuid, surname, firstname, middlename, is_deleted, is_relevant)
VALUES (uuid_generate_v4(), 'Мирянин', 'Елисей', '', FALSE, TRUE);
INSERT INTO sys_users (uuid, surname, firstname, middlename, member_ref, is_deleted, is_relevant)
VALUES (uuid_generate_v4(), 'Священнослужиель', 'Чак', '',1, FALSE, TRUE);
INSERT INTO sys_users (uuid, surname, firstname, middlename, member_ref, is_deleted, is_relevant)
VALUES (uuid_generate_v4(), 'Священнослужиель', 'Собчак', '',1, FALSE, TRUE);
INSERT INTO sys_users (uuid, surname, firstname, middlename, member_ref, is_deleted, is_relevant)
VALUES (uuid_generate_v4(), 'Помощник', 'Чук', '',1, FALSE, TRUE);
INSERT INTO sys_users (uuid, surname, firstname, middlename, member_ref, is_deleted, is_relevant)
VALUES (uuid_generate_v4(), 'Помощник', 'Гек', '',1, FALSE, TRUE);

/* sys_link_users_roles_gb */
INSERT INTO sys_link_users_roles_gb (description, user_ref, role_ref)
VALUES ('Связь пользователя Настоятель Сергий с ролью Настоятель', 3, 3);
INSERT INTO sys_link_users_roles_gb (description, user_ref, role_ref)
VALUES ('Связь пользователя Священнослужиель Чак с ролью Священнослужитель', 5, 4);
INSERT INTO sys_link_users_roles_gb (description, user_ref, role_ref)
VALUES ('Связь пользователя Священнослужиель Собчак с ролью Священнослужитель', 6, 4);
INSERT INTO sys_link_users_roles_gb (description, user_ref, role_ref)
VALUES ('Связь пользователя Помощник Чук с ролью Помощник', 7, 5);
INSERT INTO sys_link_users_roles_gb (description, user_ref, role_ref)
VALUES ('Связь пользователя Помощник Гек с ролью Помощник', 8, 5);
INSERT INTO sys_link_users_roles_gb (description, user_ref, role_ref)
VALUES ('Связь пользователя Мирянин Елисей с ролью Мирянина', 4, 6);

/* sys_authen */
INSERT INTO sys_authen (uuid, name, type_ref, user_ref, is_relevant, author, modifier)
VALUES (uuid_generate_v4(), '+7(222) 222-22-22', 1, 3, TRUE, 1, 1);
INSERT INTO sys_authen (uuid, name, type_ref, user_ref, is_relevant, author, modifier)
VALUES (uuid_generate_v4(), '+7(333) 333-33-33', 1, 4, TRUE, 1, 1);
INSERT INTO sys_authen (uuid, name, type_ref, user_ref, is_relevant, author, modifier)
VALUES (uuid_generate_v4(), '+7(222) 111-11-11', 1, 5, TRUE, 1, 1);
INSERT INTO sys_authen (uuid, name, type_ref, user_ref, is_relevant, author, modifier)
VALUES (uuid_generate_v4(), '+7(222) 333-33-33', 1, 6, TRUE, 1, 1);
INSERT INTO sys_authen (uuid, name, type_ref, user_ref, is_relevant, author, modifier)
VALUES (uuid_generate_v4(), '+7(222) 311-11-11', 1, 7, TRUE, 1, 1);
INSERT INTO sys_authen (uuid, name, type_ref, user_ref, is_relevant, author, modifier)
VALUES (uuid_generate_v4(), '+7(222) 322-22-22', 1, 8, TRUE, 1, 1);

/* sys_passwords */
INSERT INTO sys_passwords (uuid, content, authen_ref, is_relevant, author, modifier)
VALUES (uuid_generate_v4(), '{bcrypt}$2a$10$SjZ4iWx/Ep7MaxWrU/PPeeqDMNJyFSQoM1N.rx8yoz2JoTKL24FK.', 2, TRUE, 1, 1);
INSERT INTO sys_passwords (uuid, content, authen_ref, is_relevant, author, modifier)
VALUES (uuid_generate_v4(), '{bcrypt}$2a$10$SjZ4iWx/Ep7MaxWrU/PPeeqDMNJyFSQoM1N.rx8yoz2JoTKL24FK.', 3, TRUE, 1, 1);
INSERT INTO sys_passwords (uuid, content, authen_ref, is_relevant, author, modifier)
VALUES (uuid_generate_v4(), '{bcrypt}$2a$10$SjZ4iWx/Ep7MaxWrU/PPeeqDMNJyFSQoM1N.rx8yoz2JoTKL24FK.', 4, TRUE, 1, 1);
INSERT INTO sys_passwords (uuid, content, authen_ref, is_relevant, author, modifier)
VALUES (uuid_generate_v4(), '{bcrypt}$2a$10$SjZ4iWx/Ep7MaxWrU/PPeeqDMNJyFSQoM1N.rx8yoz2JoTKL24FK.', 5, TRUE, 1, 1);
INSERT INTO sys_passwords (uuid, content, authen_ref, is_relevant, author, modifier)
VALUES (uuid_generate_v4(), '{bcrypt}$2a$10$SjZ4iWx/Ep7MaxWrU/PPeeqDMNJyFSQoM1N.rx8yoz2JoTKL24FK.', 6, TRUE, 1, 1);
INSERT INTO sys_passwords (uuid, content, authen_ref, is_relevant, author, modifier)
VALUES (uuid_generate_v4(), '{bcrypt}$2a$10$SjZ4iWx/Ep7MaxWrU/PPeeqDMNJyFSQoM1N.rx8yoz2JoTKL24FK.', 7, TRUE, 1, 1);

/* sys_users_contact */
INSERT INTO sys_users_contact (uuid, content, description, type_ref, user_ref, author, modifier, is_deleted, is_relevant)
VALUES (uuid_generate_v4(), 'sergiy@test.com','Почта Настоятеля Сергия',1, 3, 1, 1,false ,true);
INSERT INTO sys_users_contact (uuid, content, description, type_ref, user_ref, author, modifier, is_deleted, is_relevant)
VALUES (uuid_generate_v4(), 'сhuck@test.com','Почта Священнослужителя Чак',1, 4, 1, 1,false ,true);
INSERT INTO sys_users_contact (uuid, content, description, type_ref, user_ref, author, modifier, is_deleted, is_relevant)
VALUES (uuid_generate_v4(), 'sob.сhuck@test.com','Почта Священнослужителя Собчак',1, 5, 1, 1,false ,true);
INSERT INTO sys_users_contact (uuid, content, description, type_ref, user_ref, author, modifier, is_deleted, is_relevant)
VALUES (uuid_generate_v4(), 'ch@test.com','Почта Помощник Чук',1, 6, 1, 1,false ,true);
INSERT INTO sys_users_contact (uuid, content, description, type_ref, user_ref, author, modifier, is_deleted, is_relevant)
VALUES (uuid_generate_v4(), 'gek@test.com','Почта Помощник Гек',1, 7, 1, 1,false ,true);
INSERT INTO sys_users_contact (uuid, content, description, type_ref, user_ref, author, modifier, is_deleted, is_relevant)
VALUES (uuid_generate_v4(), '+7(222) 222-22-22','Телефон Настоятеля Сергия',2, 3, 1, 1,false ,true);
INSERT INTO sys_users_contact (uuid, content, description, type_ref, user_ref, author, modifier, is_deleted, is_relevant)
VALUES (uuid_generate_v4(), '+7(222) 111-11-11','Телефон Священнослужителя Чак',2, 4, 1, 1,false ,true);
INSERT INTO sys_users_contact (uuid, content, description, type_ref, user_ref, author, modifier, is_deleted, is_relevant)
VALUES (uuid_generate_v4(), '+7(222) 333-33-33','Телефон Священнослужителя Собчак',2, 5, 1, 1,false ,true);
INSERT INTO sys_users_contact (uuid, content, description, type_ref, user_ref, author, modifier, is_deleted, is_relevant)
VALUES (uuid_generate_v4(), '+7(222) 311-11-11','Телефон Помощник Чук',2, 6, 1, 1,false ,true);
INSERT INTO sys_users_contact (uuid, content, description, type_ref, user_ref, author, modifier, is_deleted, is_relevant)
VALUES (uuid_generate_v4(), '+7(222) 322-22-22','Почта Помощник Гек',2, 7, 1, 1,false ,true);

/* sys_link_users_users_gb */
INSERT INTO sys_link_users_users_gb (user_ref, sub_user_ref)
VALUES (4, 5);
INSERT INTO sys_link_users_users_gb (user_ref, sub_user_ref)
VALUES (4, 6);

/* claim_object */
INSERT INTO claim_object (uuid, is_deleted, is_relevant, claim_status, is_free, object_type, user_id, performer, user_address, description, comment, first_timestamp, end_timestamp, is_hram, author, modifier)
VALUES (uuid_generate_v4(), false, true, 1, true, 1, 4, null, 'ул. Подшипниковая, д.4, кв. 6', 'blah', null, '2017-12-03 06:15:30.000000', '2019-12-03 06:15:30.000000', false, 4, 3);
INSERT INTO claim_object (uuid, is_deleted, is_relevant, claim_status, is_free, object_type, user_id, performer, user_address, description, comment, first_timestamp, end_timestamp, is_hram, author, modifier)
VALUES (uuid_generate_v4(), false, true, 3, true, 1, 4, 3, 'ул. Синей канарейки, д.24, кв. 667', 'blah', 'что за дела?', '2018-12-03 06:15:30.000000', '2020-12-03 06:15:30.000000', false, 4, 3);
INSERT INTO claim_object (uuid, is_deleted, is_relevant, claim_status, is_free, object_type, user_id, performer, user_address, description, comment, first_timestamp, end_timestamp, is_hram, author, modifier)
VALUES (uuid_generate_v4(), false, true, 2, true, 1, 4, 3, 'ул. Ерошевского, д.3', 'blah', null, '2018-02-03 06:15:30.000000', '2018-10-10 06:15:30.000000', false, 4, 4);
INSERT INTO claim_object (uuid, is_deleted, is_relevant, claim_status, is_free, object_type, user_id, performer, user_address, description, comment, first_timestamp, end_timestamp, is_hram, author, modifier)
VALUES (uuid_generate_v4(), false, true, 2, true, 1, 4, 3, 'ул. Западносибирскомагистральная, 654км', 'blah', null, '2019-12-03 06:15:30.000000', '2019-12-05 06:15:30.000000', false, 4, 4);
INSERT INTO claim_object (uuid, is_deleted, is_relevant, claim_status, is_free, object_type, user_id, performer, user_address, description, comment, first_timestamp, end_timestamp, is_hram, author, modifier)
VALUES (uuid_generate_v4(), false, true, 1, true, 1, 4, null, 'ул. Рукапомощная, палата 6, койка 9', 'blah', null, '2017-12-03 06:15:30.000000', '2019-12-03 06:15:30.000000', false, 4, 4);
INSERT INTO claim_object (uuid, is_deleted, is_relevant, claim_status, is_free, object_type, user_id, performer, user_address, description, comment, first_timestamp, end_timestamp, is_hram, author, modifier)
VALUES (uuid_generate_v4(), false, true, 1, true, 1, 4, null, 'ул. Синей канарейки, д.24, кв. 668', 'test', null, '2017-12-03 06:15:30.000000', '2019-12-03 06:15:30.000000', false, 4, 4);
INSERT INTO claim_object (uuid, is_deleted, is_relevant, claim_status, is_free, object_type, user_id, performer, user_address, description, comment, first_timestamp, end_timestamp, is_hram, author, modifier)
VALUES (uuid_generate_v4(), false, true, 1, true, 1, 4, null, null, 'тест', null, '2019-04-26 15:12:15.723000', '2019-04-30 15:12:18.579000', false, 4, 4);

/* claim_message */
INSERT INTO claim_message (uuid, is_deleted, is_relevant, performer_id, user_id, message, destination, claim, author, modifier)
VALUES (uuid_generate_v4(), false, true, 3, 4,'Здравствуйте, отец',2,2,3,3);
INSERT INTO claim_message (uuid, is_deleted, is_relevant, performer_id, user_id, message, destination, claim, author, modifier)
VALUES (uuid_generate_v4(), false, true, 3, 4,'Привет, дитя',1,2,3,3);

/* library_object */
INSERT INTO library_object (uuid, author, modifier, is_deleted, is_relevant, type_ref, name, url, description, author_ref, published, file_ref, label)
VALUES (uuid_generate_v4(), 3, 3, false, true, 2, 'Домашняя работа на тему: "Изучение влияния солнечных затмений на веру в человека и человечество"', 'ya.ru', 'сабж',3,true, 1,'Скажика, дядя...');

/* message_object */
INSERT INTO message_object (uuid, author, modifier, is_deleted, is_relevant, type_ref, user_ref, text_message, is_read)
VALUES (uuid_generate_v4(), 3,1,false , true, 1,4,'Сообщение по Email',false);
INSERT INTO message_object (uuid, author, modifier, is_deleted, is_relevant, type_ref, user_ref, text_message, is_read)
VALUES (uuid_generate_v4(), 3,1,false , true, 3,4,'Внутреннее сообщение',false);
INSERT INTO message_object (uuid, author, modifier, is_deleted, is_relevant, type_ref, user_ref, text_message, is_read)
VALUES (uuid_generate_v4(), 4,1,false , true, 3,3,'Внутреннее сообщение в обратную сторону',false);

/* ministration_object */
INSERT INTO ministration_object (uuid, author, modifier, is_deleted, is_relevant, hram, object_type, date_timestamp, date_end_timestamp, description, is_report)
VALUES (uuid_generate_v4(), 1, 1, false, true, 1, 2,'2019-04-26 06:00:15','2019-04-26 10:00:15','Сбор на утреннюю литургию',true);
INSERT INTO ministration_object (uuid, author, modifier, is_deleted, is_relevant, hram, object_type, date_timestamp, date_end_timestamp, description, is_report)
VALUES (uuid_generate_v4(), 1, 1, false, true, 1, 3,'2019-02-26 20:00:15','2019-04-26 10:00:15','Сбор на вечернюю литургию',true);

/* ministration_performer */
INSERT INTO ministration_performer (uuid, author, modifier, is_deleted, is_relevant, ministration, performer_name, performer, is_main_performer)
VALUES (uuid_generate_v4(), 1, 1, false, true,1,'Настоятель Сергий',3,true);
INSERT INTO ministration_performer (uuid, author, modifier, is_deleted, is_relevant, ministration, performer_name, performer, is_main_performer)
VALUES (uuid_generate_v4(), 1, 1, false, true,2,'Настоятель Сергий',3,true);

/* slots_objects */
INSERT INTO slots_object (uuid, author, modifier, is_deleted, is_relevant, performer, hram, status, object_type, auto_create, from_timestamp, to_timestamp, is_report, comment, result, result_comment)
VALUES (uuid_generate_v4(),1,1,false,true, 3, 1, 1,1,false,'2019-04-26 20:00:15','2019-04-26 20:00:15',true,'что-то с чем-то', true, 'хорошо помолились');

/* slots_reservation */
INSERT INTO slots_reservation (uuid, author, modifier, is_deleted, is_relevant, user_id, slot, is_applay)
VALUES (uuid_generate_v4(), 1,1,false,true,1,1,false);

/* slots_message */
INSERT INTO slots_message (uuid, is_deleted, is_relevant, performer_id, user_id, message, destination, slot, author, modifier)
VALUES (uuid_generate_v4(), false, true, 4,5,'Письмо по слотам',1,1, 4,4);

/* structure_link_users_duty_gb */
INSERT INTO structure_link_users_duty_gb (description, hram_ref, user_ref, date_ref)
VALUES ('Вечно дежурный Чак',1,5,'2019-04-26');

/* workitem_object */
INSERT INTO workitem_object (uuid, author, modifier, is_deleted, is_relevant, performer, date_timestamp, date_end_timestamp, user_ref, object_type, hram_ref, user_phone, user_email, user_address, description, is_report)
VALUES (uuid_generate_v4(), 1,1,false, true,4,'2019-04-26 20:00:15','2019-04-27 20:00:15',4,1,1,'+7(333) 333-33-33','miryanin@test.com','Черепичная, д.26','тест', true );