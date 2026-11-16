# Parametric Espresso Cup Container, Flush Threaded Lid & 2 Separator Sleeves

A 3D-printable container, flush screw-on lid, and two protective separator sleeves designed in OpenSCAD to hold two classic cafe-style glass espresso cups.

---

## 1. Specifications & Design Criteria

| Feature | Dimension / Specification | Notes |
| :--- | :--- | :--- |
| **Glass Top Diameter** | $58.0\text{ mm}$ | Outer rim of glass |
| **Glass Bottom Diameter** | $42.0\text{ mm}$ | Outer base of glass |
| **Glass Height** | $70.0\text{ mm}$ | Height of a single cup |
| **Mating Location ($z$)** | $28.0\text{ mm}$ | Distance from bottom of container |
| **Mating Outer Diameter** | $58.0\text{ mm}$ | Target outer diameter at $z = 28\text{ mm}$ |
| **Lower Profile** | Smooth Taper | Matches glass taper angle down to container base |
| **Upper Cylinder Profile** | $OD = 68.70\text{ mm}$ | Internal diameter matches top of glass ($58.0\text{ mm}$ + clearance) |
| **Tactile Grips** | **Matching Flutes** | 18 recessed vertical flutes on both the Lid and Container cylinder |
| **Lid Wall Thickness** | **$4.55\text{ mm}$ Solid Wall** | Prevents flute breakthrough; $3.25\text{ mm}$ solid plastic behind flutes |
| **Total Stack Height** | $120.0\text{ mm}$ | Height of both glasses stacked together with separator |
| **Lid Design** | Option 2 Flush-Fit | Screws onto neck and seats flush with container outer cylinder |
| **Print Orientation** | Container upright; lid upside down | Print with supports disabled; thread flanks are shaped for support-free printing |
| **Thread Type** | **50/50 Trapezoidal Coarse Thread** | $6.0\text{ mm}$ pitch, $1.2\text{ mm}$ tooth depth, balanced 50% tooth / 50% groove |
| **Separator Sleeves** | **2 Sleeves** ($40.0\text{ mm}$ tall) | Thin-walled ($1.2\text{ mm}$), large $35\text{ mm}$ center hole with $3.7\text{ mm}$ support ring |
| **Print Bed Arrangement** | **2x2 Square Grid** | $153\text{ mm} \times 153\text{ mm}$ footprint, fits all standard build plates |

---

## 2. Mathematical Derivation of Wall Thickness

The optimal container wall thickness is geometrically determined by the glass taper rate and the specified mating condition:

### A. Taper Slope
The taper rate (diameter change per unit of vertical height) is:
$$\text{Slope}_d = \frac{D_{\text{top}} - D_{\text{bot}}}{H_{\text{glass}}} = \frac{58\text{ mm} - 42\text{ mm}}{70\text{ mm}} = \frac{16}{70} = \frac{8}{35} \approx 0.228571\text{ mm/mm}$$

Half-angle taper:
$$\theta = \arctan\left(\frac{8}{70}\right) \approx 6.52^\circ$$

### B. Glass Diameter at Mating Height ($z = 28\text{ mm}$)
At $28\text{ mm}$ from the base:
$$D_{\text{glass}}(28) = 42\text{ mm} + \left(28\text{ mm} \times \frac{16}{70}\right) = 42\text{ mm} + 6.4\text{ mm} = 48.4\text{ mm}$$

### C. Optimal Wall Thickness ($t$)
The mating requirement specifies an outer diameter of $58.0\text{ mm}$ at $z = 28\text{ mm}$. The radial wall thickness is half the difference between container outer diameter and glass diameter:
$$t = \frac{OD_{\text{mate}} - D_{\text{glass}}(28)}{2} = \frac{58.0\text{ mm} - 48.4\text{ mm}}{2} = \frac{9.6\text{ mm}}{2} = \mathbf{4.8\text{ mm}}$$

This computed thickness of **$4.8\text{ mm}$** is used uniformly for:
- The tapered container walls
- The base floor
- The main cylindrical walls

### D. Derived Key Dimensions
* **Container Bottom Outer Diameter ($z = 0$)**:
  $$OD(0) = OD(28) - \left(28\text{ mm} \times \frac{16}{70}\right) = 58.0\text{ mm} - 6.4\text{ mm} = \mathbf{51.6\text{ mm}}$$

* **Taper Transition Height ($z_{\text{trans}}$)**:
  With base floor thickness $t_{\text{base}} = 4.8\text{ mm}$ and glass height $70.0\text{ mm}$, the inside diameter reaches $58.0\text{ mm}$ at:
  $$z_{\text{trans}} = t_{\text{base}} + H_{\text{glass}} = 4.8\text{ mm} + 70.0\text{ mm} = \mathbf{74.8\text{ mm}}$$

