class DirectionError < StandardError
end

class NoSolutionError < StandardError
end

class Puzzle
  attr_accessor :directions, :location
  HEADINGS = %i(NORTH EAST SOUTH WEST)

  class Direction
    attr_accessor :direction, :distance

    def initialize(direction)
      @direction = direction.chars[0]
      @distance = direction.chars[1...direction.chars.size].join.to_i
    end

    def to_s
      "#{@direction}-#{distance}"
    end
  end

  def initialize(document, first_overlap=false)
    @first_overlap = first_overlap
    @found = false
    @location = [0, 0]
    @heading_value = 0
    @visited = {0 => [0]}
    @directions = document.split(', ').map { |d| Direction.new(d) }
    directions.each { |d|
      next if @found
      move(d)
    }
  end

  def distance
    raise NoSolutionError if @first_overlap and not @found
    @location[0].abs + @location[1].abs
  end

  def x
    location[0]
  end

  def y
    location[1]
  end

  def heading
    HEADINGS[@heading_value % 4]
  end

  def step_to(next_location, axis)
    if @first_overlap

      if @location[axis] > next_location[axis]
        range = (next_location[axis]..@location[axis]-1).to_a.reverse
      else
        range = @location[axis]+1..next_location[axis]
      end

      range.each { |s|
        next if @found

        @location[axis] = s

        unless @visited[x]
          @visited[x] = []
        end

        if @visited[x].include? y
          @found = true
        else
          @visited[x] << y
        end
      }

    else
      @location = next_location
    end
  end

  def move(direction)
    # New heading
    case direction.direction
      when 'R'
        @heading_value += 1
      when 'L'
        @heading_value -= 1
      else
        raise DirectionError, "Unknown direction: #{direction.direction}"
    end

    #puts "#{@location} #{direction} #{@heading_value} #{heading}"

    # New location
    case heading
      when :NORTH
        step_to([x, y + direction.distance], 1)
      when :EAST
        step_to([x + direction.distance, y], 0)
      when :SOUTH
        step_to([x, y - direction.distance], 1)
      when :WEST
        step_to([x - direction.distance, y], 0)
      else
        raise DirectionError("Unknown heading: #{heading}")
    end
  end

end

