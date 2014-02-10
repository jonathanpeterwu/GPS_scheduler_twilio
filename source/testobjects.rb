module DatabaseInteraction

  # Conditionally checks for item class and calls the appropiate method
  # to add that item to the database, this is the interface for this method
  def add_to_database
    case self.class
    when Teacher
      add_teacher(self)
    when Student
      add_student(self)
    when Session
      add_session(self)
    end
  end

  def add_teacher(teacher)
    # crazy database jargon here
  end

  def add_student(student)
    # crazy database jargon here
  end

  def add_session(timespot)
    # crazy database jargon here
  end

  def get_timespots(teacher)
  end
end


################## Models ##################
class Student
  include DatabaseInteraction

  def initialize(name, last_name, phone)
    @name = name
    @last_name = last_name
    @phone = phone
    add_to_database(self)
  end
end

class Teacher
  include DatabaseInteraction

  def initialize(name, last_name, phone)
    @name = name
    @last_name = last_name
    @phone = phone
    add_to_database
  end
end

class Session

  def initialize(time, student, teacher)
    @student = student
    @teacher = teacher
    @time_desired = time
  end

  def add_r
  end
end

class Timespot
  attr_accessor :available
  attr_reader :time

  def initialize(time)
    @time = time
    @available = true
  end
end


################## Controller ##################
class Scheduler  #decides database type here with a variable
  require DatabaseInteraction

  def initialize
  end

  def available_teachers(timespot)
    # Returns an array
  end

  def available_times(teacher)
    timespots = get_timespots(teacher)
    print_availability(timespots)
  end

  def schedule(args={})
    args[:student]
    args[:teacher]
    args[:timespot]
  end
end



################## Viewer ##################
class Interface

end

monday = Scheduler.new
sherif = Teacher.new('Sheriff', 'Abushadi', '555555555' )
monday.available_times(sherif)

jose = Student.new('Jose', 'Menor', '123456789')
date = Session.new('11:30', jose, sherif)  ## this might be the unique appointment time
monday.available_teachers('12:00')

monday.schedule('jose','shadi', '12:00')
monday.available_spots('shadi')
monday.cancel_session('jose','sherif')
student.view_sessions