// =================================================================
// E61 STAND FRAME - REFINED FLANGED SPLIT (FLAT-TO-FLAT MOUNT)
// =================================================================
$fn = 120; // Crisp rendering circles

// --- Explicit Component Height Constants ---
tower_height       = 70;   // UPDATED: Main cylindrical tower body height (mm)
bridge_height      = 12;   // UPDATED: Flat-to-flat bridge plate thickness (mm)
cup_lip_depth      = 5;    // UPDATED: Depth of anti-vibration protective pocket lip (mm)

// --- Machine & Cup Geometry Parameters ---
machine_dia        = 68;   // Outer base diameter of your portable espresso machine
machine_slot_depth = 6;    // How deep the machine base sits inside the top rim
cup_outer_dia      = 65;   // Top outer diameter of your glass cups (mm)
cup_spacing        = 55;   // Center-to-center nominal distance between cups
shell_wall         = 4.0;  // Structural wall padding thickness

// --- Tier 2 (Middle): E61 Portafilter Socket & Ear Slots ---
portafilter_dia    = 63;   // Tight-ish hole diameter for the main circular body
portafilter_depth  = 10;   // Depth/thickness of the portafilter body ring section
ear_span           = 79;   // Total tip-to-tip width across both ears 
ear_width          = 11;   

// --- Adjustable Track Customisation ---
track_adjustment   = 10;   // Total horizontal play allowance (mm) to slide cups in/out
bolt_hole_dia      = 4.5;  // Clearance holes for M4 assembly screws

// =================================================================
// MAIN PRINT BED ASSEMBLY (SIDE-BY-SIDE)
// =================================================================

// 1. LEFT SIDE: Upper Cylinder Tower (Printed Right-Side Up)
translate([-55, 0, 0]) {
    upper_cylinder_tower();
}

// 2. RIGHT SIDE: Lower Bridge Plate (Printed UPSIDE DOWN for supportless track)
translate([60, 0, 0]) {
    lower_bridge_plate_upside_down();
}

// =================================================================
// COMPONENT MODULES
// =================================================================

// PIECE 1: Upper Cylinder Tower (70mm Tall, True Flat Bottom Surface)
module upper_cylinder_tower() {
    flange_dia = ear_span + (shell_wall * 2);
    
    difference() {
        // Outer solid boundary: Straight cylinder all the way down to a flat base
        cylinder(h = tower_height, d = flange_dia);
        
        // Tier 1: Machine Well Sinking at the very top
        translate([0, 0, tower_height - machine_slot_depth])
            cylinder(h = machine_slot_depth + 1, d = machine_dia);
        
        // Tier 2: Portafilter Main Ring Drop Hole (Sits right underneath machine slot)
        translate([0, 0, tower_height - machine_slot_depth - portafilter_depth])
            cylinder(h = portafilter_depth + 0.1, d = portafilter_dia);
        
        // Continuous Ear Tracks slicing down past the top lip rim all the way to the pf floor
        translate([0, 0, tower_height - (machine_slot_depth + portafilter_depth)/2])
            cube([ear_span, ear_width, machine_slot_depth + portafilter_depth + 2], center = true);
            
        // Central internal fluid clearance corridor passing all the way out the flat bottom
        translate([0, 0, -1])
            cylinder(h = tower_height + 2, d = portafilter_dia - 8);
            
        // Assembly bolt holes passing straight through the solid cylinder walls to the base
        flange_bolt_coordinates()
            translate([0, 0, -1])
                cylinder(h = tower_height + 2, d = bolt_hole_dia);
    }
}

// PIECE 2: Lower Bridge Plate (True Flat Top Surface, Flipped Upside Down on Bed)
module lower_bridge_plate_upside_down() {
    max_internal_dia = max(machine_dia, portafilter_dia, cup_outer_dia, ear_span);
    total_span = cup_spacing + max_internal_dia + track_adjustment;
    slide_limit  = track_adjustment / 2;
    
    // We model right-side up internally, then flip it completely flat to print supportless
    translate([0, 0, bridge_height])
    rotate([180, 0, 0]) 
    difference() {
        // Core structural shape footprint (Two circles + joining bridge rectangle)
        hull() {
            translate([-total_span/4, 0, 0])
                cylinder(h = bridge_height, d = max_internal_dia + (shell_wall*2));
            translate([total_span/4, 0, 0])
                cylinder(h = bridge_height, d = max_internal_dia + (shell_wall*2));
            cylinder(h = bridge_height, d = max_internal_dia + (shell_wall*2));
        }
        
        // Central fluid pass-through entry pocket matching portafilter core diameter
        translate([0, 0, -1])
            cylinder(h = bridge_height + 2, d = portafilter_dia - 8);
            
        // Capsule slot tracking track underneath to protect against cup skate/vibration
        // Because the part is flipped, this prints facing straight up out of the bed
        translate([0, 0, -0.1]) {
            hull() {
                translate([-(cup_spacing/2) - slide_limit, 0, 0])
                    cylinder(h = cup_lip_depth + 0.1, d = cup_outer_dia + 1.2);
                translate([(cup_spacing/2) + slide_limit, 0, 0])
                    cylinder(h = cup_lip_depth + 0.1, d = cup_outer_dia + 1.2);
            }
        }
        
        // Mating screw holes aligned exactly with the upper tower bolt paths
        flange_bolt_coordinates()
            translate([0, 0, -1])
                cylinder(h = bridge_height + 2, d = bolt_hole_dia);
    }
}

// Shared hardware coordinate bolt layout helper (4 symmetrical positions flanking the core)
module flange_bolt_coordinates() {
    bolt_radius = (ear_span + (shell_wall * 2)) / 2 - (shell_wall / 1.5);
    rotate([0, 0, 45])  translate([bolt_radius, 0, 0]) children();
    rotate([0, 0, 135]) translate([bolt_radius, 0, 0]) children();
    rotate([0, 0, 225]) translate([bolt_radius, 0, 0]) children();
    rotate([0, 0, 315]) translate([bolt_radius, 0, 0]) children();
}

