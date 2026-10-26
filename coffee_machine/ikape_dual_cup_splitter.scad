// =================================================================
// E61 STAND FRAME - ITERATION 18 (SELF-TAPPING SCREW REFINEMENTS)
// =================================================================
$fn = 120; // Crisp rendering circles

// --- Explicit Component Height Constants ---
tower_height       = 70;   // Main cylindrical tower body height (mm)
bridge_height      = 12;   // Flat-to-flat bridge plate thickness (mm)
cup_lip_depth      = 0;    // Depth of anti-vibration protective pocket lip (mm)

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

// --- Hardware & Self-Tapping Fastener Parameters ---
bridge_screw_hole_dia = 4.2;  // Clearance pass-through diameter in the bridge (for M4)
tower_screw_hole_dia  = 3.2;  // Tight pilot hole diameter in tower for self-tapper bite
countersink_dia       = 8.5;  // Maximum outer diameter of the 90-degree screw head head-sink

// =================================================================
// MAIN PRINT BED ASSEMBLY (SIDE-BY-SIDE WITH EXTENDED CLEARANCE)
// =================================================================

// 1. LEFT SIDE: Upper Cylinder Tower (Printed Right-Side Up)
translate([-100, 0, 0]) { // Increased distance to prevent print bed crowding
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
            cylinder(h = tower_height + 2, d = portafilter_dia - 8);
            
        // Tight pilot holes for self-tapping threads (centered on the thick lower wall)
        screw_pattern_coordinates()
            translate([0, 0, -1])
                cylinder(h = 25, d = tower_screw_hole_dia); // 24mm deep thread engagement cavity
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
        translate([0, 0, -0.1]) {
            hull() {
                translate([-(cup_spacing/2) - slide_limit, 0, 0])
                    cylinder(h = cup_lip_depth + 0.1, d = cup_outer_dia + 1.2);
                translate([(cup_spacing/2) + slide_limit, 0, 0])
                    cylinder(h = cup_lip_depth + 0.1, d = cup_outer_dia + 1.2);
            }
        }
        
        // Clearance holes + coned countersinks for the self-tapping assembly fasteners
        screw_pattern_coordinates() {
            // Main thread pass-through shaft
            translate([0, 0, -1])
                cylinder(h = bridge_height + 2, d = bridge_screw_hole_dia);
                
            // Conical 90-degree countersink cut out of the bottom face (Z=0 when right-side up)
            cs_height = (countersink_dia - bridge_screw_hole_dia) / 2;
            translate([0, 0, -0.1])
                cylinder(h = cs_height + 0.1, d1 = countersink_dia, d2 = bridge_screw_hole_dia);
        }
    }
}

// REFINED: Positions 4 screw channels perfectly centered within the thick lower solid walls
module screw_pattern_coordinates() {
    tower_outer_dia = ear_span + (shell_wall * 2);
    internal_core_dia = portafilter_dia - 8;
    
    // Calculate the exact midpoint circle between the outer wall and the internal bore line
    centered_radius = (internal_core_dia / 2) + ((tower_outer_dia - internal_core_dia) / 4);
    
    // Symmetrical 45-degree corner offset array to tuck screws clear of the wide ear tracks
    rotate([0, 0, 45])  translate([centered_radius, 0, 0]) children();
    rotate([0, 0, 135]) translate([centered_radius, 0, 0]) children();
    rotate([0, 0, 225]) translate([centered_radius, 0, 0]) children();
    rotate([0, 0, 315]) translate([centered_radius, 0, 0]) children();
}

