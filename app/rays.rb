# Main class for Dynamic Lighting demo
class Rays
  def initialize(args)
    # Constants
    @obstacles_num = 1
    @do_debug = false

    # Variables
    @mouse = { x: args.inputs.mouse.x, y: args.inputs.mouse.y }
    @rays = []

    @output_primitives = []

    # Setup
    create_bounding_box

    @obstacles = []
    @obstacle_lines = []
    @obstacle_points = []

    create_obstacles
  end

  def create_bounding_box
    @bounding_box = { x: 100,
                      y: 100,
                      x2: 1180,
                      y2: 620,
                      w: 1080,
                      h: 520,
                      primitive_marker: :border }
    @bounding_box_lines = RayGeometry.rect_lines(rect: @bounding_box)
    @bounding_box_points = RayGeometry.rect_points(rect: @bounding_box)

    @output_primitives.concat @bounding_box_lines
  end

  def create_obstacles
    calculate_obstacles

    @obstacles.each do |rect|
      @obstacle_lines.concat RayGeometry.rect_lines(rect: rect)
    end

    @obstacles.each do |rect|
      @obstacle_points.concat RayGeometry.rect_points(rect: rect)
    end

    @output_primitives << @obstacle_lines.map do |line|
      line.merge({primitive_marker: :line})
    end

  end

  def calculate_obstacles
    @obstacles_num.times do
      @obstacles << { x: randr(@bounding_box[:x], @bounding_box[:x2]),
                      y: randr(@bounding_box[:y], @bounding_box[:y2]),
                      w: randr(20, 100), h: randr(20, 100),
                      r: 127, g: 0, b: 0,
                      primitive_marker: :solid }
    end
  end

  #---

  def tick(args)
    mouse_move(args)
    args.outputs.primitives << @output_primitives

    # puts @real_rays
    args.outputs.lines << @real_rays
  end

  def mouse_move(args)
    mouse = { x: args.inputs.mouse.x, y: args.inputs.mouse.y }
    return unless @mouse != mouse
    @mouse = mouse

    update_rays(args)
  end

  def update_rays(args)
    @ray_angles = @obstacle_points.map do |point|
      args.geometry.angle_to(@mouse, point)
    end

    @fake_rays = []
    @ray_angles.each do |angle|
      end_point = RayGeometry.find_point(point: @mouse, distance: 1280, angle: angle)
      @fake_rays << @mouse.merge(x2: end_point[:x], y2: end_point[:y])
    end

    @real_rays = []
    @fake_rays.each do |fake_ray|
      @bounding_box_lines.each do |border|
        intersection = RayGeometry.segment_intersect(line1: fake_ray, line2: border)
        args.outputs.solids << intersection.merge({w: 5, h: 5}) unless
        @real_rays << @mouse.merge(x2: intersection[:x], y2: intersection[:y]) unless intersection.nil?
      end
    end

  end
end
