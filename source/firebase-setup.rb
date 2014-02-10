require 'firebase'
require 'faker'

base_uri="https://gps-bananslugs.firebaseio.com/"


db_connection = Firebase.new(base_uri)


db_connection.push("students",
{
  first_name: "Jamie",
  phone: "+12342344567",
  cohort: "banana slugs"
})

db_connection.push("students",
{
  first_name: "Jose",
  phone: "+12344562345",
  cohort: "banana slugs"
}

db_connection.push("students",
{
  first_name: "Johnny",
  phone: "+54687346709",
  cohort: "banana slugs"
})

db_connection.push("students",
{
  first_name: "Armando",
  phone: "+54312334561",
  cohort: "banana slugs"
})