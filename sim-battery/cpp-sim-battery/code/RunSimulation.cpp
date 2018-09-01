#include <cpp_redis/cpp_redis>

#include <stdio.h>
#include <time.h>
#include <iostream>
#include <string>

#include "./lib/fakebattery.h"
//using namespace cpp_redis;

// TODO remove hardcoded config
const int TIME_STEP = 1;
const int LIMIT = 360;

// Default current 500mA
double current = 500;

void capture_current(cpp_redis::reply& reply) {
	if (reply.is_string()) {
		double input_current = std::stod(reply.as_string());

    if ( input_current != current ) {
      current = input_current;
    }
	}
};

// TODO Use std::cout
int main()
{
  std::cout << "Starting Simulation" << std::endl;

	double time_counter = 0;
	clock_t this_time = clock();
	clock_t last_time = this_time;

  cpp_redis::client client;
  
  client.connect("127.0.0.1", 6379, [](const std::string& host, std::size_t port, cpp_redis::client::connect_state status) {
    if (status == cpp_redis::client::connect_state::dropped) {
      std::cout << "Client disconnected from " << host << ":" << port << std::endl;
    }
  });
  
  client.set("input_current", std::to_string(current), [](cpp_redis::reply& reply) {
      //std::cout << "Setting initial input_current reply : " << reply << std::endl;
  });

  int step_id = 0;
  std::string str_step_id = std::to_string(step_id);

  std::string str_soc;
  std::pair<std::string, std::string> pair_soc; 

  std::string str_voltage;
  std::pair<std::string, std::string> pair_voltage; 

  std::string str_current;
  std::pair<std::string, std::string> pair_current; 

  std::vector<std::pair<std::string, std::string>> step_map(3);

	while(true)
	{
		this_time = clock();
		time_counter += (double)(this_time - last_time);
		last_time = this_time;

		if(time_counter > (double)(TIME_STEP * CLOCKS_PER_SEC))
		{
			time_counter -= (double)(TIME_STEP * CLOCKS_PER_SEC);

			step_id++;
			str_step_id = std::to_string(step_id);

			client.set("last_step_id", str_step_id, [](cpp_redis::reply& reply) {
        //Do nothing
			});

      // Check for updates to the input_current
			client.get("input_current", capture_current);

      std::cout << "Step: " << step_id << " - " \
        << "SOC: " << get_soc(current, TIME_STEP) << "mAh - " \
        << "Voltage: " << get_voltage() << "V - " \
        << "Current: " << current << "mA - " << std::endl;

      str_soc = std::to_string(get_soc(current, TIME_STEP));
      pair_soc = std::make_pair("soc", str_soc);

      str_voltage = std::to_string(get_voltage());
      pair_voltage = std::make_pair("voltage", str_voltage);

      str_current = std::to_string(current);
      pair_current = std::make_pair("current", str_current);

      step_map.push_back(pair_soc);
      step_map.push_back(pair_voltage);
      step_map.push_back(pair_current);

      client.hmset(str_step_id, step_map, [](cpp_redis::reply& reply) { 
        // Do nothing
			});

			// synchronous commit, no timeout
			client.sync_commit();
			
			if (step_id == LIMIT) {
				break;
			}
		}
	}
  return 0;
}
