include <../../parts_cafe/openscad/battery-9v.scad>;
include <../../parts_cafe/openscad/cap_blank.scad>;
include <../../parts_cafe/openscad/knob.scad>;
include <../../parts_cafe/openscad/print_test.scad>;
include <../../parts_cafe/openscad/speaker-AZ40R.scad>;
include <../../parts_cafe/openscad/switch_clutch-angled.scad>;
include <../../parts_cafe/openscad/switch_clutch.scad>;

include <button_lever.scad>;
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
    show_knobs = true,
    show_button_cap = true,
    show_switch_clutches = true,
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

    pcb_top_clearance = PCB_TOP_CLEARANCE,
    pcb_bottom_clearance = PCB_BOTTOM_CLEARANCE,

    pcb_screw_hole_positions = [PCB_HOLE_POSITIONS[4]],
    pcb_post_hole_positions = [
        PCB_HOLE_POSITIONS[0],
        PCB_HOLE_POSITIONS[2],
        PCB_HOLE_POSITIONS[3],
        PCB_HOLE_POSITIONS[6],
    ],

    tolerance = 0,

    enclosure_outer_color = "#FF69B4",
    enclosure_cavity_color = "#CC5490",

    control_outer_color = "#FFFFFF",
    control_cavity_color = "#EEEEEE",

    side_switch_position = round($t),
    switch_clutch_web_length_extension = 4, // NOTE: eyeballed!

    quick_preview = true
) {
    e = .0319;

    available_width = width - outer_gutter * 2;
    available_length = length - outer_gutter * 2;

    pcb_position = [
        PCB_XY,
        PCB_XY,
        ENCLOSURE_FLOOR_CEILING + SPEAKER_HEIGHT + pcb_bottom_clearance
    ];

    speaker_position = [
        pcb_position.x + pcb_screw_hole_positions[0].x / 2,
        pcb_position.y + pcb_length / 2,
        ENCLOSURE_FLOOR_CEILING
    ];

    battery_position = [
        width - ENCLOSURE_WALL - BATTERY_HEIGHT - e,
        ENCLOSURE_WALL + e,
        ENCLOSURE_FLOOR_CEILING + e
    ];

    switch_clutch_grip_height = height / 2;
        // - (pcb_position.z + PCB_HEIGHT + SWITCH_ACTUATOR_Z) * 2;

    enclosure_bottom_height = pcb_position.z - ENCLOSURE_LIP_HEIGHT + PCB_HEIGHT;
    enclosure_top_height = height - enclosure_bottom_height;

    knob_diameter = CONTROL_WIDTH - control_clearance * 2;

    right_panel_width = width
        - outer_gutter * 2 - default_gutter * 3
        - control_width * 3;
    right_panel_section_length =
        (length - outer_gutter * 2 - default_gutter * 4) / (4 + 1);
    branding_dimensions = [
        right_panel_width,
        (length - outer_gutter * 2) / 5
    ];
    speaker_grill_dimensions = [
        right_panel_width,
        (length - outer_gutter * 2) / 3
    ];
    button_cap_exposure_dimensions = [
        right_panel_width, // TODO: control_clearance * 2,
        (length - outer_gutter * 2)
            - branding_dimensions.y
            - speaker_grill_dimensions.y
            - default_gutter * 2
    ];

    branding_position = [
        width - outer_gutter - right_panel_width,
        length - outer_gutter - branding_dimensions.y
    ];
    speaker_grill_position = [
        width - outer_gutter - right_panel_width,
        outer_gutter,
    ];
    button_cap_exposure_position = [
        width - outer_gutter - right_panel_width,
        outer_gutter +
            speaker_grill_dimensions.y + default_gutter,
    ];

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

    minimum_height = pcb_position.z + PCB_HEIGHT + pcb_top_clearance
        + ENCLOSURE_FLOOR_CEILING;
    assert(height >= minimum_height, "Height is too low.");

    if (show_battery) {
        translate(battery_position) translate([0, 0, -e * 2]) {
            rotate([0, 90, 0]) rotate([0, 0, 90])
            % battery();
        }
    }

    if (show_enclosure_bottom || show_enclosure_top) {
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

            pcb_screw_hole_positions = pcb_screw_hole_positions,
            pcb_post_hole_positions = pcb_post_hole_positions,

            switch_clutch_grip_height = switch_clutch_grip_height,
            switch_clutch_web_length_extension = switch_clutch_web_length_extension,

            right_panel_width = right_panel_width,
            branding_dimensions = branding_dimensions,
            button_cap_exposure_dimensions = button_cap_exposure_dimensions,
            speaker_grill_dimensions = speaker_grill_dimensions,
            branding_position = branding_position,
            speaker_grill_position = speaker_grill_position,
            button_cap_exposure_position = button_cap_exposure_position,

            outer_gutter = outer_gutter,
            default_gutter = default_gutter,

            tolerance = tolerance,

            outer_color = enclosure_outer_color,
            cavity_color = enclosure_cavity_color,

            show_dfm = !quick_preview,

            quick_preview = quick_preview
        );
    }

    translate(pcb_position) translate([0, 0, -e]) {
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

    if (show_knobs) {
        knob_brim_coverage = 1; // NOTE: eyeballed against side switch_clutch
        knob_z_clearance = .4;
        knob_z = pcb_position.z + PCB_HEIGHT + PTV09A_POT_BASE_HEIGHT_FROM_PCB + knob_z_clearance;
        knob_brim_height = height - ENCLOSURE_FLOOR_CEILING - knob_z - knob_z_clearance;

        for (xy = PCB_POT_POSITIONS) {
            translate([
                pcb_position.x + xy.x,
                pcb_position.y + xy.y,
                knob_z
            ]) {
                knob(
                    diameter = knob_diameter,
                    height = PTV09A_POT_ACTUATOR_HEIGHT - knob_z_clearance
                        + ENCLOSURE_FLOOR_CEILING,
                    fillet = accessory_fillet,
                    dimple_y = knob_diameter / 2 / 2,
                    round_bottom = false,
                    brim_diameter = CONTROL_WIDTH + knob_brim_coverage,
                    brim_height = knob_brim_height,
                    color = "#FFFFFF",
                    cavity_color = "#EEEEEE",
                    tolerance = tolerance,
                    $fn = quick_preview ? undef : 24
                );
            }
        }
    }

    if (show_button_cap) {
        button_cap_brim_height = 1;

        color(control_outer_color) {
            button_lever(
                screw_mount_position = [
                    pcb_position.x + pcb_screw_hole_positions[0].x,
                    pcb_position.y + pcb_screw_hole_positions[0].y
                ],
                button_cap_exposure_position = button_cap_exposure_position,
                button_cap_exposure_dimensions = button_cap_exposure_dimensions,
                control_clearance = control_clearance,
                button_cap_brim_height = button_cap_brim_height,
                fillet = accessory_fillet,
                tolerance = tolerance,
                mount_z = pcb_position.z + PCB_HEIGHT,
                $fn = quick_preview ? undef : 12
            );
        }
    }

    if (show_switch_clutches) {
        // TODO: fix power clutch obstruction, component obstruction

        // HACK: lots of arbitrary values here to make Scout's clutch work.
        // Copied from higher_lower bahhhhh
        translate([
            pcb_position.x + SWITCH_ORIGIN.x + .15,
            pcb_position.y + PCB_SWITCH_Y + SWITCH_ORIGIN.y,
            0
        ]) {
            switch_clutch_angled(
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

                quick_preview = 0
            );
        }

        z = pcb_position.z + PCB_HEIGHT + SWITCH_BASE_HEIGHT;
        overshoot = [0, 1];
        base_width = control_width / 2 + overshoot.x * 2;
        base_length = control_width + SWITCH_ACTUATOR_TRAVEL + overshoot.y * 2;

        for (i = [0 : len(PCB_TOP_CONTROL_SWITCH_POSITONS) - 1]) {
            xy = PCB_TOP_CONTROL_SWITCH_POSITONS[i];

            translate([
                pcb_position.x + xy.x,
                pcb_position.y + xy.y,
                z - e
            ]) {
                difference() {
                    switch_clutch(
                        base_width = SWITCH_CLUTCH_MIN_BASE_WIDTH,
                        base_length = SWITCH_CLUTCH_MIN_BASE_LENGTH,
                        base_height = height - z - ENCLOSURE_FLOOR_CEILING,

                        plate_width = base_width,
                        plate_length = base_length,
                        plate_height = ENCLOSURE_FLOOR_CEILING,

                        actuator_width = control_width / 2 - control_clearance * 2,
                        actuator_length = control_width - SWITCH_ACTUATOR_TRAVEL
                            - control_clearance * 2,
                        actuator_height = ENCLOSURE_FLOOR_CEILING + 2,

                        position = 1,

                        cavity_base_height = -e,
                        cavity_actuator_height = SWITCH_ACTUATOR_HEIGHT + e,

                        fillet = accessory_fillet,

                        color = control_outer_color,
                        cavity_color = control_cavity_color,

                        chamfer_cavity_top = false,

                        clearance = control_clearance,
                        tolerance = tolerance
                    );

                    // TODO: obviate
                    if (i == 0) {
                        translate([6.3, 8.7, -50]) {
                            color(control_cavity_color) cylinder(
                                d = 9,
                                h = 100,
                                $fn = 24
                            );
                        }

                        translate([-1.9, 8.7, -50]) {
                            color(control_cavity_color) cylinder(
                                d = 4,
                                h = 54,
                                $fn = 24
                            );
                        }
                    }
                }
            }
        }
    }

    if (show_speaker) {
        % translate([
            speaker_position.x,
            speaker_position.y,
            speaker_position.z - e * 2
        ]) {
            speaker($fn = 120);
        }
    }

    if (show_print_test) {
        print_test(quick_preview = quick_preview);
    }
}

