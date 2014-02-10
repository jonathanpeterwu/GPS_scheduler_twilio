require_relative 'test_module'
require_relative 'twilioapi'
require 'debugger'
require 'ruby_cowsay'
################## Controller ##################
class Scheduler
  attr_reader :interface, :name_of_user

  include DBWorker
  include TwilioMessage

  def initialize
    @interface = Interface.new
    puts @interface.start_up
    start!
  end

  def start!
    DBWorker.cancel_all_appointments # if you want to reset all appointments for testing
    @name_of_user = user_input
    puts @interface.get_phone_number
    @phone_of_user = user_phone
    print_availability(DBWorker.get_appointments)
    choice_of_user = user_input
    check_for_choice(choice_of_user)
  end

  def user_input
    gets.chomp
  end

  def user_phone
    gets.chomp
  end

  def print_availability(availables)
    steg = Cow.new({ :cow => 'stegosaurus' })
    puts steg.say("Welcome to the 90's")
    puts @interface.available_time
    counter = 1
    availables.each do |tuple|
      puts "#{tuple.join(' ')}\n----------------"
      counter += 1
    end
    puts @interface.enter_teacher_time_choice
  end

  def check_for_choice(appoint_time)
    teachers_time = DBWorker.get_appointments
    choice = /(?<teacher>[a-zA-Z]+)\s(?<time>[0-9]{1,2}(PM|pm))/.match(appoint_time)
    choice = [choice[:teacher].capitalize!, choice[:time]]
    error_message if choice.nil?
    if teachers_time.include?(choice)
      TwilioMessage.send_message(@name_of_user, choice[0], choice[1], @phone_of_user)
      submit_query(choice)
    elsif appoint_time == 'h'
      help_message
    elsif
      not_available
    end
  end

  def submit_query(input) # should pass in 'shadi 3pm' as an array
    teacher = input[0]
    time = input[1]
    DBWorker.make_appointment(@name_of_user, teacher, time)
    if confirm_appointment(input)
      print_confirmation(@name_of_user, teacher, time)
    else
      reboot!
    end
  end

  def reboot!
    puts @interface.reboot
    start!
  end

  def print_confirmation(name_of_user, teacher, time)
    puts @interface.print_confirmation(name_of_user, teacher, time)
  end


  def get_teacher_schedule(teacher)
    puts DBWorker.get_teacher_availability(teacher)
  end

  def not_available
    puts @interface.not_available
    start!
  end

  def error_message
    puts @interface.error
    start!
  end

  def help_message
    puts @interface.help
    start!
  end

  def confirm_appointment(input)
    DBWorker.confirm(@user_input, input)
  end

end


################## Viewer ##################
class Interface

  def initialize
  end

  def start_up
    "Welcome to the DBC Guided Pairing Session (GPS) Scheduler \nPlease enter your name: "
  end

  def available_time
    "\nThese are the available teachers and times\n----------------\n"
  end

  def get_phone_number
    "Please enter phone number like this '+12123371234'   "
  end

  def enter_teacher_time_choice
   "Please type teacher and time you want (type 'h' for help). "
  end

  def print_confirmation(student, teacher, time)
    "Confirmed: #{student} has an appointment with #{teacher} at #{time}."
  end

  def help
    return "Please type something like the following : 'Shadi 3pm'\nPress ENTER to try again"
  end

  def error
    return "Incorrect formatting please re-enter your name to try again."
  end

  def not_available
    return "Sorry, the time you have requested is no longer available please try another time by pressing ENTER"
  end

  def reboot
    return "Please try again...looks like this spot got taken.\nPress enter to look at available spots."
  end

end


# Driver Code

monday = Scheduler.new