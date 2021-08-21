
class Rays
  def initialize(args)
    # Constants
    @obstacles_num = 1
    @do_debug = false

    # Variables
    @mouse = { x: args.inputs.mouse.x, y: args.inputs.mouse.y }

    @ray_angles = []
    @rays = []

    # Setup
    @bounding_box = { x: 100, y: 100, x2: 1180, y2: 620, w: 1080, h: 520, primitive_marker: :border }
    @bounding_box_lines = RayGeometry.rect_lines(@bounding_box)
    @bounding_box_points = RayGeometry.rect_lines(@bounding_box)

    @obstacles = []
    @obstacle_lines = []
    @obstacle_points = []

    @obstacles_num.times do # Create an array with hash rectangles of random sizes and locations
      @obstacles << { x: randr(@bounding_box[:x], @bounding_box[:x2]), y: randr(@bounding_box[:y], @bounding_box[:y2]), w: randr(20, 100), h: randr(20, 100), r: 127, g: 0, b: 0, primitive_marker: :solid }
    end

    @obstacles.each do |rect|
      @obstacle_lines.concat RayGeometry.rect_lines(rect)
    end

    @obstacles.each do |rect|
      @obstacle_points.concat RayGeometry.rect_points(rect)
    end
  end

  def tick(args)
    mouse_move(args)
  end

  def mouse_move(args)
    mouse = { x: args.inputs.mouse.x, y: args.inputs.mouse.y }
    return unless @mouse != mouse
    @mouse = mouse

    update_rays(args)
  end

  def update_rays(args)
    @ray_angles = @obstacle_points.map do |point|
      args.geometry.angle_from(@mouse, point)
    end


    # @full_lines = @ray_angles.map do |angle|

    # Where do the

    # refine_rays(args)

    # Render rays
    # args.render_target(:rays).clear
    # args.render_target(:rays).lines << $rays
  end
end
