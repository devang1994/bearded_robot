module bracket(height,sheet_width)
{
	difference()
	{
		union()
		{
			cube([40,40,height]);

		}
		union()
		{
			translate([5+sheet_width,5+sheet_width,-1]) cube([40,40,height+10]);
			translate([sheet_width+0.5,sheet_width+0.5,3]) cube ([sheet_width+0.5,40,height]);
			translate([sheet_width+0.5,sheet_width+0.5,3]) cube ([40,sheet_width+0.5,height]);
		}
	}
}

bracket(30,2);
