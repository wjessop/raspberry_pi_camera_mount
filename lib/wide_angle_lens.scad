module wide_angle_lens() {
	cylinder(h = 4, r = 7.5, center = false, $fn = 100);
	translate([0, 0, 4]) cylinder(h = 5.6, r1 = 7.5, r2 = 12, center = false, $fn = 100);
	translate([0, 0, 9.6]) cylinder(h = 4, r = 12.5, center = false, $fn = 100);
}
