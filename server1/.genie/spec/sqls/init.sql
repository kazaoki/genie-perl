
-- clear tables
TRUNCATE TABLE news;
ALTER TABLE news AUTO_INCREMENT=10000;

-- init tables
INSERT INTO news ('post_date', 'message') VALUES('2016-04-07', 'testetestt');
