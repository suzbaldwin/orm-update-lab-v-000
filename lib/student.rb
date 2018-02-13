require_relative "../config/environment.rb"

class Student
  attr_accessor :name, :grade, :id

  def initialize(name, grade, id=nil)
    @name = name
    @grade = grade
    @id = id
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

  def self.count_all_students_in_grade_9
    sql = <<-SQL
    SELECT COUNT (grade) FROM students WHERE grade = 9
    SQL
    DB[:conn].execute(sql)

  end
  def save

    if self.id
      self.update
    else
      sql = <<-SQL

      INSERT INTO students (name, grade)
      VALUES (?, ?)

      SQL

      DB[:conn].execute(sql, self.name, self.grade)
      @id = DB[:conn].execute("SELECT last_insert_rowid() FROM  students")[0][0]

    end
  end
  def update
    sql = "UPDATE students SET name = ?, grade = ? WHERE id = ?"
    DB[:conn].execute(sql, self.name, self.grade, self.id)
  end

  def self.create(name, grade)

    student = Student.new(name, grade)
    student.save
    student

  end

  def self.new_from_db(row)
    id = row[0]
    name =  row[1]
    grade = row[2]

    new_student = self.new(name, grade, id)
    new_student
  end

  def self.find_by_name(name)
    sql = "SELECT name FROM students WHERE name = ?"
    row = DB[:conn].execute(sql, name)

    student = Student.new(row[0], row[1], row[2]).join

  end





end
