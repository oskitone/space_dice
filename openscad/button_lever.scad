include <../../parts_cafe/openscad/battery-9v.scad>;
include <../../parts_cafe/openscad/chamfered_cube.scad>;
include <../../parts_cafe/openscad/chamfered_xy_cube.scad>;
include <../../parts_cafe/openscad/nuts_and_bolts.scad>;
include <../../parts_cafe/openscad/spst.scad>;

include <enclosure.scad>;
include <pcb.scad>;

BUTTON_LEVER_MOUNT_DIAMETER = 7; // NOTE: eyeballed against PCB components
BUTTON_LEVER_ENCLOSURE_Z_CLEARANCE = .4;
BUTTON_LEVER_ENCLOSURE_SPST_CLEARANCE = .4;
BUTTON_LEVER_ACTUATOR_MOUNT_CAVITY_DEPTH =
    SPST_ACTUATOR_HEIGHT_OFF_PCB - SPST_BASE_DIMENSIONS.z
    - SPST_CONSERVATIVE_TRAVEL;
BUTTON_LEVER_ACTUATOR_MOUNT_BOTTOM_HEIGHT = SPST_ACTUATOR_HEIGHT_OFF_PCB
    + BUTTON_LEVER_ENCLOSURE_SPST_CLEARANCE - BUTTON_LEVER_ACTUATOR_MOUNT_CAVITY_DEPTH;
BUTTON_LEVER_ACTUATOR_CANTILEVER_HEIGHT = .8;

function get_button_lever_arm_z(arm_height) = (
    ENCLOSURE_DIMENSIONS.z - ENCLOSURE_FLOOR_CEILING
        - arm_height
        - BUTTON_LEVER_ENCLOSURE_Z_CLEARANCE
);

module button_lever(
    screw_mount_position,
    battery_position,
    battery_clearance = .4,
    exposure_position,
    exposure_dimensions,
    control_clearance,
    arm_height,
    fillet,
    tolerance = 0,
    mount_diameter = BUTTON_LEVER_MOUNT_DIAMETER,
    actuator_mount_z,
    actuator_diameter = BUTTON_LEVER_MOUNT_DIAMETER,
    cantilever_length = 4,
    registration_nub_height = 2,
    registration_nub_diameter = 2.6,
    exposed_height = 0,
    chamfer = 0,
    fulcrum_width = 4,
    part_separation = $preview ? .1 : 1
) {
    e = .0235;

    width_to_actuator_from_screw =
        battery_position.x - screw_mount_position.x
        - actuator_diameter / 2
        - tolerance - battery_clearance;
    width_to_screw = PCB_XY + PCB_BUTTON_POSITION.x
        - screw_mount_position.x;

    arm_z = get_button_lever_arm_z(arm_height);
    battery_top_z = ENCLOSURE_FLOOR_CEILING + BATTERY_LENGTH; // yep
    height_from_battery = arm_z - battery_top_z;

    max_right_x = ENCLOSURE_DIMENSIONS.x - tolerance * 2
        - ENCLOSURE_WALL;

    brim_xy_coverage = SCOUT_DEFAULT_GUTTER / 2;

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
        module _registration_nub_ring() {
            difference() {
                translate([width_to_actuator_from_screw, 0, -height_from_battery]) {
                    _c(actuator_diameter, height_from_battery + e);
                }

                translate([
                    screw_mount_position.x + width_to_actuator_from_screw,
                    screw_mount_position.y,
                    -height_from_battery - e
                ]) {
                    cylinder(
                        d = registration_nub_diameter + tolerance * 4, // NOTE: intentionally loose
                        h = registration_nub_height + e
                    );
                }
            }
        }

        module _base() {
            brim_right_extension = max_right_x
                - exposure_position.x
                - exposure_dimensions.x
                + control_clearance;

            dimensions = [
                dimensions.x + brim_xy_coverage + brim_right_extension,
                dimensions.y + brim_xy_coverage * 2,
                arm_height
            ];

            hull() {
                translate([width_to_actuator_from_screw, 0, 0]) {
                    _c(actuator_diameter, arm_height);
                }

                translate([
                    exposure_position.x,
                    screw_mount_position.y + actuator_diameter / -2,
                    0
                ]) {
                    cube([
                        e,
                        actuator_diameter,
                        arm_height
                    ]);
                }
            }

            translate([
                exposure_position.x + control_clearance
                    - brim_xy_coverage,
                exposure_position.y + control_clearance
                    - brim_xy_coverage,
                0
            ]) {
                difference() {
                    cube(dimensions);

                    translate([dimensions.x, -e, arm_height]) {
                        rotate([-90, 0, 0]) cylinder(
                            r = ENCLOSURE_INNER_CHAMFER,
                            h = dimensions.y + brim_xy_coverage * 2 + e * 2,
                            $fn = 4
                        );
                    }
                }
            }
        }

        module _fulcrum() {
            translate([
                max_right_x - fulcrum_width,
                exposure_position.y + control_clearance
                        - brim_xy_coverage,
                -height_from_battery
            ]) {
                cube([
                    fulcrum_width,
                    dimensions.y + brim_xy_coverage * 2,
                    height_from_battery + e
                ]);
            }
        }

        module _cap() {
            translate([
                exposure_position.x + control_clearance,
                exposure_position.y + control_clearance,
                e
            ]) {
                rounded_cube([
                    dimensions.x,
                    dimensions.y,
                    dimensions.z - exposed_height + fillet - e
                ], fillet);

                hull() {
                    rounded_cube([
                        dimensions.x / 2 + chamfer,
                        dimensions.y,
                        dimensions.z - exposed_height + fillet - e
                    ], fillet);

                    translate([chamfer, chamfer, dimensions.z - fillet * 2]) {
                        rounded_cube_corners([
                            (dimensions.x - chamfer * 2) / 2,
                            dimensions.y - chamfer * 2
                        ], fillet);
                    }
                }
            }
        }

        _registration_nub_ring();
        _base();
        _fulcrum();
        _cap();
    }

    module _actuator_mount() {
        bottom_height = BUTTON_LEVER_ACTUATOR_MOUNT_BOTTOM_HEIGHT;
        height_above_switch = arm_z - height_from_battery
            - (actuator_mount_z + bottom_height);

        difference() {
            translate([0, 0, bottom_height]) {
                _c(mount_diameter, BUTTON_LEVER_ACTUATOR_CANTILEVER_HEIGHT);

                hull() {
                    _c(cantilever_length, BUTTON_LEVER_ACTUATOR_CANTILEVER_HEIGHT);

                    translate([width_to_actuator_from_screw, 0, 0]) {
                        _c(cantilever_length, BUTTON_LEVER_ACTUATOR_CANTILEVER_HEIGHT);
                    }
                }

                hull() {
                    translate([width_to_screw, 0, 0]) {
                        _c(mount_diameter, height_above_switch + e);
                    }

                    translate([
                        screw_mount_position.x + width_to_actuator_from_screw,
                        screw_mount_position.y,
                        0
                    ]) {
                        cylinder(
                            d = actuator_diameter,
                            h = height_above_switch
                        );
                    }
                }

                translate([
                    screw_mount_position.x + width_to_actuator_from_screw,
                    screw_mount_position.y,
                    height_above_switch - e
                ]) {
                    cylinder(
                        d = registration_nub_diameter - tolerance * 2,
                        h = registration_nub_height + e
                    );
                }
            }

            translate([width_to_screw, 0, 0]) {
                _c(
                    SPST_ACTUATOR_DIAMETER + tolerance * 2,
                    BUTTON_LEVER_ACTUATOR_MOUNT_CAVITY_DEPTH + e,
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