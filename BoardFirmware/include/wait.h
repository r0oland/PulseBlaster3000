#ifndef WAIT
#define WAIT

#define NOP __asm__ __volatile__ ("nop\n\t") // one clock cycle ~4.25 ns
#define NOP_5 NOP; NOP; NOP; NOP; NOP;
#define NOP_10 NOP_5; NOP_5;
#define NOP_25 NOP_10; NOP_10; NOP_5;
#define NOP_50 NOP_25; NOP_25;
#define NOP_100 NOP_50; NOP_50;
#define NOP_500 NOP_100; NOP_100; NOP_100; NOP_100; NOP_100;
#define NOP_1000 NOP_500; NOP_500; NOP_100; NOP_100; NOP_100;

#define WAIT_10_NS NOP; NOP; NOP; NOP;
#define WAIT_20_NS NOP_10; NOP_10;

#endif
