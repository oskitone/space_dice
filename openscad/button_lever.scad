include <../../parts_cafe/openscad/nuts_and_bolts.scad>;
include <../../parts_cafe/openscad/spst.scad>;

include <enclosure.scad>;

BUTTON_LEVER_MOUNT_DIAMETER = 7; // NOTE: eyeballed against PCB components
BUTTON_LEVER_ENCLOSURE_Z_CLEARANCE = .2;

function get_button_lever_cap_z(button_cap_brim_height) = (
    ENCLOSURE_DIMENSIONS.z - ENCLOSURE_FLOOR_CEILING
        - button_cap_brim_height
        - BUTTON_LEVER_ENCLOSURE_Z_CLEARANCE
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
    mount_diameter = BUTTON_LEVER_MOUNT_DIAMETER,
    cantilever_height = 1,
    mount_z,
    spst_actuator_cavity_depth = 1,
    spst_clearance = .2,
    part_separation = $preview ? 0 : 1
) {
    e = .0235;

    mount_height = SPST_ACTUATOR_HEIGHT_OFF_PCB
        + spst_clearance - spst_actuator_cavity_depth;
    cantilever_width = 8.45; // TODO: derive

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
        cap_z + part_separation * 1
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
    
    module _c(diameter, height, z) {
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

    module _actuator_ends(height) {
        _c(
            mount_diameter,
            height,
            actuator_z + part_separation * 0
        );

        translate([cantilever_width, 0, 0]) {
            _c(
                mount_diameter,
                height,
                actuator_z + part_separation * 0
            );
        }
    }

    difference() {
        union() {
            translate([
                button_cap_exposure_position.x - width_to_mount_center,
                screw_mount_position.y - mount_diameter / 2,
                cap_z + part_separation * 1
            ]) {
                cube([
                    width_to_mount_center,
                    mount_diameter,
                    button_cap_brim_height
                ]);
            }

            _c(
                mount_diameter,
                button_cap_brim_height,
                cap_z + part_separation * 1
            );

            _actuator_ends(actuator_height);
            hull() _actuator_ends(cantilever_height);

            _c(
                mount_diameter,
                mount_height + e,
                mount_z + part_separation * 0
            );
        }

        _c(
            SCREW_DIAMETER + tolerance * 2,
            100,
            -e
        );

        translate([
            screw_mount_position.x - (mount_diameter / 2 + e),
            screw_mount_position.y - (mount_diameter / 2 + e),
            cap_z + button_cap_brim_height - SCREW_HEAD_HEIGHT + part_separation
        ]) {
            cube([
                cantilever_width + e,
                mount_diameter + e * 2,
                SCREW_HEAD_HEIGHT + e
            ]);
        }

        translate([cantilever_width, 0, 0]) {
            _c(
                SPST_ACTUATOR_DIAMETER + tolerance * 2,
                spst_actuator_cavity_depth + e,
                actuator_z - e + part_separation * 0
            );
        }
    }
}