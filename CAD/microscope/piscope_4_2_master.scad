use <../utilities.scad>;
use <./vertical_flexure.scad>;
use <./focus_flexure_and_pillar.scad>;
use <./picam_clip.scad>;
use <./flexures.scad>;
use <./x_flexure.scad>;



sample_h=50;			//height of the top of the structure (pillar and objective carriage)
board_h=10;			//height of the camera board
//width=50;  			//width of microscope
depth=40;				//depth of microscope

stage_w=55;			//size of sample stage
stage_d=depth;
stage_t=3;

xyflex_l=3;			//length and thickness of bendy-bits
xyflex_t=1.0;
zflex_l=2;
zflex_t=0.5;

leg_t=6;					//thickness of legs
rollbar_h1=3;			//thickness of the ends of the rollbar (connects legs together at top/bottom)
rollbar_h2=5;			//thickness of middle of rollbar

focus_d = 16; //depth of objective carriage
focus_strut_l = 20; //length of focus struts
focus_strut_dz = 9; //separation of focus struts
focus_strut_t = 3;
objective_r = 5; //radius of "objective"

									//thickness and position of main support pillar
pillar_innerx = stage_w/2 + 10;
pillar_outerx = pillar_innerx+10;
pillar_d = depth/2+focus_d/2;     //depth of support pilllar

leg_h=sample_h - stage_t - 2*rollbar_h1 - 2*xyflex_l - 2*zflex_l;
leg_x=(stage_w-leg_t)/2;
leg_y=(stage_d-leg_t)/2;
pivot=[0,0,(sample_h-stage_t)/2];

leg_top = pivot[2] + leg_h/2;
leg_bottom = pivot[2] - leg_h/2;

reduction_xy=0.6;
strut_t=3;


d=0.05;
$fn=32;


//		translate([pillar_x,0,base_h+x_strut_l/2]) rotate([0,-90,0]) nut(3,h=99,fudge=1.22,shaft=true);

module leg(){
	union() translate(pivot) reflect([0,0,1]){
		rotate([-90,0,-90]) linear_extrude(leg_t,center=true) polygon(
			[[-leg_t/2,-d],[-leg_t/2,leg_h/2],[leg_t/2,leg_h/2-leg_t/2],[leg_t/2,-d]]);
		translate([0,leg_t/2-zflex_t/2,leg_h/2+zflex_l/2]) cube([leg_t,zflex_t,2*zflex_l+2*d],center=true);
	}
}

module focus_nut(){
	translate([pillar_innerx-4,0,xyflex_l + rollbar_h1 + 3]) rotate([0,-90,0]) nut(3,h=10,fudge=1.22,shaft=true);
}
module x_nut(){
	union(){
		translate([pillar_outerx+12,0,5]) nut(3,h=10,fudge=1.05,shaft=true);
		translate([pillar_outerx+12,0,-10-1.5]) nut(3,h=10,fudge=1.15,shaft=true);
	}
}
module y_nut(){
	union(){
		translate([0,depth/2+5,6.5]) nut(3,h=10,fudge=1.05,shaft=true);
		translate([0,depth/2+5,-10-1.5]) nut(3,h=10,fudge=1.15,shaft=true);
	}
}
	

rotate([90,0,0])
union(){
	difference(){
		union(){
			//base of the whole structure
			translate([0,0,-2]) cube([pillar_outerx*2,depth,4],center=true); //base
			//reinforcement for base
			reflect([0,1,0]) translate([0,-depth/2,0]) mirror([0,0,1]){	//supports along long edges
				sequential_hull(){
					translate([pillar_outerx+7,0,0]) cube([10,3,1]);
					translate([pillar_outerx,0,0]) cube([d,3,10]);
					translate([pillar_outerx-5,0,0]) cube([d,3,10]);
					translate([pillar_outerx-5-4,0,0]) cube([d,3,6]);
					translate([-pillar_outerx+5+4,0,0]) cube([d,3,6]);
					translate([-pillar_outerx,0,0]) cube([5,3,10]);
				}
				reflect([1,0,0]) translate([-pillar_outerx,0,0]) sequential_hull(){ //short edges
					cube([5,3,10]);
					cube([5,10,6]);
					cube([5,depth/2+d,6]);
				}
			}
			reflect([1,0,0]) translate([-15,-depth/2,-6]) cube([3,depth+10,6]); //reinforcing bars under Y actuator
			translate([0,depth/2,-1.5]) cube([30,20,3],center=true);					//y actuator nut seat
			translate([pillar_outerx+7,-depth/2,-3]) cube([10,depth,3]);				//x actuator nut seat
		}
		y_nut();
		x_nut();
	}

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
	reflect([1,0,0]) translate([leg_x,0,pivot[2]]){																	//support for top flexures
		assign(sh=leg_h-8,si=12) assign(n=ceil(sh/si)+1) repeat([0,0,sh/(n-1)],n,center=true) //cube([leg_t,stage_d-2*leg_t+2*d,1],center=true);
			union() reflect([0,1,0]) linear_extrude(1,center=true) polygon(
				[[-leg_t/2,-d],[-leg_t/2,stage_d/2-leg_t+d],[leg_t/2,stage_d/2-leg_t+d],[-leg_t/2+3,8],[-leg_t/2+3,-d]]);
	}
	//Y actuating arms
	reflect([1,0,0]) translate([-stage_w/2+leg_t,-stage_d/2,0]) sequential_hull(){
		translate([-d,0,xyflex_l+zflex_l+rollbar_h1+leg_t/2]) cube([4+d,leg_t,12]);
		translate([1,0,xyflex_l+zflex_l+rollbar_h1+leg_t/2]) cube([3,2,12]);
		translate([1,stage_w/2+5,5]) cube([3,2,8]);
		translate([1,stage_d+1,5]) cube([2,8,8]);
	}
	difference(){
		translate([0,stage_d/2+5,5+3/2]) rotate([90,0,0]) flexure_link(length=stage_w-2*leg_t-4*2,width=8);
		y_nut();
	}
	reflect([1,0,0]) translate([stage_w/4,depth/2-d,sample_h - 4]) rotate([-90,0,0]) cylinder(r1=2,r2=3,h=3);		//hooks for elastic band

