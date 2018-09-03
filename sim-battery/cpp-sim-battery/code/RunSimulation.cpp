#include <cpp_redis/cpp_redis>

#include <stdio.h>
#include <time.h>
#include <iostream>
#include <string>

// My fake battery ;)
#include "./lib/fakebattery.h"

// TODO remove hardcoded config
const int TIME_STEP = 1;
const int LIMIT = 360;

// Default current 500mA
double current = 500;

// Function called asynchronously to update the global current vrb
void capture_current(cpp_redis::reply& reply) {
	if (reply.is_string()) {
    // string to double
		double input_current = std::stod(reply.as_string());

    // Update global current if DB current is not current current
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
  
  // Connect to redis server on local host
  client.connect("127.0.0.1", 6379, [](const std::string& host, std::size_t port, cpp_redis::client::connect_state status) {
    if (status == cpp_redis::client::connect_state::dropped) {
      std::cout << "Client disconnected from " << host << ":" << port << std::endl;
    }
  });
  
  client.set("input_current", std::to_string(current), [](cpp_redis::reply& reply) {
      //std::cout << "Setting initial input_current reply : " << reply << std::endl;
  });

  // Set initial step id
  int step_id = 0;
  std::string str_step_id = std::to_string(step_id);

  // Setting up local data objects
  std::string str_soc;
  std::pair<std::string, std::string> pair_soc; 

  std::string str_voltage;
  std::pair<std::string, std::string> pair_voltage; 

  std::string str_current;
  std::pair<std::string, std::string> pair_current; 

  std::vector<std::pair<std::string, std::string>> step_map(3);

  // FIXME: This is probably crazy bad practice
  // Its become clear to me that I should run a sim in respone to a scheduler
	while(true)
	{
		this_time = clock();
		time_counter += (double)(this_time - last_time);
		last_time = this_time;

    // If we hit our time step
		if(time_counter > (double)(TIME_STEP * CLOCKS_PER_SEC))
		{
      // Don't overflow, could use modulo 
			time_counter -= (double)(TIME_STEP * CLOCKS_PER_SEC);

			step_id++;
			str_step_id = std::to_string(step_id);

      // update last step id
			client.set("last_step_id", str_step_id, [](cpp_redis::reply& reply) {
        //Do nothing
			});

      // Check for updates to the input_current
      // Async callback
			client.get("input_current", capture_current);

      // In production these will get logged to CloudWatch
      std::cout << "Step: " << step_id << " - " \
        << "SOC: " << get_soc(current, TIME_STEP) << "mAh - " \
        << "Voltage: " << get_voltage() << "V - " \
        << "Current: " << current << "mA - " << std::endl;

      // Populate date objects
      str_soc = std::to_string(get_soc(current, TIME_STEP));
      pair_soc = std::make_pair("soc", str_soc);

      str_voltage = std::to_string(get_voltage());
      pair_voltage = std::make_pair("voltage", str_voltage);

      str_current = std::to_string(current);
      pair_current = std::make_pair("current", str_current);

      step_map.push_back(pair_soc);
      step_map.push_back(pair_voltage);
      step_map.push_back(pair_current);

      // Upload step data to redis
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
