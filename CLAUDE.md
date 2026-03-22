# Garden Drip Irrigation System

## Project Overview
Design and planning for a drip irrigation system covering vegetable beds (V1-V9), flower beds (F1-F5), and a hedge.

## Key Files
- `garden-layout.typ` — Typst diagram (main source of truth for layout)
- `garden-layout.pdf` — Compiled diagram (A4 landscape, `typst compile garden-layout.typ`)
- `irrigation_materials_list.md` — Updated materials list (matches current diagram)
- `google-maps.png` — Aerial view with bed labels

## Build
```
typst compile garden-layout.typ
```
Requires Typst with `@preview/cetz:0.4.2` package and Lato font.

## Diagram Structure (garden-layout.typ)
- Canvas scale: `length: 0.95cm` per unit (1 unit = 1m)
- Page: A4 landscape (297mm × 210mm)
- Sections 1-9: Diagram elements (beds, pipes, fittings, dimensions)
- Sections 10-12: Legend, Material Summary, System Specs (positioned in empty space below flower beds, inside the canvas)

## System Design
- **Water source:** 3/4" tap, 2400 L/h
- **Single zone**, ~875 L/h demand
- **Head unit:** Timer → Filter → Pressure regulator (1.5-2 bar) → 25mm main pipe
- **Pipe:** 25mm supply (permanent + 540cm removable lawn crossing), 16mm drip line, 16mm plain pipe (stairs)
- **Beds:** V1-V7 (upper veg), V8-V9 (top-right veg), F1-F3 (near tap), F4-F5 (between hedge and V1), Hedge

## Key Design Decisions
- **F1→F3 connection:** Drip line through F1 → elbow (horizontal→down) → plain pipe down stairs → elbow (down→right) → plain pipe along path → connector → drip line through F3. No emitters on path section.
- **Elbows act as connectors** between drip line and plain pipe (both 16mm, same barbed fittings)
- **No reducers needed** — hedge and flower drip lines tap directly off 25mm pipe via barbed takeoffs
- **Removable pipe** across lawn with quick-connects (540cm, for mowing access)
- **Stairs vertical drop** is 35cm (not the diagram's visual distance)

## Future Work
- **Lawn sprinkler zone:** Separate zone 2 with dedicated pipe at full tap pressure (split before pressure regulator). Needs dual-zone timer, pop-up sprinklers, and new pipe routing. Lawn area is between F1/F2 and vegetable beds.
