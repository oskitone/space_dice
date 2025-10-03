include <../../parts_cafe/openscad/nuts_and_bolts.scad>;
include <../../parts_cafe/openscad/spst.scad>;

include <enclosure.scad>;

function get_button_lever_cap_z(button_cap_brim_height) = (
    ENCLOSURE_DIMENSIONS.z - ENCLOSURE_FLOOR_CEILING
        - button_cap_brim_height - SCREW_HEAD_HEIGHT
);

module button_lever(
    screw_mount_position,
    button_cap_exposure_position,
    button_cap_exposure_dimensions,
    control_clearance,
    button_cap_brim_height,
    button_cap_brim_xy_coverage = SCOUT_DEFAULT_GUTTER,
    fillet,
    tolerance = 0,
    mount_diameter = SPST_BASE_DIMENSIONS.x,
    mount_z,
    part_separation = $preview ? 0 : 1
) {
    e = .0235;

    mount_height = SPST_ACTUATOR_HEIGHT_OFF_PCB;

    actuator_z = mount_z + mount_height;
    cap_z = get_button_lever_cap_z(button_cap_brim_height);
    actuator_height = cap_z - actuator_z;

    button_cap_dimensions = [
        button_cap_exposure_dimensions.x - control_clearance * 2,
        button_cap_exposure_dimensions.y - control_clearance * 2,
        8 // TODO: refine against switches and knobs
    ];

    echo(cap_z, ENCLOSURE_DIMENSIONS.z, button_cap_dimensions.z);

    contact_dimensions = [
        button_cap_dimensions.x - 5, // OUTER_GUTTER
        button_cap_dimensions.y - 5, // OUTER_GUTTER
        ENCLOSURE_DIMENSIONS.z - cap_z - ENCLOSURE_FLOOR_CEILING
    ];

    width_to_mount_center = button_cap_exposure_position.x - screw_mount_position.x;

    translate([
        button_cap_exposure_position.x + control_clearance,
        button_cap_exposure_position.y + control_clearance,
        cap_z + part_separation * 2
    ]) {
        cap_blank(
            dimensions = button_cap_dimensions,
            contact_dimensions = contact_dimensions,
            fillet = fillet,
            brim_dimensions = [
                button_cap_dimensions.x + button_cap_brim_xy_coverage,
                button_cap_dimensions.y + button_cap_brim_xy_coverage,
                button_cap_brim_height
            ]
        );
    }
    
    // TODO: DRY
    difference() {
        union() {
            translate([
                button_cap_exposure_position.x,
                screw_mount_position.y - mount_diameter / 2,
                cap_z + part_separation * 2
            ]) {
                translate([-width_to_mount_center, 0, 0]) {
                    cube([
                        width_to_mount_center,
                        mount_diameter,
                        button_cap_brim_height
                    ]);
                }
            }

            translate([
                screw_mount_position.x,
                screw_mount_position.y,
                cap_z + part_separation * 2
            ]) {
                cylinder(
                    d = mount_diameter,
                    h = button_cap_brim_height
                );
            }

            translate([
                screw_mount_position.x,
                screw_mount_position.y,
                actuator_z + part_separation * 1
            ]) {
                cylinder(
                    d = mount_diameter,
                    h = actuator_height
                );
            }

            translate([
                screw_mount_position.x + 8.4, // TODO: derive
                screw_mount_position.y,
                actuator_z + part_separation * 1
            ]) {
                cylinder(
                    d = mount_diameter,
                    h = actuator_height
                );
            }

            hull() {
                translate([
                    screw_mount_position.x,
                    screw_mount_position.y,
                    actuator_z + part_separation * 1
                ]) {
                    cylinder(
                        d = mount_diameter,
                        h = button_cap_brim_height
                    );
                }

                translate([
                    screw_mount_position.x + 8.4, // TODO: derive
                    screw_mount_position.y,
                    actuator_z + part_separation * 1
                ]) {
                    cylinder(
                        d = mount_diameter,
                        h = button_cap_brim_height
                    );
                }
            }

            translate([
                screw_mount_position.x,
                screw_mount_position.y,
                mount_z
            ]) {
                cylinder(
                    d = mount_diameter,
                    h = mount_height
                );
            }
        }

        translate([
            screw_mount_position.x,
            screw_mount_position.y,
            -e
        ]) {
            cylinder(
                d = SCREW_DIAMETER + tolerance * 2,
                h = 100
            );
        }
    }
}