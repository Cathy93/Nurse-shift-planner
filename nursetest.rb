require 'csv'
require 'terminal-table'

def open_csv(filename)
  people = []

  CSV.foreach(filename, headers:true) do | row |
      bed_no = row['bed_number']
      hospital_no = row['hospital_number']
      first_name = row['first_name']
      last_name = row['last_name']
      dob = row['dob']
      current_diagnosis = row['current_diagnosis']
      patient = { :bed_no => bed_no, :hospital_no => hospital_no, :first_name => first_name, :last_name => last_name, :dob => dob, :current_diagnosis => current_diagnosis}
      people.push(patient)
  end

  return people
end

def ask_for_beds()
  beds = []
  loop do
    puts "Which bed numbers are you looking after? Put X when complete."
    bed = gets.chomp
    beds << bed
    if bed == 'X'
      return beds
    end
end
end

beds = ask_for_beds
people = open_csv('patients.csv')

def find_patients(beds, people)

  patients_found = []
  beds.each do | bed |
    people.each do | person |
      if bed == person[:bed_no]
        patients_found.push(person)
      end
    end
  end

  return patients_found
end

x = find_patients(beds, people)


def build_table(people)
  rows = []
  people.each do | person |
    rows << [person[:bed_no], person[:hospital_no], person[:first_name], person[:last_name], person [:dob], person[:current_diagnosis] ]
  end

  table = Terminal::Table.new :rows => rows
  table.title = "Your Patients for the Day!"
  table.headings = ['Bed Number', 'Hospital Number', 'First Name', 'Last Name', 'D.O.B', 'Current Diagnosis']
  puts table
end

build_table(x)
