---
id: bom
title: Annotated BOM
description: Bill of Materials, annotated.
sidebar_label: Annotated BOM
slug: /bom
image: /img/overhead-short-40-4-480.gif
hide_table_of_contents: true
---

| ID                | Quantity | Designation | Marking         | Footprint                                        | Purpose                                                     |
| ----------------- | -------- | ----------- | --------------- | ------------------------------------------------ | ----------------------------------------------------------- |
| BT1               | 1        | 9v          |                 | battery                                          | power                                                       |
| C1,C4             | 2        | 220uF       |                 | CP_Radial_D7.5mm_P2.50mm                         | DROP voltage storage, speaker coupler                       |
| C2,C3,C5          | 3        | .1uF        | 104             | C_Disc_D5.0mm_W2.5mm_P5.00mm                     | relaxation oscillator feedback voltage storage, bypass caps |
| D1,D2,D3,D4,D5,D6 | 6        | LED         |                 | LED_D3.0mm                                       | roll count display                                          |
| LS1               | 1        | AZ40R       |                 | speaker                                          | audio output                                                |
| R1,R2,R3          | 3        | 1k          | Brown Black Red | R_Axial_DIN0207_L6.3mm_D2.5mm_P7.62mm_Horizontal | pulldown/drain, relaxation oscillator feedback drain,       |
| RV1,RV2,RV3       | 3        | 10k log     | A10K            | Potentiometer_Bourns_PTV09A-1_Single_Vertical    | DROP, VOL, TONE                                             |
| SW2               | 1        | SW_SPST     |                 | SW_PUSH_6mm                                      | roll trigger                                                |
| SW3               | 1        | SW_SPDT     |                 | SW_CuK_OS102011MA1QN1_SPDT_Angled                | power on/off                                                |
| SW1,SW4           | 2        | SW_SPDT     |                 | SW_Slide_1P2T_CK_OS102011MS2Q                    | octave high/low, roll count increment fast/slow             |
| U1                | 1        | 4093        |                 | DIP-14_W7.62mm_Socket_LongPads                   | quad NAND -> oscillator, square wave booster/amp            |
| U2                | 1        | 4040        |                 | DIP-16_W7.62mm_Socket_LongPads                   | binary counter -> prescaler                                 |
| U3                | 1        | 4017        |                 | DIP-16_W7.62mm_Socket_LongPads                   | decade counter -> LED cycler                                |

Also:

- A couple inches of 2-wire ribbon cables (or similar small gauge, stranded wire)
  - Or some of the 9v snap's wires if they're long enough
- 3 DIP sockets
  - 2 16-pin for **U1**, **U2**
  - 1 14-pin for **U3**
- Nuts and bolts
  - 1 4/40 square nuts
  - 1 4/40 1/2" machine screws
- A small piece of double-sided tape

Alternate speakers for the AZ40R:

- PSR-40N08A05-JQ
- AS04008MR-21-R
- CMS-4051-058SP

Any circular 8ohm speaker that matches the dimensions will probably work, thought you may find you need a bit of hot glue to hold it in place.

Final note on **R3**: the schematic has its value as 330-1k. The kit ships with 1k to reduce the brightness on its bright white LEDs. For other colors or types of LEDs, a lower value resistor may be preferable.
