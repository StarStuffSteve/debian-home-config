from flask import Flask, render_template
from redis import Redis, RedisError
from collections import OrderedDict

import os
import socket

app = Flask(__name__)

redis_connections = {}
base_redis_host = os.getenv('SIM_BASE')
# FIXME: This is fragile
num_redis_hosts = int(os.getenv('SIM_HOSTS', '-1'))

# TODO: Use to get all unseen host data
host_data = {}

# Attempt to attach to each backend simulation instance
for num in range(1, num_redis_hosts+1):
    redis_host = base_redis_host + "-" + str(num) 
    print("Attempting to connect to: {}".format(redis_host))
    try:
        redis_connections[redis_host] = Redis(
                host=redis_host,
                port=6379,
                db=0
            )
    except RedisError as e:
        redis_connections[redis_host] = False

@app.route("/")
def home():
    
    for redis_host, redis_conn in redis_connections.items():
        if redis_conn != False:

            # TODO: Use to get all unseen host data
            #if host_data[redis_host]["step"]:
            #    last_step_id = ...
            #else
            #    last_step_id = -1

            last_step_id = -1;
            step_map = {};
            try:
                # Get last step id for a given simulation
                last_step_id = int(redis_conn.mget("last_step_id")[0])
                # Use last step id to get the data map for the given step
                step_map_values = redis_conn.hmget(str(last_step_id), ['soc', 'current', 'voltage'])

                step_map_keys = ['soc', 'current', 'voltage']
                # Create dictionary from list of values for a given step
                step_map = dict(zip(step_map_keys, step_map_values))
            
            except RedisError as e:
                step_map = {"Error": "Unavailable"}

            # Locally store data for a given simulation host for use in rendered template
            host_data[redis_host] = {}
            host_data[redis_host]["map"] = step_map
            host_data[redis_host]["step"] = last_step_id

        else:
            try:
                print("Attempting to connect to: {}".format(redis_host))
                redis_connections[redis_host] = Redis(
                        host=redis_host,
                        port=6379,
                        db=0
                    )
            except RedisError as e:
                redis_connections[redis_host] = False

    # Order host data by hostname
    ord_host_data = OrderedDict(sorted(host_data.items(),\
                key=lambda t: t[0])
            )
    
    # Render template which will create section for each host data item
    return render_template("index.html",\
                env_greet=os.getenv("GREET", "Docker"),
                hostname=socket.gethostname(),
                host_data=ord_host_data
            )

if __name__ == "__main__":
    app.run(host='0.0.0.0', port=80)
