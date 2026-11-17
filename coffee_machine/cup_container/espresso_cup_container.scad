// =============================================================================
// OpenSCAD Parametric Container, Flush Threaded Lid & 2 Separator Sleeves
// For 2 Cafe-Style Glass Espresso Cups
// =============================================================================
// Features:
// - Lower section tapers to match the glass cup angle (42 mm bottom to 58 mm top).
// - Mating outer diameter is exactly 58 mm at 28 mm from the container base.
// - Upper cylinder matches the outer diameter (68.7 mm) with zero-thickness-safe revolve.
// - Flush-Fit Trapezoidal Coarse Thread via BOSL2 (2-start, 6mm pitch).
// - Matching recessed vertical grip flutes on BOTH the lid and the container cylinder.
// - Extra thick plastic above the thread (4.75 mm wall, 5.0 mm solid roof) for maximum strength.
// - Lid is oriented UPSIDE DOWN on the build plate for beautiful bed texture & support-free printing.
// - TWO thin-walled protective separator sleeves (40 mm tall) with large center holes
//   leaving small support rings for the cup rims (saves weight, zero vacuum lock).
// - 4 components arranged in a compact, balanced SQUARE layout on the build plate.
// =============================================================================

include <../../lib/BOSL2/std.scad>;
include <../../lib/BOSL2/threading.scad>;

/* [Part Selection] */
// What part to generate or inspect:
part = "all"; // [all: All 4 Components in Square Grid, container: Container Only, lid: Threaded Lid Only (upside down), sleeve: Single Sleeve Only, sleeves: Two Sleeves Side-by-Side, cutaway: Cutaway Cross-Section with Lid Closed]

// Show semi-transparent ghost preview of the 2 espresso glasses (F5 Preview only)
show_glasses = true;

/* [Glass Dimensions] */
glass_top_dia       = 58.0;  // Top outer diameter of the glass (mm)
glass_bot_dia       = 42.0;  // Bottom outer diameter of the glass (mm)
glass_height        = 70.0;  // Total height of a single glass (mm)

/* [Mating Requirements] */
mating_z            = 28.0;  // Height from outer bottom to mating location (mm)
mating_od           = 58.0;  // Target container outer diameter at mating_z (mm)

/* [Cup Stacking & Heights] */
// Total measured height of the two glasses when stacked together with the separator sleeve:
total_glasses_stack_height = 120.0; // Total height of stacked cups with separator (mm)

/* [Container Wall Thickness & Tolerances] */
// Mathematical derivation of optimal wall thickness:
// Taper slope = (58 - 42) / 70 = 16 / 70 ≈ 0.22857 mm dia / mm height
// Glass diameter at z = 28 mm: 42 + 28 * (16/70) = 48.4 mm
// Optimal radial wall thickness = (OD_mating - Glass_dia_at_28) / 2
//                                = (58.0 - 48.4) / 2 = 4.8 mm
optimal_wall_thickness = (mating_od - (glass_bot_dia + mating_z * ((glass_top_dia - glass_bot_dia) / glass_height))) / 2;

use_computed_thickness = true; // Use exact calculated 4.8 mm wall thickness
custom_wall_thickness  = 4.8;  // Manual override if use_computed_thickness is false

wall_thickness = use_computed_thickness ? optimal_wall_thickness : custom_wall_thickness;
base_thickness = wall_thickness; // Base floor thickness equals wall thickness (4.8 mm)

// 3D printing fit clearance (radial clearance between glass and container inner wall)
fit_clearance   = 1.4;   // Radial clearance (mm)
base_hole_dia   = 20.0;  // Center finger push-out hole diameter in container base (0 for solid)

