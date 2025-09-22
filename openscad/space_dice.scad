include <../../parts_cafe/openscad/battery-9v.scad>;
include <../../parts_cafe/openscad/pcb_base.scad>;
include <../../parts_cafe/openscad/speaker-AZ40R.scad>;

PCB_WIDTH = 88.9;
PCB_LENGTH = 76.2;
EDGE_CUT_START_X = 94.615;
EDGE_CUT_START_Y = 64.77;

module space_dice(
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
    e = .015;

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

space_dice();