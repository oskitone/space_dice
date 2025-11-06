include <../../parts_cafe/openscad/rounded_xy_cube.scad>;

BATTERY_COVER_HEIGHT = .6;

module battery_cover(
    dimensions = [0,0,BATTERY_COVER_HEIGHT],
    outer_color = undef
) {
    color(outer_color) {
        rounded_xy_cube(
            dimensions,
            radius = ENCLOSURE_INNER_CHAMFER,
            $fn = 4
        );
    }
}