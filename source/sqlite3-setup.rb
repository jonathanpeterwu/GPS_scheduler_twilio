require 'sqlite3'
require 'faker'


# Naming database
DATABASE_NAME = "pairing-sessions-database-sqlite3"

db_connection = SQLite3::Database.new "#{DATABASE_NAME}.db"

#Reactivate if testing sqlite setup.rb
db_connection.execute("
  drop table if exists students;
  ")
db_connection.execute("
  drop table if exists teachers;
  ")
db_connection.execute("
  drop table if exists timeslots;
  ")

db_connection.execute("
  drop table if exists appointments;
  ")



db_connection.execute("
  create table students
  (
    id          integer primary key autoincrement,
    first_name  varchar(80),
    phone       varchar(80),
    cohort_name varchar(80)
    );
")

# Creates teacher table
db_connection.execute("
  CREATE TABLE teachers(
    id          integer primary key autoincrement,
    first_name  varchar(80),
    phone       varchar(80)
    );
")

# Creates time slot table
db_connection.execute("
  CREATE TABLE timeslots(
    id    integer primary key autoincrement,
    time  text
  );
")

db_connection.execute("
  CREATE TABLE appointments(
    id_Time_Slots  integer,
    id_Teacher     integer,
    id_Student     integer,
    FOREIGN KEY(id_Teacher) REFERENCES teachers(id),
    FOREIGN KEY(id_Time_Slots) REFERENCES timeslots(id),
    FOREIGN KEY(id_Student) REFERENCES students(id),
    PRIMARY KEY(id_Time_Slots,id_Teacher,id_Student)
  );
")

db_connection.execute("
  CREATE UNIQUE INDEX teacher_can_only_do_one_timeslot_at_a_time
    on appointments (id_Time_Slots, id_Teacher);

  CREATE UNIQUE INDEX students_have_one_appointment_per_day
    on appointments (id_Student);
")



#Populating tables using faker

db_connection.execute("
  INSERT INTO students
  (first_name, phone, cohort_name)
  VALUES
  ('Jamie', '+12342344567', 'banana slugs'),
  ('Johnny','+54687346709', 'banana slugs'),
  ('Armando','+54312334561', 'banana slugs'),
  ('Jose', '+12344562345', 'banana slugs');
")

db_connection.execute("
  INSERT INTO teachers
  (first_name, phone)
  VALUES
  ('Sherif', '+11142344567'),
  ('Brick', '+11564344567'),
  ('Jeffrey', '+38572344567'),
  ('Shadi', '+48672344567');
")

db_connection.execute("
  INSERT INTO timeslots
  (time)
  VALUES
  ('12pm'),
  ('1pm'),
  ('2pm'),
  ('3pm');
")

teachers = db_connection.execute("
  SELECT id FROM teachers
  ")
time_slots = db_connection.execute("
  SELECT id FROM timeslots
  ")

# p teachers
# p time_slots
teachers.flatten.each do |teacher_id|
  time_slots.flatten.each do |time_slot_id|
  db_connection.execute("
        INSERT INTO appointments
        (id_Time_Slots, id_Teacher)
        VALUES
        (#{time_slot_id}, #{teacher_id});
          ")
  end
end

test = db_connection.execute("
  SELECT * FROM timeslots
")

test2 = db_connection.execute("
  SELECT * FROM teachers
")

test3 = db_connection.execute("
  SELECT * FROM students
")

test4 = db_connection.execute("
  SELECT * FROM appointments
")

# puts test
# puts test2
# puts test3
# p test4
