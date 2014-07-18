$fn=24;
h=25;
outer_r=5; //radius of tube
inner_r=4.5; //inner radius of bottom of tube
baffle_r=10;//baffle to stop external light hitting the sensor
baffle_h=1;
lens_outer_r=5/2+0.3; //outer radius of lens
lens_aperture_r=3.8/2+0.2; //clear aperture of lens
lens_t=1.0; //thickness of lens

n_cones=floor((h-lens_t)/2); //how many ridges to make
cone_h=(h-lens_t)/n_cones; //height of each ridge
cone_dr=cone_h/2; //change in radius over each cone

d=0.05;

difference(){
	union(){
		cylinder(r=outer_r, h=h); //tube
		cylinder(r=baffle_r, h=baffle_h); //baffle
	}

	translate([0, 0, h-1.0]) cylinder(r=5.6/2, h=999); //lens

	//clearance for beam, with light-trapping edges
	for(i = [0 : n_cones - 1]) assign(p = i/(n_cones - 1))
		translate([0, 0, i * cone_h - d]) 
			cylinder(r1=(1-p)*inner_r + p*(lens_aperture_r + cone_dr),
						r2=(1-p)*(inner_r - cone_dr) + p*lens_aperture_r,
						h=cone_h+2*d);
}