// =================================================================
// E61 STAND FRAME - ITERATION 24 (LOOP VALUE ARRAY FIXED COMPLETELY)
// =================================================================
$fn = 120; // High render quality for circular cuts

// --- Explicit Component Height Constants ---
bridge_height      = 12;   // Flat-to-flat bridge plate thickness (mm)
cup_lip_depth      = 5;    // Depth of anti-vibration protective pocket lip (mm)


// --- Machine & Cup Geometry Parameters ---
machine_dia        = 70;   // Outer base diameter of your portable espresso machine
machine_slot_depth = 19;    // How deep the machine base sits inside the top rim
cup_outer_dia      = 65;   // Top outer diameter of your glass cups (mm)
cup_spacing        = 55;   // Center-to-center nominal distance between cups
shell_wall         = 4.0;  // Structural wall padding thickness

// --- Tier 2 (Middle): E61 Portafilter Socket & Ear Slots ---
portafilter_dia    = 70;   // Tight-ish hole diameter for the main circular body
portafilter_depth  = 0;   // Depth/thickness of the portafilter body ring section
ear_span           = 81;   // Total tip-to-tip width across both ears 
ear_width          = 26;   
ear_depth          = 10;    // Vertical distance from bottom of ear to top of portafilter
splitter_depth     = 60;    // Vertical distance for splitter to clear classes to top of portafilter

// --- Adjustable Track Customisation ---
track_adjustment   = 10;   // Total horizontal play allowance (mm) to slide cups in/out

// --- Hardware & Self-Tapping Fastener Parameters ---
bridge_screw_hole_dia = 4.2;  // Clearance pass-through diameter in the bridge (for M4)
tower_screw_hole_dia  = 3.2;  // Tight pilot hole diameter in tower for self-tapper bite
counterbore_dia       = 8.5;  // Width of the flat pocket for a Pan-Head screw profile
counterbore_depth     = 3.5;  // Pocket depth (mm) measured from the cup slot floor


tower_height       = splitter_depth - ear_depth + machine_slot_depth;   // Main cylindrical tower body height (mm)

// =================================================================
// MAIN PRINT BED ASSEMBLY (SIDE-BY-SIDE - PERFECTLY SEPARATED)
// =================================================================

// 1. LEFT SIDE: Upper Cylinder Tower (Printed Right-Side Up)
translate([0, 100, 0]) { 
    upper_cylinder_tower();
}

// 2. RIGHT SIDE: Lower Bridge Plate (Printed UPSIDE DOWN for supportless track)
translate([0, 0, 0]) { 
    lower_bridge_plate_upside_down();
}

// =================================================================
// COMPONENT MODULES
// =================================================================

// PIECE 1: Upper Cylinder Tower (True Flat Bottom Surface)
module upper_cylinder_tower() {
    tower_outer_dia = ear_span + (shell_wall * 2);
    
    difference() {
        // Outer solid boundary
        cylinder(h = tower_height, d = tower_outer_dia);
        
        // Tier 1: Machine Well Sinking at the very top
        translate([0, 0, tower_height - machine_slot_depth])
            cylinder(h = machine_slot_depth + 1, d = machine_dia);
        
        // Tier 2: Portafilter Main Ring Drop Hole
        translate([0, 0, tower_height - machine_slot_depth - portafilter_depth])
            cylinder(h = portafilter_depth + 0.1, d = portafilter_dia);
        
        // Continuous Ear Tracks slicing down past the top lip rim
        translate([0, 0, tower_height - (machine_slot_depth + portafilter_depth)/2])
            cube([ear_span, ear_width, machine_slot_depth + portafilter_depth + 2], center = true);
            
        // Central internal fluid clearance corridor passing out the bottom
        translate([0, 0, -1])
            cylinder(h = tower_height + 2, d = portafilter_dia);
            
        // Deeper pilot engagement channels for long self-tapping threads
        screw_pattern_coordinates()
            translate([0, 0, -1])
                cylinder(h = 35 + 1, d = tower_screw_hole_dia); 
    }
}

// PIECE 2: Lower Bridge Plate (True Flat Top Surface, Flipped Upside Down on Bed)
module lower_bridge_plate_upside_down() {
    max_internal_dia = max(machine_dia, portafilter_dia, cup_outer_dia, ear_span);
    total_span = cup_spacing + max_internal_dia + track_adjustment;
    slide_limit  = track_adjustment / 2;
    
    // Clean inversion flip: Pins the true top face flat onto the print bed plane
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
            cylinder(h = bridge_height + 2, d = portafilter_dia);
            
        // Capsule slot tracking track underneath to protect against cup skate/vibration
        translate([0, 0, -0.1]) {
            hull() {
                translate([-(cup_spacing/2) - slide_limit, 0, 0])
                    cylinder(h = cup_lip_depth + 0.1, d = cup_outer_dia + 1.2);
                translate([(cup_spacing/2) + slide_limit, 0, 0])
                    cylinder(h = cup_lip_depth + 0.1, d = cup_outer_dia + 1.2);
            }
        }
        
        // 4x Shafty Channels & Flat-Bottom Counterbores for Pan-Head Screws
        screw_pattern_coordinates() {
            // Main thread clearance pass-through shaft running all the way through
            translate([0, 0, -1])
                cylinder(h = bridge_height + 2, d = bridge_screw_hole_dia);
                
            // The counterbore starts at the cup slot floor and cuts deep into the solid plastic core
            translate([0, 0, cup_lip_depth - 0.1])
                cylinder(h = counterbore_depth + 0.1, d = counterbore_dia);
        }
    }
}

// FIXED: Symmetrical corner arrangement mapping coordinates array explicitly
module screw_pattern_coordinates() {
    tower_outer_dia = ear_span + (shell_wall * 2);
    internal_core_dia = portafilter_dia;
    
    // Calculate the exact midpoint circle between outer diameter and internal bore line
    centered_radius = (internal_core_dia / 2) + ((tower_outer_dia - internal_core_dia) / 4);
    
    // FIXED ARMED CORNER TRACK LOOP VECTOR
    for (angle =[45, 135, 225, 315]) {
        rotate([0, 0, angle]) 
            translate([centered_radius, 0, 0]) 
                children();
    }
}

