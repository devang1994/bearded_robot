// Global
bracketThickness=2;

module mountingArm(height, width, thickness)
{
	difference()
	{
		union()
		{
			cube([thickness+2,bracketThickness,height+2], center=true);
			translate([0,bracketThickness,height/2]) cube([thickness+2,bracketThickness,2], center=true);
		}

		union()
		{
			translate([0,bracketThickness,-1]) cube([thickness,bracketThickness*2,height+2], center=true);
		}
	}
}

module mountingBracket(height, width, thickness)
{
	difference()
	{
		union()
		{
			translate([1,0,0]) cube([thickness+4,width+10,bracketThickness], center=true);
			translate([0,-width/2,bracketThickness/2 + height/2]) mountingArm(height, width, thickness);
			translate([0,+width/2,bracketThickness/2 + height/2]) rotate([0,0,180])mountingArm(height, width, thickness);
		}

		union()
		{
		}
	}
}

//mountingArm(50,37,5);
mountingBracket(16,25,2);