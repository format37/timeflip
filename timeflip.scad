side=1;

difference()
{
    dodekaeder(24);
    if (side==0) translate([0,0,200/2]) cube([200,200,200],center=true);
    else translate([0,0,-200/2]) cube([200,200,200],center=true);
    bias = -10;
    //battery
    translate([17/2,0,0]) cube([18,27,52],center=true);
    //arduino nano body
    translate([-7.5/5+bias,0,-7.5]) cube([7.5,19,45],center=true);
    //arduino nano connector
    translate([-7.5/5+bias-0.7,0,-10]) cube([5,8,44],center=true);
    //accel
    translate([-7.5/5-22,0,0]) cube([5,16.7,26],center=true);
    //wire hole wide
    rotate([0,0,90])
    translate([0,0,0]) cube([5,48,24.1],center=true);
    //wire hole near
    rotate([0,0,90])
    translate([0,0,0]) cube([5,16,55],center=true);
    //screw
    translate([bias*0.4,bias,0]) cylinder(h=65,d=3.2,$fn=300,center = true);
    translate([bias*0.4,-bias,0]) cylinder(h=65,d=3.2,$fn=300,center = true);
    //nut hex
    translate([bias*0.4,bias,-65/2]) rotate([0,0,30]) cylinder(h=30,d=7.3,$fn=6,center = true);
    translate([bias*0.4,-bias,-65/2]) rotate([0,0,30])cylinder(h=30,d=7.3,$fn=6,center = true);
    //nut cyl
    translate([bias*0.4,bias,65/2]) cylinder(h=30,d=7,$fn=300,center = true);
    translate([bias*0.4,-bias,65/2]) cylinder(h=30,d=7,$fn=300,center = true);
}

module dodekaeder(r = 50)
{
  w = acos(1/sqrt(5));
  rotate([0, 0, 180])
  twosides(r, 0);
  for(i=[0:4])
    rotate([0, -w, i*72])  // tricky!
    twosides(r, i+1);
}

module twosides(r=1, i=1)
{
  h = r*2.618;
  difference()
    {
      linear_extrude(height = h, twist = 36, center = true) // tricky twist
      circle(r, $fn=5);
            
      // text for upper and lower surface
      strings = ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11"];
      
      translate([0, 0, -h/2])
      linear_extrude(height = 1)
      rotate([0, 180, 0])
      text(strings[i],halign = "center", valign = "center");
      rotate([0, 180, 0])
      translate([0, 0, -h/2])
      linear_extrude(height = 1)
      rotate([0, 180, 0])
      text(strings[i+6],halign = "center", valign = "center");
    }
}