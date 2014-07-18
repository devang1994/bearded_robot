use <../utilities.scad>;
use <./flexures.scad>;
d=0.05;

module x_flexure(pillar_outerx=40,
						strut_t=3,
						base_h=-8,
						top_h=30,
						width=32,
						flexure_spacing=15
						)
						assign(travel=4)
						assign(fl=top_h-base_h-strut_t)
						assign($fn=16)
	{
	translate([pillar_outerx,0,base_h]) {
		difference(){
			translate([travel+strut_t/2,0,0]) repeat([flexure_spacing,0,0],2) 
					rotate([90,-90,0]) translate([fl/2,0,0]) union(){
						reflect([0,0,1]) translate([0,0,width*3/8]) flexure_link(length=fl,width=width/4); //flexures
						cube([fl-16,strut_t,width*2/3],center=true);
					}
	
			translate([0,0,fl/2]) rotate([0,90,0]) cylinder(r=3/2*1.15,h=999,center=true); //actuating bolt
	//		translate([0,0,fl/2]) rotate([0,90,0]) cylinder(r=2.5,h=30,center=true); //actuating bolt
			translate([travel+strut_t/2+flexure_spacing,0,fl/2]) rotate([0,-90,0]) nut(3,h=6,fudge=1.22,shaft=true); //nut trap
		}
	}
	
	/////// top plate
	assign(fw=flexure_spacing+strut_t){
		translate([pillar_outerx+travel+fw/2,0,top_h-strut_t/2]) cube([fw,width,strut_t],center=true);
		reflect([0,1,0]) translate([pillar_outerx+travel+fw,3-width/2,top_h]) rotate([90,180,90]) rightangle_prism([3,strut_t,2]);
	}

	/////// pillar for actuating bolt
	translate([pillar_outerx+ flexure_spacing + strut_t + 6+travel,0,base_h]) difference(){
		rotate([90,0,0]) linear_extrude(width,center=true)
			polygon([[-4,-d],[0,fl/2+5],[4,fl/2+5],[4,-d]]);
		translate([-10,0,fl/2]) rotate([0,-90,0])
			nut(3,h=6,fudge=1.22,shaft=true);
	}
}

module x_flexure_nut(strut_t=3,base_h=-8,top_h=30) assign(fl=top_h-base_h-strut_t) translate([0,0,base_h+fl/2]) rotate([0,-90,0])
	nut(3,h=6,fudge=1.22,shaft=true);

x_flexure();
//x_flexure_nut();