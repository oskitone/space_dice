include <../../parts_cafe/openscad/battery-9v.scad>;
include <../../parts_cafe/openscad/print_test.scad>;
include <../../parts_cafe/openscad/speaker-AZ40R.scad>;

use <../../scout/openscad/switch_clutch.scad>;

include <enclosure.scad>;
include <pcb.scad>;

module space_dice(
    width = ENCLOSURE_DIMENSIONS.x,
    length = ENCLOSURE_DIMENSIONS.y,
    height = ENCLOSURE_DIMENSIONS.z,

    pcb_width = PCB_WIDTH,
    pcb_length = PCB_LENGTH,

    show_enclosure_bottom = true,
    show_battery = true,
    show_pcb = true,
    show_switch_clutch = true,
    show_speaker = true,
    show_enclosure_top = true,
    show_print_test = false,

    show_clearance = false,

    button_exposure = 3,
    switch_exposure = 2,
    control_clearance = .6,

    control_width = CONTROL_WIDTH,
    control_length = CONTROL_LENGTH,

    outer_gutter = OUTER_GUTTER,
    default_gutter = SCOUT_DEFAULT_GUTTER,

    accessory_fillet = 1,

    pcb_bottom_clearance = PCB_BOTTOM_CLEARANCE,

    // pcb_post_hole_positions = [
    //     PCB_HOLE_POSITIONS[0],
    //     PCB_HOLE_POSITIONS[2],
    //     PCB_HOLE_POSITIONS[4],
    // ],

    tolerance = 0,

    enclosure_outer_color = "#FF69B4",
    enclosure_cavity_color = "#CC5490",

    control_outer_color = "#FFFFFF",
    control_cavity_color = "#EEEEEE",

    side_switch_position = round($t),
    switch_clutch_web_length_extension = 4, // NOTE: eyeballed!

    quick_preview = true
) {
    e = .00319;

    available_width = width - outer_gutter * 2;
    available_length = length - outer_gutter * 2;

    pcb_position = [
        PCB_XY,
        PCB_XY,
        ENCLOSURE_FLOOR_CEILING + SPEAKER_HEIGHT + pcb_bottom_clearance
    ];

    speaker_position = [
        pcb_position.x + pcb_width / 2,
        pcb_position.y + pcb_length / 2,
        ENCLOSURE_FLOOR_CEILING
    ];

    battery_position = [
        width - ENCLOSURE_WALL - BATTERY_HEIGHT,
        ENCLOSURE_WALL,
        ENCLOSURE_FLOOR_CEILING + e
    ];

    switch_clutch_grip_height = height / 2;
        // - (pcb_position.z + PCB_HEIGHT + SWITCH_ACTUATOR_Z) * 2;

    enclosure_bottom_height = height / 2;
    enclosure_top_height = height - enclosure_bottom_height;

    knob_diameter = CONTROL_WIDTH - control_clearance * 2;

    echo("Enclosure", width / 25.4, length / 25.4, height / 25.4);
    echo("PCB", pcb_width / 25.4, pcb_length / 25.4);
    echo("PCB bottom clearance", pcb_position.z - ENCLOSURE_FLOOR_CEILING);
    echo("Speaker",
        SPEAKER_DIAMETER / 2,
        get_speaker_fixture_diameter(tolerance),
        [
            // consts here are bottom left of PCB in KiCad
            (speaker_position.x - pcb_position.x) + 101.6,
            114.3 - (speaker_position.y - pcb_position.y),
        ]
    );

    if (show_battery) {
        translate(battery_position) {
            rotate([0, 90, 0]) rotate([0, 0, 90])
            % battery();
        }
    }

    if (show_enclosure_bottom || show_enclosure_top) {
        // TODO: you know
        // cube([width, length, ENCLOSURE_FLOOR_CEILING]);
        // cube([width, length, height]);

        enclosure(
            show_top = show_enclosure_top,
            show_bottom = show_enclosure_bottom,

            dimensions = [width, length, height],
            bottom_height = enclosure_bottom_height,
            top_height = enclosure_top_height,

            control_clearance = control_clearance,

            pcb_position = pcb_position,

            speaker_position = speaker_position,

            pcb_width = pcb_width,
            pcb_length = pcb_length,

            // pcb_post_hole_positions = pcb_post_hole_positions,

            switch_clutch_grip_height = switch_clutch_grip_height,
            switch_clutch_web_length_extension = switch_clutch_web_length_extension,

            outer_gutter = outer_gutter,
            default_gutter = default_gutter,

            tolerance = tolerance,

            outer_color = enclosure_outer_color,
            cavity_color = enclosure_cavity_color,

            show_dfm = !quick_preview,

            quick_preview = quick_preview
        );
    }

    translate(pcb_position) {
        pcb(
            show_board = show_pcb,
            show_silkscreen = false,

            show_switches = show_pcb,
            show_leds = show_pcb,
            show_pots = show_pcb,
            show_button = show_pcb,

            show_clearance = show_clearance,

            side_switch_position = side_switch_position,

            tolerance = tolerance
        );
    }

    if (show_switch_clutch) {
        // boooo. this is from having two different SWITCHes w/ the same const names
        SWITCH_BASE_WIDTH = 4.4;
        SWITCH_BASE_LENGTH = 8.6;
        SWITCH_ORIGIN = [SWITCH_BASE_WIDTH / 2, SWITCH_BASE_LENGTH - 6.36];

        // HACK: lots of arbitrary values here to make Scout's clutch work.
        // boooooooooooo
        translate([
            pcb_position.x + SWITCH_ORIGIN.x + .15,
            pcb_position.y + PCB_SWITCH_Y + SWITCH_ORIGIN.y,
            0
        ]) {
            switch_clutch(
                position = side_switch_position,

                web_available_width = pcb_position.x - ENCLOSURE_WALL,
                web_length_extension = switch_clutch_web_length_extension,

                enclosure_height = height,

                // Negative here to make up for bigger tolerance below
                x_clearance = -.2,

                grip_height = switch_clutch_grip_height,

                fillet = accessory_fillet,
                side_overexposure = switch_exposure,
                tolerance = tolerance * 2, // NOTE: intentionally loose

                outer_color = control_outer_color,
                cavity_color = control_cavity_color,

                quick_preview = quick_preview
            );
        }
    }

    if (show_speaker) {
        % translate([
            speaker_position.x,
            speaker_position.y,
            speaker_position.z - e
        ]) {
            speaker($fn = 120);
        }
    }

    if (show_print_test) {
        print_test(quick_preview = quick_preview);
    }
}

SHOW_ENCLOSURE_BOTTOM = true;
SHOW_BATTERY = 0;
SHOW_PCB = true;
SHOW_SWITCH_CLUTCH = 0;
SHOW_SPEAKER = 0;
SHOW_ENCLOSURE_TOP = true;
SHOW_PRINT_TEST = false;

SHOW_CLEARANCE = 1;
DEFAULT_TOLERANCE = .1;
Y_ROTATION = 0;

rotate([0, Y_ROTATION, 0])
difference() {
space_dice(
    show_enclosure_bottom = SHOW_ENCLOSURE_BOTTOM,
    show_battery = SHOW_BATTERY,
    show_pcb = SHOW_PCB,
    show_switch_clutch = SHOW_SWITCH_CLUTCH,
    show_speaker = SHOW_SPEAKER,
    show_enclosure_top = SHOW_ENCLOSURE_TOP,
    show_print_test = SHOW_PRINT_TEST,

    show_clearance = SHOW_CLEARANCE,

    tolerance = DEFAULT_TOLERANCE,

    quick_preview = $preview
);

// right side
// translate([ALTOIDS_TIN_DIMENSIONS.x * .8, -1, -1]) cube([100, 100, 100]);
}