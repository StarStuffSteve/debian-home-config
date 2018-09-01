#include <ctime>  
#include <cstdlib>

const int VOLTAGE = 5;
// mAh
const int START_CAPACITY = 1000;

double capacity = START_CAPACITY;

double get_soc(double current, int time_step) 
{
  capacity = ((capacity * 3600) - (current * time_step))/3600;
  return capacity;
}

double get_voltage()
{
  srand(time(0));
  double jitter = double(((rand() % 10) + 1))/100;
  int choice = (rand() % 10) + 1;
  
  if (choice > 5)
    return VOLTAGE - jitter;
  else
    return VOLTAGE + jitter;  
}
