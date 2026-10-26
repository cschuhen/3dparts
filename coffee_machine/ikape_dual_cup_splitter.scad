// =================================================================
// PIECE 1: MAIN TOWER STAND - ITERATION 16 (SYNTAX FIXED)
// =================================================================
$fn = 120; 

// --- Setup Dimensions ---
cup_outer_dia      = 65;   // Top outer diameter of your glass cups (mm)
cup_spacing        = 55;   // Center-to-center nominal distance between cups
stand_height       = 70;   // Height of the plastic block frame
shell_wall         = 4.0;  // Structural padding thickness 

// --- Tier 1 (Top): Espresso Machine Socket ---
machine_dia        = 68;   // Outer base diameter of your portable espresso machine
machine_slot_depth = 20;    // How deep the machine base sits inside the top rim

// --- Tier 2 (Middle): E61 Portafilter Socket & Ear Slots ---
portafilter_dia    = 63;   // Tight-ish hole diameter for the main circular body
portafilter_depth  = 10;   // Depth/thickness of the portafilter body ring section
ear_span           = 79;   // Total tip-to-tip width across both ears 
ear_width          = 11;   // // FIXED COMMENT MARKER HERE

// --- Adjustable Track Customisation ---
track_adjustment   = 10;   // Total horizontal play allowance (mm) to slide cups in/out

// =================================================================
// MAIN ASSEMBLY PIPELINE (PIECE 1)
// =================================================================
difference() {
    // 1. Core solid housing body block
    solid_housing_frame();
    
    // 2. TIER 1 (TOP): 100% FLAT socket for the espresso machine base
    top_machine_socket();
    
    // 3. TIER 2 (MIDDLE): 100% FLAT tight hole for E61 body + open vertical ear slots
    middle_portafilter_socket();
    
    // 4. FLUID EXIT: Central through-hole corridor extending all the way out the bottom
    bottom_fluid_exit_hole();
}

// =================================================================
// GEOMETRIC COMPONENT DEFINITIONS
// =================================================================

module solid_housing_frame() {
    max_internal_dia = max(machine_dia, portafilter_dia, cup_outer_dia, ear_span);
    total_span = cup_spacing + max_internal_dia + track_adjustment;
    
    hull() {
        translate([-total_span/4, 0, 0])
            cylinder(h=stand_height, d=max_internal_dia + (shell_wall*2));
        translate([total_span/4, 0, 0])
            cylinder(h=stand_height, d=max_internal_dia + (shell_wall*2));
        cylinder(h=stand_height, d=max_internal_dia + (shell_wall*2));
    }
}

module top_machine_socket() {
    machine_z = stand_height - machine_slot_depth;
    translate([0, 0, machine_z])
        cylinder(h=machine_slot_depth + 1, d=machine_dia);
}

module middle_portafilter_socket() {
    pf_z = stand_height - machine_slot_depth - portafilter_depth;
    
    // Main tight-fitting body hole (FLAT LEDGE)
    translate([0, 0, pf_z])
        cylinder(h=portafilter_depth + 0.1, d=portafilter_dia);
    
    // Open-topped ear slots tracking straight up out of the block
    ear_cutout_height = stand_height - pf_z + 1;
    translate([0, 0, pf_z])
        translate([0, 0, ear_cutout_height / 2])
            cube([ear_span, ear_width, ear_cutout_height], center=true);
}

module bottom_fluid_exit_hole() {
    pf_z = stand_height - machine_slot_depth - portafilter_depth;
    // Single tight vertical hole piercing straight through to the bottom floor
    translate([0, 0, -1])
        cylinder(h=pf_z + 1.1, d=portafilter_dia - 8);
}

