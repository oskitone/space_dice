include <enclosure.scad>;

// TODO:
// * tolerance
// * fixtures against enclosure
// * pips
// * ceiling tests
// * fillet

module led_display(
    exposed_width, exposed_length,
    height,

    ceiling_height = .6,
    wall = ENCLOSURE_INNER_WALL,
    tolerance = 0,
    outer_color = undef,
    accent_color = undef
) {
    e = .014;

    rows = 3;
    columns = 2;

    module _walls() {
        _height = height - ceiling_height + e;

        for (i = [0 : columns]) {
            translate([
                wall / -2 + (exposed_width / columns) * i,
                wall / -2,
                0
            ]) {
                cube([wall, exposed_length + wall, _height]);
            }
        }

        for (i = [0 : rows]) {
            translate([
                wall / -2,
                wall / -2 + (exposed_length / rows) * i,
                0
            ]) {
                cube([exposed_width + wall, wall, _height]);
            }
        }
    }

    module _ceiling() {
        translate([wall / -2, wall / -2, height - ceiling_height]) {
            cube([exposed_width + wall, exposed_length + wall, ceiling_height]);
        }
    }

    module _HACK_deobstructions() {
        // C1
        translate([-2, 26.9, -e]) {
            cylinder(
                d = 9,
                h = 100 // ideally PCB_BIG_CAP_HEIGHT when height is taller
            );
        }

        // button lever
        translate([21.3, 25, -e]) {
            cylinder(
                d = 9,
                h = 100
            );
        }
    }

    color(outer_color) {
        difference() {
            union() {
                _walls();
                _ceiling();
            }

            _HACK_deobstructions();
        }
    }
}