/* [Flush Trapezoidal Thread Parameters] */
thread_pitch        = 6.0;   // Coarse pitch (mm per revolution)
thread_turns        = 2.5;   // Number of thread turns (engagement height = 15.0 mm)
thread_depth        = 1.2;   // Tooth depth (mm)
thread_angle        = 30;    // Included angle between thread flanks (degrees, BOSL2 trapezoidal)
thread_clearance    = 0.35;  // Radial clearance between male/female threads for smooth gliding
thread_starts       = 2;     // 2-start thread for balanced, instant engagement
neck_wall_min       = 1.35;  // Neck wall thickness at thread root (mm, ~4 solid perimeters)
lid_roof_thickness  = 5.0;   // Thick solid roof on the lid (sits on bed for plate texture) (mm)

/* [Tactile Grip Flutes (Lid & Container)] */
num_grip_flutes     = 18;    // Number of recessed tactile grip flutes around perimeter
flute_radius        = 1.3;   // Radius of flute cutouts (mm)
container_flute_h   = 22.0;  // Height of grip flutes on container cylinder (mm)
lid_flute_h         = 8.0;   // Height of grip flutes on lid (mm)

/* [Separator Sleeve Parameters] */
sleeve_height         = 40.0;  // Height of separator sleeve (mm)
sleeve_wall_thickness = 1.2;   // Thin wall thickness (mm, ~3 perimeters)
sleeve_base_thickness = 1.2;   // Base shelf thickness (mm)
sleeve_hole_dia       = 35.0;  // Large hole in sleeve base (leaves a small support ring, 0 for solid)
sleeve_clearance      = 0.2;   // Fit clearance on glass cup (mm)
sleeve_rim_chamfer    = 0.5;   // Entry chamfer at top of sleeve (mm)

/* [Square Bed Layout Spacing] */
square_grid_spacing   = 16.0;  // Minimum spacing between adjacent components on the print bed (mm)

/* [Mesh Resolution] */
$fn = 120; // Clean facet resolution (optimal for fast rendering and smooth threads)

// =============================================================================
// DERIVED GEOMETRY CALCULATIONS
// =============================================================================
taper_slope = (glass_top_dia - glass_bot_dia) / glass_height; // 16/70 ≈ 0.22857

// Container bottom outer diameter (at z = 0)
od_bottom = mating_od - (mating_z * taper_slope); // 58 - 28*(16/70) = 51.6 mm

// Height where inside diameter reaches 58 mm (top of 1st glass)
z_transition = base_thickness + glass_height; // 4.8 + 70 = 74.8 mm

// Outer diameter of container cylinder
od_transition = od_bottom + (z_transition * taper_slope); // 68.697 mm
od_cylinder   = od_transition; 
id_cylinder   = glass_top_dia + 2 * fit_clearance;        // 58.8 mm

// Radius shortcuts
r_out = od_cylinder / 2; // 34.348 mm
r_in  = id_cylinder / 2; // 29.400 mm

// Glass 2 rim elevation inside container
cup2_top_z = base_thickness + total_glasses_stack_height; // 4.8 + 120 = 124.8 mm

// Threaded Neck & Shoulder Geometry
h_thread = thread_pitch * thread_turns; // 15.0 mm thread length
z_shoulder = 105.0; // Height of container shoulder where lid seats flush
z_neck_top = z_shoulder + h_thread; // 120.0 mm (cup sticks out 4.8mm above neck for easy grabbing)

// Center elevation for container grip flutes (centered in the 74.8 - 105.0 mm cylindrical span)
container_flute_z = (z_transition + z_shoulder) / 2; // 89.9 mm

// Thread radial dimensions
r_neck_root  = r_in + neck_wall_min;                 // 29.4 + 1.35 = 30.75 mm
r_male_crest = r_neck_root + thread_depth;           // 30.75 + 1.2 = 31.95 mm
r_lid_major  = r_male_crest + thread_clearance;      // 31.95 + 0.35 = 32.30 mm
lid_wall_at_thread = r_out - r_lid_major;            // 34.35 - 32.30 = 2.05 mm solid wall

// Plastic thickness ABOVE the thread:
// Cup rim is 58.0 mm. Sizing pocket to r = 29.6 mm (D = 59.2 mm) gives generous clearance for the cup
r_pocket = 29.60;
lid_wall_above_thread = r_out - r_pocket;            // 34.35 - 29.60 = 4.75 mm SOLID HEAVY-DUTY WALL

