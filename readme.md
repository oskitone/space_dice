# Space Dice

Space Dice is a combination space laser noise and electronic dice machine. Click the big button to roll and adjust controls for tone/speed/etc.

![Oskitone Space Dice 3D model](/assembly_guide/static/img/overhead-short-40-4-480.gif)

Its Altoids-tin-sized enclosure and controls are 3D-printed, and its circuitry is implemented with beloved 1970's era CMOS technology. No microcontrollers here!

COMING SOON: links to purchase DIY electronics kit, demo video, and assembly guide

Obviously, I'd prefer you wait and buy the kit from me. But, if circumstances prohibit, I've uploaded the latest [Space Dice PCB to OSH Park](https://oshpark.com/shared_projects/y5ph1b9p); please buy it from them with my blessing.

## Schematic

![Oskitone Space Dice schematic](/misc/schematic.svg)

## TODO

- Start documentation
- GIFs
  - LED soldering, LED cycle

## 3D models

3D-printed models are written in OpenSCAD.

<!-- ### Updating pcb.scad

Documenting here because I always forget what I last did.

1. `kicad-cli pcb export svg --black-and-white --layers Edge.Cuts,F.Mask,F.SilkS --exclude-drawing-sheet --page-size-mode 2 --output misc/pcb.svg kicad/space_dice.kicad_pcb`
2. `kicad-cli pcb export svg --black-and-white --layers Edge.Cuts --exclude-drawing-sheet --page-size-mode 2 --output misc/edge_cuts.svg kicad/space_dice.kicad_pcb`
3. For both SVGs, in Inkscape
   1. Path -> Stroke to Path

The `kicad-cli` commands apparently are deprecated so they'll have to change soon. Also the edge_cuts one isn't even totally right. Ideally, this is all automated! -->

### Dependencies

Assumes the `parts_cafe` repo is in a sibling directory and _up to date_ on the `main` branch. Here's how I've got it:

    \ oskitone
        \ space_dice
        \ parts_cafe

You'll also need to install the [Orbitron](https://fonts.google.com/specimen/Orbitron) font.

## License

Designed by Oskitone. Please support future projects by purchasing from [Oskitone](https://www.oskitone.com/).

Creative Commons Attribution/Share-Alike, all text above must be included in any redistribution. See license.txt for additional details.
