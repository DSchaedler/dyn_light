# DragonRuby RayTracing
# By Dee Schaedler

# Constants - Change these to change the simulation parameters

RAYS = 360 # Number of rays to calculate
NUM_OBSTACLES = 20 # Number of Obstacles to generate

DEG_TO_RAD = Math::PI / 180 # Convert Degrees to Radians for use with Math.sin and Math.cos. Multiply by this constant to convert

def once(args)
  $once_done = true

  $mouse_old ||= { x: 0, y: 0 }
  $do_debug ||= false
  $obstacle_lines ||= []
  $obstacle_points ||= []

  $obstacles = NUM_OBSTACLES.map do # Create an array with hash rectangles of random sizes and locations
    { x: randr(0, 1280), y: randr(0, 720), w: randr(20, 100), h: randr(20, 100), r: 127, g: 0, b: 0, primitive_marker: :solid }
  end
  $obstacles << { x: 0, y: 0, w: 1280, h: 720, primitive_marker: :border }

  obstacle_lines
  obstacle_points

  # args.render_target(:boxes).solids << $obstacles
  args.render_target(:boxes).lines << $obstacle_lines
  # args.render_target(:boxes).solids << $obstacle_points
end

# Generate a random integer between min and max
def randr(min, max)
  rand(max - min + 1) + min
end

# Call line deconstruct method
def obstacle_lines
  $obstacles.each do |rect|
    $obstacle_lines.concat deconstruct_rect_lines(rect)
  end
end

# Call point deconstruct method
def obstacle_points
  $obstacles.each do |rect|
    $obstacle_points.concat deconstruct_rect_points(rect)
  end
end

# Convert a hash rectangle into an array of hash lines
def deconstruct_rect_lines(rect)
  [
    { x: rect[:x], y: rect[:y], x2: rect[:x] + rect[:w], y2: rect[:y] },
    { x: rect[:x], y: rect[:y], x2: rect[:x], y2: rect[:y] + rect[:h] },
    { x: rect[:x] + rect[:w], y: rect[:y] + rect[:h], x2: rect[:x], y2: rect[:y] + rect[:h] },
    { x: rect[:x] + rect[:w], y: rect[:y] + rect[:h], x2: rect[:x] + rect[:w], y2: rect[:y] }
  ]
end

# Convert a hash rectangle into an array of hash points
def deconstruct_rect_points(rect)
  [
    { x: rect[:x], y: rect[:y] },
    { x: rect[:x], y: rect[:y] + rect[:h] },
    { x: rect[:x] + rect[:w], y: rect[:y] },
    { x: rect[:x] + rect[:w], y: rect[:y] + rect[:h] }
  ]
end

def tick(args)
  once(args) unless $once_done

  update_rays(args)

  args.outputs.primitives << [
    { x: 0, y: 0, w: 1280, h: 720, path: :rays },
    { x: 0, y: 0, w: 1280, h: 720, path: :boxes }
  ]

  qol(args)
end

def qol(args)
  args.outputs.screenshots << { x: 0, y: 0, w: 1280, h: 720, path: 'lines.png' } if args.inputs.keyboard.key_up.escape

  $do_debug = !$do_debug if args.keyboard.key_up.d
  args.outputs.debug << args.gtk.framerate_diagnostics_primitives if $do_debug
end

def update_rays(args)
  if $mouse_old != { x: args.inputs.mouse.x.round, y: args.inputs.mouse.y.round }
    $mouse_old = { x: args.inputs.mouse.x.round, y: args.inputs.mouse.y.round }

    args.render_target(:rays).clear

    args.render_target(:rays).lines << $obstacle_points.map do |point|
      $mouse_old.merge(x2: point[:x], y2: point[:y])
    end
    
    calc_rays(args)
  end
end

def calc_rays(args)

    $obstacle_points.each { |point|
      ray_line = $mouse_old.merge(x2: point[:x], y2: point[:y])
      $obstacle_lines.each { |line|
        intersect = args.geometry.line_intersect(line, ray_line)
        puts intersect
        }
      }
end
