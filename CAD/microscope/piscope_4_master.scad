use <../utilities.scad>;
use <./vertical_flexure.scad>;
use <./focus_flexure_and_pillar.scad>;
use <./picam_clip.scad>;
use <./flexures.scad>;
use <./x_flexure.scad>;



sample_h=50;			//height of the top of the structure (pillar and objective carriage)
p_dx = 2.5;					//thickness and position of main support pillar
pillar_innerx = 30;
pillar_x = pillar_innerx + p_dx;
pillar_outerx = pillar_x + p_dx;
width=60;  //width of microscope
xyflex_l=3;
xyflex_t=1.0;
zflex_l=2;
zflex_t=0.5;

stage_w=width;
leg_t=6;
leg_x=(width-leg_t)/2;
rollbar_h1=3;
rollbar_h2=6;
stage_t=4;
leg_h=sample_h - stage_t - 2*rollbar_h1 - 2*xyflex_l - 2*zflex_l;
reduction_xy=0.6;
pivot=[0,0,(sample_h-stage_t)/2];
strut_t=3;

d=0.05;
$fn=32;


//		translate([pillar_x,0,base_h+x_strut_l/2]) rotate([0,-90,0]) nut(3,h=99,fudge=1.22,shaft=true);
//rotate([90,0,0])

module leg(){
	union() translate(pivot) reflect([0,0,1]){
		rotate([-90,0,-90]) linear_extrude(leg_t,center=true) polygon(
			[[-leg_t/2,-d],[-leg_t/2,leg_h/2],[leg_t/2,leg_h/2-leg_t/2],[leg_t/2,-d]]);
		translate([0,leg_t/2-zflex_t/2,leg_h/2+zflex_l/2]) cube([leg_t,zflex_t,2*zflex_l+2*d],center=true);
	}
}

union(){
	//base of the whole structure
	translate([0,0,-2]) cube([width*2,width,4],center=true); //base
	translate([0,0,sample_h-stage_t/2]) cube([stage_w,stage_w,stage_t],center=true); //base

	translate([0,32/2,10]) picam_clip(10,depth=width/2+32/2);

	//X flexures and roll bars
	translate(pivot) reflect([0,0,1]) translate(-pivot){ //reflect about the centre, vertically
		reflect([1,0,0]) union() reflect([0,1,0]) translate([-leg_x,0,0]) {									//also reflect horizontally in X,Y
			translate([0,0,xyflex_l]) rotate([90,0,90]) linear_extrude(leg_t,center=true) polygon( //the roll bars
					[[-d,0],[stage_w/2,0],[stage_w/2,rollbar_h1],[stage_w/2-leg_t,rollbar_h1],
					[stage_w/2-leg_t-(rollbar_h2-rollbar_h1)*2,rollbar_h2],[-d,rollbar_h2]]);
			translate([0,leg_x,xyflex_l/2]) cube([xyflex_t,leg_t,xyflex_l+2*d],center=true);			//the flexures
		}
	}
	//X actuator
	assign(rollbar_h1=2) reflect([0,1,0]) {
		translate([-stage_w/2-d,0,xyflex_l]) rotate([90,0,-90]) linear_extrude(40,center=false) polygon( //the roll bars
					[[-d,0],[stage_w/2,0],[stage_w/2,rollbar_h1],[12,rollbar_h1],
					[5,rollbar_h2],[-d,rollbar_h2]]);
	}
	


	//Y flexures and legs
	reflect([1,0,0]) union() reflect([0,1,0]) translate([-leg_x,-leg_x,0])	leg();						//make four legs at the corners
													
	reflect([1,0,0]) translate([-leg_x,0,pivot[2]]){																	//support for top flexures
		assign(n=ceil((leg_h-1)/10)+1) repeat([0,0,(leg_h-1)/n],n,center=true) cube([leg_t,stage_w-leg_t+2*d,1],center=true);
	}
	//actuating arms
	reflect([1,0,0]) sequential_hull(){
		translate([-stage_w/2+leg_t-d,-stage_w/2,xyflex_l+zflex_l+rollbar_h1+leg_t/2]){
			cube([4+d,leg_t,12]);
			translate([2,0,0]) cube([2,2,12]);
		}
		translate([-stage_w/2+leg_t+2,stage_w/2-5,5]) cube([2,10,8]);
	}
	translate([0,stage_w/2,5+3/2]) rotate([90,0,0]) flexure_link(length=stage_w-2*leg_t-4*2,width=10);
		
}












































