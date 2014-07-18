use <../utilities.scad>;

//clip for the raspberry pi (flexure legs are h long)
//the board is held horizontally, in the XY plane, centred on the origin
module picam_clip(h=10,depth=24,center=false){
	shift = !center ? [0,-depth/2,0] : [0,0,0]; //is the ternary operator backwards??!!
	translate(shift) reflect([1,0,0]){
		rotate([90,0,0]) linear_extrude(depth,center=true){ //clip for PCB, 24 is the size of the PCB
			translate([(25+0.5)/2,0]) difference(){ //board is 25mm wide, and the slot profile squeezes this by about 0.5mm each side.  We make it slightly too tight to grip the board firmly.
				union(){
					square([4,4],center=true); 			//board will slot in here
					translate([1,-h/2]) 
								square([2,h],center=true);	//connect to base
				}
				rotate(135) square([10,10]);
			}
		}
	}
}

picam_clip(center=true);