	//X actuating arms
	reflect([0,1,0]) assign(brace_x=pillar_outerx - 3) union(){
		translate([0,-stage_d/2,0]) sequential_hull(){					//horizontal arms
			translate([stage_w/2-d,0,xyflex_l+rollbar_h1-rollbar_h2]) cube([d+0.5,leg_t+6,rollbar_h2]);
			translate([stage_w/2+2,0,xyflex_l+rollbar_h1-rollbar_h2]) cube([d,leg_t,rollbar_h2]);
			translate([brace_x+leg_t,0,4]) union(){
				cube([8,leg_t,xyflex_l+rollbar_h1-4]);
				cube([8,d,xyflex_l+rollbar_h1+leg_t/2-4]);
			}
			translate([pillar_outerx+7,stage_d/2-12,4]) cube([10,2,3]);
		}
		difference(){
			translate([pillar_outerx+7 + 5,0,4+1.5]) cube([10,24+2*d,3],center=true);
			x_nut();
		}
		intersection(){
		hull(){					//braces for arms
				translate([brace_x, stage_d/2-leg_t,xyflex_l+rollbar_h1]) cube([leg_t,leg_t,d]);
				translate([leg_x, leg_y,(brace_x-stage_w/2)+xyflex_l+leg_t]) cube([leg_t,leg_t,2],center=true);
			}
			translate([leg_x,leg_y,0]) scale([999,1,1]) mirror([0,1,0]) leg();
		}
	}
	translate([pillar_outerx+3,0,leg_top]) cube([3,depth,3],center=true);
	translate([pillar_outerx-3,0,leg_top]) cube([12,focus_d,3],center=true);

	//Z support pillar
	difference(){
		translate([pillar_innerx, -depth/2, 0]) sequential_hull(){
			translate([0,0,-d]) cube([10,pillar_d,15]);
			translate([0,0,15-2*d]) cube([10,pillar_d,d]);
			translate([-4,0,leg_top -1 - focus_strut_dz - focus_strut_t/2]) cube([10,pillar_d,25]);
			translate([-4,0,sample_h+25]) cube([4,pillar_d,d]);
			translate([-(pillar_innerx+20)+d,0,sample_h+25]) cube([pillar_innerx+20,pillar_d,4]);
		}
		cylinder(r=5, h=999); //illumination hole
		translate([0,-depth/2-d,d]) hull(){
			cube([pillar_outerx+5,leg_t+3,pivot[2]-leg_h/2]);
			cube([pillar_innerx-5,leg_t+3,pivot[2]]);
		}
		focus_nut();
	}

	//Z flexures
	repeat([0,0,-focus_strut_dz],2) translate([pillar_innerx - 4 - focus_strut_l/2, 0, leg_top -1]) rotate([90,0,0])
				flexure_link(length=focus_strut_l,width=focus_d,cutout_width=focus_d - 6,thickness=focus_strut_t); //flexure struts

	//Z actuating arm
	difference(){
		assign(t=6,w=8) union(){
			sequential_hull(){
				translate([pillar_innerx - 4 - xyflex_l, -t/2, leg_top -1 - focus_strut_dz]) mirror([1,0,0]) cube([7,t,d]);
				translate([pillar_innerx - 3, -t/2, 15]) mirror([1,0,0]) cube([5,t,d]);
				translate([pillar_innerx - 3, -stage_d/2 + leg_t, xyflex_l + rollbar_h1 + 3]) mirror([1,0,0]) cube([4,depth-2*leg_t,2]);
				translate([pillar_innerx - 3, -10/2, 3]) mirror([1,0,0]) cube([2,10,10]);
			//	translate(
			}
			reflect([0,1,0]) translate([pillar_innerx - 3, -stage_d/2, xyflex_l + rollbar_h1 + 3]) mirror([1,0,0]) cube([4,(depth+t)/2,2]);
		}
		focus_nut();
	}

	//////////////  Objective Holder
	assign(w=pillar_innerx - 4 - focus_strut_l, h=focus_strut_dz + focus_strut_t) union(){
		difference(){
			translate([2,-depth/2, leg_top - 1 - h + focus_strut_t/2]) cube([w-2,(depth+focus_d)/2,h]);
			rotate([0,0,45]) cube([2,2,999]*objective_r,center=true);
		}
		translate([0,-objective_r-4, leg_top - 1 - h/2 + focus_strut_t/2]) cube([2*objective_r,1,h],center=true);
		translate([1-objective_r - 3,-depth/2, leg_top - 1 - h + focus_strut_t/2]) cube([3,(depth+focus_d)/2,h]);
	}
}













































