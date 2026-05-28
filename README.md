# Traffic Light Controller🚦

A hardware traffic light controller for a two-street intersection, implemented on an **Intel Cyclone III EP3C120F780C7 FPGA** using Verilog HDL.

**Tools:** Quartus · ModelSim · Cyclone III FPGA

---

## Project Overview

This project implements a traffic light controller for an intersection of two one-way streets (North and East). The controller uses car presence sensors — simulated via FPGA switches — to dynamically manage traffic flow.

## FPGA Demo

A real-time demonstration of the traffic light controller running on the Cyclone III FPGA board, showing the LED outputs and 7-segment countdown display responding to the car sensor switches.

🎥 [Watch Demo Video](FPGA%20Demo)

### FPGA Synthesis (Quartus)
1. Open `Traffic_Light_Controller.qpf` in Quartus
2. Compile the project (Processing → Start Compilation)
3. Program the Cyclone III FPGA
4. Use the onboard switches as car sensors and observe the LEDs and 7-segment display

---

## Behavioral Requirements

| Condition | Behavior |
|-----------|----------|
| No cars present | Remain in current green state indefinitely |
| Only one road has cars | Stay green on that road |
| Both roads have cars | Cycle through all 4 phases |
| Green phase duration | At least **30 seconds** |
| Yellow phase duration | Exactly **5 seconds** (both directions yellow) |

## Parameters

| Parameter | Default | Description |
|-----------|---------|-------------|
| `GREEN_TIME` | 30 | Green phase duration (seconds) |
| `YELLOW_TIME` | 5 | Yellow phase duration (seconds) |
| `CLK_DIV` | 50,000,000 | Clock divider for 1Hz from 50MHz |
| `MUX_CLK_DIV` | 50,000 | Clock divider for 7-segment MUX |

### Full Cycle (both roads have cars)

```
Green North / Red East  →  Yellow / Yellow  →  Red North / Green East  →  Yellow / Yellow  →  (repeat)
        30s                       5s                      30s                      5s
```

---

## FSM Design

The system uses a **synchronous Moore FSM** with four states:

| State | North Light | East Light |
|-------|------------|------------|
| `STATE_N_GREEN` | 🟢 Green | 🔴 Red |
| `STATE_N_YELLOW` | 🟡 Yellow | 🟡 Yellow |
| `STATE_E_GREEN` | 🔴 Red | 🟢 Green |
| `STATE_E_YELLOW` | 🟡 Yellow | 🟡 Yellow |

---

## 📁 Project Structure

```
Traffic_Light_Controller/
│
├── traffic_light_controller.v      # Top-level FSM module
├── traffic_light_controller_tb.v   # Testbench for simulation
├── timer.v                         # Timer & clock divider modules
├── wave.do                         # ModelSim waveform script
├── simu.mpf                        # ModelSim project file
│
├── Traffic_Light_Controller.pdf    # Full project report
│
├── output_files/                   # Quartus compilation output
├── db/                             # Quartus database
└── simulation/                     # Simulation files
```

---

## Hardware Interface

| Signal | Direction | Description |
|--------|-----------|-------------|
| `clk` | Input | 50 MHz system clock |
| `reset_n` | Input | Active-low reset |
| `sensor_N` | Input | North road car sensor (FPGA switch) |
| `sensor_E` | Input | East road car sensor (FPGA switch) |
| `G_N, Y_N, R_N` | Output | North traffic LEDs |
| `G_E, Y_E, R_E` | Output | East traffic LEDs |
| `seg[6:0]` | Output | 7-segment display data |
| `digit_sel[1:0]` | Output | 7-segment digit select |

---

## Module Breakdown

### `traffic_light_controller`
Top-level module. Contains the FSM logic, state transitions, and output assignments. Instantiates all submodules.

### `timer`
Countdown timer driven by the 1Hz clock. Signals `done` when the target time is reached and exposes the current `count`.

### `clock_divider`
Divides the 50 MHz FPGA clock down to 1 Hz for the FSM timer logic.

### `mux_clock_divider`
Faster clock divider used to multiplex the dual-digit 7-segment display.

### `seven_seg_decoder`
Converts a 4-bit BCD digit (0–9) into the 7-segment encoding for the display.

---

## Verification ✅ 

Verified through simulation in **ModelSim** and real-time testing on the FPGA.

| Test Scenario | Expected Behavior | Pass Criteria |
|---------------|-------------------|---------------|
| No cars present | Remain in North Green indefinitely | `G_N=1, R_E=1` after >30s |
| Only North car | Stay in North Green | `G_N=1, R_E=1` after >30s |
| Only East car | Transition to East Green after 30s + 5s | `R_N=1, G_E=1` |
| Both cars (full cycle) | Complete 70s cycle through all 4 states | All 4 states observed |
| East car leaves during North green | Remain in North Green | `G_N=1, R_E=1` |
| No cars in East Green | Remain in East Green | `G_E=1, R_N=1` after >30s |

---

## Full Report

The complete project report including circuit schematic, pin assignment, FSM diagram, and code walkthrough is available here:

📥 [TrafficLightController.pdf](TrafficLightController1.pdf)



