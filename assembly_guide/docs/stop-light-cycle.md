---
id: stop-light-cycle
title: Stop light cycle
description: Make the LED light cycle stop when the button isn't pressed
sidebar_label: 4. Stop light cycle
image: /img/overhead-short-40-4-480.gif
slug: /stop-light-cycle
---

## Steps

1. Solder 1k resistor to **R1**.  
   [![1k resistor on R1](/img/1k_resistor_on_r1.jpg)](/img/1k_resistor_on_r1.jpg)
2. Solder 10k potentiometer to **RV1**.  
   [![potentiometer on RV1](/img/potentiometer_on_rv1.jpg)](/img/potentiometer_on_rv1.jpg)
3. Solder .1uF capacitors to **C3** and **C5**.  
   [![capacitors on C3 and C5](/img/capacitors_on_c3_and_c5.jpg)](/img/capacitors_on_c3_and_c5.jpg)

## Test

The LED cycle should now only occur while **SW2** is pressed.

[![LED cycle test with SW2](/img/led_cycle_test_with_sw2.jpg)](/img/led_cycle_test_with_sw2.jpg)

**RV1** is an important part of the circuit but, for now, turning it has no effect.

Not working as expected? Check the [PCB troubleshooting](pcb-troubleshooting.md) section. Otherwise, continue.

## How it works

[![Stop light cycle schematic](/img/schematic/4-stop.svg)](/img/schematic/4-stop.svg)

- **R1** and **RV2** are wired serially as a pull-down resistor to the oscillator's control input.
- When the **SW2** is closed, VCC tells the oscillator to run; when it's open, the pulldown brings it back down low to 0v.
- **C3** and **C5** are bypass/decoupling capacitors. Their job is to prevent spurious noise in the supply voltage from affecting the circuit's performance.
- **RV1** indeed does nothing, yet!

Consider:

- A potentiometer is also called a variable resistor. Its resistance is anywhere between 0 and its prescribed value, based on how it's set.
- When resistors are connected one after the other, this is called "serial." Their total resistance is the sum of their values.
- Knowing this, why doesn't turning **RV1** have any effect?
- **R2** and **RV3** are also wired serially, and turning **RV3** does indeed have an effect. What's different? And how would it behave if **R2** weren't there?
