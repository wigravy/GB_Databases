-- Задача 1. У вас есть социальная сеть, где пользователи (id, имя) могут ставить друг другу лайки. 
-- Создайте необходимые таблицы для хранения данной информации. Создайте запрос, который выведет информацию:
-- id пользователя;
-- имя;
-- лайков получено;
-- лайков поставлено;
-- взаимные лайки.


-- Пользователь может не указывать дату рождения и пол
CREATE TABLE `user` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `surname` varchar(255) NOT NULL,
  `birthday` date DEFAULT NULL,
  `gender` enum('male','female') DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=14 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci


-- Можно предположить, что поиск будет вестись по имени и фамилии, стоит добавить индекс
CREATE INDEX user_name_IDX USING BTREE ON almost_tinder.`user` (name,surname);


INSERT into
	user (name, surname, birthday, gender)
VALUES
	('Anna', 'Olsen', '2000-05-13', 2),
	('Emma', 'Dam', '1995-04-22', 2),
	('William', 'Smith', '1989-12-31', 1),
	('James', 'Jones', '1999-02-24', 1),
	('Lucas', 'Davis', '1984-03-10', 1),
	('Logan', 'Anderson', '1995-07-24', 1),
	('Ava', 'Yang', '2001-04-01', 2),
	('Mia', 'Yang', '2001-04-01', 2),
	('Anna', 'Smith', '1988-12-15', 2),
	('Lucas', 'Dam', '1977-12-31', 1),
	('James', 'Briem', '1988-12-31', 1),
	('Alice', 'Yandex', '2017-10-10', NULL);
	
--Проверки идут на стороне приложения (пользователь не может поставить лайк себе, пользователь не может поставить лайк удаленной/не существующей странице)

CREATE TABLE `likes` (
  `from_user` int unsigned NOT NULL,
  `to_user` int unsigned NOT NULL,
  PRIMARY KEY (`from_user`,`to_user`),
  KEY `likes_FK_1` (`to_user`),
  CONSTRAINT `likes_FK` FOREIGN KEY (`from_user`) REFERENCES `user` (`id`),
  CONSTRAINT `likes_FK_1` FOREIGN KEY (`to_user`) REFERENCES `user` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci


INSERT into
	likes (from_user, to_user)
VALUES
	(2, 3),
	(3, 2),
	(3, 7),
	(4, 2),
	(5, 2),
	(4, 3),
	(4, 6),
	(5, 3),
	(6, 2),
	(7, 2),
	(7, 3),
	(6, 3),
	(13, 2),
	(13, 3),
	(13, 4),
	(13, 5),
	(13, 6),
	(13, 7),
	(13, 8),
	(13, 9),
	(13, 10),
	(13, 11),
	(13, 12);


SELECT
	user.id,
	user.name,
	user.surname,
	(
	SELECT
		COUNT(likes.from_user)
	FROM
		likes
	WHERE
		user.id = likes.from_user
	) AS likes_give,
	(
	SELECT
		COUNT(likes.to_user)
	FROM
		likes
	WHERE
		user.id = likes.to_user
	) AS likes_get,
	(
	SELECT
		COUNT(*)
	FROM
		likes as fu
	INNER JOIN
		likes as tu
	ON 
		(fu.from_user = tu.to_user 
		AND 
		tu.from_user = fu.to_user)
	WHERE 
		fu.from_user = user.id
	) AS mutual_likes
FROM 
	user	
ORDER BY 
	user.id
	
	
--Задача 2. Для структуры из задачи 1 выведите список всех пользователей, которые поставили лайк пользователям A и B (id задайте произвольно), но при этом не поставили лайк пользователю C.

SELECT
	user.id,
	user.name,
	user.surname		
FROM
	user
JOIN
	(SELECT likes.to_user
	FROM
	likes
	WHERE
	likes.to_user = 3
	OR 
	likes.to_user = 2	
	LIMIT 1
	) likes
WHERE
	NOT user.id = (
	SELECT likes.from_user
	FROM
	likes
	WHERE
	likes.to_user = 4
	)
ORDER BY
	user.id
	

-- Задача 3. Добавим сущности «Фотография» и «Комментарии к фотографии». Нужно создать функционал для пользователей, который позволяет ставить лайки не только пользователям, но и фото или комментариям к фото. Учитывайте следующие ограничения:
-- пользователь не может дважды лайкнуть одну и ту же сущность;
-- пользователь имеет право отозвать лайк;
-- необходимо иметь возможность считать число полученных сущностью лайков и выводить список пользователей, поставивших лайки;
-- в будущем могут появиться новые виды сущностей, которые можно лайкать.


-- Можно предположить, что нам понадобится расширение изображения (его тип)
CREATE TABLE `img_type` (
  `id` tinyint unsigned NOT NULL AUTO_INCREMENT,
  `type` varchar(255) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci


-- В бд храним ссылку (url) на изображение. Так как максимальная длинна url не ограничена (в одной статье путем экспериментов дошли до значения 100.000), то даем ему тип text. Никакой индексации и поиска по нему не предполагается.
CREATE TABLE `photo` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `title` varchar(255) DEFAULT NULL,
  `url` text NOT NULL,
  `img_type` tinyint unsigned NOT NULL,
  PRIMARY KEY (`id`),
  KEY `photo_FK` (`img_type`),
  CONSTRAINT `photo_FK` FOREIGN KEY (`img_type`) REFERENCES `img_type` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci


-- Изначально была идея сделать составной индекс по типу id_user + id_comment, чтобы было больше значений. (пример 1-1, 1-2, 1-3, 2-1, 2-2). Но не решил проблему автозаполнения второго столбца (для каждого пользователя счет должен начинаться с 1) или хранить двойной ссылкой по типу вк (номерСтраницы_номерЗаписи_номерКоммента).
CREATE TABLE `photo_comment` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `user_id` int unsigned NOT NULL,
  `photo_id` bigint unsigned NOT NULL,
  `comment` text NOT NULL,
  PRIMARY KEY (`id`),
  KEY `photo_comment_FK` (`user_id`),
  KEY `photo_comment_FK_1` (`photo_id`),
  CONSTRAINT `photo_comment_FK` FOREIGN KEY (`user_id`) REFERENCES `user` (`id`),
  CONSTRAINT `photo_comment_FK_1` FOREIGN KEY (`photo_id`) REFERENCES `photo` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci


CREATE TABLE `comment_like` (
  `comment_id` bigint unsigned NOT NULL,
  `user_id` int unsigned NOT NULL,
  `liked` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`comment_id`,`user_id`),
  KEY `comment_like_FK_1` (`user_id`),
  CONSTRAINT `comment_like_FK` FOREIGN KEY (`comment_id`) REFERENCES `photo_comment` (`id`),
  CONSTRAINT `comment_like_FK_1` FOREIGN KEY (`user_id`) REFERENCES `user` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci


CREATE TABLE `photo_like` (
  `photo_id` bigint unsigned NOT NULL,
  `user_id` int unsigned NOT NULL,
  `liked` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`photo_id`,`user_id`),
  KEY `photo_like_FK` (`user_id`),
  CONSTRAINT `photo_like_FK` FOREIGN KEY (`user_id`) REFERENCES `user` (`id`),
  CONSTRAINT `photo_like_FK_1` FOREIGN KEY (`photo_id`) REFERENCES `photo` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci










