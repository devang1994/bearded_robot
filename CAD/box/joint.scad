module bracket()
{
	difference()
	{
		union()
		{
			cube([40,40,40]);

		}
		union()
		{
			translate([7,7,-1]) cube([40,40,42]);
			translate([2.5,5.1,10]) cube ([2.5,40,40]);
			translate([5.1,2.5,10]) cube ([40,2.5,40]);
		}
	}
}

bracket();

