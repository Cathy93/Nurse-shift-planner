require 'csv'
require 'terminal-table'
require 'Date'
require_relative 'medications'
@drugs = { :ventolin => {:name => 'Ventolin', :dose => '100mg', :dose_times => ['0800', '1200', '1600', '2000']} }

def open_csv(filename)
  patients = []

  # For each row in CSV create a patient hash and append to patients array
  CSV.foreach(filename, headers:true) do | row |
      bed_no = row['bed_number']
      hospital_no = row['hospital_number']
      first_name = row['first_name']
      last_name = row['last_name']
      dob = row['dob']
      age = age(dob)
      current_diagnosis = row['current_diagnosis']
      patient = { :bed_no => bed_no, :hospital_no => hospital_no, :first_name => first_name, :last_name => last_name, :dob => dob, :age => age, :current_diagnosis => current_diagnosis, :medications => @drugs[:ventolin]}
      patients.push(patient)
  end

  return patients
end

def age(dob)
  dob = Date.parse(dob)
  now = Date.today
  age = now.year - dob.year - ((now.month > dob.month || (now.month == dob.month && now.day >= dob.day)) ? 0 : 1)
  return age
end

# Query user for bed numbers the nurse is taking care of
def ask_for_bed_numbers()
  puts "Which bed numbers are you looking after? Seperate each number with a space"
  bed = gets.chomp
  beds = bed.split(' ')
  return beds
end

# Return matching patients by the bed number
def find_patients(beds, patients)

  patients_found = []
  beds.each do | bed |
    patients.each do | person |
      if bed == person[:bed_no]
        patients_found.push(person)
      end
    end
  end

  return patients_found
end


# Print table of patients
def build_table(patients)
  rows = []
  patients.each do | person |
    rows << [person[:bed_no], person[:hospital_no], person[:first_name], person[:last_name], person [:dob], person[:age], person[:current_diagnosis] ]
    x = person[:medications]
    puts x[:name]
  end


  table = Terminal::Table.new :rows => rows
  table.title = "Your Patients for the Day!"
  table.headings = ['Bed Number', 'Hospital Number', 'First Name', 'Last Name', 'D.O.B', 'Age', 'Current Diagnosis', 'Medications']
  puts table
end

patients = open_csv('patients.csv')
beds = ask_for_bed_numbers
selectedPatients = find_patients(beds, patients)
build_table(selectedPatients)
