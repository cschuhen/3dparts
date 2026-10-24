// =================================================================
// PARAMETERIZED DUAL ESPRESSO CUP ADAPTER PROTOTYPE
// =================================================================
$fn = 120; // Smoothness of circles

// --- Measurements (Adjust these for your specific setup) ---
cup_outer_dia    = 50;  // Top outer diameter of your glass cups (mm)
cup_wall_thick   = 3;   // Thickness of glass rim to help alignment lips
cup_spacing      = 55;  // Distance center-to-center between the two cups
adapter_height   = 25;  // Total height of the adapter block
wall_thickness   = 3;   // Structural thickness of the printed adapter

machine_dia      = 60;  // Outer diameter of the machine's bottom base
machine_well_depth= 8;  // How deep the machine sits inside the top rim
nozzle_dia       = 12;  // Diameter of the machine's espresso output nozzle

// =================================================================
// MAIN ASSEMBLY
// =================================================================
difference() {
    main_body();
    internal_funnels();
}
splitter_wedge();
cup_locators();

// =================================================================
// MODULES (CHUNKS OF GEOMETRY)
// =================================================================

// 1. The solid outer block spanning both cups
module main_body() {
    hull() {
        // Left side cup cap
        translate([-cup_spacing/2, 0, 0])
            cylinder(h=adapter_height, d=cup_outer_dia + (wall_thickness*2));
        
        // Right side cup cap
        translate([cup_spacing/2, 0, 0])
            cylinder(h=adapter_height, d=cup_outer_dia + (wall_thickness*2));
        
        // Central ring to support the machine base
        translate([0, 0, 0])
            cylinder(h=adapter_height, d=machine_dia + (wall_thickness*2));
    }
}

// 2. The cutouts that create the sloped funnels draining into each cup
module internal_funnels() {
    // Top cavity where the espresso machine drops in
    translate([0, 0, adapter_height - machine_well_depth])
        cylinder(h=machine_well_depth + 1, d=machine_dia);
    
    // Left funnel path down to the left cup
    hull() {
        translate([0, 0, adapter_height - machine_well_depth])
            cylinder(h=0.1, d=nozzle_dia + 4);
        translate([-cup_spacing/2, 0, -1])
            cylinder(h=1, d=cup_outer_dia - 4);
    }
    
    // Right funnel path down to the right cup
    hull() {
        translate([0, 0, adapter_height - machine_well_depth])
            cylinder(h=0.1, d=nozzle_dia + 4);
        translate([cup_spacing/2, 0, -1])
            cylinder(h=1, d=cup_outer_dia - 4);
    }
}

// 3. The sharp V-wedge right under the nozzle to split the stream 50/50
module splitter_wedge() {
    wedge_height = 8;
    translate([0, 0, adapter_height - machine_well_depth - wedge_height])
    intersection() {
        // Limit the wedge to the central nozzle area
        cylinder(h=wedge_height, d=nozzle_dia + 2);
        // Create the sharp dividing triangle
        rotate([90, 0, 0]) 
            linear_extrude(height=nozzle_dia+4, center=true)
                polygon(points=[[-2,0], [2,0], [0,wedge_height]]);
    }
}

// 4. Rings on the bottom to stop the adapter sliding off the glasses
module cup_locators() {
    lip_depth = 4;
    
    // Left cup guide
    translate([-cup_spacing/2, 0, -lip_depth])
        difference() {
            cylinder(h=lip_depth, d=cup_outer_dia + 1.5);
            translate([0, 0, -0.5])
                cylinder(h=lip_depth + 1, d=cup_outer_dia - cup_wall_thick);
        }
        
    // Right cup guide
    translate([cup_spacing/2, 0, -lip_depth])
        difference() {
            cylinder(h=lip_depth, d=cup_outer_dia + 1.5);
            translate([0, 0, -0.5])
                cylinder(h=lip_depth + 1, d=cup_outer_dia - cup_wall_thick);
        }
}

