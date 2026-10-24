// =================================================================
// PARAMETERIZED DUAL ESPRESSO CUP ADAPTER - V2 (CONICAL FUNNEL)
// =================================================================
$fn = 150; // Smooth render quality

// --- Measurements (Adjust these for your specific setup) ---
cup_outer_dia      = 50;   // Top outer diameter of your glass cups (mm)
cup_wall_thick     = 3;    // Thickness of glass rim to help alignment lips
cup_spacing        = 55;   // Distance center-to-center between the two cups
adapter_height     = 30;   // Increased height to allow for steep cone angles
wall_thickness     = 3;    // Structural wall thickness

machine_dia        = 60;   // Outer diameter of the machine's bottom base
machine_well_depth = 6;    // Deep well for the machine to sit in safely
flat_rim_width     = 4;    // Width of the flat ring the machine actually rests on
restrictor_hole_dia= 6;    // Small hole to keep flow perfectly centralized

splitter_type      = "arc"; // Choose: "triangle" or "arc"

// =================================================================
// MAIN ASSEMBLY EXECUTION
// =================================================================
difference() {
    main_body();
    internal_funnels_and_cone();
}
splitter();
cup_locators();

// =================================================================
// MODULE DEFINITIONS
// =================================================================

// 1. Solid outer footprint bridging the cups
module main_body() {
    hull() {
        translate([-cup_spacing/2, 0, 0])
            cylinder(h=adapter_height, d=cup_outer_dia + (wall_thickness*2));
        translate([cup_spacing/2, 0, 0])
            cylinder(h=adapter_height, d=cup_outer_dia + (wall_thickness*2));
        cylinder(h=adapter_height, d=machine_dia + (wall_thickness*2));
    }
}

// 2. Clearances, flat ledge, conical funnel, and exit ports
module internal_funnels_and_cone() {
    cone_top_dia = machine_dia - (flat_rim_width * 2);
    cone_height = 12; 
    cone_top_z = adapter_height - machine_well_depth;
    cone_bottom_z = cone_top_z - cone_height;

    // Cavity for the base of the machine
    translate([0, 0, cone_top_z])
        cylinder(h=machine_well_depth + 1, d=machine_dia);
    
    // Conical funnel sloping down from the flat rim
    translate([0, 0, cone_bottom_z])
        cylinder(h=cone_height + 0.01, d1=restrictor_hole_dia, d2=cone_top_dia);
    
    // Centralized vertical restrictor hole drop
    translate([0, 0, cone_bottom_z - 3])
        cylinder(h=3, d=restrictor_hole_dia);

    // Left exit path down into the left cup
    hull() {
        translate([0, 0, cone_bottom_z - 3])
            cylinder(h=0.1, d=restrictor_hole_dia);
        translate([-cup_spacing/2, 0, -1])
            cylinder(h=1, d=cup_outer_dia - 6);
    }
    
    // Right exit path down into the right cup
    hull() {
        translate([0, 0, cone_bottom_z - 3])
            cylinder(h=0.1, d=restrictor_hole_dia);
        translate([cup_spacing/2, 0, -1])
            cylinder(h=1, d=cup_outer_dia - 6);
    }
}

// Replace the old splitter module with this version optimized for gravity-only flow
module splitter() {
    cone_top_z = adapter_height - machine_well_depth;
    cone_height = 12;
    splitter_z = cone_top_z - cone_height - 3; 
    wedge_h = 7; // Slightly taller for a smoother transition
    wedge_w = restrictor_hole_dia + 4;

    translate([0, 0, splitter_z - wedge_h]) {
        if (splitter_type == "triangle") {
            intersection() {
                cylinder(h=wedge_h, d=wedge_w);
                rotate([90, 0, 0]) 
                    linear_extrude(height=wedge_w, center=true)
                        polygon(points=[[-wedge_w/2, 0], [wedge_w/2, 0], [0, wedge_h]]);
            }
        } else {
            // OPTIMIZED LOW-PRESSURE COANDĂ ARC SPLITTER
            intersection() {
                cylinder(h=wedge_h, d=wedge_w);
                translate([0, 0, wedge_h])
                    rotate([90, 0, 0])
                        difference() {
                            // Main splitter boundary block
                            translate([-wedge_w/2, -wedge_h, -wedge_w/2])
                                cube([wedge_w, wedge_h, wedge_w]);
                            
                            // A teardrop-shaped or smooth horizontal cylindrical cutout
                            // This forms the inverted arc that the gravity stream will hug
                            translate([0, 0, -wedge_w/2 - 0.1])
                                cylinder(h=wedge_w + 0.2, r=wedge_h - 1);
                        }
            }
        }
    }
}

// 4. Secure underside rims to lock onto the cups
module cup_locators() {
    lip_depth = 4;
    for (offset = [-cup_spacing/2, cup_spacing/2]) {
        translate([offset, 0, -lip_depth])
            difference() {
                cylinder(h=lip_depth, d=cup_outer_dia + 1.5);
                translate([0, 0, -0.5])
                    cylinder(h=lip_depth + 1, d=cup_outer_dia - cup_wall_thick);
            }
    }
}

