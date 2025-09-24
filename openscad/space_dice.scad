include <../../parts_cafe/openscad/battery-9v.scad>;
include <../../parts_cafe/openscad/cap_blank.scad>;
include <../../parts_cafe/openscad/pcb_base.scad>;
include <../../parts_cafe/openscad/spst.scad>;
include <../../parts_cafe/openscad/speaker-AZ40R.scad>;
include <../../parts_cafe/openscad/switch_clutch_fixture.scad>;

PCB_WIDTH = 88.9;
PCB_LENGTH = 76.2;
EDGE_CUT_START_X = 94.615;
EDGE_CUT_START_Y = 64.77;

SPST_HEIGHT = 6;

e = .015;

module base(
    gutter = 5,
    pcb_bottom_clearance = 10,
    tolerance = .1,
    pcb_dimensions = [PCB_WIDTH, PCB_LENGTH, PCB_HEIGHT],
    battery_dimensions = [
        BATTERY_WIDTH + BATTERY_SNAP_WIDTH,
        BATTERY_HEIGHT,
        BATTERY_LENGTH
    ]
) {
    speaker_fixture_diameter = get_speaker_fixture_diameter(tolerance);

    width = PCB_WIDTH + gutter * 3 + max(
        battery_dimensions.x,
        speaker_fixture_diameter
    );
    length = PCB_LENGTH + gutter * 2;

    battery_position = [
        width - gutter - battery_dimensions.x,
        length - gutter - battery_dimensions.y,
        pcb_dimensions.z
    ];

    pcb_position = [
        gutter, gutter, get_pcb_base_total_height(
            min_clearance = pcb_bottom_clearance,
            nut_z_clearance = PCB_MOUNT_NUT_Z_CLEARANCE,
            screw_length = 25.4 / 4,
            pcb_height = pcb_dimensions.z,
            pcb_mount_post_ceiling = PCB_MOUNT_POST_CEILING,

            base_height = PCB_BASE_BASE_HEIGHT
        )
    ];

    speaker_position = [
        width - gutter - speaker_fixture_diameter / 2,
        gutter + speaker_fixture_diameter / 2,
        pcb_position.z + PCB_HEIGHT - SPEAKER_HEIGHT
    ];

    function _xy(
        xy,
        start = [EDGE_CUT_START_X, EDGE_CUT_START_Y]
    ) = (
        [xy.x - start.x + gutter, PCB_LENGTH - xy.y + start.y + gutter]
    );

    pcb_base(
        width, length,

        pcb_bottom_clearance = pcb_bottom_clearance,

        screw_positions = [
            _xy([98.425, 137.16]),
            _xy([179.705, 137.16]),
            _xy([98.425, 68.58]),
            _xy([179.705, 68.58]),

            // button
            _xy([170.18, 123.19]),
        ],
        stool_positions = [],

        tolerance = tolerance,

        show_dfm = !$preview,
        quick_preview = $preview
    );

    translate([
        speaker_position.x,
        speaker_position.y,
        PCB_BASE_BASE_HEIGHT - e
    ]) {
        speaker_fixture(
            height = speaker_position.z + SPEAKER_HEIGHT - PCB_BASE_BASE_HEIGHT + e,
            tolerance = tolerance,
            quick_preview = $preview
        );
    }

    translate(speaker_position) translate([0, 0, -e]) {
        % speaker();
    }

    translate(battery_position) translate([0, 0, -e])  {
        % cube(battery_dimensions);
    }

    translate(pcb_position) translate([0, 0, -e])  {
        % cube(pcb_dimensions);
    }
}

