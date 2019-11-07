class Student
  attr_accessor :id, :name, :grade

  def self.new_from_db(row)
    student = Student.new
    student.id = row[0]
    student.name = row[1]
    student.grade = row[2]
    student
  end

  def self.all
    sql = "SELECT * FROM students"
    student = DB[:conn].execute(sql)
    student.map do |s|
      Student.new_from_db(s)
    end
  end

  def self.find_by_name(name)
    sql = "SELECT * FROM students WHERE name = ? "
    row = DB[:conn].execute(sql, name)[0]
    Student.new_from_db(row)
  end
  
  def save
    sql = <<-SQL
      INSERT INTO students (name, grade) 
      VALUES (?, ?)
    SQL

    DB[:conn].execute(sql, self.name, self.grade)
  end
  
  def self.create_table
    sql = <<-SQL
    CREATE TABLE IF NOT EXISTS students (
      id INTEGER PRIMARY KEY,
      name TEXT,
      grade TEXT
    )
    SQL

    DB[:conn].execute(sql)
  end

  def self.drop_table
    sql = "DROP TABLE IF EXISTS students"
    DB[:conn].execute(sql)
  end

  def self.multi_new_from_array(array)
    array.map do |student|
      Student.new_from_db(student)
    end
  end

  def self.all_students_in_grade_9
    sql = "SELECT * FROM students WHERE grade = 9"
    DB[:conn].execute(sql)
  end

  def self.students_below_12th_grade
    sql = "SELECT * FROM students WHERE grade < 12"
    arr = DB[:conn].execute(sql)
    Student.multi_new_from_array(arr)
    # binding.pry
  end

  def self.first_X_students_in_grade_10(num)
    sql = "SELECT * FROM students WHERE grade = 10 LIMIT ?"
    array = DB[:conn].execute(sql, num)
    Student.multi_new_from_array(array)
  end

  def self.first_student_in_grade_10
    sql = "SELECT * FROM students WHERE grade = 10 LIMIT 1"
    arr = DB[:conn].execute(sql)[0]
    Student.new_from_db(arr)
  end

  def self.all_students_in_grade_X(grade)
    sql = "SELECT * FROM students WHERE grade = ?"
    array = DB[:conn].execute(sql, grade)
    Student.multi_new_from_array(array)
  end

end
