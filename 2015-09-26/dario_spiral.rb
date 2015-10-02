# General:
# - Codewars kata - 3 kyu
# - first iteration
# - to do: rewrite it in OOP and test it

def spiralize(size)
  return small_matrix(size) if size < 5

  matrix         = build_matrix(size)
  direction      = :right
  field          = {x: 0, y: 0}
  finished       = false
  # Position of a first field that is not surrounded by nil.
  start_testing_fields = (4 * (size - 2)) + 4
  current_field  = 1

  until finished
    matrix[field[:x]][field[:y]] = 1
    peek_one, peek_two = find_fields(matrix, field, direction)

    if peek_one.nil? || peek_two == 1
      direction, field = change_direction(direction, field)
    else
      field = move(direction, field, 1)
    end

    if current_field == start_testing_fields
      if last_field?(matrix, field)
        matrix[field[:x]][field[:y]] = 0
        finished = true
      end
    else
      current_field += 1
    end
  end

  matrix
end

def change_direction(direction, field)
  case direction
  when :right then direction = :down ; field[:x] += 1
  when :down  then direction = :left ; field[:y] -= 1
  when :left  then direction = :up   ; field[:x] -= 1
  when :up    then direction = :right; field[:y] += 1
  end
  [direction, field]
end

def move(direction, field, steps)
  case direction
  when :right then field[:y] += steps
  when :down  then field[:x] += steps
  when :left  then field[:y] -= steps
  when :up    then field[:x] -= steps
  end
  field
end

def small_matrix(size)
  case size
  when 1 then [[1]]
  when 2 then [[1,1], [0,1]]
  when 3 then [[1,1,1], [0,0,1], [1,1,1]]
  when 4 then [[1,1,1,1], [0,0,0,1],[1,0,0,1],[1,1,1,1]]
  end
end

def last_field?(matrix, field)
  els = []
  (-1..1).each do |i|
    (-1..1).each do |j|
      next if i == 0 && j == 0
      els << matrix[field[:x] + i][field[:y] + j]
    end
  end
  els.count(1) > 2
end

def build_matrix(size)
  Array.new(size) { (1..size).inject([]) { |memo, e| memo << " " } }
end

def find_fields(matrix, field, direction)
  peek_one = peek_field(matrix, field, 1, direction)
  peek_two = peek_field(matrix, field, 2, direction)
  [peek_one, peek_two]
end

def peek_field(matrix, field, peek_count, direction)
  check_field = move(direction, field.dup, peek_count)

  if (check_field[:x] > (matrix.size - 1)) || check_field[:y] < 0
    nil
  else
    matrix[check_field[:x]][check_field[:y]]
  end
end

# For debugging; not a component of spiralize.
def show(matrix)
  puts matrix.inject("") { |memo, row| memo << row.to_s << "\n" }
end

show spiralize(10)

