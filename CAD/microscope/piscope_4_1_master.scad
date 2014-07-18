use <../utilities.scad>;
use <./vertical_flexure.scad>;
use <./focus_flexure_and_pillar.scad>;
use <./picam_clip.scad>;
use <./flexures.scad>;
use <./x_flexure.scad>;



sample_h=50;			//height of the top of the structure (pillar and objective carriage)
board_h=10;
width=50;  //width of microscope
depth=40;

stage_w=60;
stage_d=depth;
stage_t=3;

									//thickness and position of main support pillar
pillar_innerx = stage_w/2 + 6;
pillar_d = depth/2+8     //depth of support illlar

xyflex_l=3;
xyflex_t=1.0;
zflex_l=2;
zflex_t=0.5;

leg_t=6;
leg_x=(stage_w-leg_t)/2;
leg_y=(stage_d-leg_t)/2;

rollbar_h1=3;
rollbar_h2=5;
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
	translate([0,0,-2]) cube([width*2,depth,4],center=true); //base

	//sample stage
	translate([0,0,sample_h-stage_t/2]) difference(){
		union() assign(rw=stage_w - 3*leg_t){
			cube([stage_w,stage_d,stage_t],center=true); //sample stage
			reflect([1,0,0]) translate([-rw/2,0,-3]) cube([2,stage_d,6],center=true); //reinforcement (mostly for during print)
			reflect([0,1,0]) translate([0,-stage_d/2+1,-3]) cube([rw,2,6],center=true); //reinforcement (mostly for during print)
		}
		assign(hole_w=19,hole_d=19)difference(){
			cube([hole_w+stage_t,hole_d+stage_t, stage_t+2*d],center=true);			//through-hole for objective with bevelled edges
			reflect([1,0,0]) translate([-(hole_w+stage_t+d)/2,0,0]) rotate([90,0,0]) cylinder(r=stage_t/2+d,h=999,center=true);
			reflect([0,1,0]) translate([0,-(hole_d+stage_t+d)/2,0]) rotate([0,90,0]) cylinder(r=stage_t/2+d,h=999,center=true);
		}
	}

	translate([0,32/2,board_h]) picam_clip(board_h,depth=depth/2+32/2); //camera clip

	//X flexures and roll bars
	translate(pivot) reflect([0,0,1]) translate(-pivot){ //reflect about the centre, vertically
		reflect([1,0,0]) union() reflect([0,1,0]) translate([-leg_x,0,0]) {									//also reflect horizontally in X,Y
			translate([0,0,xyflex_l+rollbar_h1]) rotate([-90,0,90]) linear_extrude(leg_t,center=true) polygon( //the roll bars
					[[-d,0],[stage_d/2,0],[stage_d/2,rollbar_h1],[stage_d/2-leg_t,rollbar_h1],
					[stage_d/2-leg_t-(rollbar_h2-rollbar_h1)*2,rollbar_h2],[-d,rollbar_h2]]);
			translate([0,leg_y,xyflex_l/2]) cube([xyflex_t,leg_t,xyflex_l+2*d],center=true);			//the flexures
		}
	}
	//Y flexures and legs
	reflect([1,0,0]) union() reflect([0,1,0]) translate([-leg_x,-leg_y,0])	leg();						//make four legs at the corners
	reflect([1,0,0]) translate([-leg_x,0,pivot[2]]){																	//support for top flexures
		assign(sh=leg_h-3,si=10) assign(n=ceil(sh/si)+1) repeat([0,0,sh/(n-1)],n,center=true) cube([leg_t,stage_d-2*leg_t+2*d,1],center=true);
	}
	//X actuator
//	assign(rollbar_h1=2) reflect([0,1,0]) {
//		translate([-stage_w/2-d,0,xyflex_l]) rotate([90,0,-90]) linear_extrude(40,center=false) polygon( //the roll bars
//					[[-d,0],[stage_d/2,0],[stage_d/2,rollbar_h1],[12,rollbar_h1],
//					[5,rollbar_h2],[-d,rollbar_h2]]);
//	}
	//Y actuating arms
	reflect([1,0,0]) translate([-stage_w/2+leg_t,-stage_d/2,0]) sequential_hull(){
		translate([-d,0,xyflex_l+zflex_l+rollbar_h1+leg_t/2]) cube([4+d,leg_t,12]);
		translate([1,0,xyflex_l+zflex_l+rollbar_h1+leg_t/2]) cube([3,2,12]);
		translate([1,stage_w/2+5,xyflex_l+zflex_l+rollbar_h1+leg_t/2]) cube([3,2,8]);
		translate([1,stage_d-5,5]) cube([2,10,8]);
	}
	translate([0,stage_d/2,5+3/2]) rotate([90,0,0]) flexure_link(length=stage_w-2*leg_t-4*2,width=10);

	//Z support pillar
	translate([pillar_innerx, -depth/2, 0]) sequential_hull(){
		cube([
		
}












































