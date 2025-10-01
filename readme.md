# Space Dice

Work in progress!

## Schematic

![space dice prototype schematic](/kicad/space_dice.svg)

## BOM

| Designator        | Footprint                                         | Quantity | Designation |
| ----------------- | ------------------------------------------------- | -------- | ----------- |
| BT1               | PinHeader_1x02_P2.54mm_Vertical                   | 1        | 9v          |
| C1,C4             | CP_Radial_D7.5mm_P2.50mm                          | 2        | 220uF       |
| C5,C3,C2          | C_Disc_D5.0mm_W2.5mm_P5.00mm                      | 3        | .1uF        |
| D6,D2,D5,D4,D1,D3 | LED_D3.0mm                                        | 6        | LED         |
| LS1               | PinHeader_1x02_P2.54mm_Vertical                   | 1        | Speaker     |
| R1,R2             | R_Axial_DIN0207_L6.3mm_D2.5mm_P7.62mm_Horizontal  | 2        | 1k          |
| R3                | R_Axial_DIN0207_L6.3mm_D2.5mm_P7.62mm_Horizontal  | 1        | 330         |
| RV2               | Potentiometer_Alpha_RD901F-40-00D_Single_Vertical | 1        | 10k log     |
| RV3,RV1           | Potentiometer_Alpha_RD901F-40-00D_Single_Vertical | 2        | 100k        |
| SW2               | SW_PUSH_6mm                                       | 1        | SW_SPST     |
| SW3               | SW_CuK_OS102011MA1QN1_SPDT_Angled                 | 1        | SW_SPDT     |
| SW4,SW1           | SW_Slide_1P2T_CK_OS102011MS2Q                     | 2        | SW_SPDT     |
| U1                | DIP-14_W7.62mm_Socket_LongPads                    | 1        | HEF4093B    |
| U2                | DIP-16_W7.62mm_Socket_LongPads                    | 1        | 4040        |
| U3                | DIP-16_W7.62mm_Socket_LongPads                    | 1        | 4017        |

## Electronics TODO

- Fix pot footprints. Tab holes are too small too high.
- BT1 and LS1 need polarity labels.
- Reverse RV1 and RV3 rotations. Clockwise for higher pitch and for more decay.
- Try reducing RV1 and RV3 values. 10k-50k?
- LEDs have + on the wrong side.
- Make LEDs sequence more compelling. Cycle like a clock from top right?

## 3D-Printing and soldering advice

- Force bridging angles to be consistent.
- All components need to be flush against PCB but _especially_ the big caps. Clearance inside the enclosure is _tight_.

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
