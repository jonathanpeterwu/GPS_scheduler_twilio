require 'sqlite3'

# As a user, I want to be able to check time slots for a specific teacher.
# As a user, I want to be able to check teachers for a specific time slot.
# As a user, I want to be able to see all available teachers and their open time slots.
# As a user, I want to be able to book a time slot with a specific teacher.

DATABASE_NAME = "pairing-sessions-database-sqlite3"


module DBWorker

  extend self

  @db_connection = SQLite3::Database.open "#{DATABASE_NAME}.db"


# Returns an array of tuples with the teacher names and time slots with no student assigned.

  def get_appointments
    availables = @db_connection.execute("
    SELECT first_name, time
    FROM appointments a
    JOIN teachers
    ON a.id_Teacher = teachers.id
    JOIN timeslots
    ON a.id_Time_Slots = timeslots.id
    WHERE a.id_Student IS NULL
    ")
  end

  def get_teacher_names
    teachers = @db_connection.execute("
    SELECT first_name
    FROM teachers
    ")
  end

  def get_teacher_availability(teacher)
    schedule = @db_connection.execute("
      SELECT time
      FROM appointments a
      JOIN teachers
      ON a.id_Teacher = teachers.id
      JOIN timeslots
      ON a.id_Time_Slots = timeslots.id
      WHERE a.id_Student IS NULL
      AND first_name LIKE '#{teacher}'
      ")
  end

# Updates the database by resetting all appointments to free (null in student id value).

  def cancel_all_appointments
    @db_connection.execute("
      UPDATE appointments
      SET id_Student = NULL
      ")
  end

# Input: string values of student name, teacher name and time slot time.
# Output: Updates the database with student id in appointments table.

  def make_appointment(student, teacher, time)
    @db_connection.execute("
      UPDATE appointments
      SET id_Student =
      (SELECT id FROM students WHERE first_name LIKE '#{student}')
      WHERE id_Time_Slots =
      (SELECT id FROM timeslots WHERE time LIKE '#{time}')
      AND id_Teacher =
      (SELECT id FROM teachers WHERE first_name LIKE '#{teacher}')
      ")
  end

  def confirm(student, input)
    test = @db_connection.execute("
      SELECT id_Student
      FROM appointments a
      JOIN students
      ON a.id_Student = students.id
      WHERE a.id_Teacher = '#{input[0]}'
      AND a.id_Time_Slots = '#{input[1]}'
      ")
    if test == @db_connection.execute("SELECT id_Student FROM appointments a
      JOIN students
      ON a.id_Student = students.id
      WHERE a.id_Teacher = '#{input[0]}'
      AND a.id_Time_Slots = '#{input[1]}'")
      true
    else
      nil
    end
  end
# Input: string values of teacher name and time slot time.
# Output: Updates the database by removing the student id from the appointments table.

  def cancel_appointment(student, teacher, time)
    @db_connection.execute("
      UPDATE appointments
      SET id_Student = NULL
      WHERE id_Time_Slots =
      (SELECT id FROM timeslots WHERE time LIKE '#{time}')
      AND id_Teacher =
      (SELECT id FROM teachers WHERE first_name LIKE '#{teacher}')
      AND id_Student =
      (SELECT id FROM students WHERE first_name LIKE '#{student}')

      ")
  end

# submit_query(array with teacher.first_name + time_slot.time)
# select student_id from appointments, teachers, time_slots
# where teacher.first_name and time_slot.tim == array values
end

##########################################
# Driver Code
##########################################

# puts "Available appointments..."
# puts DBWorker.get_appointments

# puts "Making appointment..."
# DBWorker.make_appointment('Jose', 'Sherif', '12pm')
# puts "Available appointments..."
# puts DBWorker.get_appointments

# puts "Making appointment..."
# DBWorker.make_appointment('Jamie', 'Shadi', '1pm')
# puts "Available appointments..."
# puts DBWorker.get_appointments

# puts "Canceling your appointment..."
# DBWorker.cancel_appointment('Jamie', 'Shadi', '1pm')
# puts "Available appointments..."
# puts DBWorker.get_appointments

# puts "Canceling appointments..."
# DBWorker.cancel_all_appointments
# puts "Available appointments..."
# puts DBWorker.get_appointments

# puts "Sherif is available: #{DBWorker.get_teacher_availability('Sherif')}"
# puts "Available appointments..."
# puts DBWorker.get_appointments


##########################################
# Desired functionality for implementation down the road
##########################################


# def add_student(student)
# end

# def add_teacher(teacher)
#   # crazy database jargon here
# end

# def add_session(timespot)
#   # crazy database jargon here
# end

# def get_timespots(teacher)
#   # SELECT WHERE = teacher.phone
# end