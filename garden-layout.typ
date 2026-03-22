#import "@preview/cetz:0.4.2"
#set page(width: 297mm, height: 210mm, margin: 1cm, flipped: false)
#set text(font: "Lato", size: 9pt)

// ============================================================
// Garden Drip Irrigation System — Layout Diagram
// ============================================================
// Coordinate system: X = right, Y = up
// Origin (0, 0) = water tap position
// All coordinates in METERS (1 unit = 1m = 100cm)
// ============================================================

// --- Color palette ---
#let c-pipe25 = rgb("#1565C0")     // 25mm main pipe
#let c-pipe16 = rgb("#42A5F5")     // 16mm secondary pipe
#let c-drip = rgb("#90CAF9")       // 16mm drip lines
#let c-bed-veg = rgb("#C8E6C9")    // vegetable beds
#let c-bed-flower = rgb("#F8BBD0") // flower beds
#let c-hedge = rgb("#8D6E63")      // hedge area (brown/earthy)
#let c-fitting = rgb("#FF8F00")    // T / elbow / reducer
#let c-endcap = rgb("#E53935")     // end caps
#let c-house = rgb("#BDBDBD")      // house wall

// --- Stroke presets ---
#let s-pipe25 = (paint: c-pipe25, thickness: 1.5pt)
#let s-pipe16 = (paint: c-pipe16, thickness: 1pt)
#let s-drip = (paint: c-drip, thickness: 1pt, dash: "dashed")
#let s-bed-veg = rgb("#4CAF50") + 0.5pt
#let s-bed-flower = rgb("#E91E63") + 0.5pt

// --- Bed data: (start-x, width-m, label, drip-line-offsets-m) ---
#let upper-beds = (
  (0,    1.04, "V1", (0.15, 0.52, 0.89)),
  (1.39, 1.51, "V2", (0.15, 0.55, 0.95, 1.36)),
  (3.25, 0.82, "V3", (0.26, 0.56)),
  (4.42, 1.48, "V4", (0.15, 0.54, 0.93, 1.33)),
  (6.25, 1.15, "V5", (0.15, 0.57, 1.00)),
  (7.75, 0.83, "V6", (0.265, 0.565)),
  (8.93, 1.41, "V7", (0.15, 0.52, 0.89, 1.26)),
)

#let bed-top = 8.2   // y of 25mm header pipe (540 + 280 = 820cm from tap)
#let bed-depth = 2.8  // 280cm

// --- Title ---
#align(center)[
  #text(size: 16pt, weight: "bold")[Garden Drip Irrigation System]
]
#v(0.3cm)

