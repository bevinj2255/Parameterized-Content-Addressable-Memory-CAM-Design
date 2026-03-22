# Parameterized-Content-Addressable-Memory-CAM-Design

## Overview

A parameterized Content Addressable Memory (CAM) module designed in Verilog, supporting efficient value-based search operations with address output. The design includes write, search, and delete functionality along with status tracking.

---

## Key Features

* Parameterizable depth, data width, and address size
* Valid-bit management for each entry
* Priority-based matching (lowest index returned on duplicates)
* Entry deletion / invalidation support
* Synchronous reset
* Full and empty status indicators
* Fully verified using a dedicated testbench

---

## Port Description

| Port        | Direction | Width      | Description                     |
| ----------- | --------- | ---------- | ------------------------------- |
| clk         | Input     | 1          | System clock                    |
| rst         | Input     | 1          | Synchronous reset (active high) |
| we          | Input     | 1          | Write enable                    |
| waddr       | Input     | ADDR_WIDTH | Address for write operation     |
| din         | Input     | WIDTH      | Data input                      |
| delete_en   | Input     | 1          | Deletes entry at given address  |
| search_en   | Input     | 1          | Initiates search operation      |
| search_key  | Input     | WIDTH      | Data value to search            |
| match       | Output    | 1          | High when match is found        |
| match_index | Output    | ADDR_WIDTH | Address of matched entry        |
| busy        | Output    | 1          | Indicates search completion     |
| full        | Output    | 1          | High when memory is full        |
| empty       | Output    | 1          | High when memory is empty       |

---

## Parameters

| Parameter  | Default | Description                   |
| ---------- | ------- | ----------------------------- |
| DEPTH      | 16      | Number of entries             |
| WIDTH      | 8       | Data width (bits)             |
| ADDR_WIDTH | 4       | Address width (≥ log₂(DEPTH)) |

---

## Simulation

### Icarus Verilog

```bash
iverilog -o cam_tb.vvp rtl/cam.v tb/cam_tb.v
vvp cam_tb.vvp
gtkwave cam_tb.vcd   # optional waveform viewing
```

### Xilinx Vivado

```tcl
read_verilog rtl/cam.v
read_verilog tb/cam_tb.v
launch_simulation
```

---

## Testbench Coverage

| Test Case   | Description                               |
| ----------- | ----------------------------------------- |
| Reset       | Verifies proper initialization of flags   |
| Write       | Confirms correct data storage             |
| Search Hit  | Detects correct match and index           |
| Search Miss | Ensures no false matches                  |
| Priority    | Returns lowest index on duplicate entries |
| Delete      | Removes entry and updates search results  |
| Overwrite   | Replaces old data correctly               |
| Full Flag   | Asserts when all entries are occupied     |

---

## Notes

This design focuses on efficient search-based memory operations and can be extended for applications such as lookup tables, caching mechanisms, and high-speed matching systems.
