# CPU with AXI4

## **1. Specification**


| Component              | Role     |  Memory mapped             |
| --------               | -------- |  --------                  |
| **IF stage**           | Master 0 |                            |
| **MEM stage**          | Master 1 |                            |
| **Instruction memory** | Slave  0 |  0x0000_0000 - 0x0000_ffff |
| **Data memory**        | Slave  1 |  0x0001_0000 - 0x0001_ffff |


![8](https://github.com/Rex1110/CPU-AXI4/assets/123956376/c1e8d2d0-9da3-4f5a-8f83-16826952c6e7)

![9](https://github.com/Rex1110/CPU-AXI4/assets/123956376/3b520904-4537-45cd-8938-4a4c26ea7566)

![10](https://github.com/Rex1110/CPU-AXI4/assets/123956376/bf6914ee-62fb-4b80-916f-5825b3af1615)

![11](https://github.com/Rex1110/CPU-AXI4/assets/123956376/1f26991e-4c6d-4299-8fb5-56dc36566ddf)

![12](https://github.com/Rex1110/CPU-AXI4/assets/123956376/fdb995dd-25f7-457e-a331-d0bae03a1cc7)

![13](https://github.com/Rex1110/CPU-AXI4/assets/123956376/51237751-3f4f-418a-bab5-ac25ccc9eb3d)


## **2. Schematic**

![1](https://github.com/Rex1110/CPU-AXI4/assets/123956376/7521f20f-1509-4d81-a5cc-e3261d1eebf6)


### Shared Address Shared Data architecture

![2](https://github.com/Rex1110/CPU-AXI4/assets/123956376/57ccca98-f4e8-49ad-a30f-4e61d0e5157b)


## **3. State machine**

### **1. Master 0 (IF stage)**
Master 0 為 IF stage，只需要與 Instruction memory 讀溝通，如果今天 CPU 中無 Load、Store 指令在管線中，則不斷地抓取指令，之所以這樣設計是因為 IF stage 讀取進來後位於 MEM stage 的指令正在使用 AXI bus 這樣管線就需要暫停，因此為了方便直接判斷管線中是否有 Load、 Store 指令，有的話暫停等到 Load、Store 使用完 AXI bus 再繼續讀取。


![3](https://github.com/Rex1110/CPU-AXI4/assets/123956376/d304af52-6ed2-4af7-9ee7-78fb7cbc65e8)



### **2. Master 1 (MEM stage)**
Master 1 為 Mem stage，測資"讀"範圍 Instruction memory、 Data memory，以及"寫"範圍 Data memory，AXI bus 使用上若要寫入則為 Store 指令，因此判斷 DM_WEB 是否需寫入，若要讀取則判斷是否 DM_OE，雖然訊號線為 DM(Data memory) 但事實上讀取範圍可能跨到 Instruction memory 位置。

![4](https://github.com/Rex1110/CPU-AXI4/assets/123956376/7239921a-95d3-492a-9f77-2537461a8a08)


### **3. Slave 0, 1(SRAM)**
| Component              | Role     |  Memory mapped             |
| --------               | -------- |  --------                  |
| **Instruction memory** | Slave  0 |  0x0000_0000 - 0x0000_ffff |
| **Data memory**        | Slave  1 |  0x0001_0000 - 0x0001_ffff |

![5](https://github.com/Rex1110/CPU-AXI4/assets/123956376/f873a184-2e80-4062-80e5-d8ba1912c989)


### **4. AXI Read Arbiter**
AXI interconnect 中的讀通道仲裁器。

根據測資， \
M0 讀取範圍只有 S0， \
M1 讀取範圍不只 S1 會跨到 S0。

- **1. IDLE state**\
  ARVALID_MX 拉起則進入 AR_MX_SY state 其中 Slave 根據 Master 欲讀取位置選擇。

- **2. AR_MX_SY state**\
  當 ARVALID_MX && ARREADY_SY 進入 R_MX_SY state。

- **3. R_MX_SY state**\
  當 RVALID_SY && RREADY_MX && RLAST_SY 回到 IDLE state。

![6](https://github.com/Rex1110/CPU-AXI4/assets/123956376/45e5ed19-2322-4f5e-b746-bcd2198f79e1)



### **5. AXI Write Arbiter**
AXI interconnect 中的寫通道仲裁器，只有 Master 0 會進行寫操作，並且只與 Slave 1 交流。

- **1. IDLE state**\
  AWVALID_M1 拉起則進入並且位置指向 Slave 1 進入 AW_M1_S1 state。

- **2. AW_M1_S1 state**\
  AWVALID_M1 && AWREADY_S1 進入 W_M1_S1 state。

- **3. W_M1_S1 state**\
  WVALID_M1 && WREADY_S1 && WLAST_M1 進入 B_M1_S1。

- **4. B_M1_S1**\
  BREADY_M1 && BVALID_S1 回到 IDLE state。

![7](https://github.com/Rex1110/CPU-AXI4/assets/123956376/b7cf4d5b-dc02-4aa6-983a-9b2f58ee42fa)




