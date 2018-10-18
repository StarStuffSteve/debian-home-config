# Use an official Python runtime as a parent image
FROM python:3.6-slim

# Set the working directory to /app
WORKDIR /app

# Add just the requirements file to the app directory
COPY ./code/requirements.txt /app

# Install any needed packages specified in requirements.txt
RUN pip3 install --trusted-host pypi.python.org -r requirements.txt

# Add the remainder of our application code
COPY ./code/app.py /app
#RUN ls

# Make port 80 available to the world outside this container
EXPOSE 80

# Define environment variable
ENV NAME Telespazio

# Run app.py when the container launches
CMD ["python3", "app.py"]