* **Outer Cylinder Diameter (Container & Flush Lid)**:
  $$OD_{\text{cyl}} = OD(0) + \left(74.8\text{ mm} \times \frac{16}{70}\right) = 51.6\text{ mm} + 17.097\text{ mm} = \mathbf{68.70\text{ mm}}$$

---

## 3. Lid Pocket Wall Geometry & Zero-Breakthrough Fix

### Root Cause of the Previous Breakthrough
* The top of the lid includes an unthreaded interior pocket to accommodate the $4.8\text{ mm}$ rim of the top cup that extends above the container neck.
* In the previous revision, this pocket diameter was oversized to $65.4\text{ mm}$ (the thread clearance diameter), which reduced the lid wall thickness at that region to only $1.65\text{ mm}$.
* Because the exterior grip flutes cut $1.8\text{ mm}$ deep, they punched through the $1.65\text{ mm}$ wall, leaving small holes into the pocket.

### The Fix
1. **Accurate Pocket Sizing**: The glass cup rim is $58.0\text{ mm}$. Sizing the internal pocket to $D_{\text{pocket}} = 59.6\text{ mm}$ provides generous clearance while increasing the lid wall thickness in that section from $1.65\text{ mm}$ to **$4.55\text{ mm}$**.
2. **Flute Depth & Solid Margin**: Grip flutes are cut to $1.3\text{ mm}$ depth, leaving **$3.25\text{ mm}$ of continuous, solid plastic behind every flute**.
3. **Smooth Transition**: A $45^\circ$ internal bevel smoothly connects the $59.6\text{ mm}$ pocket to the thread cavity.
4. **Topological Closure**: STL verification confirms Euler characteristic $\chi = 2$ with zero boundary or non-manifold edges. The lid is 100% airtight and solid.

---

## 4. 50/50 Trapezoidal Coarse Thread Architecture

The container and lid feature a symmetrical **50/50 Acme-style trapezoidal thread form**, eliminating narrow/thin thread vanes in favor of balanced, thick, high-strength teeth:

### A. Balanced 50/50 Geometry
* **Tooth Width**: Exactly 50% of the thread cycle along the pitch line ($3.0\text{ mm}$ on a $6.0\text{ mm}$ pitch).
* **Groove Width**: Exactly 50% of the thread cycle along the pitch line ($3.0\text{ mm}$).
* **Flat Crests and Roots**: Narrow $0.2\text{ mm}$ plateaus preserve a 50/50 tooth-to-groove profile while allowing shallower, support-free flanks.
* **Support-Free Flank Slopes**: The thread flanks use a 156° ramp in the helical profile, giving a maximum overhang of about 42.7° from vertical at the default 1.2 mm tooth depth. Print the container upright with supports disabled.
* **Tooth Strength**: Eliminates thin, fragile vanes. Both male (container) and female (lid) threads have equal bulk and massive shear strength.

### B. 2-Start Fast Action
* **Pitch**: $6.0\text{ mm}$ per revolution (only **2.5 turns** to fully lock or release).
* **Dual Starts**: Two independent thread entry points spaced 180° apart ensure instant, cross-thread-free engagement.
* **Radial Clearance**: $0.35\text{ mm}$ uniform radial clearance between male and female profiles ensures smooth operation straight off the print bed without binding.

### C. Wall Distribution & Structural Strength
Across the $4.95\text{ mm}$ cylinder wall thickness:
* **Lid outer wall thickness**: $2.05\text{ mm}$ minimum at thread root ($4.55\text{ mm}$ at cup pocket).
* **Neck wall thickness**: $1.35\text{ mm}$ minimum at thread root ($2.55\text{ mm}$ at thread crest).
* **Shoulder stop**: $2.15\text{ mm}$ annular shoulder providing a solid mechanical stop.

---

## 5. Thin Plastic Separator Sleeves (x2)

The design includes **two identical protective sleeves** ($40.0\text{ mm}$ tall) to completely cushion the glasses:
- **Sleeve 1**: Cushions the bottom of Cup 1 against the container floor and lower taper.
- **Sleeve 2**: Cushions Cup 2 nested inside Cup 1.

### Features
* **Height**: $40.0\text{ mm}$.
* **Wall Thickness**: $1.2\text{ mm}$ (thin-walled, 3 solid perimeters with a 0.4 mm nozzle).
* **Base Shelf**: $1.2\text{ mm}$ thick.
* **Large Base Hole**: $35.0\text{ mm}$ diameter center cutout.
* **Annular Support Ring**: A $3.7\text{ mm}$ wide inward shelf (total $4.9\text{ mm}$ with wall) that securely supports the bottom rim of the glass cup.
* **Zero Suction**: The open bottom ring allows air to pass freely, eliminating any vacuum seal.