// Flush Lid Dimensions
cup_reveal_in_lid = max(0, cup2_top_z - z_neck_top + 1.0); // 5.8 mm pocket depth above threads
lid_total_height  = h_thread + cup_reveal_in_lid + lid_roof_thickness; // ~ 25.8 mm total lid height

// Separator sleeve derived dimensions
sleeve_id_bot = glass_bot_dia + 2 * sleeve_clearance;
sleeve_id_top = glass_bot_dia + (sleeve_height * taper_slope) + 2 * sleeve_clearance;
sleeve_od_bot = sleeve_id_bot + 2 * sleeve_wall_thickness;
sleeve_od_top = sleeve_id_top + 2 * sleeve_wall_thickness;
sleeve_ring_width = (sleeve_id_bot - sleeve_hole_dia) / 2; // Width of annular base ring

// 2x2 Square Grid Center-to-Center Pitch:
grid_pitch = od_cylinder + square_grid_spacing; // ~ 84.7 mm
gx = grid_pitch / 2; // ± 42.35 mm from origin
gy = grid_pitch / 2; // ± 42.35 mm from origin

// Console diagnostics
echo("==================================================");
echo(str("Container Bottom OD:        ", od_bottom, " mm"));
echo(str("Mating OD (at z = 28mm):    ", mating_od, " mm"));
echo(str("Taper Transition z:         ", z_transition, " mm"));
echo(str("Cylinder OD (Container&Lid):", od_cylinder, " mm"));
echo(str("Container Shoulder z:       ", z_shoulder, " mm"));
echo(str("Thread Profile:             BOSL2 Trapezoidal (", thread_angle, "° flanks)"));
echo(str("Thread Depth:               ", thread_depth, " mm"));
echo(str("Neck Wall Thickness (root): ", neck_wall_min, " mm"));
echo(str("Lid Wall at Thread Root:    ", lid_wall_at_thread, " mm"));
echo(str("Lid Wall ABOVE Thread:      ", lid_wall_above_thread, " mm (Solid Heavy-Duty Plastic)"));
echo(str("Lid Roof Thickness:         ", lid_roof_thickness, " mm (Solid Plate Surface)"));
echo(str("Grip Flute Depth:           ", flute_radius, " mm"));
echo(str("Wall Behind Flute:          ", lid_wall_above_thread - flute_radius, " mm (Solid Plastic)"));
echo(str("Total Lid Height:           ", lid_total_height, " mm"));
echo(str("Lid Print Orientation:      UPSIDE DOWN (flat top roof on z=0 for bed texture)"));
echo(str("Square Grid Footprint:      ", grid_pitch + od_cylinder, " x ", grid_pitch + od_cylinder, " mm"));
echo("==================================================");

// =============================================================================
// RECESSED GRIP FLUTE CUTTER
// =============================================================================
// Smooth rounded ends for comfortable tactile grip and beautiful print aesthetics
module flute_cutter(h, r) {
    hull() {
        translate([0, 0, h / 2 - r]) sphere(r = r, $fn = 16);
        translate([0, 0, -(h / 2 - r)]) sphere(r = r, $fn = 16);
    }
}

// =============================================================================
// TRAPEZOIDAL THREAD (BOSL2)
// =============================================================================
module male_thread() {
    trapezoidal_threaded_rod(
        d = r_male_crest * 2,
        l = h_thread,
        pitch = thread_pitch,
        thread_angle = thread_angle,
        thread_depth = thread_depth,
        starts = thread_starts,
        blunt_start = true,
        bevel = false,
        anchor = BOTTOM
    );
}

module female_thread_cavity() {
    trapezoidal_threaded_rod(
        d = (r_neck_root + thread_clearance) * 2,
        l = h_thread + 1.0,
        pitch = thread_pitch,
        thread_angle = thread_angle,
        thread_depth = thread_depth,
        starts = thread_starts,
        internal = true,
        blunt_start = true,
        bevel = false,
        anchor = BOTTOM
    );
}

