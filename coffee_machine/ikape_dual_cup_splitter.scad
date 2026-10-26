// =================================================================
// OBJECT 1: VERTICAL ARCHED U-CHANNEL - ONE SINGLE ARM
// =================================================================
$fn = 120; 

// --- Setup Parameters ---
cup_spacing        = 55;   
restrictor_hole_dia= 5;    
shell_wall         = 2.2;  

gutter_inner_dia   = restrictor_hole_dia * 2; 
gutter_outer_dia   = gutter_inner_dia + (shell_wall * 2);

arc_angle          = 32;   
arch_radius        = (cup_spacing / 2) / sin(arc_angle); 

// =================================================================
// RENDERING EXECUTION
// =================================================================
translate([0, 0, -arch_radius]) {
    pure_arched_u_channel_single();
}

// =================================================================
// COMPONENT MODULES
// =================================================================

module pure_arched_u_channel_single() {
    // Only one arm remains now to isolate the shape layout
    rotate([0, arc_angle, 0]) 
        rotate_extrude(angle = arc_angle)
            translate([arch_radius, 0, 0])
                sky_facing_u_profile_2d();
}

module sky_facing_u_profile_2d() {
    difference() {
        union() {
            circle(d = gutter_outer_dia);
            translate([0, -gutter_outer_dia/2])
                square([gutter_outer_dia/2, gutter_outer_dia]);
        }
        union() {
            circle(d = gutter_inner_dia);
            translate([0, -gutter_inner_dia/2])
                square([gutter_outer_dia, gutter_inner_dia]);
        }
    }
}

