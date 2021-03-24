# USING `while` LOOP:

def select(array)
  counter = 0
  selected = []
  
  while counter < array.size
    current_el = array[counter]
    selected << current_el if yield(current_el)
    counter += 1
  end
  
  selected
end

# USING `Array#each`:

def select(array)
  selected = []
  
  array.each do |current_el|
    selected << current_el if yield(current_el)
  end
  
  selected
end

array = [1, 2, 3, 4, 5]

select(array) { |num| num.odd? }      # => [1, 3, 5]
select(array) { |num| puts num }      # => [], because "puts num" returns nil and evaluates to false
select(array) { |num| num + 1 }       # => [1, 2, 3, 4, 5], because "num + 1" evaluates to true