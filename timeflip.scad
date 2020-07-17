side=1;

difference()
{
    dodekaeder(24);
    if (side==0) translate([0,0,200/2]) cube([200,200,200],center=true);
    else translate([0,0,-200/2]) cube([200,200,200],center=true);
    bias = -10;
    //battery
    translate([17/2,0,0]) cube([18,27,56],center=true);
    //battery wire hole
    translate([4,15,0]) cylinder(d=10,h=56,center=true,$fn=300);
    //arduino nano body
    translate([-7.5/5+bias,0,-7.5]) cube([7.5,19,45],center=true);
    //arduino nano connector
    translate([-7.5/5+bias-0.7,0,-10]) cube([5,8,44],center=true);
    //accel
    translate([-7.5/5-22,0,0]) cube([5,16.7,26],center=true);
    //wire hole wide
    rotate([0,0,90])
    translate([0,10,0]) cube([13,28,24.1],center=true);
    //wire hole near
    rotate([0,0,90])
    translate([0,0,0]) cube([13,16,55],center=true);
    //screw
    translate([bias*0.4,bias,0]) cylinder(h=65,d=3.5,$fn=300,center = true);
    translate([bias*0.4,-bias,0]) cylinder(h=65,d=3.5,$fn=300,center = true);
    //nut hex
    translate([bias*0.4,bias,-65/2]) rotate([0,0,30]) cylinder(h=30,d=7.3,$fn=6,center = true);
    translate([bias*0.4,-bias,-65/2]) rotate([0,0,30])cylinder(h=30,d=7.3,$fn=6,center = true);
    //nut cyl
    translate([bias*0.4,bias,65/2]) cylinder(h=30,d=7,$fn=300,center = true);
    translate([bias*0.4,-bias,65/2]) cylinder(h=30,d=7,$fn=300,center = true);
    //voltmeter
    translate([-8,-25.5+1.7,1.5+3])
    rotate([0,0,90+(360/5)]) 
    rotate([-360/6-3,0,0]) 
    voltmeter();
    volt_wire_hole();
    //charge connector
    color("red")
    translate([-8.5,28.7,4])
    rotate([0,0,90-(360/5)]) 
    rotate([-360/6-3.5+180,0,0]) 
    charge_connector(14,17,15,3,side ? 8.5 : 15);
    //button
    color("red") translate([-6.5,-20,-20.5]) charge_connector(11,17,13,18,8);
    translate([-6.5-0.7,-20-3,-20.5-18/2-2.8]) 
    cylinder(d=10,h=18,center=true,$fn=300);    
}

module charge_connector(inner_dia,inner_heigh,outer_dia,outer_heigh,wall_dia)
{
    translate([0,0,-outer_heigh/2]) 
    cylinder(d=outer_dia,h=outer_heigh,center=true,$fn=300);
    wall_thin = 2;    
    translate([0,0,wall_thin/2]) 
    cylinder(d=wall_dia,h=wall_thin,center=true,$fn=300);
    translate([0,0,wall_thin/2+inner_heigh/2]) 
    cylinder(d=inner_dia,h=inner_heigh,center=true,$fn=300);
}

module volt_wire_hole()
{
    translate([-11.5,0,0])
    cube([7.5,40,10],center = true);
}

module voltmeter()
{
    width_mod=22.6;
    heigh_mod=11;
    depth_mod=7;
    color("red") 
    translate([-width_mod/2,-heigh_mod/2,0]) 
    cube([width_mod,heigh_mod,depth_mod]);
    width_plate=33;
    heigh_plate=15;
    depth_plate=12;
    color("green") 
    translate([-width_plate/2,-heigh_plate/2,-depth_plate]) 
    cube([width_plate,heigh_plate,depth_plate]);
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