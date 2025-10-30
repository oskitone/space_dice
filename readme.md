# Space Dice

![Oskitone Space Dice 3D model](/misc/12-90-600.gif)

Electronic dice + space laser noise machine

Work in progress!

## Schematic

![Oskitone Space Dice schematic](/misc/schematic.svg)

## BOM

| Designator        | Footprint                                        | Quantity | Designation |
| ----------------- | ------------------------------------------------ | -------- | ----------- |
| BT1               | battery                                          | 1        | 9v          |
| C1,C4             | CP_Radial_D7.5mm_P2.50mm                         | 2        | 220uF       |
| C5,C3,C2          | C_Disc_D5.0mm_W2.5mm_P5.00mm                     | 3        | .1uF        |
| D6,D2,D5,D4,D1,D3 | LED_D3.0mm                                       | 6        | LED         |
| LS1               | speaker                                          | 1        | AZ40R       |
| R1,R2             | R_Axial_DIN0207_L6.3mm_D2.5mm_P7.62mm_Horizontal | 2        | 1k          |
| R3                | R_Axial_DIN0207_L6.3mm_D2.5mm_P7.62mm_Horizontal | 1        | 330         |
| RV3,RV2,RV1       | Potentiometer_Bourns_PTV09A-1_Single_Vertical    | 3        | 10k log     |
| SW2               | SW_PUSH_6mm                                      | 1        | SW_SPST     |
| SW3               | SW_CuK_OS102011MA1QN1_SPDT_Angled                | 1        | SW_SPDT     |
| SW4,SW1           | SW_Slide_1P2T_CK_OS102011MS2Q                    | 2        | SW_SPDT     |
| U1                | DIP-14_W7.62mm_Socket_LongPads                   | 1        | 4093        |
| U2                | DIP-16_W7.62mm_Socket_LongPads                   | 1        | 4040        |
| U3                | DIP-16_W7.62mm_Socket_LongPads                   | 1        | 4017        |

Also:

- A couple inches of 2-wire ribbon cables (or similar small gauge, stranded wire)
- 3 DIP sockets
  - 1 14 pin for U1, U2
  - 2 14 pin for U3
- 2 nuts and bolts
  - 1 4/40 square nuts
  - 1 4/40 1/2" machine screws

## TODO

- Electronics
  - White LEDs
  - Obscured silkscreen labels on caps left of U1
  - U1 obstructions
  - Faster INCREMENT\_ oscs?
  - Bigger clearance around pots
- OpenSCAD
  - DFM: button_lever arm and actuator_mount
  - Chamfer enclosure exposures consistently
  - Split STL parts, rotate for printing
  - Nicer top brand engraving
  - Bigger, chamfered actuator cavity
  - Prevent false button triggers
  - Don't use battery for lever; height will be inconsistent
  - STL manifold issues?

### Soldering instructions

General advice:

- All components need to be flush against PCB but _especially_ the big caps. Clearance inside the enclosure is _tight_.
- Similarly, trim soldered leads on the PCB's bottom as close as possible. It's easy to accidentally short connections on assembly.

1. Power
   1. 9v battery snap to BT1
   2. Right-angled SPDT switch to SW3
   3. 16-pin socket and CD4017 to U3
   4. .1uF capacitor to C5
   5. LEDs to D1 through D6
   6. 330 ohm resistor to R3
   7. **Test:** Connect battery and toggle SW3. One of the LEDs should light up.
2. Count
   1. 14-pin socket and CD4093 to U1
   2. 16-pin socket and CD4040 to U2
   3. .1uF capacitors to C3 and C2
   4. 1k resistors to R1 and R2
   5. 10k log pots to RV1 and RV3
   6. Pushbutton SPST switch to SW2
   7. Vertical SPDT to SW4
   8. **Test:** Pressing SW2 should cycle the LEDs lighting up, D1 through D6 and then looping back to D1. RV3 and SW4 should control how fast it loops. RV1 doesn't do anything, yet!
3. Sound
   1. Vertical SPDT to SW1
   2. 10k log pot to RV2
   3. 220uF capacitor to C4
   4. Wire and speaker to LS1
   5. **Test:** Pressing SW2 should now also make a beeping sound. RV2 should control its volume. RV3 and SW1 should control pitch.
4. Decay
   1. 220uF capacitor to C1
   2. **Test:** The beep from before should now sound like a little space laser. RV1 now controls its decay.

### 3D-Printing

- Force bridging angles to be consistent.

## 3D models

3D-printed models are written in OpenSCAD.

### Updating pcb.scad

Documenting here because I always forget what I last did.

1. `kicad-cli pcb export svg --black-and-white --layers Edge.Cuts,F.Mask,F.SilkS --exclude-drawing-sheet --page-size-mode 2 --output misc/pcb.svg kicad/space_dice.kicad_pcb`
2. `kicad-cli pcb export svg --black-and-white --layers Edge.Cuts --exclude-drawing-sheet --page-size-mode 2 --output misc/edge_cuts.svg kicad/space_dice.kicad_pcb`
3. For both SVGs, in Kicad
   1. File -> Document properties -> Resize to content
   2. Path -> Stroke to Path

The `kicad-cli` commands apparently are deprecated so they'll have to change soon. Also the edge_cuts one isn't even totally right. Ideally, this is all automated!

### Dependencies

Assumes the `parts_cafe` repo is in a sibling directory and _up to date_ on the `main` branch. Here's how I've got it:

    \ oskitone
        \ space_dice
        \ parts_cafe

You'll also need to install the [Orbitron](https://fonts.google.com/specimen/Orbitron) font.

## License

Designed by Oskitone. Please support future projects by purchasing from [Oskitone](https://www.oskitone.com/).

Creative Commons Attribution/Share-Alike, all text above must be included in any redistribution. See license.txt for additional details.
