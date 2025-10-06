include <../../parts_cafe/openscad/battery-9v.scad>;
include <../../parts_cafe/openscad/chamfered_cube.scad>;
include <../../parts_cafe/openscad/chamfered_xy_cube.scad>;
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
    exposure_position,
    exposure_dimensions,
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
    chamfer = 0,
    part_separation = $preview ? 0 : 1
) {
    e = .0235;

    button_x = PCB_XY + PCB_BUTTON_POSITION.x;
    cantilever_width = button_x - screw_mount_position.x;

    battery_top_z = ENCLOSURE_FLOOR_CEILING + BATTERY_LENGTH; // yep

    max_right_x = ENCLOSURE_DIMENSIONS.x - tolerance * 2
        - ENCLOSURE_WALL;

    arm_z = get_button_lever_arm_z(arm_height);
    brim_xy_coverage = SCOUT_DEFAULT_GUTTER / 2;
    brim_right_extension = max_right_x
        - exposure_position.x
        - exposure_dimensions.x
        + control_clearance;

    dimensions = [
        exposure_dimensions.x - control_clearance * 2,
        exposure_dimensions.y - control_clearance * 2,
        ENCLOSURE_DIMENSIONS.z - arm_z + exposed_height
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

    module _arm() {
        width_to_actuator = exposure_position.x - button_x;
        height_from_battery = arm_z - battery_top_z;

        fulcrum_position = [
            exposure_position.x + exposure_dimensions.x,
            exposure_position.y + control_clearance
                    - brim_xy_coverage,
            -height_from_battery
        ];

        hull() {
            translate([
                exposure_position.x - width_to_actuator,
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
                exposure_position.x + control_clearance
                    - brim_xy_coverage,
                exposure_position.y + control_clearance
                    - brim_xy_coverage,
                0
            ]) {
                chamfered_cube([
                    dimensions.x + brim_xy_coverage
                        + brim_right_extension,
                    dimensions.y + brim_xy_coverage * 2,
                    arm_height
                ], ENCLOSURE_INNER_CHAMFER);
            }
        }

        // TODO: DFM w/o print supports
        translate(fulcrum_position) {
            chamfered_xy_cube([
                max_right_x - fulcrum_position.x,
                dimensions.y + brim_xy_coverage * 2,
                height_from_battery + ENCLOSURE_INNER_CHAMFER
            ], ENCLOSURE_INNER_CHAMFER);
        }

        translate([
            exposure_position.x + control_clearance,
            exposure_position.y + control_clearance,
            e
        ]) {
            hull() {
                rounded_cube([
                    dimensions.x,
                    dimensions.y,
                    dimensions.z - exposed_height + fillet - e
                ], fillet);

                translate([chamfer, chamfer, dimensions.z - fillet * 2]) {
                    rounded_cube_corners([
                        (dimensions.x - chamfer * 2) / 2,
                        dimensions.y - chamfer * 2,
                        fillet
                    ], fillet);
                }
            }
        }
    }

    // TODO: reduce for DFM and screw height; rounded_cube
    module _actuator_mount() {
        bottom_height = SPST_ACTUATOR_HEIGHT_OFF_PCB
            + spst_clearance - spst_actuator_cavity_depth;
        top_height = arm_z - (actuator_mount_z + bottom_height);

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
            translate([0, 0, arm_z + part_separation * 1]) {
                _arm();
            }

            translate([0, 0, actuator_mount_z]) {
                _actuator_mount();
            }
        }

        _c(SCREW_DIAMETER + tolerance * 2, 100, -e);
    }
}