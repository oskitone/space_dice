include <../../parts_cafe/openscad/chamfered_cube.scad>;
include <../../parts_cafe/openscad/chamfered_xy_cube.scad>;
include <../../parts_cafe/openscad/dice_pips.scad>;
include <../../parts_cafe/openscad/enclosure.scad>;
include <../../parts_cafe/openscad/flat_top_rectangular_pyramid.scad>;

include <enclosure.scad>;

// TODO:
// * ceiling tests
// * confirm top wall vs fillet

LED_DISPLAY_MARK_HEIGHT = .6;

module led_display(
    exposed_width, exposed_length, exposed_height,

    inner_height,

    ceiling_height = .6,
    wall = ENCLOSURE_INNER_WALL,
    mark_height = LED_DISPLAY_MARK_HEIGHT,

    fillet = 0,
    tolerance = 0,

    outer_color = undef,
    cavity_color = undef,
    accent_color = undef
) {
    e = .014;

    rows = 3;
    columns = 2;

    exposed_width = exposed_width - tolerance * 2;
    exposed_length = exposed_length - tolerance * 2;

    base_width = exposed_width + wall + tolerance * 2;
    base_length = exposed_length + wall + tolerance * 2;

    non_inner_height = ENCLOSURE_FLOOR_CEILING + exposed_height;
    total_height = inner_height + non_inner_height;

    cell_width = exposed_width / columns;
    cell_length = exposed_length / rows;

    module _exposed_pip_cells(
        pip_diameter = 1.4,
        gutter_from_fillet = .4
    ) {
        module _cap() {
            difference() {
                rounded_top_cube([
                    cell_width,
                    cell_length,
                    non_inner_height + fillet
                ], fillet);

                translate([wall, wall, -ceiling_height]) {
                    rounded_top_cube([
                        cell_width - wall * 2,
                        cell_length - wall * 2,
                        non_inner_height + fillet
                    ], fillet);
                }
            }
        }

        for (columnI = [0 : columns - 1], rowI = [0 : rows - 1]) {
            translate([
                tolerance + cell_width * columnI,
                tolerance + cell_length * rowI,
                inner_height - fillet
            ]) {
                color(outer_color) {
                    _cap();
                }
            }
        }

        for (columnI = [0 : columns - 1], rowI = [0 : rows - 1]) {
            translate([
                tolerance + cell_width * columnI + cell_width / 2,
                tolerance + cell_length * rowI + cell_length / 2,
                total_height - e
            ]) {
                color(accent_color) {
                    linear_extrude(height = mark_height + e) {
                        dice_pips(
                            count = columnI + (rows - rowI) * (rows - 1) - 1,
                            diameter = pip_diameter,
                            size = min(cell_width, cell_length) - wall * 2 - pip_diameter
                                - gutter_from_fillet * 2,
                            center = true
                        );
                    }
                }
            }
        }
    }

    module _inner_base() {
        module _cells_cavities() {
            bottom_dimensions = [base_width, base_length, inner_height];
            top_dimensions = [exposed_width, exposed_length];
            height = inner_height + e * 2;
            position = [wall / 2, wall / 2, -e];

            cell_bottom_width = (bottom_dimensions.x - wall * (columns + 1)) / columns;
            cell_bottom_length = (bottom_dimensions.y - wall * (rows + 1)) / rows;

            cell_top_width = (top_dimensions.x - wall * 4) / columns;
            cell_top_length = (top_dimensions.y - wall * 6) / rows;

            for (columnI = [0 : columns - 1], rowI = [0 : rows - 1]) {
                translate([
                    position.x + (cell_bottom_width + wall) * columnI,
                    position.y + (cell_bottom_length + wall) * rowI,
                    position.z
                ]) {
                    flat_top_rectangular_pyramid(
                        top_width = cell_top_width,
                        top_length = cell_top_length,
                        bottom_width = cell_bottom_width,
                        bottom_length = cell_bottom_length,
                        height = height
                    );
                }
            }
        }


        difference() {
            translate([wall / -2, wall / -2, 0]) {
                rounded_top_cube([base_width, base_length, inner_height], fillet);
            }

            _cells_cavities();
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

    difference() {
        union() {
            color(cavity_color) {
                _inner_base();
            }

            _exposed_pip_cells();
        }

        color(cavity_color) {
            _HACK_deobstructions();
        }

        // DEBUG x
        // translate([-2, -2, -2]) cube([base_width + 2, base_length / 2, total_height + 4]);

        // DEBUG y
        // translate([4.5, -2, -2]) cube([100, base_length + 2, total_height + 20]);
    }
}