use <MCAD/involute_gears.scad>;
use <../utilities.scad>;

difference(){
	gear(number_of_teeth=16,
		circular_pitch=280,
		gear_thickness = 3,
		rim_thickness = 3,
		hub_thickness = 5.2,
		hub_diameter = 8,
		bore_diameter = 1
	);
	nut(3,shaft=true,fudge=1.25,h=4.5*2,center=true);
}

translate([0,20,0]) translate([-15,10,0]) rotate([0,0,19])
difference(){
	gear(number_of_teeth=7,
		circular_pitch=280,
		gear_thickness = 3,
		rim_thickness = 3,
		hub_thickness = 5.2,
		hub_diameter = 8,
		bore_diameter = 1
	);
	nut(3,shaft=true,fudge=1.25,h=4.5*2,center=true);
}
//translate([0,0,-10]) cylinder(h=1,r=14,$fn=20);

//base is 3.3mm thick, need to clear 6mm bars: step is 2.7mm
//2 washers, 0.5mm each, so make the step 2.2mm high and we should clear it ok...