---
id: lights-on
title: Lights on
description: Light up an LED
sidebar_label: 2. Lights on
image: /img/overhead-short-40-4-480.gif
slug: /lights-on
---

:::info
There are three sockets in this kit: one with 14 pins (7 on each side) and two with 16 (8 on each side). For this step, we want a 16-pin one.
:::

## Steps

1. Solder **U3** chip socket
   1. Find the 16-pin socket to **U3**. It will have a dimple or notch at one end, which will match the footprint on the PCB.
   2. To hold it in place, tape it on top and then solder a pin on each row from the bottom. Then push the socket in while melting the solder.  
      [![socket taped flat on PCB](/img/socket_taped_flat_on_pcb.jpg)](/img/socket_taped_flat_on_pcb.jpg)
   3. Before soldering the rest of the pins, verify the socket is perfectly flat against the PCB. If it's not, push the socket _into_ the PCB while remelting the applied solder. (If it's not flat and you try pushing it in, you can accidentally pop out a pin — not good!)
   4. When it's good and flat, solder the remaining pins.
2. Insert chip into socket
   1. If necessary, bend the pins of the 4017 IC chip so that they're straight up and down, not angled.  
      [![straightening 4017 pins](/img/straightening_4017_pins.jpg)](/img/straightening_4017_pins.jpg)
   2. Match the **4017** chip's dimple to its socket, then push it all the way in.  
      [![4017 inserted in socket](/img/4017_inserted_in_socket.jpg)](/img/4017_inserted_in_socket.jpg)
3. Solder LEDs
   1. Note the small "+" signs beside **D1** through **D6**. LEDs have polarity and won't work if connected backwards. Insert each LED so its long leg is in the "+" hole.  
      [![LED orientation marking on PCB](/img/led_orientation_marking_on_pcb.jpg)](/img/led_orientation_marking_on_pcb.jpg)
   2. Solder one leg of each LED and make sure they're all lined up and flat against the PCB before soldering their other legs.  
      [![LEDs positioned flat in PCB](/img/leds_positioned_flat_in_pcb.jpg)](/img/leds_positioned_flat_in_pcb.jpg)
4. Solder a 1k (Brown Black Red) resistor to **R3**.  
   [![resistor soldered to R3](/img/resistor_soldered_to_r3.jpg)](/img/resistor_soldered_to_r3.jpg)

## Test

Powering the board should light up one of the LEDs. If not, try running a finger across the soldered pins of **U3**. That should change which one is lit.

[![LED lit test](/img/led_lit_test.jpg)](/img/led_lit_test.jpg)

:::info
The lit LED may not match the one in the photo. It may also seem like some LEDs are not lighting at all. Both situations are fine for now.
:::

Not working as expected? It's probably a polarity issue. Confirm that the chip and LEDs are all inserted in the right orientation, then check the [PCB troubleshooting](pcb-troubleshooting.md) section. Otherwise, continue.

## How it works

[![Lights on schematic](/img/schematic/2-lights.svg)](/img/schematic/2-lights.svg)

- The 4017 is a decade counter. Its job is to count pulses of high voltage at its CLK input, then display that number on one of its ten outputs. After the tenth output is high or when its RESET input is pulsed, it resets to the first output.
- Check out its schematic layout. In real life, chips' pins are in neat rows, ordered counter-clockwise. In schematics, their pins are usually arranged by function: inputs and outputs on opposite sides, power at top and bottom, and pins ordered to match their uses.
- CKEN is "ClocK ENable" and is brought low to GND for regular operation. You might expect us to bring it high to enable the clock, but that's not always the case.
- CLK is unconnected. A "floating" input!
- The 4017 is called a decade counter because it has ten ("dec") outputs. It counts in base 10, AKA decimal.
- **R3** limits the current to the LED so it doesn't burn out. The schematic denotes a suitable range of 330ohm (very bright, minimum to not burn out LED) to 1k (1000ohm, dimmer, what's included in the kit).

### Consider

- Sometimes, when powering up the board, no LEDs are lit. Why?
- Why does touching the chip's pins with your finger change its output?
