include <../../parts_cafe/openscad/diagonal_grill.scad>;
include <../../parts_cafe/openscad/enclosure_engraving.scad>;
include <../../parts_cafe/openscad/enclosure.scad>;
include <../../parts_cafe/openscad/flat_top_rectangular_pyramid.scad>;
include <../../parts_cafe/openscad/pcb_mounting_columns.scad>;
include <../../parts_cafe/openscad/ring.scad>;
include <../../parts_cafe/openscad/switch_clutch_enclosure_engraving.scad>;

include <pcb.scad>;

SWITCH_CLUTCH_GRIP_LENGTH = 10;

DEFAULT_ROUNDING = 24;
HIDEF_ROUNDING = 120;

SCOUT_DEFAULT_GUTTER = 3.4;
OUTER_GUTTER = 5;
PCB_XY = 5;

ALTOIDS_TIN_DIMENSIONS = [95,60,20];

// NOTE: Arbitrary height is for 9v and component clearance.
// It's also effectively 1/4 ALTOIDS_TIN_DIMENSIONS.x
ENCLOSURE_DIMENSIONS = [
    ALTOIDS_TIN_DIMENSIONS.x, ALTOIDS_TIN_DIMENSIONS.y,
    24
];

CONTROL_WIDTH = 17.4;
CONTROL_LENGTH = CONTROL_WIDTH +
    ENCLOSURE_ENGRAVING_LENGTH + ENCLOSURE_ENGRAVING_GUTTER;

