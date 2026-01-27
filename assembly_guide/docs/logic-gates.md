---
id: logic-gates
title: A primer on logic gates
description: Logic Gates 101
sidebar_label: A primer on logic gates
image: /img/overhead-short-40-4-480.gif
slug: /logic-gates
---

- [Logic gates](https://en.wikipedia.org/wiki/Logic_gate) are machines that perform, you guessed it, logic. They take input(s), perform some function on them, and finally provide a new output.
- All complex machines can be reduced to simpler machines. Chaining a dozen logic gates together can make a simple number adder. Twenty billion (or so!) can make an iPhone. Despite there only being seven different logic gates, they are the underlying fundamental building block for _all_ electronic technology.
- Philosophers talk about logic with the words "true" and "false". In electronics, we represent those ideas with presence of voltage (ie, VCC) or absence (ie, GND). Logic gates use an even simpler language: binary, 1s and 0s. True/false, yes/no, 1/0, +/-, VCC/GND, etc are all different expressions of the same idea.

The basic logic gates are NOT, OR, NOR (NOT OR), AND, NAND (NOT AND), XOR (Exclusive OR), XNOR (NOT XOR). Walk through the truth table for AND and see if it makes sense:

| A   | B   | A AND B |
| --- | --- | ------- |
| 0   | 0   | 0       |
| 0   | 1   | 0       |
| 1   | 0   | 0       |
| 1   | 1   | 1       |

The 4093 has NAND gates:

| A   | B   | A NAND B |
| --- | --- | -------- |
| 0   | 0   | 1        |
| 0   | 1   | 1        |
| 1   | 0   | 1        |
| 1   | 1   | 0        |

Additionally, its gates are Schmitt triggers, which means that the inputs have to exceed some voltage threshold to change the output.
