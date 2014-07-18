//utilities
module reflect(axis){ //reflects its children about the origin, but keeps the originals
	children();
	mirror(axis) children();
}
module repeat(delta,N,center=false){ //repeat something along a regular array
	translate( (center ?  -(N-1)/2 : 0) * delta)
				for(i=[0:1:(N-1)]) translate(i*delta) children();
}

module oldnut(d,h=-1,center=false,fudge=1,shaft=false){ //make a nut, for metric bolt of nominal diameter d
	//d: nominal bolt diameter (e.g. 3 for M3)
	//h: height of nut
	//center: works as for cylinder
	//fudge: multiply the diameter by this number (1.22 works when vertical)
	//shaft: include a long cylinder representing the bolt shaft, diameter=d*1.05
	assign(h=(h<0)?d*0.8:h) union(){
		linear_extrude(h,center=center) for(theta=[0:60:300])
			rotate(theta) polygon([[0,0],[0,1],[sin(60.01),cos(60.01)]]*0.9*d*fudge); 
		if(shaft){
			reflect([0,0,1]) cylinder(r=d/2*1.05*(fudge+1)/2,h=99999999999,$fn=16); 
			//the reason I reflect rather than use center=true is that the latter 
			//fails in fast preview mode (I guess because of the lack of points 
			//inside the nut).  Also, less fudge is applied to the shaft, it can
			//always be fixed with a drill after all...
		}
	}
}
module nut(d,h=-1,center=false,fudge=1,shaft=false){ //make a nut, for metric bolt of nominal diameter d
	//d: nominal bolt diameter (e.g. 3 for M3)
	//h: height of nut
	//center: works as for cylinder
	//fudge: multiply the diameter by this number (1.22 works when vertical)
	//shaft: include a long cylinder representing the bolt shaft, diameter=d*1.05
	assign(h=(h<0)?d*0.8:h) union(){
		cylinder(h=h,center=center,r=0.9*d*fudge,$fn=6); 
		if(shaft){
			reflect([0,0,1]) cylinder(r=d/2*1.05*(fudge+1)/2,h=99999999999,$fn=16); 
			//the reason I reflect rather than use center=true is that the latter 
			//fails in fast preview mode (I guess because of the lack of points 
			//inside the nut).  Also, less fudge is applied to the shaft, it can
			//always be fixed with a drill after all...
		}
	}
}

module unrotate(rotation){
	//undo a previous rotation, NB this is NOT the same as rotate(-rotation) due to ordering.
	rotate([0,0,-rotation[2]]) rotate([0,-rotation[1],0]) rotate([-rotation[0],0,0]) children();
}

module support(size, height, baseheight=0, rotation=[0,0,0], supportangle=45, outline=false){
	//generate "support material" in the STL file for selective supporting of things
	module support_2d() assign(sw=1.0, sp=3){
		union(){
			if(outline){
				difference()	{
					minkowski(){
						children();
						circle(r=sw,$fn=8);
					}
					children();
				}
			}
			intersection(){
				children();
				rotate(supportangle) for(x=[-size:sp:size])
					translate([x,0]) square([sw,2*size],center=true);
			}
		}
	}
	
	unrotate(rotation){
		translate([0,0,baseheight]) linear_extrude(height) support_2d() projection() rotate(rotation) children();
	}
	children();
}

module rightangle_prism(size,center=false){
	intersection(){
		cube(size,center=center);
		rotate([0,45,0]) translate([9999/2,0,0]) cube([1,1,1]*9999,center=true);
	}
}

module sequential_hull(){
	//given a sequence of >2 children, take the convex hull between each pair - a helpful, general extrusion technique.
	for(i=[0:$children-2]){
		hull(){
			children(i);
			children(i+1);
		}
	}
}

module cylinder_with_45deg_top(h,r,center=false,extra_height=0.7,$fn=$fn){
	union(){
		rotate([90,0,0]) hull(){
			cylinder(h=h,r=r,$fn=$fn,center=center);
			translate([0,r-0.001,center?0:h/2]) cube([2*(sqrt(2)-1)*r,0.002,h],center=true);
		}
		rotate([90,0,0]) translate([0,r-0.001,(center?0:h/2)]) cube([2*(sqrt(2)-1)*r,0.002+2*extra_height,h],center=true);
	}
}

cylinder_with_45deg_top(20,10,center=true,$fn=32,extraheight=0.5);

//$fn=12;
//sequential_hull(){
//	translate([0,0,0]) sphere(r=.2);
//	translate([0,1,0]) sphere(r=.2);
//	translate([0,1,1]) sphere(r=.2);
//	translate([1,1,1]) sphere(r=.2);
//}

//nut(3,shaft=true);

//rightangle_prism([1,1,1],center=true);

//support(50,20,baseheight=-20,rotation=[90,0,0]) sphere(r=8,$fn=16);