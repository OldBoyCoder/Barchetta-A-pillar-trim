// Set this to '1' if you want the visible trim printed
// set this to '0' if you don't want this printed.  Usually when you have an existing
// clip that has had its little legs broken off and you just want to ad a clip to the back
draw_main_face = 1;
// Due to the fact my printer seems to mess up trying to print both the
// bolt and the trim at the same time, I've added a couple of flags
// so you can do none, one or both
draw_bolt =0;
draw_trim =1;
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
bolt_slot_wall_width=2;

bolt_length = recess_plate_length - recess_plate_width;
bolt_width = recess_plate_width-4*bolt_slot_wall_width-1;
bolt_height = 3;
bolt_spring_gap = 1.5;
// bolt_slot
bolt_slot_length = recess_plate_length - recess_plate_width;
bolt_slot_inner_width = bolt_width +0.5;
bolt_slot_outer_width = bolt_slot_inner_width+bolt_slot_wall_width*2;
bolt_slot_inner_height = bolt_height+1;
bolt_slot_outer_height = bolt_slot_inner_height + bolt_slot_wall_width;
bolt_slot_offset = 0; // amount to move the slot to one side
notch_width=2;
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
        translate([0, (recess_plate_length-recess_plate_width)/2 + flange_overhang,face_plate_height/2 + recess_plate_height+flange_height/2])
            cylinder(h=flange_height, r=recess_plate_width/2, center=true);
        translate([0, 0, face_plate_height + recess_plate_height])
            cube([recess_plate_width, recess_plate_length-recess_plate_width +flange_overhang , flange_height+0.1], center=true);
    }
}
module slot_for_bolt()
{
    translate([bolt_slot_offset, 0, face_plate_height/2 + recess_plate_height +bolt_slot_outer_height/2])
    {
        difference()
        {
            cube([bolt_slot_outer_width, bolt_slot_length, bolt_slot_outer_height], center=true);
            union()
            {
                // main slot
                translate([0,0,-bolt_slot_wall_width/2])
                    cube([bolt_slot_inner_width, bolt_slot_length+0.1, bolt_slot_inner_height], center=true);
                // engagement notch part way down
                translate([0, -10, 0])
                    cube([bolt_slot_outer_width+0.1,notch_width,bolt_slot_outer_height+1], center=true);
                translate([0, 10, 0])
                    cube([bolt_slot_outer_width+0.1,notch_width,bolt_slot_outer_height+1], center=true);
                translate([0, -5, -(bolt_slot_wall_width)/2])
                    cube([bolt_slot_outer_width+0.1,notch_width,bolt_slot_inner_height], center=true);
                translate([0, 5, -(bolt_slot_wall_width)/2])
                    cube([bolt_slot_outer_width+0.1,notch_width,bolt_slot_inner_height], center=true);
                translate([0, 0, -(bolt_slot_wall_width)/2])
                    cube([bolt_slot_outer_width+0.1,notch_width,bolt_slot_inner_height], center=true);
            }
        }
    }
}
module sprung_bolt()
{
    // Move bolt out of the way of the trim piece
    translate([-face_plate_width, 0, 0])
    {
        union()
        {
            difference()
            {
                cube([bolt_width,bolt_length,bolt_height], center=true);
                union()
                {
                    // add the slots to make it springy
                    translate([bolt_width/2-2, 0, 0])
                        cube([bolt_spring_gap, bolt_length - 7, bolt_height+1], center=true);
                    translate([-(bolt_width/2-2), 0, 0])
                        cube([bolt_spring_gap, bolt_length - 7, bolt_height+1], center=true);
                    //add the hole to move it
                    translate([0,4, 0])
                        cube([5,5,bolt_height+1], center=true);
                }
                    
            }
            translate([0, -(bolt_length+(0.75*bolt_width))/2, 0])
                cube([bolt_width, bolt_width*0.75, bolt_height], center=true);
        }
        // add the little blob to click in the slots
        translate([bolt_width/2, 0, 0])
            cylinder(h=bolt_height, r=0.5, center=true);
        translate([-bolt_width/2, 0, 0])
            cylinder(h=bolt_height, r=0.5, center=true);
    }
}
$fn=100;
if (draw_trim ==1)
{
    if (draw_main_face  == 1)
        visible_part();
    recess_plate();
    flange();
    slot_for_bolt();
}
if (draw_bolt == 1)
    sprung_bolt();
