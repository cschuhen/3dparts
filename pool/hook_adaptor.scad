// ==========================================
// WyBot Hook to Standard Pool Pole Adapter
// ==========================================

/* [Main Cylinder (Fits over Pool Pole)] */
main_cylinder_len = 105;              // Not including taper (mm)
main_cylinder_internal_diameter = 32; // (mm)
mc_hole_1_pos = 16;                   // From open end of main cylinder (mm)
mc_hole_1_diameter = 8;               // (mm)
mc_hole_2_pos = 91;                   // From open end of main cylinder (mm)
mc_hole_2_diameter = 6;               // (mm)

/* [Secondary Cylinder (Accepts WyBot Hook)] */
secondary_cylinder_len = 75;          // Not including taper (mm)
secondary_cylinder_diameter = 30;     // Internal socket diameter (mm)
sc_hole_1_pos = 15;                   // From open end of secondary cylinder (mm)
sc_hole_1_diameter = 6;               // (mm)

/* [General & Taper Settings] */
wall_thickness = 3;                   // (mm)
taper_len = 15;                       // Transition length between cylinders (mm)
$fn = 96;                             // Smoothness of curves

// ==========================================
// Calculated Dimensions
// ==========================================
mc_id = main_cylinder_internal_diameter;
mc_od = mc_id + (wall_thickness * 2);

sc_id = secondary_cylinder_diameter;
sc_od = sc_id + (wall_thickness * 2);

total_len = main_cylinder_len + taper_len + secondary_cylinder_len;
eps = 0.02; // Tiny overlap to prevent coplanar Z-fighting artifacts

// ==========================================
// Helper Modules
// ==========================================
module cross_hole(z_pos, hole_dia, outer_dia) {
    translate([0, 0, z_pos])
        rotate([0, 90, 0])
            cylinder(h = outer_dia + 10, d = hole_dia, center = true);
}

// ==========================================
// Main Geometry
// ==========================================
difference() {
    // 1. Outer Shell
    union() {
        // Main cylinder (Bottom: Z = 0 to main_cylinder_len)
        cylinder(h = main_cylinder_len + eps, d = mc_od);
        
        // Taper transition
        translate([0, 0, main_cylinder_len])
            cylinder(h = taper_len + eps, d1 = mc_od, d2 = sc_od);
            
        // Secondary cylinder (Top)
        translate([0, 0, main_cylinder_len + taper_len])
            cylinder(h = secondary_cylinder_len, d = sc_od);
    }
    
    // 2. Inner Hollow Core (overlapped by 'eps' for clean manifold cuts)
    union() {
        // Main inner bore
        translate([0, 0, -0.1])
            cylinder(h = main_cylinder_len + 0.1 + eps, d = mc_id);
            
        // Inner taper transition
        translate([0, 0, main_cylinder_len])
            cylinder(h = taper_len + eps, d1 = mc_id, d2 = sc_id);
            
        // Secondary inner bore
        translate([0, 0, main_cylinder_len + taper_len])
            cylinder(h = secondary_cylinder_len + 0.1, d = sc_id);
    }
    
    // 3. Through-Holes (cuts opposing walls simultaneously)
    // Main Cylinder Holes (measured from Z = 0)
    cross_hole(mc_hole_1_pos, mc_hole_1_diameter, mc_od);
    cross_hole(mc_hole_2_pos, mc_hole_2_diameter, mc_od);
    
    // Secondary Cylinder Hole (measured from top open end)
    cross_hole(total_len - sc_hole_1_pos, sc_hole_1_diameter, sc_od);
}

