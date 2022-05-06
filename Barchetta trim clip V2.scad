// Set this to '1' if you want the visible trim printed
// set this to '0' if you don't want this printed.  Usually when you have an existing
// clip that has had its little legs broken off and you just want to ad a clip to the back
draw_main_face = 1;
// Main face sizes
face_plate_length = 55;
face_plate_width = 25;
face_plate_height = 2;
face_slot_length = 10;
face_slot_width =2;
// Recess plate sizes
recess_plate_inset =3;
recess_plate_length = face_plate_length-recess_plate_inset*2;
recess_plate_width = face_plate_width-recess_plate_inset*2;
recess_plate_height = 3;
// flange to secure bottom of trim clip
flange_height = 2;
flange_overhang = 2;
//bolt
bolt_length = 35;
bolt_width = 7;
bolt_height = 2;
bolt_spring_gap = 1.5;

// bolt_slot
bolt_slot_inner_width = bolt_width +1;
bolt_slot_outer_width = bolt_slot_inner_width+3;
module draw_plate_with_slot(l, w, h, slot_length, slot_width)
{
    difference()
    {           
        union()
        {
            cube([w, l-w, h], center=true);
            translate([0, -(l-w)/2, 0])       
                cylinder(h=h, r=w/2, center=true);       
            translate([0,(l-w)/2 , 0])       
                cylinder(h=h, r=w/2, center=true);       
        }
        cube([slot_width, slot_length, h+1], center=true);
    }     
}
module visible_part()
{
    if (draw_main_face  == 1)
        draw_plate_with_slot(face_plate_length, face_plate_width, face_plate_height, 
            face_slot_length, face_slot_width);
}
module recess_plate()
{
    translate([0,0,(face_plate_height+recess_plate_height)/2])
    {
        draw_plate_with_slot(recess_plate_length, recess_plate_width, recess_plate_height,
                            face_slot_length, face_slot_width);
    }
}
module flange()
{
    difference()
    {
        translate([0, (recess_plate_length-recess_plate_width)/2 + flange_overhang,face_plate_height + recess_plate_height])
            cylinder(h=flange_height, r=recess_plate_width/2, center=true);
        translate([0, 0, face_plate_height + recess_plate_height])
            cube([recess_plate_width, recess_plate_length-recess_plate_width +flange_overhang , flange_height+0.1], center=true);
    }
}
module slot_for_bolt()
{
    translate([2, 0, 6])
    {
        difference()
        {
            cube([10, 29, 5], center=true);
            union()
            {
                // main slot
                translate([0,0,-1])
                    cube([8, 30, 4], center=true);
                // engagement notch part way down
                translate([0, -10, 0])
                    cube([11,2,6], center=true);
                translate([0, -5, 0])
                    cube([11,2,6], center=true);
                // cut part of roof off
                translate([0, 0, 0])
                    cube([8,10,6], center =true);
                // cut part of roof off
                translate([0, -12.5, 0])
                    cube([8,5,6], center =true);
                translate([0, 12.5, 0])
                    cube([8,5,6], center =true);
            }
        }
    }
}
module sprung_bolt()
{
    // Move bolt out of the way of the trim piece
    translate([-face_plate_width, 0, 0])
    {
        difference()
        {
            cube([bolt_width,bolt_length,bolt_height], center=true);
            union()
            {
                // add the slot to make it springy
                translate([bolt_width/2-2, 0, 0])
                    cube([bolt_spring_gap, bolt_length - 7, bolt_height+1], center=true);
                //add the hole to move it
                translate([-.5,9, 0])
                    cube([3,2,3], center=true);
            }
                
        }
        // add the little blob to click in the slots
        translate([3.5, 0, -1])
            cylinder(h=2, r=1.5);
    }
}
$fn=100;
visible_part();
recess_plate();
flange();
slot_for_bolt();
sprung_bolt();
