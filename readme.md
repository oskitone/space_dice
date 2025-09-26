# Space Dice

This branch is an abandoned sequencer/countdown dice prototype.

- U6 is a 7 segment LED, lit by a CD4511 driver at U5.
- It displays numbers 1 through 6 from a CD4510 BCD counter at U4. The CD4510 is a special counter because it can start at an arbitrary preset instead of always being 0. Diode logic resets it at 7 back to the preset of 1. RV1 controls counting frequency.
- Press S2 to start a countdown sequence on the CD4040 binary counter at U2. RV2 controls countdown speed. When the 4040's last bit is high, the sequence stops.
- The three bits before the last control a CD4051 multiplexer at U3, wired as a kind of digitally controlled variable resistor running parallel to RV2.
- SW3, SW4, and SW5 connect the other CD4040 bits to the speaker.
- There's no amp!

Abandoned for a simpler design and spacier sound.

## Schematic

![space dice sequencer prototype schematic](/kicad/space_dice.svg)

## Known issues

- BT1, LS1, and all the LEDs need their footprints' polarities labelled on the PCB. The LEDs' longer legs are positive and all go on the right side of their footprints. BT1 is - on top, + on bottom. LS1 is the opposite, though it won't make a difference in practice.
- RV2's tab holes are too small. They can be kinda banged out with a center punch tool.
- The unlabeled component at the bottom left of U4 is cap C6, .1uF.
- C1's footprint is wrong for an electrolytic cap. Left pin is +, right is -.
- Octave switches should be rotated 180 and reversed in order: low to high and up for on.
- Similarly, RV1 pot rotation could be reversed. It makes sense for clockwise to increase decay, but it's confusing that it _also_ increases the tone frequency.
- R7 is a pull-up to start oscillating before the CD4040 at U2 is installed. Could be cool for incremental/functional soldering but isn't really necessary.

## 3D Models

3D-printed models are written in OpenSCAD.

Because this is just a prototype, it's really just a base to put stuff on and some other accoutrements.

### Dependencies

Assumes the `parts_cafe` repo is in a sibling directory and _up to date_ on the `main` branch. Here's how I've got it:

    \ oskitone
        \ space_dice
        \ parts_cafe

You'll also need to install the [Orbitron](https://fonts.google.com/specimen/Orbitron) font.

## License

Designed by Oskitone. Please support future projects by purchasing from [Oskitone](https://www.oskitone.com/).

Creative Commons Attribution/Share-Alike, all text above must be included in any redistribution. See license.txt for additional details.
