use <../utilities.scad>
d=0.05; //a small displacement, used to ensure unions work neatly without seams

xyflex_l=2.5;
xyflex_t=1.0;
xystrut_t=3;

//make a flexure link, i.e. a rigid strut with two thin bits at the end that join neatly onto things
module flexure_link0(length=10,	//length of the link (i.e. surface-to-surface spacing - it includes the strut and the flexures)
							width=1,			//size of the link along the axis of the flexure
							thickness=3,	//thickness of the rigid part
							flex_length=xyflex_l, //length of the bendy part
							flex_thickness=xyflex_t //thickness of the bendy part
							) union(){
	reflect([1,0,0]){
		translate([length/2 - flex_length - thickness/2,0,0])
			cylinder(r=thickness/2,h=width,center=true,$fn=12);
		translate([length/2 - flex_length/2,0,0])
			cube([flex_length+2*flex_thickness,flex_thickness,width],center=true);
	}
	cube([length - flex_length*2 - thickness,thickness,width],center=true);
}

//make a flexure link, i.e. a rigid strut with two thin bits at the end that join neatly onto things
module flexure_link(length=10,	//length of the link (i.e. surface-to-surface spacing - it includes the strut and the flexures)
							width=10,			//size of the link along the axis of the flexure
							thickness=3,	//thickness of the rigid part
							flex_length=xyflex_l, //length of the bendy part
							flex_thickness=xyflex_t, //thickness of the bendy part
							cutout_width=0 //cut out the middle part of the bendy bit for lower stiffness
							) union(){
	hull() reflect([1,0,0])reflect([0,0,1]){ //make the strut, with nice rounded edges and corners
		translate([length/2 - flex_length - thickness/2,0,width/2-thickness/2])
			sphere(r=thickness/2,$fn=8);
	}
//	reflect([1,0,0]) translate([length/2 - flex_length - thickness/2,-flex_thickness/2,-width/2]) //add the bendy bits
//			cube([flex_length+thickness/2+flex_thickness,flex_thickness,width]);
	difference(){
		cube([length+2*flex_thickness,flex_thickness,width],center=true);
		if(cutout_width>0) cube([999999,999999,cutout_width],center=true);
	}
}

flexure_link();