#cetz.canvas(length: 0.95cm, {
  import cetz.draw: *

  // ==========================================================
  // 1. BACKGROUND AREAS
  // ==========================================================


  // Hedge strip along x = -8
  rect((-8.25, -4.2), (-7.75, 10.0),
    fill: c-hedge.lighten(40%), stroke: c-hedge + 0.3pt)

  // ==========================================================
  // 2. VEGETABLE BEDS — Upper row (Beds 1–7)
  // ==========================================================

  // Draw bed rectangles and drip lines first
  let bed-gap = 0.2  // visual gap between supply pipe and bed top
  for bed in upper-beds {
    let (sx, w, name, lines) = bed
    let ex = sx + w
    let y-bot = bed-top - bed-depth

    // Bed rectangle with gap from supply pipe, extended to keep same size
    rect((sx + bed-gap, y-bot - bed-gap), (ex + bed-gap, bed-top - bed-gap),
      fill: c-bed-veg, stroke: s-bed-veg)

    // Drip lines shifted with bed
    for lx in lines {
      line((sx + lx + bed-gap, bed-top), (sx + lx + bed-gap, y-bot - bed-gap), stroke: s-drip)
      circle((sx + lx + bed-gap, y-bot - bed-gap), radius: 0.06, fill: c-endcap, stroke: none)
    }
  }

  // Draw labels in the middle of shifted bed rectangles
  for bed in upper-beds {
    let (sx, w, name, lines) = bed
    let y-bot = bed-top - bed-depth
    // Center of shifted box: x = sx + bed-gap + w/2, y = midpoint of (y-bot - bed-gap) to (bed-top - bed-gap)
    let cx = sx + bed-gap + w / 2
    let cy = (y-bot - bed-gap + bed-top - bed-gap) / 2

    content((cx, cy),
      text(size: 8pt, weight: "regular")[#name])
  }

  // Dimension lines below beds (shifted to match bed positions)
  let dim-y = bed-top - bed-depth - bed-gap - 0.4
  for bed in upper-beds {
    let (sx, w, name, lines) = bed
    let sx-shifted = sx + bed-gap
    let ex-shifted = sx + w + bed-gap
    // Tick marks
    line((sx-shifted, dim-y - 0.1), (sx-shifted, dim-y + 0.1), stroke: luma(150) + 0.5pt)
    line((ex-shifted, dim-y - 0.1), (ex-shifted, dim-y + 0.1), stroke: luma(150) + 0.5pt)
    // Dimension line
    line((sx-shifted, dim-y), (ex-shifted, dim-y), stroke: luma(150) + 0.5pt)
    // Label
    content((sx-shifted + w / 2, dim-y - 0.15), anchor: "north",
      text(size: 4pt, fill: luma(100))[#{ calc.round(w * 100) }])
  }

  // 270 and 530 dimensions — both on right side of main pipe, aligned with shifted beds
  let dim-pipe-x = -0.4
  let bed-top-shifted = bed-top - bed-gap
  let bed-bot-shifted = bed-top - bed-depth - bed-gap

  // 270: from top mainline (bed-top) to shifted bed bottom
  line((dim-pipe-x, bed-top), (dim-pipe-x, bed-bot-shifted), stroke: luma(150) + 0.5pt)
  line((dim-pipe-x - 0.1, bed-top), (dim-pipe-x + 0.1, bed-top), stroke: luma(150) + 0.5pt)
  line((dim-pipe-x - 0.1, bed-bot-shifted), (dim-pipe-x + 0.1, bed-bot-shifted), stroke: luma(150) + 0.5pt)
  content((dim-pipe-x - 0.15, (bed-top + bed-bot-shifted) / 2), anchor: "east",
    text(size: 4pt, fill: luma(100))[280])

  // Removable pipe section (540) from F1 top to bed bottom
  let f1-top-y = 0.515 + 0.75  // = 1.265
  line((dim-pipe-x, f1-top-y), (dim-pipe-x, bed-bot-shifted), stroke: luma(150) + 0.5pt)
  line((dim-pipe-x - 0.1, f1-top-y), (dim-pipe-x + 0.1, f1-top-y), stroke: luma(150) + 0.5pt)
  content((dim-pipe-x - 0.15, (f1-top-y + bed-bot-shifted) / 2), anchor: "east",
    text(size: 4pt, fill: luma(100))[540])

  // ==========================================================
  // 3. VEGETABLE BEDS — Top-right (R1 & R2)
  // ==========================================================

  let r-top = 10.1
  let r-depth = 4.52
  let r-bot = r-top - r-depth

  // V8: x = 12.44 → 13.64
  rect((12.44 + bed-gap, r-bot - bed-gap), (13.64 + bed-gap, r-top - bed-gap), fill: c-bed-veg, stroke: s-bed-veg)
  for lx in (0.15, 0.60, 1.05) {
    line((12.44 + lx + bed-gap, r-top), (12.44 + lx + bed-gap, r-bot - bed-gap), stroke: s-drip)
    circle((12.44 + lx + bed-gap, r-bot - bed-gap), radius: 0.06, fill: c-endcap, stroke: none)
  }
  content((13.04 + bed-gap, (r-bot - bed-gap + r-top - bed-gap) / 2), text(size: 8pt, weight: "regular")[V8])

  // V9: x = 13.90 → 15.01
  rect((13.90, r-bot - bed-gap), (15.01, r-top - bed-gap), fill: c-bed-veg, stroke: s-bed-veg)
  for lx in (0.15, 0.55, 0.96) {
    line((13.90 + lx, r-top), (13.90 + lx, r-bot - bed-gap), stroke: s-drip)
    circle((13.90 + lx, r-bot - bed-gap), radius: 0.06, fill: c-endcap, stroke: none)
  }
  content((14.455, (r-bot - bed-gap + r-top - bed-gap) / 2), text(size: 8pt, weight: "regular")[V9])

  // R1/R2 dimension lines below (shifted)
  let r-dim-y = r-bot - bed-gap - 0.4
  for (rx, rw, rname) in ((12.44 + bed-gap, 1.20, "120"), (13.90, 1.11, "111")) {
    line((rx, r-dim-y - 0.1), (rx, r-dim-y + 0.1), stroke: luma(150) + 0.5pt)
    line((rx + rw, r-dim-y - 0.1), (rx + rw, r-dim-y + 0.1), stroke: luma(150) + 0.5pt)
    line((rx, r-dim-y), (rx + rw, r-dim-y), stroke: luma(150) + 0.5pt)
    content((rx + rw / 2, r-dim-y - 0.15), anchor: "north",
      text(size: 4pt, fill: luma(100))[#rname])
  }
  // V8/V9 depth split into 190 + 262 (right side of V9)
  let r-depth-x = 15.4
  let r-top-shifted = r-top - bed-gap
  let r-bot-shifted = r-bot - bed-gap
  // 190: from r-top to main header (bed-top)
  line((r-depth-x, r-top-shifted), (r-depth-x, bed-top), stroke: luma(150) + 0.5pt)
  line((r-depth-x - 0.1, r-top-shifted), (r-depth-x + 0.1, r-top-shifted), stroke: luma(150) + 0.5pt)
  line((r-depth-x - 0.1, bed-top), (r-depth-x + 0.1, bed-top), stroke: luma(150) + 0.5pt)
  content((r-depth-x + 0.15, (r-top-shifted + bed-top) / 2), anchor: "west",
    text(size: 4pt, fill: luma(100))[190])
  // 262: from main header (bed-top) to r-bot
  line((r-depth-x, bed-top), (r-depth-x, r-bot-shifted), stroke: luma(150) + 0.5pt)
  line((r-depth-x - 0.1, r-bot-shifted), (r-depth-x + 0.1, r-bot-shifted), stroke: luma(150) + 0.5pt)
  content((r-depth-x + 0.15, (bed-top + r-bot-shifted) / 2), anchor: "west",
    text(size: 4pt, fill: luma(100))[262])

  // ==========================================================
  // 3b. FLOWER BEDS F4 & F5 (between hedge and V1)
  // ==========================================================
  // F4: 180×280, F5: 145×280, 50cm gap between, 290cm gap to main pipe
  let f4-left = -7.0 + bed-gap
  let f4-right = -5.2 + bed-gap
  let f4-top = bed-top - bed-gap
  let f4-bot = bed-top - 2.8 - bed-gap

  let f5-left = -4.7 + bed-gap
  let f5-right = -3.25 + bed-gap
  let f5-top = f4-top
  let f5-bot = f4-bot

  // F4 box
  rect((f4-left, f4-bot), (f4-right, f4-top), fill: c-bed-flower, stroke: s-bed-flower)

  // F5 box
  rect((f5-left, f5-bot), (f5-right, f5-top), fill: c-bed-flower, stroke: s-bed-flower)

  // F4 drip lines (4 lines, evenly distributed)
  // 180cm bed: 180/5 = 36 → at 36, 72, 108, 144 from left edge
  for lx in (0.36, 0.72, 1.08, 1.44) {
    line((-7.0 + lx + bed-gap, bed-top), (-7.0 + lx + bed-gap, f4-bot), stroke: s-drip)
    circle((-7.0 + lx + bed-gap, f4-bot), radius: 0.06, fill: c-endcap, stroke: none)
  }

  // F5 drip lines (3 lines, 40cm spacing, ~32cm margins)
  // 145cm bed: at 32.5, 72.5, 112.5 from left edge → 0.325, 0.725, 1.125
  for lx in (0.325, 0.725, 1.125) {
    line((-4.7 + lx + bed-gap, bed-top), (-4.7 + lx + bed-gap, f5-bot), stroke: s-drip)
    circle((-4.7 + lx + bed-gap, f5-bot), radius: 0.06, fill: c-endcap, stroke: none)
  }

  // Labels
  content(((f4-left + f4-right) / 2, (f4-top + f4-bot) / 2),
    text(size: 7pt, weight: "regular")[F4])
  content(((f5-left + f5-right) / 2, (f5-top + f5-bot) / 2),
    text(size: 7pt, weight: "regular")[F5])

  // Dimension lines
  // F4 width
  let f45-dim-y = f4-bot - 0.3
  line((f4-left, f45-dim-y - 0.1), (f4-left, f45-dim-y + 0.1), stroke: luma(150) + 0.5pt)
  line((f4-right, f45-dim-y - 0.1), (f4-right, f45-dim-y + 0.1), stroke: luma(150) + 0.5pt)
  line((f4-left, f45-dim-y), (f4-right, f45-dim-y), stroke: luma(150) + 0.5pt)
  content(((f4-left + f4-right) / 2, f45-dim-y - 0.15), anchor: "north",
    text(size: 4pt, fill: luma(100))[180])

  // F5 width
  line((f5-left, f45-dim-y - 0.1), (f5-left, f45-dim-y + 0.1), stroke: luma(150) + 0.5pt)
  line((f5-right, f45-dim-y - 0.1), (f5-right, f45-dim-y + 0.1), stroke: luma(150) + 0.5pt)
  line((f5-left, f45-dim-y), (f5-right, f45-dim-y), stroke: luma(150) + 0.5pt)
  content(((f5-left + f5-right) / 2, f45-dim-y - 0.15), anchor: "north",
    text(size: 4pt, fill: luma(100))[145])

  // F4/F5 depth (shared, on right side of F5)
  let f45-depth-x = f5-right + 0.3
  line((f45-depth-x, f4-top), (f45-depth-x, f4-bot), stroke: luma(150) + 0.5pt)
  line((f45-depth-x - 0.1, f4-top), (f45-depth-x + 0.1, f4-top), stroke: luma(150) + 0.5pt)
  line((f45-depth-x - 0.1, f4-bot), (f45-depth-x + 0.1, f4-bot), stroke: luma(150) + 0.5pt)
  content((f45-depth-x + 0.15, (f4-top + f4-bot) / 2), anchor: "west",
    text(size: 4pt, fill: luma(100))[280])

  // ==========================================================
  // 4. FLOWER BEDS (Branch 2)
  // ==========================================================

  // + connector at (1.5, 0): tap is at middle of F2
  // F2 centered on y=0: top=0.515, bottom=-0.515
  // F1 above F2: top=1.265, bottom=0.515
  let fg = bed-gap
  let f-pipe-x = 0
  let f1-left = f-pipe-x + fg
  let f1-right = f1-left + 4.9  // 490cm wide
  let f3-left = f1-right + 1.4  // 140cm path gap (removable pipe)
  let f3-right = f3-left + 5.0  // 500cm wide

  // F2 box (490×103, centered on tap y=0)
  let f2-top2 = 0.515
  let f2-bot = -0.515
  rect((f1-left, f2-bot), (f1-right, f2-top2), fill: c-bed-flower.lighten(20%), stroke: s-bed-flower)

  // F1 box (490×75, above F2)
  let f1-bot = f2-top2
  let f1-top = f1-bot + 0.75
  rect((f1-left, f1-bot), (f1-right, f1-top), fill: c-bed-flower, stroke: s-bed-flower)

  // F3 box drawn after path-bottom is defined (see below)

  // (vertical pipe from F2 bottom to header is one continuous line, drawn in section 5)

  // F1+F3 drip line with removable section across path (140cm gap)
  let f1-drip = (f1-top + f1-bot) / 2

  // F1 section (permanent)
  line((0, f1-drip), (f1-right, f1-drip), stroke: s-drip)

  // Stairs/path section: plain pipe (no emitters) with 2 elbows
  let path-bottom = f1-bot - 0.15  // just below F1
  let el-stroke = (paint: c-fitting, thickness: 2pt, cap: "round")
  let plain-stroke = (paint: luma(120), thickness: 1pt)

  // F3 box (500×80, centered on pipe level)
  let f3-top = path-bottom + 0.40
  let f3-bot = path-bottom - 0.40
  rect((f3-left, f3-bot), (f3-right, f3-top), fill: c-bed-flower.lighten(10%), stroke: s-bed-flower)
  // Plain pipe: vertical drop down stairs
  line((f1-right, f1-drip), (f1-right, path-bottom), stroke: plain-stroke)
  // Plain pipe: horizontal along path to F3
  line((f1-right, path-bottom), (f3-left, path-bottom), stroke: plain-stroke)
  // Elbow 1: F1 right edge (horizontal → down)
  line((f1-right - 0.2, f1-drip), (f1-right, f1-drip), stroke: el-stroke)
  line((f1-right, f1-drip), (f1-right, f1-drip - 0.2), stroke: el-stroke)
  // Elbow 2: Stairs bottom corner (down → right)
  line((f1-right, path-bottom + 0.2), (f1-right, path-bottom), stroke: el-stroke)
  line((f1-right, path-bottom), (f1-right + 0.2, path-bottom), stroke: el-stroke)
  // Pipe connector: plain → drip at F3 entry (only one needed; elbows connect directly)
  circle((f3-left, path-bottom), radius: 0.07, fill: rgb("#6A1B9A"), stroke: white + 0.5pt)

  // F3 section (permanent, at underground pipe level)
  line((f3-left, path-bottom), (f3-right, path-bottom), stroke: s-drip)
  circle((f3-right, path-bottom), radius: 0.06, fill: c-endcap, stroke: none)

  // F2 drip lines (2 lines, from main pipe at x=0, going RIGHT)
  let f2-drip1 = f2-top2 - 1.03 / 3
  let f2-drip2 = f2-top2 - 2 * 1.03 / 3
  line((0, f2-drip1), (f1-right, f2-drip1), stroke: s-drip)
  circle((f1-right, f2-drip1), radius: 0.06, fill: c-endcap, stroke: none)
  line((0, f2-drip2), (f1-right, f2-drip2), stroke: s-drip)
  circle((f1-right, f2-drip2), radius: 0.06, fill: c-endcap, stroke: none)

  // F3 drip line is shared with F1 (drawn above)

  // Labels
  content(((f1-left + f1-right) / 2, f1-drip), text(size: 7pt, weight: "regular")[F1])
  content(((f1-left + f1-right) / 2, (f2-drip1 + f2-drip2) / 2), text(size: 7pt, weight: "regular")[F2])
  content(((f3-left + f3-right) / 2, path-bottom), text(size: 7pt, weight: "regular")[F3])

  // Dimension lines
  // F1/F2 width
  let fab-dim-y = f2-bot - 0.3
  line((f1-left, fab-dim-y - 0.1), (f1-left, fab-dim-y + 0.1), stroke: luma(150) + 0.5pt)
  line((f1-right, fab-dim-y - 0.1), (f1-right, fab-dim-y + 0.1), stroke: luma(150) + 0.5pt)
  line((f1-left, fab-dim-y), (f1-right, fab-dim-y), stroke: luma(150) + 0.5pt)
  content(((f1-left + f1-right) / 2, fab-dim-y - 0.15), anchor: "north",
    text(size: 4pt, fill: luma(100))[490])
  // F1 depth
  let fa-dim-x = f-pipe-x - 0.4
  line((fa-dim-x, f1-top), (fa-dim-x, f1-bot), stroke: luma(150) + 0.5pt)
  line((fa-dim-x - 0.1, f1-top), (fa-dim-x + 0.1, f1-top), stroke: luma(150) + 0.5pt)
  line((fa-dim-x - 0.1, f1-bot), (fa-dim-x + 0.1, f1-bot), stroke: luma(150) + 0.5pt)
  content((fa-dim-x - 0.15, (f1-top + f1-bot) / 2), anchor: "east",
    text(size: 4pt, fill: luma(100))[75])
  // F2 depth
  line((fa-dim-x, f2-top2), (fa-dim-x, f2-bot), stroke: luma(150) + 0.5pt)
  line((fa-dim-x - 0.1, f2-bot), (fa-dim-x + 0.1, f2-bot), stroke: luma(150) + 0.5pt)
  content((fa-dim-x - 0.15, (f2-top2 + f2-bot) / 2), anchor: "east",
    text(size: 4pt, fill: luma(100))[103])
  // F1–F3 gap (140cm plain pipe, no emitters) — aligned with 490 dimension
  line((f1-right, fab-dim-y - 0.1), (f1-right, fab-dim-y + 0.1), stroke: luma(150) + 0.5pt)
  line((f3-left, fab-dim-y - 0.1), (f3-left, fab-dim-y + 0.1), stroke: luma(150) + 0.5pt)
  line((f1-right, fab-dim-y), (f3-left, fab-dim-y), stroke: luma(150) + 0.5pt)
  content(((f1-right + f3-left) / 2, fab-dim-y - 0.15), anchor: "north",
    text(size: 4pt, fill: luma(100))[140])
  // F3 width — aligned with 490 dimension
  line((f3-left, fab-dim-y - 0.1), (f3-left, fab-dim-y + 0.1), stroke: luma(150) + 0.5pt)
  line((f3-right, fab-dim-y - 0.1), (f3-right, fab-dim-y + 0.1), stroke: luma(150) + 0.5pt)
  line((f3-left, fab-dim-y), (f3-right, fab-dim-y), stroke: luma(150) + 0.5pt)
  content(((f3-left + f3-right) / 2, fab-dim-y - 0.15), anchor: "north",
    text(size: 4pt, fill: luma(100))[500])
  // F3 depth
  let fc-depth-x2 = f3-right + 0.3
  line((fc-depth-x2, f3-top), (fc-depth-x2, f3-bot), stroke: luma(150) + 0.5pt)
  line((fc-depth-x2 - 0.1, f3-top), (fc-depth-x2 + 0.1, f3-top), stroke: luma(150) + 0.5pt)
  line((fc-depth-x2 - 0.1, f3-bot), (fc-depth-x2 + 0.1, f3-bot), stroke: luma(150) + 0.5pt)
  content((fc-depth-x2 + 0.15, (f3-top + f3-bot) / 2), anchor: "west",
    text(size: 4pt, fill: luma(100))[80])

  // ==========================================================
  // 5. PIPES — 25mm main lines (drawn on top of beds)
  // ==========================================================

  // Permanent pipe: Head Unit up to top of F1
  line((0, f2-bot - 0.1), (0, f1-top), stroke: s-pipe25)

  // Removable pipe: across lawn (540cm), shown dotted
  line((0, f1-top), (0, bed-bot-shifted), stroke: (paint: c-pipe25, thickness: 1.5pt, dash: (4pt, 2pt)))

  // Permanent pipe: from bed bottom up to header
  line((0, bed-bot-shifted), (0, bed-top), stroke: s-pipe25)

  // Quick-connect symbols at both ends of removable section
  rect((-0.15, f1-top - 0.08), (0.15, f1-top + 0.08), fill: rgb("#FF6F00"), stroke: white + 0.5pt)
  rect((-0.15, bed-bot-shifted - 0.08), (0.15, bed-bot-shifted + 0.08), fill: rgb("#FF6F00"), stroke: white + 0.5pt)

  // Junction → Hedge (left, 25mm)
  line((0, bed-top), (-8, bed-top), stroke: s-pipe25)

  // Junction → Upper beds header (right, 25mm)
  line((0, bed-top), (10.34, bed-top), stroke: s-pipe25)

  // Gap after Bed 7, continuing to elbow
  line((10.34, bed-top), (12.44, bed-top), stroke: s-pipe25)

  // Up to R1/R2 level (190 cm)
  line((12.44, bed-top), (12.44, r-top), stroke: s-pipe25)

  // Right along R1/R2 top (270 cm)
  // Header runs straight across V8 and V9, ends with cap
  line((12.44, r-top), (15.01, r-top), stroke: s-pipe25)
  circle((15.01, r-top), radius: 0.06, fill: c-endcap, stroke: none)

  // ==========================================================
  // 6. PIPES — 16mm secondary lines
  // ==========================================================

  // (no separate branch — all flower drip lines tap off main vertical pipe)

  // (no separate pipe to F2 — drip lines tap directly from main vertical pipe)

  // ==========================================================
  // 7. HEDGE — drip lines (16mm)
  // ==========================================================

  // Up from junction at hedge: 190 cm
  line((-8, bed-top), (-8, 10.1), stroke: s-drip)
  circle((-8, 10.1), radius: 0.06, fill: c-endcap, stroke: none)

  // Down from junction at hedge: 1200 cm
  line((-8, bed-top), (-8, -4), stroke: s-drip)
  circle((-8, -4), radius: 0.06, fill: c-endcap, stroke: none)

  // Hedge labels
  content((-8, 10.2), anchor: "south", text(size: 7pt, weight: "bold")[Hedge])

  // Hedge dimension lines (like vegetable beds)
  let hdim-x = -8.6
  // 190 up segment: y=8 to y=9.9
  line((hdim-x, bed-top), (hdim-x, 10.1), stroke: luma(150) + 0.5pt)
  line((hdim-x - 0.1, bed-top), (hdim-x + 0.1, bed-top), stroke: luma(150) + 0.5pt)
  line((hdim-x - 0.1, 10.1), (hdim-x + 0.1, 10.1), stroke: luma(150) + 0.5pt)
  content((hdim-x - 0.15, (bed-top + 9.9) / 2), anchor: "east",
    text(size: 4pt, fill: luma(100))[190])

  // 1200 down segment: y=8 to y=-4
  line((hdim-x, bed-top), (hdim-x, -4), stroke: luma(150) + 0.5pt)
  line((hdim-x - 0.1, -4), (hdim-x + 0.1, -4), stroke: luma(150) + 0.5pt)
  content((hdim-x - 0.15, (bed-top + -4) / 2), anchor: "east",
    text(size: 4pt, fill: luma(100))[1200])

  // ==========================================================
  // 8. FITTINGS
  // ==========================================================

  // --- Head unit connects directly to bottom of main vertical pipe ---
  rect((-0.3, f2-bot - 0.6), (0.3, f2-bot - 0.1), fill: rgb("#546E7A"), stroke: white + 1pt)


  // --- Helper: T-connector drawn as a T shape ---
  // The existing pipes form 2 of 3 legs; we draw a short stub on the opposite
  // side of the branch to complete the T shape.
  let t-len = 0.25
  let t-stroke = (paint: c-fitting, thickness: 2pt, cap: "round")


  // --- Junction (0, 8) — pipe UP from tap, splits L (hedge) + R (beds) → stub DOWN ---
  line((0, bed-top), (0, bed-top - t-len), stroke: t-stroke)
  line((-t-len, bed-top), (t-len, bed-top), stroke: t-stroke)  // crossbar


  // --- Hedge pipe end cap + barbed takeoffs (no T needed) ---
  circle((-8, bed-top), radius: 0.06, fill: c-endcap, stroke: none)



  // --- Elbows as L shapes ---
  let e-len = 0.2

  // (12.44, 8) — pipe from LEFT, turns UP
  line((12.44 - e-len, bed-top), (12.44, bed-top), stroke: t-stroke)
  line((12.44, bed-top), (12.44, bed-top + e-len), stroke: t-stroke)

  // (12.44, 10.1) — pipe from BELOW, turns RIGHT
  line((12.44, r-top - e-len), (12.44, r-top), stroke: t-stroke)
  line((12.44, r-top), (12.44 + e-len, r-top), stroke: t-stroke)



  // ==========================================================
  // 8b. BARBED TAKEOFFS (drawn last, on top of everything)
  // ==========================================================

  // V1-V7 barbed dots
  for bed in upper-beds {
    let (sx, w, name, lines) = bed
    for lx in lines {
      circle((sx + lx + bed-gap, bed-top), radius: 0.06, fill: black, stroke: none)
    }
  }

  // V8 barbed dots
  for lx in (0.15, 0.60, 1.05) {
    circle((12.44 + lx + bed-gap, r-top), radius: 0.06, fill: black, stroke: none)
  }

  // V9 barbed dots
  for lx in (0.15, 0.55, 0.96) {
    circle((13.90 + lx, r-top), radius: 0.06, fill: black, stroke: none)
  }

  // F4 barbed dots
  for lx in (0.36, 0.72, 1.08, 1.44) {
    circle((-7.0 + lx + bed-gap, bed-top), radius: 0.06, fill: black, stroke: none)
  }
  // F5 barbed dots
  for lx in (0.325, 0.725, 1.125) {
    circle((-4.7 + lx + bed-gap, bed-top), radius: 0.06, fill: black, stroke: none)
  }

  // F1+F3 barbed dot (on main vertical pipe)
  circle((0, f1-drip), radius: 0.06, fill: black, stroke: none)
  // Flower F2 barbed dots (on main vertical pipe)
  circle((0, f2-drip1), radius: 0.06, fill: black, stroke: none)
  circle((0, f2-drip2), radius: 0.06, fill: black, stroke: none)

  // Hedge barbed dots (25mm pipe → 16mm drip)
  circle((-8, bed-top + 0.15), radius: 0.06, fill: black, stroke: none)
  circle((-8, bed-top - 0.15), radius: 0.06, fill: black, stroke: none)

  // ==========================================================
  // 9. DIMENSION ANNOTATIONS
  // ==========================================================

  // Dimension lines for pipes
  let pdim-style = luma(150) + 0.5pt


  // Horizontal: Junction → Hedge (800)
  let hdim-y1 = bed-top + 0.5
  line((-8, hdim-y1), (0, hdim-y1), stroke: pdim-style)
  line((-8, hdim-y1 - 0.1), (-8, hdim-y1 + 0.1), stroke: pdim-style)
  line((0, hdim-y1 - 0.1), (0, hdim-y1 + 0.1), stroke: pdim-style)
  content((-4, hdim-y1 + 0.15), anchor: "south",
    text(size: 4pt, fill: luma(100))[800])

  // Horizontal: Upper beds header (1034) — end aligned with V7 right edge
  let v7-end = 10.34 + bed-gap
  line((0, hdim-y1), (v7-end, hdim-y1), stroke: pdim-style)
  line((v7-end, hdim-y1 - 0.1), (v7-end, hdim-y1 + 0.1), stroke: pdim-style)
  content(((0 + v7-end) / 2, hdim-y1 + 0.15), anchor: "south",
    text(size: 4pt, fill: luma(100))[1034])

  // Gap after Bed 7 (210)
  line((v7-end, hdim-y1), (12.44, hdim-y1), stroke: pdim-style)
  line((12.44, hdim-y1 - 0.1), (12.44, hdim-y1 + 0.1), stroke: pdim-style)
  content(((v7-end + 12.44) / 2, hdim-y1 + 0.15), anchor: "south",
    text(size: 4pt, fill: luma(100))[210])


  // R1/R2 header (270)
  let rdim-y = r-top + 0.5
  line((12.44, rdim-y), (15.01, rdim-y), stroke: pdim-style)
  line((12.44, rdim-y - 0.1), (12.44, rdim-y + 0.1), stroke: pdim-style)
  line((15.01, rdim-y - 0.1), (15.01, rdim-y + 0.1), stroke: pdim-style)
  content((13.73, rdim-y + 0.15), anchor: "south",
    text(size: 4pt, fill: luma(100))[257])


  // ==========================================================
  // 10. LEGEND (in empty space below flower beds)
  // ==========================================================

  let lx = 0.5
  let ly = -2.5

  rect((lx - 0.3, ly - 3.8), (lx + 5.0, ly + 0.4),
    fill: white, stroke: luma(200) + 0.5pt)

  content((lx, ly), anchor: "west",
    text(size: 7pt, weight: "bold")[Legend])

  let col2 = lx + 2.6
  // Column 1
  line((lx, ly - 0.5), (lx + 0.8, ly - 0.5), stroke: s-pipe25)
  content((lx + 1.0, ly - 0.5), anchor: "west", text(size: 5pt)[25 mm supply pipe])
  line((lx, ly - 0.9), (lx + 0.8, ly - 0.9), stroke: (paint: c-pipe25, thickness: 1.5pt, dash: (4pt, 2pt)))
  content((lx + 1.0, ly - 0.9), anchor: "west", text(size: 5pt)[25 mm removable])
  line((lx, ly - 1.3), (lx + 0.8, ly - 1.3), stroke: s-drip)
  content((lx + 1.0, ly - 1.3), anchor: "west", text(size: 5pt)[16 mm drip line])
  line((lx, ly - 1.7), (lx + 0.8, ly - 1.7), stroke: (paint: luma(120), thickness: 1pt))
  content((lx + 1.0, ly - 1.7), anchor: "west", text(size: 5pt)[16 mm plain pipe])
  rect((lx, ly - 2.15), (lx + 0.2, ly - 2.05), fill: rgb("#FF6F00"), stroke: white + 0.5pt)
  content((lx + 1.0, ly - 2.1), anchor: "west", text(size: 5pt)[Quick-connect])
  line((lx, ly - 2.35), (lx + 0.3, ly - 2.35), stroke: t-stroke)
  line((lx + 0.15, ly - 2.35), (lx + 0.15, ly - 2.55), stroke: t-stroke)
  content((lx + 1.0, ly - 2.5), anchor: "west", text(size: 5pt)[T-connector])
  line((lx, ly - 2.75), (lx, ly - 2.95), stroke: t-stroke)
  line((lx, ly - 2.95), (lx + 0.2, ly - 2.95), stroke: t-stroke)
  content((lx + 1.0, ly - 2.9), anchor: "west", text(size: 5pt)[Elbow])
  // Column 2
  circle((col2 + 0.1, ly - 0.5), radius: 0.05, fill: rgb("#6A1B9A"), stroke: white + 0.5pt)
  content((col2 + 1.0, ly - 0.5), anchor: "west", text(size: 5pt)[Pipe connector])
  circle((col2 + 0.1, ly - 0.9), radius: 0.04, fill: black, stroke: none)
  content((col2 + 1.0, ly - 0.9), anchor: "west", text(size: 5pt)[Barbed takeoff])
  circle((col2 + 0.1, ly - 1.3), radius: 0.04, fill: c-endcap, stroke: none)
  content((col2 + 1.0, ly - 1.3), anchor: "west", text(size: 5pt)[End cap])
  rect((col2, ly - 1.85), (col2 + 0.8, ly - 1.55), fill: rgb("#546E7A"), stroke: white + 0.5pt)
  content((col2 + 1.0, ly - 1.7), anchor: "west", text(size: 5pt)[Head Unit])
  rect((col2, ly - 2.25), (col2 + 0.8, ly - 1.95), fill: c-bed-veg, stroke: s-bed-veg)
  content((col2 + 1.0, ly - 2.1), anchor: "west", text(size: 5pt)[Vegetable bed])
  rect((col2, ly - 2.65), (col2 + 0.8, ly - 2.35), fill: c-bed-flower, stroke: s-bed-flower)
  content((col2 + 1.0, ly - 2.5), anchor: "west", text(size: 5pt)[Flower bed])

  // ==========================================================
  // 11. MATERIAL SUMMARY
  // ==========================================================

  let mx = lx + 5.5
  let my = ly

  rect((mx - 0.3, my - 3.8), (mx + 5.5, my + 0.4),
    fill: white, stroke: luma(200) + 0.5pt)

  content((mx, my), anchor: "west",
    text(size: 7pt, weight: "bold")[Material Summary])
  content((mx, my - 0.3), anchor: "west",
    text(size: 4pt, fill: luma(120))[(all quantities include 10% buffer)])

  content((mx, my - 0.7), anchor: "west", text(size: 5pt)[25 mm supply pipe: ~33 m + 6 m removable])
  content((mx, my - 1.0), anchor: "west", text(size: 5pt)[16 mm drip line: ~156 m])
  content((mx, my - 1.3), anchor: "west", text(size: 5pt)[16 mm plain pipe: ~2 m])
  content((mx, my - 1.6), anchor: "west", text(size: 5pt)[Fittings: 1× T, 4× Elbow, 1× Connector, 2× QC])
  content((mx, my - 1.9), anchor: "west", text(size: 5pt)[40× Barbed takeoff, 41× End cap])
  content((mx, my - 2.4), anchor: "west", text(size: 5pt, weight: "bold")[Head Unit])
  content((mx, my - 2.7), anchor: "west", text(size: 5pt)[1× Timer, 1× Filter + Pressure reg, 1× 3/4″→25 mm])
  content((mx, my - 3.2), anchor: "west", text(size: 5pt, weight: "bold")[Accessories])
  content((mx, my - 3.5), anchor: "west", text(size: 5pt)[~284 stakes, ~33 pipe clips, 2× teflon tape])

  // ==========================================================
  // 12. SYSTEM SPECS
  // ==========================================================

  let sx = mx + 6.0
  let sy = ly

  rect((sx - 0.3, sy - 3.8), (sx + 5.0, sy + 0.4),
    fill: white, stroke: luma(200) + 0.5pt)

  content((sx, sy), anchor: "west",
    text(size: 7pt, weight: "bold")[System Specs])

  content((sx, sy - 0.5), anchor: "west", text(size: 5pt)[Tap: 3/4″ outdoor, 2400 L/h])
  content((sx, sy - 0.8), anchor: "west", text(size: 5pt)[Head: Timer → Filter → Pressure reg (1.5–2 bar)])
  content((sx, sy - 1.1), anchor: "west", text(size: 5pt)[Emitter: 1.6 L/h @ 30 cm spacing])
  content((sx, sy - 1.4), anchor: "west", text(size: 5pt)[Drip line spacing: 30 cm (veg), 40 cm (flowers)])
  content((sx, sy - 1.7), anchor: "west", text(size: 5pt)[Schedule: 06:00, 30–45 min daily])
  content((sx, sy - 2.0), anchor: "west", text(size: 5pt)[Single zone, ~875 L/h demand])
})