---

## 6. 2x2 Square Bed Layout (part = "all")

All 4 components are centered on the print bed in a balanced **square grid**:

```
                  2x2 SQUARE PRINT BED LAYOUT (part = "all")
                 
                 [-42, +42]                             [+42, +42]
          +-----------------------+              +-----------------------+
          |                       |              |                       |
          |  MAIN CONTAINER BODY  |              |  FLUSH THREADED LID   |
          |  (Cylindrical Flutes) |              |  (Matching Flutes)    |
          |  (OD = 68.7 mm)       |              |  (Upside Down on Bed) |
          +-----------------------+              +-----------------------+
          
                 [-42, -42]                             [+42, -42]
          +-----------------------+              +-----------------------+
          |                       |              |                       |
          |  SEPARATOR SLEEVE 1   |              |  SEPARATOR SLEEVE 2   |
          |  (OD = 53.9 mm)       |              |  (OD = 53.9 mm)       |
          |  (35mm Center Hole)   |              |  (35mm Center Hole)   |
          +-----------------------+              +-----------------------+

          Footprint: ~153 mm x 153 mm (Fits 180x180 mm and larger beds)
```

---

## 7. OpenSCAD Parameter Reference

| Variable | Default | Description |
| :--- | :--- | :--- |
| `part` | `"all"` | Output: `"all"`, `"container"`, `"lid"`, `"sleeve"`, `"sleeves"`, `"cutaway"` |
| `total_glasses_stack_height` | `120.0` | Total height of both glasses stacked with separator (mm) |
| `show_glasses` | `true` | Show semi-transparent preview of the 2 cups (F5 preview only) |
| `glass_top_dia` | `58.0` | Top outer rim diameter of glass (mm) |
| `glass_bot_dia` | `42.0` | Bottom outer diameter of glass (mm) |
| `glass_height` | `70.0` | Height of a single glass (mm) |
| `mating_z` | `28.0` | Vertical position of mating diameter from container base (mm) |
| `mating_od` | `58.0` | Target outer diameter at `mating_z` (mm) |
| `fit_clearance` | `0.4` | Container inner wall radial fit clearance (mm) |
| `base_hole_dia` | `20.0` | Container center push-out hole diameter (`0` = solid bottom) |
| `thread_pitch` | `6.0` | Coarse thread pitch (mm per turn) |
| `thread_turns` | `2.5` | Thread engagement turns (15.0 mm engagement) |
| `thread_depth` | `1.2` | Thread tooth depth (mm, 45° overhang) |
| `thread_clearance` | `0.35` | Radial clearance between male and female threads (mm) |
| `neck_wall_min` | `1.35` | Neck wall thickness at thread root (mm) |
| `lid_roof_thickness` | `3.5` | Top roof thickness of lid (mm) |
| `num_grip_flutes` | `18` | Number of recessed vertical grip flutes on lid & container |
| `container_flute_h` | `22.0` | Vertical height of container grip flutes (mm) |
| `lid_flute_h` | `8.0` | Vertical height of lid grip flutes (mm) |
| `flute_radius` | `1.3` | Radius of flute cutouts with rounded ends (mm) |
| `sleeve_height` | `40.0` | Height of separator sleeve (mm) |
| `sleeve_wall_thickness` | `1.2` | Sleeve wall thickness (mm) |
| `sleeve_base_thickness` | `1.2` | Sleeve base shelf thickness (mm) |
| `sleeve_hole_dia` | `35.0` | Large center hole in sleeve base (leaves $3.7\text{ mm}$ ring) |
| `sleeve_clearance` | `0.2` | Fit clearance between sleeve and glass (mm) |
| `square_grid_spacing` | `16.0` | Minimum spacing between adjacent components on bed (mm) |
| `$fn` | `60` | Circular polygon facet resolution |

---

## 8. CLI Export Commands

```bash
# Export all 4 parts in Square Layout to a single STL:
openscad -D 'part="all"' -o all_4_parts_square.stl espresso_cup_container.scad

# Export Flush Lid only (completely solid, no breakthrough, upside down on z = 0):
openscad -D 'part="lid"' -o flush_lid.stl espresso_cup_container.scad

# Export Container Body only (with cylindrical grip flutes & 50/50 threads):
openscad -D 'part="container"' -o container_body.stl espresso_cup_container.scad

# Export both Separator Sleeves side-by-side:
openscad -D 'part="sleeves"' -o two_separator_sleeves.stl espresso_cup_container.scad

# Export Cutaway view with lid closed for internal inspection:
openscad -D 'part="cutaway"' -o cutaway_closed.stl espresso_cup_container.scad
```