SHOW_ENCLOSURE_BOTTOM = true;
SHOW_BATTERY = true;
SHOW_PCB = true;
SHOW_KNOBS = true;
SHOW_BUTTON_CAP = true;
SHOW_SWITCH_CLUTCHES = true;
SHOW_SPEAKER = true;
SHOW_ENCLOSURE_TOP = true;
SHOW_PRINT_TEST = false;

SHOW_CLEARANCE = false;
DEFAULT_TOLERANCE = .1;
Y_ROTATION = 0;

rotate([0, Y_ROTATION, 0])
difference() {
space_dice(
    show_enclosure_bottom = SHOW_ENCLOSURE_BOTTOM,
    show_battery = SHOW_BATTERY,
    show_pcb = SHOW_PCB,
    show_knobs = SHOW_KNOBS,
    show_button_cap = SHOW_BUTTON_CAP,
    show_switch_clutches = SHOW_SWITCH_CLUTCHES,
    show_speaker = SHOW_SPEAKER,
    show_enclosure_top = SHOW_ENCLOSURE_TOP,
    show_print_test = SHOW_PRINT_TEST,

    show_clearance = SHOW_CLEARANCE,

    tolerance = DEFAULT_TOLERANCE,

    quick_preview = $preview
);

// INCR
// translate([31, -1, -1]) cube([100, 100, 100]);

// VOL
// translate([55, -1, -1]) cube([100, 100, 100]);

// pcb_mount_post
// translate([52, -1, -1]) cube([100, 100, 100]);

// right panel
// translate([79, -1, -1]) cube([100, 100, 100]);
}