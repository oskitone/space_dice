---
id: sound-on
title: Sound on
description: Make some noise
sidebar_label: 5. Sound on
image: /img/overhead-short-40-4-480.gif
slug: /sound-on
---

:::note
Speaker terminals do have +/- sides but, for the way this one's being used, it won't matter how they're connected. Feel free to honor the "red is positive, black is negative" convention like the battery, or not! You'd be hard pressed to hear any difference.
:::

## Steps

1.  Solder the last vertical SPDT to **SW1** and 10k potentiometer to **RV2**.
    [![SPDT and potentiometer soldered](/img/spdt_and_potentiometer_soldered.jpg)](/img/spdt_and_potentiometer_soldered.jpg)
2.  Solder 220uF capacitor to **C4**.
    1.  Note the cap's polarity. Match the white band on its cylinder to the white half of the PCB footprint.
        [![capacitor polarity band alignment](/img/capacitor_polarity_band_alignment.jpg)](/img/capacitor_polarity_band_alignment.jpg)
3.  Connect speaker
    1. Just like you did for **BT1**, feed the other half of the 9v snap's wires through the relief hole by **LS1** and solder to **LS1**.
       [![battery snap wires at LS1](/img/battery_snap_wires_at_ls1.jpg)](/img/battery_snap_wires_at_ls1.jpg)
    2. Strip 1/4" of insulation from its other ends and "tin" them by melting some solder onto them.
       [![tinning wire ends](/img/tinning_wire_ends.jpg)](/img/tinning_wire_ends.jpg)
    3. Solder the stripped, tinned ends to the speaker's terminals.
       [![wires soldered to speaker](/img/wires_soldered_to_speaker.jpg)](/img/wires_soldered_to_speaker.jpg)

## Test

Pressing **SW2** should now also make a beeping sound. **RV2** should control its volume. **RV3** and **SW1** should control pitch.

[![speaker test with multimeter](/img/speaker_test_with_multimeter.jpg)](/img/speaker_test_with_multimeter.jpg)

Not working as expected? Check the [PCB troubleshooting](pcb-troubleshooting.md) section. Otherwise, continue.

## How it works

[![Sound on schematic](/img/schematic/5-sound.svg)](/img/schematic/5-sound.svg)

- Each 4040 output pin creates a square waves at half the frequency of its predecessor. In musical terms, when a note is half the frequency of another, it's an octave down. Twice the frequency, it's an octave up. The 4040 is an octave generator!
- But how can we listen to it? If we were to connect any single output pin up to a speaker, there wouldn't be enough current to audibly drive the speaker. We need an amplifier or some way to boost the signal...
- A NAND with its inputs tied together becomes a NOT. If you connect multiple NOTs in parallel, their output current multiplies. Thus, the three remaining 4093 NAND gates make a crude inverting square wave booster. _This is a hack!_ PCB software warns against connecting logic gate outputs; in practice, it is fine.
- Three of these octaves (two switchable through **SW1**) connect to the input to our amp, and its output goes through the **RV2** potentiometer wired as [voltage divider](https://en.wikipedia.org/wiki/Voltage_divider) for volume control and then to a speaker.
- The enclosure labels **RV2** as "VOL" for "volume" and **SW1** as "OCT" for "octave."
- **C4** is a [coupling capacitor](https://en.wikipedia.org/wiki/Capacitive_coupling). Its job is to connect the amplified audio's alternating current (AC) to the speaker but block direct current (DC; for example, a sustained 9v). Without it, the speaker would draw more current than the 4093 could provide, eventually damaging it.
- The lines out of Q0 and Q2 are drawn crossed, but they don't connect electronically. Schematics will usually explicitly denote line/wire connections with dots, like the ones flanking the NAND gates.

Consider:

- If the 4040 outputs square waves, what kind of waveform do you get when they're connected? (Hint: any low GND output will sink any high VCC output it contacts...) If you've got an oscilloscope, you could measure and watch the resultant waveforms.
- Inside the speaker is an electromagnet that moves the speaker's cone when electricity is applied. The cone's movement creates a wave in the air that our ears interpret as sound. Knowing this, why does reversing the polarity of its connections not seem to matter?
