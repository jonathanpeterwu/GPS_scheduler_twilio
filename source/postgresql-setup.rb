require 'pg'
require 'faker'


DATABASE_NAME = "pairing-sessions-database-postgresql"


ignore_errors = "/dev/null 2>&1" # this is a little helper for the line below
`createdb #{DATABASE_NAME} #{ignore_errors}`

db_connection = PG.connect( dbname: DATABASE_NAME ) # Creating database

db_connection.exec("drop table if exists students, teachers, timeslots;")  # Drop creating table if already exists

db_connection.exec('
  create table students
  (
    id SERIAL,
    first_name  varchar(80),
    phone       varchar(80),
    cohort_name varchar(80)
    );
')

db_connection.exec('
  CREATE TABLE teachers(
    id SERIAL,
    first_name  varchar(80),
    phone       varchar(80)
    );
')

db_connection.exec("
  CREATE TABLE timeslots(
    id SERIAL,
    time  text
  );
")


#GENERATING DATABASES

db_connection.exec("
  insert into students (first_name, phone, cohort_name)
  values ('Jamie', '+12342344567', 'banana slugs'),
  ('Johnny','+54687346709', 'banana slugs'),
  ('Armando','+54312334561', 'banana slugs'),
  ('Jose', '+12344562345', 'banana slugs');
")

db_connection.exec("
  insert into teachers (first_name, phone)
  values ('Sherif', '+11142344567'),
  ('Brick', '+11564344567'),
  ('Jeffrey', '+38572344567'),
  ('Shadi', '+48672344567');
")

db_connection.exec("
  insert into timeslots (time)
  values ('12pm'),
  ('1pm'),
  ('2pm'),
  ('3pm');
")


results = db_connection.exec("select * from students;")
results2 = db_connection.exec("select * from teachers;")
results3 = db_connection.exec("select * from timeslots;")


p results.values # SUPER IMPORTANT PRINTS DIFFERENTLY FROM SQLITE3.... need to call values