# Space Dice

Work in progress!

## Schematic

![space dice prototype schematic](/kicad/space_dice.svg)

## Known issues

- Pot tab holes are wrong, unfixably small.

## 3D Models

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
