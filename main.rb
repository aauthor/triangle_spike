require 'rvg/rvg'

RADIUS = 1.0
BASE = Math::sqrt(3)
HEIGHT = 1.5
HEIGHT_AFTER_RADIUS = HEIGHT - RADIUS
HALF_BASE = BASE / 2

Magick::RVG::dpi = 72

side_background = Magick::Image.read('in.png').first

hexagon_width = side_background.columns
hexagon_height = side_background.rows
triangle_height = hexagon_height / 2
triangle_base = hexagon_width / 2
triangle_half_base = triangle_base / 2
triangle_base_to_center = 1.0/3.0 * triangle_height
triangle_center_to_top = 2.0/3.0 * triangle_height

side = Magick::RVG::Group.new
side.image(side_background)

triangle_cut = Magick::RVG::ClipPath.new do |path|
  path.polygon(
    0, triangle_height,
    triangle_half_base, 0,
    triangle_base, triangle_height)
end

triangle_1 = Magick::RVG::Group.new
triangle_1.use(side).styles(clip_path: triangle_cut)

rotated_side = Magick::RVG::Group.new
rotated_side.use(side).rotate(-60, triangle_base, triangle_height)

triangle_2 = Magick::RVG::Group.new
triangle_2.use(rotated_side)
  .styles(clip_path: triangle_cut)

template = Magick::RVG::Group.new
template.use(triangle_1)
template.use(triangle_2)
  .translate(triangle_half_base,0)
  .translate(0, -triangle_base_to_center)
  .rotate(60, triangle_half_base, triangle_center_to_top)

rvg = Magick::RVG.new(3.5.in, 3.in) do |canvas|
  scale = canvas.width / hexagon_width
  canvas.use(template).scale(scale)
end

rvg.draw.write('rvg_clippath.png')
