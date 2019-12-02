class Student
  attr_accessor :id, :name, :grade

  # Retrieve all the rows from the "Students" database
  # Each row should be a new instance of the Student class
  # Use .map to retrieve each student
  def self.all
    sql = <<-SQL
      SELECT * 
      FROM students 
    SQL
    DB[:conn].execute(sql).map {|row| self.new_from_db(row)}
  end
  # ALTERNATIVE METHOD: do block
  # DB[:conn].execute(sql).map do |row| 
  #   self.new_from_db(row)
  # end
  
  # Create a new Student class table
  def self.create_table
    sql = <<-SQL
    CREATE TABLE IF NOT EXISTS students (
      id INTEGER PRIMARY KEY,
      name TEXT,
      grade INTEGER
    )
    SQL
    DB[:conn].execute(sql)
  end

  # Delete the Students class table
  def self.drop_table
    sql = <<-SQL
    DROP TABLE IF EXISTS students
    SQL
    DB[:conn].execute(sql)
  end

  # Save each instance of the Student class
  def save
    sql = <<-SQL
      INSERT INTO students (name, grade) 
      VALUES (?, ?)
    SQL
    DB[:conn].execute(sql, self.name, self.grade)
  end

  # Create a new Student object given a row from the database
  def self.new_from_db(row)
    student = self.new  # self.new is the same as Student.new
    student.id = row[0]
    student.name = row[1]
    student.grade = row[2]
    student  # Returns the newly created instance
  end

  # 1. Get result from the database where the student's name matches the name passed into the argument.
  # 2. Take the result and create a new student instance using the `.new_from_db` method you just created.
  def self.find_by_name(name)
    sql = <<-SQL
      SELECT * 
      FROM students 
      WHERE name = ? 
    SQL
    DB[:conn].execute(sql, name).map {|row| self.new_from_db(row)}.first
  end
  # ALTERNATIVE METHOD: do block
  # DB[:conn].execute(sql, name).map do |row|
  #   self.new_from_db(row)
  # end.first

  # Return an array of all the students in grade 9
  def self.all_students_in_grade_9
    sql = <<-SQL
      SELECT * 
      FROM students 
      WHERE grade = 9
    SQL
    DB[:conn].execute(sql).map {|row| self.new_from_db(row)}
  end

  # Return an array of all the students in grade 12
  def self.students_below_12th_grade
    sql = <<-SQL
      SELECT * 
      FROM students 
      WHERE grade < 12
    SQL
    DB[:conn].execute(sql).map {|row| self.new_from_db(row)}
  end
  
  # Return an array of exactly `X` number of students
  def self.first_X_students_in_grade_10(x)
    sql = <<-SQL
      SELECT * 
      FROM students 
      WHERE grade = 10
      LIMIT ?
    SQL
    DB[:conn].execute(sql, x).map {|row| self.new_from_db(row)}
  end

  # Return an array of all the students in grade 10
  def self.first_student_in_grade_10
    sql = <<-SQL
      SELECT * 
      FROM students 
      WHERE grade = 10
      LIMIT 1
    SQL
    DB[:conn].execute(sql).map {|row| self.new_from_db(row)}.first
  end

  # Return an array of all students for grade `X`
  def self.all_students_in_grade_X(grade)
    sql = <<-SQL
      SELECT * 
      FROM students 
      WHERE grade = ?
    SQL
    DB[:conn].execute(sql, grade).map {|row| self.new_from_db(row)}
  end
end
