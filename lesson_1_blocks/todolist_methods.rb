# This class represents a collection of Todo objects.
# You can perform typical collection-oriented actions
# on a TodoList object, including iteration and selection.

class TodoList
  attr_accessor :title

  def initialize(title)
    @title = title
    @todos = []
  end

  def add(todo)
    raise TypeError, "Can only add Todo objects" unless todo.instance_of? Todo

    @todos << todo
  end

  alias_method :<<, :add

  def size
    @todos.size
  end

  def first
    @todos.first
  end

  def last
    @todos.last
  end

  def to_a
    @todos.dup
  end

  def done?
    @todos.all? { |todo| todo.done? }
  end

  def item_at(index)
    @todos.fetch(index)
  end

  def mark_done_at(index)
    item_at(index).done!
  end

  def mark_undone_at(index)
    item_at(index).undone!
  end

  def done!
    @todos.each { |todo| todo.done! }
  end

  def shift
    @todos.shift
  end

  def pop
    @todos.pop
  end

  def remove_at(index)
    @todos.delete(item_at(index))
  end

  def to_s 
    message = "---- #{title} ----\n"
    message += @todos.map(&:to_s).join("\n")
  end

  def each
    @todos.each do |todo|
      yield(todo)
    end
    self
  end

  def select
    result = TodoList.new(title)
    each do |todo|
      result.add(todo) if yield(todo)
    end
    result
  end

  def find_by_title(title)
    select { |todo| todo.title.downcase == title.downcase }.first
  end

  def all_done
    select { |todo| todo.done? }
  end

  def all_not_done
    select { |todo| !todo.done? }
  end

  def mark_done(title)
    find_by_title(title) && find_by_title(title).done!
  end

  def mark_all_done
    each { |todo| todo.done! }
  end

  def mark_all_undone
    each { |todo| todo.undone! }
  end
end

# This class represents a todo item and its associated
# data: name and description. There's also a "done"
# flag to show whether this todo item is done.

class Todo
  DONE_MARKER = 'X'
  UNDONE_MARKER = ' '

  attr_accessor :title, :description, :done

  def initialize(title, description='')
    @title = title
    @description = description
    @done = false
  end

  def done!
    self.done = true
  end

  def done?
    done
  end

  def undone!
    self.done = false
  end

  def to_s
    "[#{done? ? DONE_MARKER : UNDONE_MARKER}] #{title}"
  end

  def ==(otherTodo)
    title == otherTodo.title &&
      description == otherTodo.description &&
      done == otherTodo.done
  end
end

todo1 = Todo.new("Buy milk")
todo2 = Todo.new("Clean room")
todo3 = Todo.new("Go to gym")

list = TodoList.new("Today's Todos")
list.add(todo1)
list.add(todo2)
list.add(todo3)

p list.find_by_title("Buy milk")
# => #<Todo:0x00007f9386997ea8 @title="Buy milk", @description="", @done=false>

todo1.done!

p list.all_done
# => #<TodoList:0x00007fdb75947048 @title="Today's Todos", @todos=[#<Todo:0x00007fdb75947480 @title="Buy milk", @description="", @done=true>]>

p list.all_not_done
# => #<TodoList:0x00007fdb75946e40 @title="Today's Todos", @todos=[#<Todo:0x00007fdb75947408 @title="Clean room", @description="", @done=false>, #<Todo:0x00007fdb75947390 @title="Go to gym", @description="", @done=false>]>

list.mark_done("Clean room")
puts list

# ---- Today's Todos ----
# [X] Buy milk
# [X] Clean room
# [ ] Go to gym

list.mark_all_done
puts list

# ---- Today's Todos ----
# [X] Buy milk
# [X] Clean room
# [X] Go to gym

list.mark_all_undone
puts list

# ---- Today's Todos ----
# [ ] Buy milk
# [ ] Clean room
# [ ] Go to gym
