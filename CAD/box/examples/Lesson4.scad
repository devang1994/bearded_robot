difference() {
  intersection() {
    translate([0,-25,0]) sphere(25);
    translate([-20,-45,-20]) cube(40);
  }
  union() {
    translate([0,-25,-25]) cylinder(50,12,12);
    rotate([90,0,0]) cylinder(50,12,12);
    translate([-25,-25,0]) rotate([0,90,0]) cylinder(50,12,12);
  }
}