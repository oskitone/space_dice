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
BUTTON_LEVER_ACTUATOR_CANTILEVER_HEIGHT = .8;
BUTTON_LEVER_ACTUATOR_MOUNT_HEIGHT =
    SPST_BASE_DIMENSIONS.z + SPST_CONSERVATIVE_TRAVEL
    + BUTTON_LEVER_ACTUATOR_CANTILEVER_HEIGHT;
BUTTON_LEVER_ARM_BRIM = SCOUT_DEFAULT_GUTTER / 2;
BUTTON_LEVER_ENCLOSURE_WALL_CAVITY_DEPTH = 1;

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
    mount_height = BUTTON_LEVER_ACTUATOR_MOUNT_HEIGHT,
    actuator_mount_z,
    actuator_diameter = BUTTON_LEVER_MOUNT_DIAMETER / 2,
    cantilever_length = 4,
    cantilever_height = BUTTON_LEVER_ACTUATOR_CANTILEVER_HEIGHT,
    exposed_height = 0,
    chamfer = 0,
    part_separation = $preview ? .1 : 1
) {
    e = .0235;

    width_to_actuator_from_screw =
        battery_position.x - screw_mount_position.x
        - tolerance - battery_clearance;
    width_to_screw = PCB_XY + PCB_BUTTON_POSITION.x
        - screw_mount_position.x;

    arm_z = get_button_lever_arm_z(arm_height);
    cantilever_z = actuator_mount_z + mount_height - cantilever_height;

    max_right_x = ENCLOSURE_DIMENSIONS.x - tolerance * 2 - ENCLOSURE_WALL
        + BUTTON_LEVER_ENCLOSURE_WALL_CAVITY_DEPTH;

    dimensions = get_button_lever_dimensions(
        exposure_dimensions = exposure_dimensions,
        control_clearance = control_clearance,
        arm_height = arm_height,
        exposed_height = exposed_height
    );

    brim_right_extension = max_right_x
        - exposure_position.x - exposure_dimensions.x
        + control_clearance;

    base_dimensions = get_button_lever_base_dimensions(
        dimensions,
        brim_right_extension,
        arm_height
    );
    base_position = [
        exposure_position.x + control_clearance - BUTTON_LEVER_ARM_BRIM,
        exposure_position.y + control_clearance - BUTTON_LEVER_ARM_BRIM,
        0
    ];

    module _arm_and_cap() {
        module _base() {
            hull() {
                translate([
                    width_to_actuator_from_screw + screw_mount_position.x,
                    screw_mount_position.y,
                    0
                ]) {
                    cylinder(
                        d = actuator_diameter,
                        h = arm_height
                    );
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

            translate(base_position) {
                difference() {
                    cube(base_dimensions);

                    translate([base_dimensions.x, -e, arm_height]) {
                        rotate([-90, 0, 0]) cylinder(
                            r = ENCLOSURE_INNER_CHAMFER,
                            h = base_dimensions.y + BUTTON_LEVER_ARM_BRIM * 2 + e * 2,
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


    module _actuator_mount(cavity_chamfer = .4) {
        actuator_cavity_diameter = SPST_ACTUATOR_DIAMETER
            + (tolerance + control_clearance) * 2;
        height_below_cantilever = cantilever_z - actuator_mount_z;

        module _mount() {
            translate([screw_mount_position.x, screw_mount_position.y, 0]) {
                difference() {
                    rounded_cube(
                        [mount_diameter, mount_diameter, mount_height],
                        radius = fillet,
                        center = true
                    );

                    translate([0, 0, -e]) {
                        cylinder(
                            d = SCREW_DIAMETER + tolerance * 2,
                            h = mount_height + e * 2
                        );
                    }
                }
            }
        }

        module _cantilever() {
            hull() {
                for (x = [
                    mount_diameter / 2 - fillet - e,
                    width_to_screw - mount_diameter / 2 + fillet + e
                ]) {
                    translate([
                        screw_mount_position.x + x,
                        screw_mount_position.y - cantilever_length / 2,
                        height_below_cantilever
                    ]) {
                        cube([e, cantilever_length, cantilever_height]);
                    }
                }
            }
        }

        module _top() {
            module _arm_deobstruction() {
                z = arm_z - actuator_mount_z;

                translate([
                    screw_mount_position.x + width_to_actuator_from_screw,
                    screw_mount_position.y,
                    z
                ]) {
                    cylinder(
                        d = actuator_diameter + (control_clearance + tolerance) * 2,
                        h = arm_height + e
                    );
                }

                translate([
                    base_position.x - (control_clearance + tolerance),
                    screw_mount_position.y - mount_diameter / 2 - e,
                    z
                ]) {
                    cube([
                        100,
                        mount_diameter + e * 2,
                        arm_height + e
                    ]);
                }
            }

            module _spst_registration() {
                translate([
                    screw_mount_position.x + width_to_screw,
                    screw_mount_position.y,
                    height_below_cantilever - e
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

            difference() {
                hull() {
                    for (x = [
                        width_to_screw - mount_diameter / 2 + fillet,
                        width_to_actuator_from_screw - fillet
                    ]) {
                        translate([
                            screw_mount_position.x + x,
                            screw_mount_position.y,
                            height_below_cantilever
                        ]) {
                            rounded_cube(
                                [
                                    fillet * 2,
                                    mount_diameter,
                                    arm_z + arm_height - cantilever_z
                                ],
                                radius = fillet,
                                center = true
                            );
                        }
                    }
                }

                _arm_deobstruction();
                _spst_registration();
            }
        }

        _mount();
        _cantilever();
        _top();
    }

    translate([0, 0, arm_z + part_separation * 0]) {
        _arm_and_cap();
    }

    translate([0, 0, actuator_mount_z + part_separation * -1]) {
        _actuator_mount();
    }
}