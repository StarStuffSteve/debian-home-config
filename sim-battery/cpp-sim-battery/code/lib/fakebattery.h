#ifndef FAKEBATTERY_H
#define FAKEBATTERY_H

// expecting current in mA and timestep in s
double get_soc(double current, int time_step); 
// Adds random jitter +/- 0.1V in voltage 
double get_voltage();

#endif
