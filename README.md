# 🔐 AES-CTR Encryption with APB Interface (Verilog)

This project implements an **AES-128 Counter (CTR) Mode Encryption Engine** integrated with an **AMBA APB Slave Interface** using Verilog HDL. It is designed for secure and efficient cryptographic acceleration in FPGA-based embedded systems.

---

## 🎯 Objective & Motivation

The project serves as a practical implementation of cryptographic hardware, focused on:

Learning register-transfer-level (RTL) design for security applications.

Understanding AES core structure and transformation functions (SubBytes, ShiftRows, MixColumns, AddRoundKey).

Interfacing cryptographic cores with standard SoC buses (APB) to simulate real-world usage.

Gaining hands-on skills for future opportunities in defense, embedded systems, or FPGA-based security design.

## 🧠 Key Features

- ✅ **AES-128 Encryption** (CTR Mode)
- ✅ **Modular Design** with `subBytes`, `shiftRows`, `mixColumns`, and `keyExpansion`
- ✅ **APB Slave Interface** for easy integration with ARM-based SoCs
- ✅ **Testbench for Simulation** using `tb_APB_AES_CTR.v`
- ✅ **Synthesis-Friendly Code**, tested on Vivado 

---

## 📂 Directory Structure

```
AES-APB-1/
├── AES-APB-1.srcs/
│   └── sources_1/new/         # Verilog modules
│       ├── APB_AES_CTR.v      # Top-level AES + APB wrapper
│       ├── aes_round.v        # AES round logic
│       ├── subBytes.v         # S-Box substitution
│       ├── shiftRows.v        # Row shifting
│       ├── mixColumns.v       # MixColumns operation
│       ├── keyExpansion.v     # Key schedule logic
│       └── ...                # Other helper modules
│
│   └── sim_1/new/
│       └── tb_APB_AES_CTR.v   # Testbench for simulation
```

---

## ⚙️ APB Register Map

| Address | Signal        | Description                    |
|---------|---------------|--------------------------------|
| 0x00    | `ctrl`        | Start/Reset control            |
| 0x04    | `status`      | Done/Ready flag                |
| 0x08–0x0F | `input`     | 128-bit plaintext input        |
| 0x10–0x17 | `key`       | 128-bit AES key                |
| 0x18–0x1F | `counter`   | 128-bit counter input (CTR)    |
| 0x20–0x27 | `output`    | 128-bit ciphertext output      |

## 🔄 APB Interface Description

The design uses a simplified APB slave interface with support for:

Write to plain text registers

Write to key and counter registers

Trigger encryption operation

Read encrypted ciphertext

APB signals used:

PADDR, PWDATA, PWRITE, PSEL, PENABLE, PRDATA, PREADY

## 🔐 AES-CTR Core

AES-128 encryption using a 128-bit key

CTR mode: combines a counter with encryption for stream-like operation

AES core follows the standard 10-round process:

AddRoundKey

9 Main Rounds (SubBytes → ShiftRows → MixColumns → AddRoundKey)

1 Final Round (no MixColumns)
---

## 🚀 How to Simulate

1. Open Xilinx Vivado
2. Create a project and import all Verilog source files
3. Add `tb_APB_AES_CTR.v` as the simulation testbench
4. Run behavioral simulation

---

## 🛠️ Tools Used

- **Vivado** (Xilinx)
- **Verilog HDL**
---

## 📌 Applications

- Secure communication modules
- Defense & aerospace crypto accelerators
- Embedded encryption SoCs
- IoT hardware security modules

---
## 🚀 Future Enhancements

Add AES-128 decryption module.

Implement AXI-lite interface for high-performance integration.

Optimize for area/power on FPGA (Spartan-6/Artix-7).

Add support for side-channel attack protection (e.g., random masking).

Deploy on actual FPGA hardware for real-time secure comms.

## 🙋‍♂️ Author

**Vadan Shah**   
🔗 [GitHub Profile](https://github.com/VadanShah)

---


