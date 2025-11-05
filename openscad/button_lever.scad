include <../../parts_cafe/openscad/battery-9v.scad>;
include <../../parts_cafe/openscad/chamfered_cube.scad>;
include <../../parts_cafe/openscad/chamfered_xy_cube.scad>;
include <../../parts_cafe/openscad/nuts_and_bolts.scad>;
include <../../parts_cafe/openscad/spst.scad>;

include <enclosure.scad>;
include <pcb.scad>;

BUTTON_LEVER_MOUNT_DIAMETER = 7; // NOTE: eyeballed against PCB components
BUTTON_LEVER_ENCLOSURE_Z_CLEARANCE = .4;
BUTTON_LEVER_SPST_ACTUATOR_CLEARANCE = .4;
BUTTON_LEVER_ACTUATOR_MOUNT_CAVITY_DEPTH =
    SPST_ACTUATOR_HEIGHT + BUTTON_LEVER_SPST_ACTUATOR_CLEARANCE
    - SPST_CONSERVATIVE_TRAVEL;
BUTTON_LEVER_ACTUATOR_MOUNT_BOTTOM_HEIGHT = SPST_ACTUATOR_HEIGHT_OFF_PCB
    + BUTTON_LEVER_SPST_ACTUATOR_CLEARANCE - BUTTON_LEVER_ACTUATOR_MOUNT_CAVITY_DEPTH;
BUTTON_LEVER_ACTUATOR_CANTILEVER_HEIGHT = .8;
BUTTON_LEVER_ARM_BRIM = SCOUT_DEFAULT_GUTTER / 2;

function get_button_lever_arm_z(arm_height) = (
    ENCLOSURE_DIMENSIONS.z - ENCLOSURE_FLOOR_CEILING
        - arm_height
        - BUTTON_LEVER_ENCLOSURE_Z_CLEARANCE
);

function get_button_lever_dimensions(
    exposure_dimensions = [0,0],
    control_clearance = 0,
    arm_height = 0,
    exposed_height = 0
) = [
    exposure_dimensions.x - control_clearance * 2,
    exposure_dimensions.y - control_clearance * 2,
    ENCLOSURE_DIMENSIONS.z - get_button_lever_arm_z(arm_height) + exposed_height
];

function get_button_lever_base_dimensions(
    lever_dimensions = [0,0,0],
    brim_right_extension = 0,
    arm_height = 0
) = [
    lever_dimensions.x + BUTTON_LEVER_ARM_BRIM + brim_right_extension,
    lever_dimensions.y + BUTTON_LEVER_ARM_BRIM * 2,
    arm_height
];

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
    actuator_diameter = BUTTON_LEVER_MOUNT_DIAMETER / 2,
    cantilever_length = 4,
    exposed_height = 0,
    chamfer = 0,
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

    max_right_x = ENCLOSURE_DIMENSIONS.x - tolerance * 2
        - ENCLOSURE_WALL;

    dimensions = get_button_lever_dimensions(
        exposure_dimensions = exposure_dimensions,
        control_clearance = control_clearance,
        arm_height = arm_height,
        exposed_height = exposed_height
    );

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
        module _base() {
            brim_right_extension = max_right_x
                - exposure_position.x
                - exposure_dimensions.x
                + control_clearance;

            dimensions = get_button_lever_base_dimensions(
                dimensions,
                brim_right_extension,
                arm_height
            );

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
                    - BUTTON_LEVER_ARM_BRIM,
                exposure_position.y + control_clearance
                    - BUTTON_LEVER_ARM_BRIM,
                0
            ]) {
                difference() {
                    cube(dimensions);

                    translate([dimensions.x, -e, arm_height]) {
                        rotate([-90, 0, 0]) cylinder(
                            r = ENCLOSURE_INNER_CHAMFER,
                            h = dimensions.y + BUTTON_LEVER_ARM_BRIM * 2 + e * 2,
                            $fn = 4
                        );
                    }
                }
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

        _base();
        _cap();
    }

    spacer_height = BUTTON_LEVER_ACTUATOR_MOUNT_BOTTOM_HEIGHT;

    module _actuator_top(cavity_chamfer = .4) {
        height_above_switch = arm_z - (actuator_mount_z + spacer_height);
        actuator_cavity_diameter = SPST_ACTUATOR_DIAMETER
            + (tolerance + control_clearance) * 2;

        difference() {
            translate([0, 0, spacer_height]) {
                _c(mount_diameter, BUTTON_LEVER_ACTUATOR_CANTILEVER_HEIGHT);

                hull() {
                    _c(cantilever_length, BUTTON_LEVER_ACTUATOR_CANTILEVER_HEIGHT);

                    translate([width_to_screw, 0, 0]) {
                        _c(cantilever_length, BUTTON_LEVER_ACTUATOR_CANTILEVER_HEIGHT);
                    }
                }

                hull() {
                    translate([width_to_screw, 0, 0]) {
                        _c(mount_diameter, height_above_switch + arm_height);
                    }

                    translate([
                        screw_mount_position.x + width_to_actuator_from_screw - e,
                        screw_mount_position.y - actuator_diameter / 2,
                        0
                    ]) {
                        cube([e, actuator_diameter, height_above_switch + arm_height]);
                    }
                }
            }

            translate([
                screw_mount_position.x + width_to_actuator_from_screw,
                screw_mount_position.y,
                spacer_height + height_above_switch
            ]) {
                cylinder(
                    d = actuator_diameter + control_clearance * 2,
                    h = arm_height + e
                );
            }

            translate([
                screw_mount_position.x + width_to_screw,
                screw_mount_position.y,
                spacer_height - e
            ]) {
                cylinder(
                    d = actuator_cavity_diameter,
                    h = BUTTON_LEVER_ACTUATOR_MOUNT_CAVITY_DEPTH + e
                );

                cylinder(
                    d1 = actuator_cavity_diameter + cavity_chamfer * 2,
                    d2 = actuator_cavity_diameter,
                    h = cavity_chamfer + e
                );
            }
        }
    }

    module _spacer() {
        _c(mount_diameter, spacer_height + e);
    }

    difference() {
        union() {
            translate([0, 0, arm_z + part_separation * 0]) {
                _arm();
            }

            translate([0, 0, actuator_mount_z + part_separation * -1]) {
                _actuator_top();
            }

            translate([0, 0, actuator_mount_z + part_separation * -2]) {
                _spacer();
            }
        }

        _c(SCREW_DIAMETER + tolerance * 2, 100, -e);
    }
}