module switch_clutches_and_fixture(
    count = 3,
    plot = 5.8,
    fixture_width = 28,
    fixture_length = 20,
    fixture_height = 10,
    screw_hole_distance = 21.59,
    actuator_exposure = 4,
    switch_clutch_base_height = 8,
    clearance = [.2, .4, .4],
    fillet = 1,
    tolerance = .1,
    debug = false
) {
    switches_width = plot * (count - 1) + SWITCH_BASE_WIDTH;

    // clutch rests on switch, not PCB
    switch_clutch_width = plot - clearance.x;
    switch_clutch_base_length = max(
        fixture_length - SWITCH_ACTUATOR_TRAVEL - fillet,
        SWITCH_CLUTCH_MIN_BASE_LENGTH
    );

    window_width = switch_clutch_width * count + clearance.x * (count + 1);
    x_gutter = (fixture_width - window_width) / 2;

    actuator_length = max(
        fixture_length - x_gutter * 2 - SWITCH_ACTUATOR_TRAVEL
            - clearance.y * 2,
        SWITCH_CLUTCH_MIN_ACTUATOR_LENGTH
    );

    window_length = actuator_length + SWITCH_ACTUATOR_TRAVEL
        + clearance.y * 2;

    translate([
        SWITCH_ORIGIN.x - (switch_clutch_width - SWITCH_BASE_WIDTH) / 2
            - (fixture_width - window_width) / 2
            - clearance.x,
        fixture_length / -2,
        0
    ]) {
        switch_clutch_fixture(
            width = fixture_width,
            length = fixture_length,
            height = fixture_height,

            cavity_base_width = window_width,
            cavity_base_length = fixture_length + 10,
            cavity_base_height = switch_clutch_base_height + clearance.z,

            window_width = window_width,
            window_length = window_length,

            fillet = fillet, $fn = 8,

            include_screw_holes = true,
            screw_hole_distance = screw_hole_distance,

            tolerance = tolerance,

            debug = debug
        );
    }

    for (i = [0 : count - 1]) {
        translate([
            plot * i,
            -SWITCH_ORIGIN.y - SWITCH_BASE_LENGTH / 2,
            0
        ]) {
            switch_clutch(
                base_height = switch_clutch_base_height,
                base_width = switch_clutch_width - tolerance * 2,
                base_length = switch_clutch_base_length,

                actuator_width = switch_clutch_width - tolerance * 2,
                actuator_length = actuator_length,
                actuator_height = fixture_height - switch_clutch_base_height
                    + actuator_exposure,

                position = round($t * count) == i ? 1 : 0,

                cavity_base_width = switch_clutch_width - tolerance * 2,

                fillet = fillet, $fn = 6,

                clearance = 0.4,
                tolerance = tolerance,

                debug = debug
            );

            % translate([0,0,-.01]) switch(position = round($t * count) == i ? 1 : 0);
        }
    }
}

// MAYBE: registration against SPST actuator, alignment fixtures for spacer/mount/SPST
module button_key(
    mount_size = NUT_DIAMETER,
    mount_height = 1,
    height = NUT_DIAMETER / 2,
    cap_size = NUT_DIAMETER * 1.5,
    actuator_cavity_height = .6,
    actuator_cavity_x = 1,
    tolerance = .1,
    $fn = 12
) {
    translate([mount_size / 2, cap_size / 2, -e]) {
        ring(
            diameter = mount_size,
            height = SPST_HEIGHT - actuator_cavity_height,
            inner_diameter = SCREW_DIAMETER + tolerance * 2
        );
    }

    actuator_cavity_diameter = SPST_ACTUATOR_DIAMETER + tolerance * 2;

    translate([0, 0, SPST_HEIGHT - actuator_cavity_height]) {
        difference() {
            union() {
                translate([mount_size / 2, cap_size / 2, 0]) {
                    difference() {
                        hull() {
                            cylinder(d = mount_size, h = mount_height);
                            translate([mount_size / 2 + e, mount_size / -2, 0]) {
                                cube([e, mount_size, mount_height]);
                            }
                        }

                        translate([0, 0, -e]) {
                            cylinder(
                                d = SCREW_DIAMETER + tolerance * 2,
                                h = mount_height + e * 2
                            );
                        }
                    }
                }
                translate([mount_size - e, cap_size / 2 - cap_size / 2, 0]) cap_blank(
                    dimensions = [cap_size, cap_size, height],
                    contact_dimensions = [cap_size * .75, cap_size * .75, height - mount_height],
                    fillet = 1,
                    brim_dimensions = [0, 0, 0]
                );
            }

            translate([mount_size + actuator_cavity_x, cap_size / 2 - actuator_cavity_diameter / 2, -e]) {
                cube([cap_size, actuator_cavity_diameter, actuator_cavity_height + e]);
            }
        }
    }
}

base();
translate([10, PCB_LENGTH + 25, 0]) switch_clutches_and_fixture(debug = 0);
translate([40, PCB_LENGTH + 18, 0]) button_key();