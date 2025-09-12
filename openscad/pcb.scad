// TODO: update to latest PCB rev

include <../../parts_cafe/openscad/ghost_cube.scad>;
include <../../parts_cafe/openscad/led.scad>;
include <../../parts_cafe/openscad/pot.scad>;
include <../../parts_cafe/openscad/spst.scad>;
include <../../parts_cafe/openscad/switch-OS102011MS2QN1.scad>;

use <../../scout/openscad/switch_clutch.scad>;

PCB_WIDTH = 60;
PCB_LENGTH = 50;
PCB_HEIGHT = 1.7;

EDGE_CUTS_BOTTOM_LEFT_X = 95;
EDGE_CUTS_BOTTOM_LEFT_Y = 130;

function get_translated_xy(xy) = (
    [xy.x - EDGE_CUTS_BOTTOM_LEFT_X, EDGE_CUTS_BOTTOM_LEFT_Y - xy.y]
);

// Copied from higher_lower.kicad_pcb
PCB_HOLE_POSITIONS = [
    get_translated_xy([114.1, 85.5052]),
    get_translated_xy([142.05, 102]),
    get_translated_xy([134.9, 85.5052]),
];
PCB_HOLE_DIAMETER = 3.2;

// TODO: differentiate side vs top actuator, no magic values
PCB_SWITCH_POSITIONS = [
    get_translated_xy([97.5, 100.5]),
    get_translated_xy([120.15, 113.4]),
    get_translated_xy([99.35, 113.4]),
];
PCB_SWITCH_Y = PCB_SWITCH_POSITIONS[0].y - 6.1; // magic
PCB_TOP_CONTROL_SWITCH_POSITONS = [
    PCB_SWITCH_POSITIONS[1],
    PCB_SWITCH_POSITIONS[2]
];

// TODO: confirm vertical offshoot on test print
PCB_POT_POSITIONS = [
    get_translated_xy([101.2 + PTV09A_POT_ORIGIN.x, 96.2 + PTV09A_POT_ORIGIN.y]),
    get_translated_xy([142.8 + PTV09A_POT_ORIGIN.x, 96.2 + PTV09A_POT_ORIGIN.y]),
    get_translated_xy([122 + PTV09A_POT_ORIGIN.x, 96.2 + PTV09A_POT_ORIGIN.y]),
];

// Switch is rotated 90deg, thus SPST_ORIGIN xy are swapped
PCB_BUTTON_POSITION = get_translated_xy([153.5 - SPST_ORIGIN.y, 104.25 - SPST_ORIGIN.x]);

PCB_LED_POSITIONS = [
    get_translated_xy([148.375 + 2.54 / 2, 126.2]),
    get_translated_xy([148.375 + 2.54 / 2, 110.5]),
    get_translated_xy([139.675 + 2.54 / 2, 126.2]),
    get_translated_xy([148.375 + 2.54 / 2, 118.35]),
    get_translated_xy([139.675 + 2.54 / 2, 110.5]),
    get_translated_xy([139.675 + 2.54 / 2, 118.35]),
];

// ie, trimmed leads and solder joints on bottom
PCB_BOTTOM_CLEARANCE = 2;

module pcb(
    show_board = true,
    show_silkscreen = true,

    show_switches = true,
    show_leds = true,
    show_pots = true,
    show_button = true,

    show_clearance = false,

    width = PCB_WIDTH,
    length = PCB_LENGTH,
    height = PCB_HEIGHT,

    switch_positions = PCB_SWITCH_POSITIONS,
    led_positions = PCB_LED_POSITIONS,
    pot_positions = PCB_POT_POSITIONS,
    button_position = PCB_BUTTON_POSITION,

    side_switch_position = 0,

    bottom_clearance = PCB_BOTTOM_CLEARANCE,

    hole_positions = PCB_HOLE_POSITIONS,
    hole_diameter = PCB_HOLE_DIAMETER,

    tolerance = 0,

    pcb_color = "purple",
    silkscreen_color = [1,1,1,.25]
) {
    e = .0143;
    silkscreen_height = e;

    module _translate(xy, z = PCB_HEIGHT - e) {
        translate([xy.x, xy.y, z]) {
            children();
        }
    }

    if (show_board) {
        difference() {
            union() {
                color(pcb_color) {
                    linear_extrude(height) {
                        render() hull() import("../misc/edge_cuts.svg");
                    }
                }

                if (show_silkscreen) {
                    color(silkscreen_color) intersection() {
                        // NOTE: eyeballed
                        translate([-.05, -.05, height - e]) {
                            linear_extrude(silkscreen_height + e) {
                                import("../misc/pcb.svg");
                            }
                        }

                        translate([e, e, e]) {
                            cube([
                                width - e * 2,
                                length - e * 2,
                                height + silkscreen_height + e,
                            ]);
                        }
                    }
                }
            }

            color(pcb_color) {
                for (xy = hole_positions) {
                    translate([xy.x, xy.y, -e]) {
                        cylinder(
                            d = hole_diameter,
                            h = height + silkscreen_height + e * 2,
                            $fn = 12
                        );
                    }
                }
            }
        }
    }

    if (show_switches) {
        for (xy = switch_positions) {
            translate([xy.x, xy.y, height - e]) {
                # switch();
            }
        }
    }

    if (show_leds) {
        for (xy = led_positions) {
            _translate(xy) {
                # led_3mm();
            }
        }
    }

    if (show_pots) {
        for (xy = pot_positions) {
            _translate(xy) {
                # pot();
            }
        }
    }

    if (show_button) {
        _translate(button_position) {
            # spst();
        }
    }

    if (show_clearance) {
        translate([e, e, -bottom_clearance]) {
            % ghost_cube([width - e * 2, length - e * 2, bottom_clearance + e]);
        }
    }
}