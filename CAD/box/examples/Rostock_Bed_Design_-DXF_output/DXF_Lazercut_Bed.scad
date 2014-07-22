
/* 
------------------------------------------------------------------------------------------------------------
This has been designed by JOHN KRACZEK, 
the idea for this loosely came from http://www.thingiverse.com/thing:31593 by RustyPaint
i liked his idea but didnt feel that it had the right dimentions for my application. 

i wanted to make sure that everything was as close to correct as possible, so i imported the Motor_End.STL file 
to help facilitate accurate Design. you can see this by turning Generate_Externals to true, 
(you will have to get that file from the Rostock Thing http://www.thingiverse.com/thing:17175)


Feel Free to modify for your application and please let me know if you find any bugs or defects in this design. 

------------------------------------------------------------------------------------------------------------

To generate an DXF so that you can send it to the laser i followed this process: 

1. Generate the Part the way that you would like to see it. 
	adjust the holes and the other parts to your likeing. 

2. Set Generate_DXF to true and then Compile using CGAL (F6) 
	This took a while for me, but i have a slower computer

3. Export to DXF

------------------------------------------------------------------------------------------------------------

*/


Generate_DXF = false; 				// if you want to export DXF set to true (May Take a while to compile, just be patient)
Generate_Externals = false; 		// Externals like the motor_end.stl just gives a visual confirmation that everything has been drawn accurately. 

Generate_Bottom = true;  			// if true then OpenSCAD will generate the bottom acrylic, if false will generate the Top acrylic piece. 
Generate_Bracket = false;

Smooth_Rod_Offset = 175; 			// This is the Distance from the center to the smooth rods. 
// (this is just for refrence if you change this then you will want to change lots of things down below)

height=9;							// The Height of the 3D Model
in = 25.4;							// Generic variable converting metric to inches IE. 4*in = 101.6 mm
Electronics_Holes = 0;				// if you want the holes on the left type 180 on right type 0;




module Rostock_Base(){
	difference(){
		intersection(){
			translate([-175,-165,0])
			cube([290,330,height]);
			translate([0,0,-2])
			//This is the Triangle for the 3 sides 
			cylinder(r=Smooth_Rod_Offset*2-9.5,h=height+5, $fn=3);
		}

		//Motor Mount Holes
		union(){
			translate([0,0,-5])
			for(i=[0:2]){
				rotate([0,0,60])
				rotate([0,0,120*i])
				translate([175-12,0,0]){
					for(x=[-30,30]){
						translate([0,x,0])
						//holes near smooth Rod
						cylinder(r=2,h=height*5+1, $fn=12);
						if(Generate_Bottom){
							translate([-36,x,0])
							cylinder(r=2,h=height*3+1, $fn=12);
						}
					}
				}
			}
		}
		
		// Generate Electronics Holes
		if(Generate_Bottom){
			
			rotate([Electronics_Holes,0,0])
			translate([-111+4*in,170])
			rotate([180,0,-90]){

				translate([14.62,2.54,-20])
				cylinder(r=2, h=height*4, $fn=30);
				translate([14.62,50.8,-20])
				cylinder(r=2, h=height*4, $fn=30);
				translate([89.55,50.8,-20])
				cylinder(r=2, h=height*4, $fn=30);
				translate([95.9,2.5,-20])
				cylinder(r=2, h=height*4, $fn=30);
			}
		}
		// PCB Heated Bed Holes
		if(Generate_Bottom){
			
			union(){
				for(i=[0:3]){
					rotate([0,0,90*i])
					translate([209/2,209/2,-5])
					cylinder(r=2,h=20);
				}
			}
		}
		
		//Hole Through Center
		translate([0,0,-20])
		if(Generate_Bottom){
			difference(){
				cylinder(r=80,h=50, $fn=120);
				rotate([Electronics_Holes,0,0]){
					translate([-12,75,-50])
					cylinder(r=15,h=100,$fn=30);
					
					translate([-33,62,-30]){
						rotate([0,0,35])
						difference(){
							cube([25,25,100]);
							cylinder(r=10,h=100,$fn=30);
						}
					}
					translate([11.8,69,-30]){
						rotate([0,0,90])
						difference(){
							translate([2,0,0])
							cube([12,25,100]);
							cylinder(r=10,h=100,$fn=30);
						}
					}
				}
			}
			
		} else {
			difference(){
				cylinder(r=130,h=50, $fn=120);
				translate([75,-200,5])
				cube([40,400,30]);
			}
		}
		
		//Wall Support Holes
		for(i=[0,180]){
			rotate([i,0,0])
			translate([-170,-165,-20]){

				for(a=[1:2]){
					translate([1.25*in*a,10,9])
					cylinder(r=2,h=25);
				}
				for(a=[1:2]){
					rotate([0,0,90])
					translate([1.25*in*a,-10,9])
					cylinder(r=2,h=25);
				}
				//Corner Holes
				if(Generate_Bottom){
					cylinder(r=20,h=45);
				}
			}
		}		
	}
}

module Wall_Support_Bracket(){
	difference(){
		#cube([3*in,3*in,height]);
		//Support Holes
		for(a=[1:2]){
			translate([1.25*in*a,10,-1])
			#cylinder(r=2,h=25, $fn = 12);
		}
		for(a=[1:2]){
			rotate([0,0,90])
			translate([1.25*in*a,-10,-1])
			#cylinder(r=2,h=25 , $fn=12);
		}
		//Corner Hole
		if(Generate_Bottom){
			translate([0,0,-1])
			cylinder(r=20,h=45);
		}
		
		//everything else
		translate([24.5,44,-1])
		cube([2.25*in,1.5*in,height+2]);
		translate([44,24.5,-1])
		cube([1.5*in,2.25*in,height+2]);
		translate([1.75*in,1.75*in,-1])
		cylinder(r=20,h=height+2);
		
		

			for (c=[[0,0,0],[180,0,90]])
			rotate(c){
			difference(){
			translate([-1,3*in-20,-height-1])
			#cube([26,40,height*2+2]);
			translate([5,3*in-20,-height-1])
			#cylinder(r=20,h=height*2+2);
			}
		}
	}
}


module Externals(){

	//Place for the Smooth Rods
	//translate([0,0,-10])
	//cylinder(r=175*2,h=height+1, $fn=3);
	for(i=[0:2]){
		color("red")
		rotate([0,0,120*i+60]){
			cube([Smooth_Rod_Offset,5,20]);
			rotate([0,0,60])
			translate([-175,0,0])
			rotate([0,0,270])
			import("motor_end.stl");
		}

	}
	
	//Motor Mount Holes
	translate([0,0,-5])
	for(i=[0:2]){
		rotate([0,0,60])
		rotate([0,0,120*i])
		translate([175-12,0,0]){
			for(x=[-30,30]){
				translate([0,x,0])
				//holes near smooth Rod
				cylinder(r=2,h=height*5+1, $fn=12);
				if(Generate_bottom){
					translate([-36,x,0])
					cylinder(r=2,h=height*3+1, $fn=12);
				}
			}
		}
	}	
	
}



// Generate either a 3d object or a 2d projection based on the variable Generate_DXF
rotate([0,0,180])
if(Generate_DXF){

	projection(cut = false) {
		translate([0,0,-5])
		
		if(Generate_Bracket){
			Wall_Support_Bracket();
		}else{
			Rostock_Base();
		}
	}
} else {
	if(Generate_Bracket){
		Wall_Support_Bracket();
	}else{
		Rostock_Base();
		if(Generate_Externals){
			Externals();
		}
	}
}
