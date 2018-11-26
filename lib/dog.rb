class Dog
  attr_accessor  :id, :name,:breed

  def initialize (id:id=nil, name:name, breed:breed)
     @name= name
     @breed = breed
     @id = id
  end

  def self.create_table
    sql =  <<-SQL
    CREATE TABLE IF NOT EXISTS dogs (
      id INTEGER PRIMARY KEY,
      name TEXT,
      breed TEXT
      )
      SQL
    DB[:conn].execute(sql)
  end

  def self.drop_table
    sql = "DROP TABLE IF EXISTS dogs"
     DB[:conn].execute(sql)
  end

  def save
  if id
    update
  else
    sql = <<-SQL
      INSERT INTO dogs (name, breed)
      VALUES (?, ?)
    SQL
    DB[:conn].execute(sql, name, breed)
    @id = DB[:conn].execute("SELECT last_insert_rowid() FROM dogs")[0][0]
   end
   self
 end

 def self.create(name:, breed:)
    dog = Dog.new(name:name, breed:breed)
    dog.save
    dog
  end

 def self.new_from_db row
    find_or_create_by(name: row[1], breed: row[2])
 end

 def self.find_or_create_by(name:name, breed:breed)
   sql = <<-SQL
     SELECT * FROM dogs WHERE name = ? AND breed = ?
   SQL
  dog = DB[:conn].execute(name:name, breed:breed)[0]

  if result
       id, name, breed = *dog
       new(id:id, name:name, breed:breed)
  else
      create name:attr[:name], breed:attr[:breed]
  end
  # if !dog.empty?
  #   dog_data = dog[0]
  #   dog = Dog.new(dog_data[0], dog_data[1], dog_data[2])
  #   # DB[:conn].execute(sql,attr[:name],attr[:breed])[0]
  # else
  #   dog = self.create(name: name, breed: breed)
  # end
  #   dog
 end

#  def self.find_or_create_by **attr
#    sql = <<-SQL
#    SELECT * FROM dogs WHERE name = ? AND breed = ?
#    SQL
#
#    result = DB[:conn].execute(sql,attr[:name],attr[:breed])[0]
#
#    if result
#      id, name, breed = *result
#      new(id:id, name:name, breed:breed)
#    else
#      create name:attr[:name], breed:attr[:breed]
#    end
# end

  #  def self.find_by_id id
  #    sql = <<-SQL
  #      SELECT * FROM dogs
  #      WHERE id = ?
  #    SQL
   #
  #    DB[:conn].execute(sql,id).map do |row|
  #      new_from_db(row)
  #    end.first
   #
  #  end
  #  def self.find_by_id id
  #     sql = <<-SQL
  #     SELECT * FROM dogs
  #     WHERE id = ?
  #     SQL
  #     id, name, breed = *DB[:conn].execute(sql,id)[0]
  #     new(id: id, name:name, breed:breed)
  #   end

   def update
     sql = "UPDATE students SET name = ?, breed = ? WHERE id = ?"
     DB[:conn].execute(sql)
  end




end
