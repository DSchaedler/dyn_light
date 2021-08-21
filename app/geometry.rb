# Convert Degrees to Radians for use with Math.sin and Math.cos. Multiply by this constant to convert
DEG_TO_RAD = Math::PI / 180

# Provides geometry functions "missing" from args.geometry
module RayGeometry
  attr_gtk

  # point: {x: num, y: num}, distance: num, angle: num - degrees | Returns point {x: float, y: float}
  def find_point(point:, distance:, angle:)
    x = point[0] + distance * Math.cos(angle * DEG_TO_RAD)
    y = point[1] + distance * Math.sin(angle * DEG_TO_RAD)
    { x: x, y: y }
  end

  # line: line: {x: num, y: num, x2: num, y2: num} | Retruns float, nil
  def slope(line:)
    return nil if line[:x] == line[:x2]
    (line[:y] - line[:y2]).fdiv(line[:x] - line[:x2])
  end

  # line: {x: num, y: num, x2: num, y2: num} | Returns float, nil
  def y_intercept(line:)
    slope = RayGeometry.slope(line)
    if slope.nil?
      nil
    else
      # b = y - (m * x)
      line[:y] - slope * line[:x]
    end
  end

  # line: {x: num, y: num, x2: num, y2: num} | Returns float, nil
  def x_intercept(line:)
    slope = RayGeometry.slope(line)
    if slope.nil? || slope.zero?
      nil
    else
      # x = (y - b) / m
      b = RayGeometry.y_intercept(slope: slope, line: line)
      x = (line[:y] - b) / slope
    end
  end

  # line(1,2): {x: num, y: num, x2: num, y2: num} | Returns point {x: float, y: float}, nil
  def intersect(line1:, line2:)
    slope_line1 = RayGeometry.slope(line1)
    y_intercept1 = RayGeometry.y_intercept(slope_line1, line1)

    slope_line2 = RayGeometry.slope(line2)
    y_intercept2 = RayGeometry.y_intercept(slope_line2, line2)

    return nil unless slope_line1 != slope_line2

    if slope_line1.nil?
      x = line1[:x]
      y = slope_line2 * x + y_intercept2
    elsif slope_line2.nil?
      x = line2[:x]
      y = slope_line1 * x + y_intercept1
    else
      x = (y_intercept2 - y_intercept1).fdiv(slope_line1 - slope_line2)
      y = slope_line1 * x + y_intercept1
    end

    { x: x, y: y }
  end

  # TODO
  def segment_intersect(line1:, line2:)
    intersect = intersect(line1: line1, line2: line2)

    #intersect
    #$gtk.args.geometry.intersect_rect()

    #return intersect if
  end

  # Convert a hash rectangle into an array of hash lines
  def rect_lines(rect:)
    [
      { x: rect[:x], y: rect[:y], x2: rect[:x] + rect[:w], y2: rect[:y] },
      { x: rect[:x], y: rect[:y], x2: rect[:x], y2: rect[:y] + rect[:h] },
      { x: rect[:x] + rect[:w], y: rect[:y] + rect[:h], x2: rect[:x], y2: rect[:y] + rect[:h] },
      { x: rect[:x] + rect[:w], y: rect[:y] + rect[:h], x2: rect[:x] + rect[:w], y2: rect[:y] }
    ]
  end

  # Convert a hash rectangle into an array of hash points
  def rect_points(rect:)
    [
      { x: rect[:x], y: rect[:y] },
      { x: rect[:x], y: rect[:y] + rect[:h] },
      { x: rect[:x] + rect[:w], y: rect[:y] },
      { x: rect[:x] + rect[:w], y: rect[:y] + rect[:h] }
    ]
  end
end

RayGeometry.extend RayGeometry
