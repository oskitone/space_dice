---
id: schematic
title: Schematic
description: Space Dice circuit schematic
sidebar_label: Schematic
image: /img/overhead-short-40-4-480.gif
hide_table_of_contents: true
---

[![Space Dice schematic](/img/schematic.svg)](/img/schematic.svg)

Differences from the PCB Assembly step schematics:

- Sub-circuits are pulled into their own box with annotations. All complex machines can be reduced to simpler machines.
- Instead of lines for all connections, this schematic uses labels: `CLOCK`, `OCTAVE_*`, `INCREMENT_*`, and `RESET`. They act just like `VCC` and `GND`. Complex schematics with lots of connections tend to use labels to avoid a spaghetti mess of lines.
- The whole thing is wrapped in a drawing sheet suitable for printing.

<!-- ### PCB assembly steps, summarized

1. **Power up:** Get power running through the PCB, controlled with an on/off switch. Measure its effects with a voltmeter/multimeter.
2. **Lights on:** Light one of six LEDs connected to an unclocked 4017 decade counter. The 4017 counts to ten on ten outputs: six to LEDs, one to reset, and finally three unconnected (which is what can cause the unobservable state).
3. **Cycle lights:** Build a 4093 NAND relaxation oscillator to clock a 4040 binary counter to clock the 4017, cycling the LED lights. The 4040 is technically a binary counter but here it acts as a prescaler, successively halving the oscillator's frequency 12 times: a 12 bit number! The cycle frequency is set by a potentiometer (wired serially with a resistor for reasonable max frequency) and and SPDT switch from two 4040 LFOs. The oscillator does have a switch but doesn't seem to totally control it, because its control input floats when the switch is open. The 4093 is called a "Quad" NAND with four logic gates, but we're only using one for now. Watch frequency change with an oscilloscope.
4. **Stop light cycle:** Add a pull-down to the oscillator's control input. When the switch is closed, 9v (VCC) of juice tell the oscillator to run; when it's open, the pulldown brings it back to 0v (GND). There's a potentiometer that doesn't seem to do anything.
5. **Sound on:** Wire the three remaining 4093 NAND gates together into a crude amplifier. This is a hack! Its input is three modulated octaves (two switchable through an SPDT) from the 4040's bits. Its output goes through a potentiometer for volume control and then to a speaker. Watch octave modulation with an oscilloscope.
6. **Pew pew pew:** Add a big capacitor to store voltage to the oscillator's control input. Now the oscillator will run as long as the cap has voltage. BUT the pull-down from step 4 is now effectively a drain, dumping that voltage to GND. The previously unused pot now controls the speed of that voltage drain. Surprisingly, when control voltage is low, frequency is too. This is also a hack! -->