// =============================================================================
// CONTAINER BODY MODULE (With Cylindrical Section Grip Flutes)
// =============================================================================
module container_body() {
    difference() {
        union() {
            // 1. Revolved main body from base up to shoulder (zero-thickness-safe)
            profile_to_shoulder = [
                [base_hole_dia / 2, 0],
                [od_bottom / 2, 0],
                [r_out, z_transition],
                [r_out, z_shoulder],
                [r_neck_root, z_shoulder],
                [r_in, z_shoulder],
                [r_in, z_transition],
                [glass_bot_dia / 2 + fit_clearance, base_thickness],
                [base_hole_dia / 2, base_thickness]
            ];
            rotate_extrude() polygon(profile_to_shoulder);
            
            // 2. Threaded neck extending above shoulder
            translate([0, 0, z_shoulder]) {
                difference() {
                    male_thread();
                    // Internal through-bore
                    translate([0, 0, -1])
                        cylinder(h = h_thread + 2, d = id_cylinder);
                    // Entry chamfer on top inner rim
                    translate([0, 0, h_thread - 1.0])
                        cylinder(h = 1.1, d1 = id_cylinder, d2 = id_cylinder + 2.0);
                    // Exterior lead-in chamfer on top rim of male thread
                    translate([0, 0, h_thread - 1.0])
                        difference() {
                            cylinder(h = 1.1, d = r_male_crest * 2 + 2.0);
                            cylinder(h = 1.2, d1 = r_male_crest * 2 - 2.0, d2 = r_neck_root * 2);
                        }
                }
            }
        }
        
        // 3. Recessed grip flutes placed strictly in the cylindrical section
        if (num_grip_flutes > 0) {
            for (i = [0 : num_grip_flutes - 1]) {
                rotate([0, 0, i * (360 / num_grip_flutes)])
                    translate([r_out, 0, container_flute_z])
                        flute_cutter(container_flute_h, flute_radius);
            }
        }
    }
}

// =============================================================================
// FLUSH THREADED LID MODULE (Print-Optimized: Flat Top Roof on Build Plate)
// =============================================================================
// Thick 4.75 mm wall and 5.0 mm solid roof above the thread guarantee zero breakthrough.
module flush_lid() {
    difference() {
        // Outer cylinder (exact same outer diameter as container: 68.7 mm)
        cylinder(h = lid_total_height, d = od_cylinder);
        
        // Matching recessed vertical grip flutes with rounded ends
        if (num_grip_flutes > 0) {
            for (i = [0 : num_grip_flutes - 1]) {
                rotate([0, 0, i * (360 / num_grip_flutes)])
                    translate([r_out, 0, lid_roof_thickness + flute_height_target()])
                        flute_cutter(lid_flute_h, flute_radius);
            }
        }
        
        // Cup pocket (D = 59.2 mm, leaving 4.75 mm solid wall above the thread!)
        translate([0, 0, lid_roof_thickness - 0.1])
            cylinder(h = cup_reveal_in_lid + 0.2, r = r_pocket);
            
        // 45° internal transition bevel from pocket to thread cavity
        translate([0, 0, lid_roof_thickness + cup_reveal_in_lid - 1.0])
            cylinder(h = 1.1, r1 = r_pocket, r2 = r_neck_root + thread_clearance);
            
        // Thread cavity (opens up to top of lid)
        translate([0, 0, lid_roof_thickness + cup_reveal_in_lid])
            female_thread_cavity();
            
        // Lead-in entry chamfer at open rim
        translate([0, 0, lid_total_height - 1.5])
            cylinder(h = 1.6, r1 = r_neck_root, r2 = r_lid_major + 0.5);
    }
}

// Helper for flute vertical placement in lid
function flute_height_target() = lid_flute_h / 2 + 1.0;

