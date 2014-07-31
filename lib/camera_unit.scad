use <wide_angle_lens.scad>;
use <shapes.scad>;

$fn = 180;

// Pi variables
camera_height = 23.9;
camera_width = 25;
lower_clearance = 2.8;
pi_circuit_height = 0.95;
bottom_hole_x = camera_height - 9.35;
top_hole_x = camera_height - 21.85;
left_hole_y = 2;
right_hole_y = camera_width - 2;

mounting_hole_r = 1.1;

cable_mount_edge_distance = 2;
cable_mount_x = 5.6;

cable_z_from_board = 1.27;
cable_width = 16.2;

// Box measurements
side_ledge = 1.5;
top_ledge = 1.3;
wall_width = 3;
box_height = camera_height + wall_width - top_ledge + 1;
box_width = camera_width + (wall_width * 2) - (side_ledge * 2);
box_z = lower_clearance + pi_circuit_height + 1 + wall_width;

module camera() {
	difference() {
		union() {
			// Board
			cube([camera_height, camera_width, pi_circuit_height]);

			// Lens
			translate([camera_height - 5.1 - 8, (camera_width / 2) - 4]) cube([8, 8, 5.2]);

			// Cable mount
			translate([camera_height - cable_mount_x, cable_mount_edge_distance, -lower_clearance]) cube([cable_mount_x, camera_width - (cable_mount_edge_distance * 2), lower_clearance]);			

			// The cable
			translate([camera_height, (camera_width - cable_width) / 2, - cable_z_from_board]) cube([30, cable_width, 0.01]);
		}

		// Mounting holes
		translate([top_hole_x, left_hole_y, -1]) cylinder(h = pi_circuit_height + 3, r = mounting_hole_r, center = true);
		translate([top_hole_x, right_hole_y, -1]) cylinder(h = pi_circuit_height + 3, r = mounting_hole_r, center = true);
		translate([bottom_hole_x, left_hole_y, -1]) cylinder(h = pi_circuit_height + 3, r = mounting_hole_r, center = true);
		translate([bottom_hole_x, right_hole_y, -1]) cylinder(h = pi_circuit_height + 3, r = mounting_hole_r, center = true);
	}
}


module variable_screw_hole(length) {
	translate([0, 0, -1]) {
		cylinder(h = 9, r = 2, center = false);
		cylinder(h = 4, r = 3.1, center = false);
		translate([0, -2, 0]) {
			cube([length, 4, 9]);
			translate([0, -1.1, 0]) cube([length, 6.2, 4]);
		}
			
		translate([length, 0, 0]) {
			cylinder(h = 9, r = 2, center = false);
			cylinder(h = 4, r = 3.1, center = false);
		}
	}
}

module camera_unit_rear() {
	difference() {
		// The outside area box
		union() {
			cube([box_height, box_width, box_z]);
			translate([0, -30, 0]) cube([9, 31, 7]);
			translate([camera_height - 7, -30, 0]) cube([9, 31, 7]);
		}

		// Temporary mounts
		translate([4.5, -25, 7]) {
			rotate([180, 0, 90]) variable_screw_hole(20);	
		}

		translate([camera_height - 7 + 4.5, -25, 7]) {
			rotate([180, 0, 90]) variable_screw_hole(20);
		}

		// Cut out the ledge
		translate([wall_width - top_ledge, wall_width - side_ledge, box_z - pi_circuit_height]) cube([camera_height + 10, camera_width, pi_circuit_height + 1]);

		// Cut out the rest of the inner box
		translate([wall_width, wall_width, wall_width]) cube([camera_height + 10, camera_width - (side_ledge * 2), box_z]);

		// Cut out the hole for the cable
		translate([wall_width, wall_width, wall_width]) cube([camera_height - top_ledge, camera_width - (side_ledge * 2), box_z]);

		// The mounting holes
		translate([wall_width - top_ledge + top_hole_x, wall_width - side_ledge + left_hole_y, -1]) {
			cylinder(h = box_z + 10, r = mounting_hole_r, center = true);
			hexagon(4.2, 6);
		}
		translate([wall_width - top_ledge + bottom_hole_x, wall_width - side_ledge + left_hole_y, -1]) {
			cylinder(h = box_z + 10, r = mounting_hole_r, center = true);
			hexagon(4.2, 6);
		}
		translate([wall_width - top_ledge + top_hole_x, wall_width - side_ledge + right_hole_y, -1]) {
			cylinder(h = box_z + 10, r = mounting_hole_r, center = true);
			hexagon(4.2, 6);
		}
		translate([wall_width - top_ledge + bottom_hole_x, wall_width - side_ledge + right_hole_y, -1]) {
			cylinder(h = box_z + 10, r = mounting_hole_r, center = true);
			hexagon(4.2, 6);
		}
	}
}

front_box_z = 5.2 + wall_width;
lens_centre_x = camera_height - 5.1 - 4;
lens_centre_y = camera_width / 2;

module camera_unit_front() {
	difference() {
		// The start box
		cube([box_height, box_width, front_box_z]);

		translate([wall_width - top_ledge, wall_width - side_ledge, 0]) {
			// Space for the connector on the board at the back
			translate([0, 8, -1]) cube([10.5, camera_width - 16, 4.5]);

			// There's an awkward resistor cluster on the top right (including the LED)
			translate([2, 16.3, -1]) cube([7, 6, 3]);

			// The sensor
			translate([9.5, (camera_width / 2) - 5, -1]) cube([10, 10, 6.5]);

			// Hole for the light
			translate([4.8, camera_width - 4.5, -1]) cylinder(h = front_box_z + wall_width + 10, r = 1.25, center = false);

			// The mounting holes
			translate([top_hole_x, left_hole_y, -1]) {
				cylinder(h = front_box_z + wall_width + 10, r = mounting_hole_r, center = true);
				translate([0, 0, front_box_z]) cylinder(h = 4, r = 2, center = true);
			}
			translate([bottom_hole_x, left_hole_y, -1]) {
				cylinder(h = front_box_z + wall_width + 10, r = mounting_hole_r, center = true);
				translate([0, 0, front_box_z]) cylinder(h = 4, r = 2, center = true);
			}
			translate([top_hole_x, right_hole_y, -1]) {
				cylinder(h = front_box_z + wall_width + 10, r = mounting_hole_r, center = true);
				translate([0, 0, front_box_z]) cylinder(h = 4, r = 2, center = true);
			}
			translate([bottom_hole_x, right_hole_y, -1]) {
				cylinder(h = front_box_z + wall_width + 10, r = mounting_hole_r, center = true);
				translate([0, 0, front_box_z]) cylinder(h = 4, r = 2, center = true);
			}

			// A hole for a lens
			translate([lens_centre_x, lens_centre_y, front_box_z - 1]) cylinder(h = wall_width + 2, r = 7.75, center = true);
		}
	}
}
