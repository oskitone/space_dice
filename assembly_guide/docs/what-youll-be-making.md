---
id: what-youll-be-making
title: Oskitone Space Dice Assembly Guide
sidebar_label: What you'll be making
description: How to solder and assemble the Oskitone Space Dice Electronics Kit
image: /img/overhead-short-40-4-480.gif
slug: /
---

[![Space Dice 3D model](/img/12-80-960.gif)](/img/12-80-960.gif)

**Purchase a kit:** [https://www.oskitone.com/product/space-dice-diy-electronics-kit](https://www.oskitone.com/product/space-dice-diy-electronics-kit)

## What you'll be making

Space Dice is a combination space laser noise and electronic dice machine.

[![Fully assembled Space Dice](/img/completed_space_dice.jpg)](/img/completed_space_dice.jpg)

Electronics hobbyists have been cutting their teeth on [electronic dice](https://www.google.com/search?q=electronic+dice+soldering+kit) circuits for years. In them, you press a button and get a random number, usually between one and six like a six-side die (1D6).

Space Dice extends on that with unnecessary sound effects, 3D printing, and knob/switch controls for tone frequency, drain time, octave, counting time, and volume. It is as much fun as I could fit in an enclosure the size of an Altoids tin.

This guide walks you through how to solder and assemble it, step by step. It will take 30 minutes or so, not counting 3D-printing time.

<!-- ## What you'll learn

1. How machines count by building two different counting machines
2. Logic gates
3. What makes something random
4. Modulation
5. How to read a schematic -->

<!-- TODO: demo video -->

### Background

I used to teach a virtual [DIY synth/electronics](https://blog.tommy.sh/posts/shopdocs/) workshop, building noisy glitch machines on breadboards for a couple months then having a big show-and-tell at the end. It was lovely.

One of my favorite topics was unexpected behavior. Your circuit's doing a thing you didn't intend. Why? Is it reproducible? Useful?

My other favorite was "randomicity," the state of being random. How do machines pick random numbers and how are their approaches different from ours as fleshy humans? It's a surprisingly fun topic!

Anyway, Space Dice is sort of the product of those explorations. Make a machine that counts, stop it arbitrarily, muse on whether or not it qualifies as random. Then exploit some unexpected behavior to listen to it and imitate science fiction foley.

:::note TODO
Here's where I'll link to a blog post with lots more background info and design notes... Later!
:::

#### Smart, but not that kind of smart

There's no code in this kit. No Arduino, no Raspberry Pi, no microcontroller. (Not that there's anything wrong with that!)

Instead, Space Dice is implemented entirely in [4000-series CMOS chips](https://en.wikipedia.org/wiki/4000-series_integrated_circuits), a 50+ year old grab bag of integrated circuits that's persisted well beyond any other tech from the same era. This series of chips has logic gates, shift registers, switches, latches, timers, counters, LED/LCD drivers, you name it. Each chip is like a single function, except instead of a line of code it's a physical block of microscopic transistors etched in silicon. Said another way, you don't program these chips, you program _with_ them.

<!-- So, why would you anyone use these old CMOS chips instead of anything newer? Take your pick: technical challenge, education, soldering practice, or maybe just for fun! -->

<!-- Space Dice's functionality is accomplished with just three of them:

| Chip       | Purpose                                   | Usage                        |
| ---------- | ----------------------------------------- | ---------------------------- |
| **CD4017** | Decade counter with 10 sequential outputs | LED cycler                   |
| **CD4040** | Binary counter with 12 bit outputs        | Prescaler, octave generation |
| **CD4093** | Quad NAND logic gate                      | Oscillator, audio booster    | -->

<video controls>
  <source src="video/assembly-4-1920.mp4" type="video/mp4" />
</video>

### Disclaimers

You've been warned!

:::note
This kit requires through-hole soldering and takes about 30min to assemble. If you bought it without 3D-printed parts, you will need to print them yourself.
:::

:::warning
Not a toy. Choking hazard. Small parts. Not for children under 3 years.
:::

## About this guide

To save cost, trees, and frustration from outdated information, printed instructions are not included by default with Oskitone kits. This online guide will always be up to date and the best source of information for how to assemble your new toy.

Thank you for understanding!

:::note
If you run into any problems with your build or something in the guide seems incorrect, please [please _email_ me to let me know](https://www.oskitone.com/contact)! I'll do my best to help you, and your feedback will help improve the guide and other future Oskitone designs.
:::