// =============================================================================
// PROTECTIVE SEPARATOR SLEEVE MODULE (With Large Base Hole & Support Ring)
// =============================================================================
module separator_sleeve() {
    r_sleeve_hole = sleeve_hole_dia / 2;
    
    sleeve_profile = [
        [r_sleeve_hole, 0],
        [sleeve_od_bot / 2, 0],
        [sleeve_od_top / 2, sleeve_height],
        [sleeve_id_top / 2 + sleeve_rim_chamfer, sleeve_height],
        [sleeve_id_top / 2, sleeve_height - sleeve_rim_chamfer],
        [sleeve_id_bot / 2, sleeve_base_thickness],
        [r_sleeve_hole, sleeve_base_thickness]
    ];
    
    rotate_extrude() polygon(sleeve_profile);
}

// =============================================================================
// GHOST VISUALIZER OF CUPS & SLEEVE (Preview Only)
// =============================================================================
module ghost_assembly() {
    // Cup 1 (resting on container floor)
    color([0.2, 0.6, 1.0, 0.35])
        translate([0, 0, base_thickness])
            cylinder(h = glass_height, d1 = glass_bot_dia, d2 = glass_top_dia);

    // Separator sleeve sitting on Cup 2 bottom
    color([1.0, 0.5, 0.2, 0.7])
        translate([0, 0, base_thickness + (total_glasses_stack_height - glass_height) - sleeve_base_thickness])
            separator_sleeve();

    // Cup 2 (nested inside Cup 1 and inside separator sleeve)
    color([0.2, 0.6, 1.0, 0.35])
        translate([0, 0, base_thickness + (total_glasses_stack_height - glass_height)])
            cylinder(h = glass_height, d1 = glass_bot_dia, d2 = glass_top_dia);
}

// =============================================================================
// MAIN ASSEMBLY & VIEW SELECTION
// =============================================================================

if (part == "all") {
    // -------------------------------------------------------------------------
    // 2x2 SQUARE GRID LAYOUT (Print Bed Centered)
    // -------------------------------------------------------------------------
    // Top-Left: Container Body (with cylindrical grip flutes)
    translate([-gx, gy, 0]) {
        container_body();
        if ($preview && show_glasses) ghost_assembly();
    }

    // Top-Right: Flush Threaded Lid (upside down for plate texture)
    translate([gx, gy, 0])
        flush_lid();

    // Bottom-Left: Separator Sleeve 1
    translate([-gx, -gy, 0])
        separator_sleeve();

    // Bottom-Right: Separator Sleeve 2
    translate([gx, -gy, 0])
        separator_sleeve();

} else if (part == "container") {
    container_body();
    if ($preview && show_glasses) ghost_assembly();

} else if (part == "lid") {
    // Lid ready for slicing: flat top roof on z = 0 for build-plate texture
    flush_lid();

} else if (part == "sleeve") {
    // Single sleeve centered
    separator_sleeve();
    if ($preview && show_glasses) {
        color([0.2, 0.6, 1.0, 0.35])
            translate([0, 0, sleeve_base_thickness])
                cylinder(h = glass_height, d1 = glass_bot_dia, d2 = glass_top_dia);
    }

} else if (part == "sleeves") {
    // Two sleeves side-by-side
    translate([-(sleeve_od_top / 2 + 6), 0, 0])
        separator_sleeve();
    translate([(sleeve_od_top / 2 + 6), 0, 0])
        separator_sleeve();

} else if (part == "cutaway") {
    // 3/4 cutaway of the fully assembled container with flush lid screwed down on neck
    difference() {
        union() {
            container_body();
            // Invert lid onto container neck
            translate([0, 0, z_shoulder + lid_total_height])
                rotate([180, 0, 0])
                    flush_lid();
        }
        // 90° cutaway wedge
        translate([0, -150, -1])
            cube([150, 300, z_shoulder + lid_total_height + 5]);
    }
    if ($preview && show_glasses) ghost_assembly();
}
