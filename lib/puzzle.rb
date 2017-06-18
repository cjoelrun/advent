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

class DirectionError < StandardError
end

class Puzzle
  attr_accessor :directions, :location

  HEADINGS = %i(NORTH EAST SOUTH WEST)

  def initialize(document)
    @location = [0, 0]
    @heading_value = 0
    @directions = document.split(', ').map { |d| Direction.new(d) }
    directions.each { |d| @location = move(d) }
  end

  def distance
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
        [x, y + direction.distance]
      when :EAST
        [x + direction.distance, y]
      when :SOUTH
        [x, y - direction.distance]
      when :WEST
        [x - direction.distance, y]
      else
        raise DirectionError("Unknown heading: #{heading}")
    end
  end

end
