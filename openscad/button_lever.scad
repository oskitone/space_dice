include <../../parts_cafe/openscad/chamfered_cube.scad>;
include <../../parts_cafe/openscad/nuts_and_bolts.scad>;
include <../../parts_cafe/openscad/spst.scad>;

include <enclosure.scad>;
include <pcb.scad>;

BUTTON_LEVER_MOUNT_DIAMETER = 7; // NOTE: eyeballed against PCB components
BUTTON_LEVER_ENCLOSURE_Z_CLEARANCE = .2;

function get_button_lever_arm_z(arm_height) = (
    ENCLOSURE_DIMENSIONS.z - ENCLOSURE_FLOOR_CEILING
        - arm_height
        - BUTTON_LEVER_ENCLOSURE_Z_CLEARANCE
);

module button_lever(
    screw_mount_position,
    button_cap_exposure_position,
    button_cap_exposure_dimensions,
    control_clearance,
    arm_height,
    fillet,
    tolerance = 0,
    mount_diameter = BUTTON_LEVER_MOUNT_DIAMETER,
    cantilever_height = .8,
    actuator_mount_z,
    spst_actuator_cavity_depth = 1,
    spst_clearance = .2,
    exposed_height = 0,
    exposure_fillet = 0,
    part_separation = $preview ? 0 : 1
) {
    e = .0235;

    button_x = PCB_XY + PCB_BUTTON_POSITION.x;
    cantilever_width = button_x - screw_mount_position.x;

    button_cap_arm_z = get_button_lever_arm_z(arm_height);
    button_cap_brim_xy_coverage = SCOUT_DEFAULT_GUTTER / 2;
    button_cap_brim_right_extension = ENCLOSURE_DIMENSIONS.x
        - button_cap_exposure_position.x
        - button_cap_exposure_dimensions.x
        + control_clearance - tolerance * 2
        - ENCLOSURE_WALL;

    button_cap_dimensions = [
        button_cap_exposure_dimensions.x - control_clearance * 2,
        button_cap_exposure_dimensions.y - control_clearance * 2,
        ENCLOSURE_DIMENSIONS.z - button_cap_arm_z + exposed_height
    ];

    // TODO: Move contact to left side (affordance)
    contact_dimensions = [
        button_cap_dimensions.x - exposure_fillet,
        button_cap_dimensions.y - exposure_fillet,
        exposed_height
    ];

    module _c(diameter, height, z = 0) {
        translate([
            screw_mount_position.x,
            screw_mount_position.y,
            z
        ]) {
            cylinder(
                d = diameter,
                h = height
            );
        }
    }

    module _button_cap_arm() {
        width_to_actuator =
            button_cap_exposure_position.x - button_x;

        hull() {
            translate([
                button_cap_exposure_position.x - width_to_actuator,
                screw_mount_position.y - mount_diameter / 2,
                0
            ]) {
                cube([
                    e,
                    mount_diameter,
                    arm_height
                ]);
            }

            translate([
                button_cap_exposure_position.x + control_clearance
                    - button_cap_brim_xy_coverage,
                button_cap_exposure_position.y + control_clearance
                    - button_cap_brim_xy_coverage,
                0
            ]) {
                chamfered_cube([
                    button_cap_dimensions.x + button_cap_brim_xy_coverage
                        + button_cap_brim_right_extension,
                    button_cap_dimensions.y + button_cap_brim_xy_coverage * 2,
                    arm_height
                ], ENCLOSURE_INNER_CHAMFER);
            }
        }

        translate([
            button_cap_exposure_position.x + control_clearance,
            button_cap_exposure_position.y + control_clearance,
            e
        ]) {
            cap_blank(
                dimensions = [
                    button_cap_dimensions.x,
                    button_cap_dimensions.y,
                    button_cap_dimensions.z + e
                ],
                contact_dimensions = contact_dimensions,
                fillet = fillet,
                brim_dimensions = [0,0,0]
            );
        }
    }

    // TODO: reduce for DFM and screw height; rounded_cube
    module _actuator_mount() {
        bottom_height = SPST_ACTUATOR_HEIGHT_OFF_PCB
            + spst_clearance - spst_actuator_cavity_depth;
        top_height = button_cap_arm_z - (actuator_mount_z + bottom_height);

        module _ends(height, half_width_actuator) {
            _c(mount_diameter, height);

            translate([cantilever_width, 0, 0]) {
                difference() {
                    _c(mount_diameter, height);

                    if (half_width_actuator) {
                        z = spst_actuator_cavity_depth + cantilever_height;

                        translate([
                            screw_mount_position.x + mount_diameter / -2 - e,
                            screw_mount_position.y + mount_diameter / -2 - e,
                            z
                        ]) {
                            cube([
                                mount_diameter / 2 + e,
                                mount_diameter + e * 2,
                                top_height - z + e
                            ]);
                        }
                    }
                }
            }
        }

        difference() {
            translate([0, 0, bottom_height]) {
                _ends(top_height, true);

                translate([0, 0, spst_actuator_cavity_depth]) {
                    hull() {
                        _ends(cantilever_height, false);
                    }
                }
            }

            translate([cantilever_width, 0, 0]) {
                _c(
                    SPST_ACTUATOR_DIAMETER + tolerance * 2,
                    spst_actuator_cavity_depth + e,
                    bottom_height - e
                );
            }
        }

        _c(mount_diameter, bottom_height + e);
    }

    difference() {
        union() {
            translate([0, 0, button_cap_arm_z + part_separation * 1]) {
                _button_cap_arm();
            }

            translate([0, 0, actuator_mount_z]) {
                _actuator_mount();
            }
        }

        _c(SCREW_DIAMETER + tolerance * 2, 100, -e);
    }
}