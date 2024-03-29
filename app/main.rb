# DragonRuby RayTracing
# By Dee Schaedler

# require
require 'app/rays.rb'
require 'app/geometry.rb'

#---

def tick(args)
  $rays_object ||= Rays.new(args)
  $rays_object.tick(args)

  screenshots(args)
  debug(args)
end

#---

def debug(args)
  $do_debug ||= false
  $do_debug = !$do_debug if args.keyboard.key_up.d
  args.outputs.debug << args.gtk.framerate_diagnostics_primitives if $do_debug
end

def screenshots(args)
  return unless args.inputs.keyboard.key_up.escape

  args.outputs.screenshots << { x: 0, y: 0, w: 1280, h: 720, path: 'lines.png' }
end

# Generate a random integer between min and max
def randr(min, max)
  rand(max - min + 1) + min
end

def between_sort(number, num1, num2)
  range = [num1, num2].sort
  number.between?(range[0], range[1])
end
