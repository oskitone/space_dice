include <../../parts_cafe/openscad/chamfered_cube.scad>;
include <../../parts_cafe/openscad/chamfered_xy_cube.scad>;
include <../../parts_cafe/openscad/enclosure.scad>;
include <../../parts_cafe/openscad/flat_top_rectangular_pyramid.scad>;

include <enclosure.scad>;

// TODO:
// * pips
// * ceiling tests
// * fillet
// * confirm top wall vs fillet

module led_display(
    exposed_width, exposed_length, exposed_height,

    inner_height,

    ceiling_height = .6,
    wall = ENCLOSURE_INNER_WALL,
    label_height = .6,

    fillet = 0,
    tolerance = 0,

    outer_color = undef,
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

    module _outer_base() {
        module _cell_top() {
            render() rounded_top_cube([
                cell_width,
                cell_length,
                non_inner_height + fillet
            ], fillet);
        }

        translate([wall / -2, wall / -2, 0]) {
            rounded_top_cube([base_width, base_length, inner_height], fillet);
        }

        translate([tolerance, tolerance, inner_height - fillet]) {
            _cell_top();
        }

        for (columnI = [0 : columns - 1], rowI = [0 : rows - 1]) {
            translate([
                tolerance + cell_width * columnI,
                tolerance + cell_length * rowI,
                inner_height - fillet
            ]) {
                _cell_top();
            }
        }
    }

    module _labels() {
        for (columnI = [0 : columns - 1], rowI = [0 : rows - 1]) {
            translate([
                tolerance + cell_width * columnI + cell_width / 2,
                tolerance + cell_length * rowI + cell_length / 2,
                total_height - e
            ]) {
                engraving(
                    string = str(columnI + (rows - rowI) * (rows - 1) - 1),
                    size = ENCLOSURE_ENGRAVING_TEXT_SIZE,
                    height = label_height + e,
                    center = true
                );
            }
        }
    }

    module _inner_cavities() {
        module _cells(
            bottom_dimensions,
            top_dimensions,
            height,
            position
        ) {
            bottom_width = (bottom_dimensions.x - wall * (columns + 1)) / columns;
            bottom_length = (bottom_dimensions.y - wall * (rows + 1)) / rows;

            top_width = (top_dimensions.x - wall * (columns + 1)) / columns;
            top_length = (top_dimensions.y - wall * (rows + 1)) / rows;

            for (columnI = [0 : columns - 1], rowI = [0 : rows - 1]) {
                translate([
                    position.x + (bottom_width + wall) * columnI,
                    position.y + (bottom_length + wall) * rowI,
                    position.z
                ]) {
                    flat_top_rectangular_pyramid(
                        top_width = top_width,
                        top_length = top_length,
                        bottom_width = bottom_width,
                        bottom_length = bottom_length,
                        height = height,
                        top_weight_x = 1 - columnI / (columns - 1),
                        top_weight_y = 1 - rowI / (rows - 1)
                    );
                }
            }
        }

        _cells(
            [base_width, base_length, inner_height],
            [exposed_width, exposed_length],
            inner_height + e * 2,
            [wall / 2, wall / 2, -e]
        );

        _cells(
            [exposed_width, exposed_length],
            [exposed_width, exposed_length],
            non_inner_height - ceiling_height + e,
            [wall + tolerance, wall + tolerance, inner_height - e]
        );
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
                _outer_base();
                _labels();
            }

            _inner_cavities();
            _HACK_deobstructions();

            // DEBUG
            // translate([-2, -2, -2]) cube([base_width + 2, base_length / 2, total_height + 4]);
        }
    }
}