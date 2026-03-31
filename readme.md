# Space Dice

Space Dice is a combination space laser noise and electronic dice machine.

![Oskitone Space Dice 3D model](/assembly_guide/static/img/12-80-960.gif)

Its Altoids-tin-sized enclosure and controls are 3D-printed, and its circuitry is implemented with beloved 1970's era CMOS technology. No microcontrollers here!

**Demo:** https://vimeo.com/1172325294  
**Purchase a kit:** https://www.oskitone.com/product/space-dice-diy-electronics-kit  
**Assembly guide:** https://oskitone.github.io/space_dice/  
**Blog post:** COMING SOON

Obviously, I'd prefer you buy the kit from me. But, if circumstances prohibit, I've uploaded the latest [Space Dice PCB to OSH Park](https://oshpark.com/shared_projects/y5ph1b9p); please buy it from them with my blessing.

## Schematic

![Oskitone Space Dice schematic](/misc/schematic-bg.svg)

## TODO/Consider for next rev

- Fix CD4040 typo in schematic
- Explain why volume pot doesn't seem to work well
- Pull-down on 4017 reset so D1 lights consistently before 4093?
- Pull-up/down between 4093 CLOCK output and 4017 CLK input to drive counter before 4040 prescaler?

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

![Oskitone Space assembly timelapse](/assembly_guide/static/img/overhead-short-40-4-480.gif)
