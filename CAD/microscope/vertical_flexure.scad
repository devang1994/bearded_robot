use <../utilities.scad>;

d=0.05; //a small displacement~!)


module vertical_flexure_actuating_hole(stagew=30){
	//this is a separate module for convenience, so that it's nice and easy to make extra clearance for the actuating bolt.
	translate([0,0,stagew/2]) rotate([0,90,0]) cylinder(r=3/2*1.15,h=999,center=true,$fn=16); //hole for actuating bolt
}
	
module vertical_flexure(h=7, //flexure "height", i.e. size along the axis of the flexure
			stagew=32, //width of stage (along flexure axis)
			stagel=10, //size of stage in other dimension
			y_strut_l=30, //length of flexures (incl. flexy bits)
			y_strut_t=3,  //thickness of strut (normal to axis of flexure)
			zflex_t=0.6, //two layers, I hope!
			zflex_l=1.8,
			zflex_support_t=0.8) union(){

	////////////  Static Base (to which we attach the flexure)
	difference(){
		translate([-2*h,-h/2,0]) cube([2*h,h,stagew]);	//base
		rotate([90,0,0]) linear_extrude(999,center=true) polygon([
			[0,y_strut_t],[-2,stagew/2+5],[0,stagew-y_strut_t]]); //cut-out for the actuating arm to move into
		vertical_flexure_actuating_hole(stagew=stagew); //hole for actuating bolt
	}
	////////////  Flexure Struts
	translate([0,0,stagew/2]) reflect([0,0,1]) translate([0,0,-stagew/2]){
		translate([-d,-h/2,y_strut_t-zflex_t]) cube([y_strut_l+2*d,h,zflex_t]); //bendy bit
		translate([zflex_l,-h/2,0]) cube([y_strut_l-2*zflex_l,h,y_strut_t]);//thick bit
	}
	translate([zflex_l,-h/2+5/2,0]) cube([y_strut_l-2*zflex_l,h-5,y_strut_t+zflex_l-0.5]);//reinforcement on bottom strut

	////////////  Moving Carriage
	translate([y_strut_l,-h/2,0]) cube([y_strut_t,h,stagew]);		//moving carriage (attached to stage)
	translate([y_strut_l,h/2-d,stagew]) rotate([0,90,0]) linear_extrude(y_strut_t)
		difference(){
			polygon([[0,-d],[0,4],[7,4],[22,-d]]);
			translate([2,0]) square([5,2]);
		}

	////////////  Actuating Arm
	translate([zflex_l,0,0]) difference(){   //actuator, with nut cut-out
		rotate([90,0,0]) linear_extrude(h,center=true) 
			polygon([[0,0],[0,stagew/2+5],[2,stagew/2+5],[5,0]]);//actuator arm
		translate([1,0,stagew/2]) rotate([0,90,0]) nut(3,h=99,fudge=1.22,shaft=true); //nut trap
	}
	translate([zflex_l,h/2,stagew]) rotate([0,90,0]) linear_extrude(y_strut_t)
		polygon([[17,-d],[17,0.5],[7,0.5],[7,2],[2,2],[2,1],[0,1],[0,4],[7,4],[17,4],[stagew,-d]]);

	////////////  Support struts for upper arm
	//these don't need to be removed - they should flex with the device but 
	//if they fall off, no biggie!
	difference(){
		translate([zflex_l+y_strut_t+3,0,y_strut_t]) 
			repeat([8,0,0],floor((y_strut_l - 2*zflex_l +2)/8)) 
			rotate([90,0,0]) linear_extrude(h,center=true) polygon([
			[0,-d],[0,stagew-y_strut_t*2+d],[zflex_support_t,stagew-y_strut_t*2+d],
			[zflex_support_t,stagew-y_strut_t*2-3],[2,stagew-y_strut_t*2-7],
			[2,7],[zflex_support_t,2],[zflex_support_t,-d]]);

		//cut-outs in the support to allow clearance for the bolt and extra flex
		translate([0,0,stagew/2]) cube([999,h-4,6],center=true); //bolt clearance
		translate([0,0,y_strut_t+zflex_l/2+0.25+d]) cube([999,h-3,zflex_l+1.0],center=true); //clearance for reinforcement arm, extra flex at bottom
		translate([0,0,stagew-y_strut_t-zflex_l/2-0.5]) cube([999,h-3,zflex_l],center=true); //weaken top flexures to make them more flexible
	}
}


vertical_flexure();