module enclosure(
    show_top = true,
    show_bottom = true,

    dimensions = [0,0,0],
    bottom_height = 0,
    top_height = 0,

    control_clearance = 0,

    pcb_position = [0,0,0],

    speaker_position = [0,0,0],

    // hehe, eyeballed
    top_engraving_model_text_size =
        ENCLOSURE_ENGRAVING_TEXT_SIZE * .666,

    lip_height = ENCLOSURE_LIP_HEIGHT,

    fillet = ENCLOSURE_FILLET,
    inner_chamfer = ENCLOSURE_INNER_CHAMFER,

    pcb_width = 0,
    pcb_length = 0,
    pcb_height = PCB_HEIGHT,

    pcb_post_hole_positions = [],

    control_width = CONTROL_WIDTH,
    control_length = CONTROL_LENGTH,
    knob_diameter = 0,

    switch_clutch_grip_height = 0,
    switch_clutch_web_length_extension = 0,

    outer_gutter = 0,
    default_gutter = 0,

    tolerance = 0,

    outer_color = undef,
    cavity_color = undef,

    chamfer = .4,
    show_dfm = true,

    quick_preview = true
) {
    e = .03183;

    cavity_z = dimensions.z - ENCLOSURE_FLOOR_CEILING - e;
    cavity_height = ENCLOSURE_FLOOR_CEILING + e * 2;

    speaker_cavity_diameter = SPEAKER_DIAMETER + tolerance * 2;

    switch_window_width = control_width / 2;
    switch_window_length = control_width;

    switch_clutch_aligner_length =
        SWITCH_CLUTCH_GRIP_LENGTH + SWITCH_ACTUATOR_TRAVEL
        + switch_clutch_web_length_extension * 2;
    switch_clutch_aligner_y = pcb_position.y + PCB_SWITCH_Y
            + SWITCH_BASE_LENGTH / 2
            - switch_clutch_aligner_length / 2;

    under_pcb_fixture_height = pcb_position.z - ENCLOSURE_FLOOR_CEILING;

    right_panel_width = dimensions.x
        - outer_gutter * 2 - default_gutter * 3
        - control_width * 3;
    right_panel_x = dimensions.x - outer_gutter - right_panel_width;
    right_panel_section_length = (dimensions.y
        - outer_gutter * 2 - default_gutter * 3) / 4;
    branding_length = right_panel_section_length;
    speaker_grill_length = right_panel_section_length * 3 + default_gutter * 2;

    module _translate(xy1, xy2 = [0,0], xy3 = [0,0], xy4 = [0,0]) {
        translate([
            pcb_position.x + xy1.x + xy2.x + xy3.x + xy4.x,
            pcb_position.y + xy1.y + xy2.y + xy3.y + xy4.y,
            dimensions.z - ENCLOSURE_FLOOR_CEILING - e
        ]) {
            children();
        }
    }

    // TODO: extract as round_enclosure_exposure
    // then add cube version too
    module _c(
        diameter,
        height,
        chamfer = chamfer,
        $fn = quick_preview ? undef : HIDEF_ROUNDING
    ) {
        cylinder(
            d = diameter,
            h = height
        );

        if (show_dfm && chamfer > 0) {
            translate([0, 0, height - chamfer]) {
                cylinder(
                    d1 = diameter,
                    d2 = diameter + chamfer * 2,
                    h = chamfer
                );
            }
        }
    }

    module _bottom_engraving(
        wordmark_length = 8,
        make_y = dimensions.y * .25
    ) {
        render() enclosure_engraving(
            size = wordmark_length,
            center = true,
            position = [dimensions.x / 2, make_y],
            bottom = true,
            quick_preview = quick_preview,
            enclosure_height = dimensions.z
        );
    }

    module _half(height, lip) {
        enclosure_half(
            width = dimensions.x,
            length = dimensions.y,
            height = height,
            add_lip = lip,
            remove_lip = !lip,
            lip_height = lip_height,
            fillet = quick_preview ? 0 : fillet,
            inner_chamfer = quick_preview ? 0 : inner_chamfer,
            tolerance = tolerance * 1.5, // intentionally kinda loose
            include_tongue_and_groove = true,
            tongue_and_groove_snap = [.5, 1, .5, 1],
            tongue_and_groove_pull = .3,
            include_disassembly_wedges = true,
            outer_color = outer_color,
            cavity_color = cavity_color,
            $fn = quick_preview ? undef : DEFAULT_ROUNDING
        );
    }

    module _bottom_pcb_fixtures() {
        pcb_mounting_columns(
            pcb_position = pcb_position,
            wall = ENCLOSURE_INNER_WALL,
            pcb_screw_hole_positions = [],
            pcb_post_hole_positions = pcb_post_hole_positions,
            tolerance = tolerance,
            enclosure_floor_ceiling = ENCLOSURE_FLOOR_CEILING,
            pcb_hole_diameter = PCB_HOLE_DIAMETER,
            registration_nub_height = PCB_HEIGHT,
            support_web_length = (pcb_position.z - ENCLOSURE_FLOOR_CEILING) / 2,
            quick_preview = quick_preview
        );
    }

    module _switch_clutch_deobstruction_cavity(
        width = 3 // NOTE: arbitrary
    ) {
        translate([
            pcb_position.x - width,
            switch_clutch_aligner_y - tolerance - e,
            -e
        ]) {
            cube([
                width,
                switch_clutch_aligner_length
                    + tolerance * 2 + e * 2,
                dimensions.z + e * 2
            ]);
        }
    }

    module _speaker_fixture() {
        translate([
            speaker_position.x,
            speaker_position.y,
            speaker_position.z - e,
        ]) {
            speaker_fixture(
                height = SPEAKER_HEIGHT + e,
                wall = ENCLOSURE_INNER_WALL,

                tab_cavity_count = 2,
                tab_cavity_rotation = 0,

                tolerance = tolerance,
                quick_preview = quick_preview
            );
        }
    }

    module _top_branding_engraving(gutter = ENCLOSURE_ENGRAVING_GUTTER) {
        wordmark_length = right_panel_width * OSKITONE_LENGTH_WIDTH_RATIO;
        placard_length = branding_length - wordmark_length - gutter;

        position = [
            right_panel_x + right_panel_width / 2,
            dimensions.y - outer_gutter - branding_length
        ];

        enclosure_engraving(
            size = wordmark_length,
            position = [
                position.x,
                position.y + placard_length + gutter
                    + wordmark_length / 2
            ],
            bottom = false,
            quick_preview = quick_preview,
            enclosure_height = dimensions.z
        );

        enclosure_engraving(
            string = "SPACE DICE",
            size = top_engraving_model_text_size,
            position = [
                position.x,
                position.y + placard_length / 2
            ],
            placard = [
                right_panel_width,
                placard_length
            ],
            bottom = false,
            center = true,
            quick_preview = quick_preview,
            enclosure_height = dimensions.z
        );
    }

    module _top_exposures() {
        // Math in here uses PCB values instead of deriving based
        // on layout. They should be the same tho!

        height = ENCLOSURE_FLOOR_CEILING + e * 2;

        led_exposure_position = [
            (PCB_LED_POSITIONS[0].x + PCB_LED_POSITIONS[2].x) / 2,
            PCB_LED_POSITIONS[3].y
        ];

        for (xy = PCB_POT_POSITIONS) {
            _translate(xy) {
                _c(control_width + tolerance * 2, height);
            }
        }

        for (xy = PCB_TOP_CONTROL_SWITCH_POSITONS) {
            _translate(
                // bottom left of switch base
                xy, SWITCH_ORIGIN,

                // centered to switch base
                [SWITCH_BASE_WIDTH / 2, SWITCH_BASE_LENGTH / 2],

                // finally, centered exposure to switch
                [switch_window_width / -2, switch_window_length / -2]
            ) {
                actuator_window(
                    dimensions = [switch_window_width, switch_window_length],
                    tolerance = tolerance
                );
            }
        }

        _translate(
            led_exposure_position,
            [control_width / -2, control_length / -2]
        ) {
            cube([control_width, control_length, height]);
        }
    }

    module _top_control_engraving() {
        // And positioning here is instead done based on layout,
        // not the PCB. It's fine!

        labels = [
            "OCT", "INCR", undef,
            "TONE", "DROP", "VOL",
        ];

        for (rowI = [0,1], columnI = [0,1,2]) {
            labelI = rowI * 3 + columnI;

            xy = [
                outer_gutter + (control_width + default_gutter) * columnI
                    + control_width / 2,
                outer_gutter + (control_length + default_gutter) * rowI
                    + ENCLOSURE_ENGRAVING_LENGTH / 2,
            ];

            if (labels[labelI]) {
                enclosure_engraving(
                    labels[labelI],
                    center = true,
                    position = xy,
                    placard = [control_width, ENCLOSURE_ENGRAVING_LENGTH],
                    quick_preview = quick_preview,
                    enclosure_height = dimensions.z
                );
            }
        }

        for (i = [0, 1]) {
            switch_clutch_enclosure_engraving(
                labels = [
                    ["Q0", "Q4"],
                    ["Q6", "Q8"]
                ][i],
                actuator_window_dimensions = [switch_window_width, switch_window_length],
                control_clearance = 0,
                quick_preview = quick_preview,
                position = [
                    outer_gutter + i * (control_width + default_gutter),
                    outer_gutter + ENCLOSURE_ENGRAVING_LENGTH
                ],
                enclosure_height = dimensions.z
            );
        }
    }

    module _speaker_grill() {
        translate([
            right_panel_x,
            outer_gutter,
            dimensions.z - ENCLOSURE_ENGRAVING_DEPTH + e
        ]) {
            diagonal_grill(
                right_panel_width, speaker_grill_length, ENCLOSURE_ENGRAVING_DEPTH
            );
        }
    }

    module _switch_clutch_fixture(
        top = true,
        width = ENCLOSURE_INNER_WALL,
        height = under_pcb_fixture_height
    ) {
        x = pcb_position.x;
        z = top
            ? dimensions.z - ENCLOSURE_FLOOR_CEILING - height
            : ENCLOSURE_FLOOR_CEILING - e;

        translate([x, switch_clutch_aligner_y, z]) {
            cube([width, switch_clutch_aligner_length, height + e]);
        }
    }

    module _switch_clutch_exposure(
        length_clearance = .2
    ) {
        length = SWITCH_CLUTCH_GRIP_LENGTH + SWITCH_ACTUATOR_TRAVEL
            + tolerance * 4 + length_clearance * 2;
        height = switch_clutch_grip_height + tolerance * 4;

        translate([
            -e,
            pcb_position.y + PCB_SWITCH_Y + SWITCH_BASE_LENGTH / 2 - length / 2,
            (dimensions.z - height) / 2
        ]) {
            cube([
                ENCLOSURE_WALL + e * 2, length, height
            ]);
        }
    }

    if (show_bottom) {
        difference() {
            union() {
                _half(bottom_height, lip = true);

                color(outer_color) {
                    _speaker_fixture();
                    _bottom_pcb_fixtures();
                    _switch_clutch_fixture(top = false);
                }
            }

            color(cavity_color) {
                _bottom_engraving();
                _switch_clutch_exposure();
            }
        }
    }

    if (show_top) {
        difference() {
            union() {
                translate([0, 0, dimensions.z]) {
                    mirror([0, 0, 1]) {
                        _half(top_height, lip = false);
                    }
                }

                color(outer_color) {
                    _switch_clutch_fixture(top = true);
                }
            }

            color(cavity_color) {
                _top_branding_engraving();
                _top_exposures();
                _top_control_engraving();
                _speaker_grill();
                _switch_clutch_exposure();
            }
        }
    }
}
