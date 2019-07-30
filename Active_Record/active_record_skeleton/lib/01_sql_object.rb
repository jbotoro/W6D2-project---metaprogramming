require_relative 'db_connection'
require 'active_support/inflector'
# NB: the attr_accessor we wrote in phase 0 is NOT used in the rest
# of this project. It was only a warm up.

class SQLObject
  def self.columns
    # ...
    return @columns if @columns
    columns = DBConnection.execute2(<<-SQL).first
  SELECT
    *
  FROM
    #{self.table_name}
  SQL

  columns.map!(&:to_sym)
  @columns = columns
  end

  def self.finalize!

    self.columns.each do |name|
      define_method(name) do
        self.attributes[name]
      end

      define_method("#{name}=") do |value|
        self.attributes[name] = value
      end
    end


  end

  def self.table_name=(table_name)
    # ...
    @table_name = table_name
  end

  def self.table_name
    @table_name ||= self.name.tableize
    # ...
  end

  def self.all
    # ...
    r = DBConnection.execute(<<-SQL)
    
    SELECT
      #{table_name}.*
    FROM
      #{table_name}
    SQL

    parse_all(r)
  end

  def self.parse_all(results)
    # ...
    results.map {|result| self.new(result)} 

  end

  def self.find(id)
    # ...
    result = DBConnection.execute(<<-SQL, id)
    
    SELECT
      #{table_name}.*
    FROM
      #{table_name}
    WHERE
      #{table_name}.id = ?
    SQL

    parse_all(result).first
  end

  def initialize(params = {})
    # ...
    params.each do |attr_name, value|
      attr_name = attr_name.to_sym
      if self.class.columns.include?(attr_name)
        self.send("#{attr_name}=", value)
      else
        raise "unknown attribute '#{attr_name}'"
      end
    end



  end

  def attributes
    # ...
    @attributes ||= {}
  end

  def attribute_values
    # ...
  end

  def insert
    # ...
    col_names =

    question_marks = 
  end

  def update
    # ...
  end

  def save
    # ...
  end
end
