# Containerized simple Python script to calculate take-home salary based on CTC.
This work is an effort to convert a Python script into a containerized app. 
It just pulls an image from an official Python repository and uploads the script to a path in the image.

Prequisites
----------------
1. Docker Desktop
2. VS code(if you want to edit docker file.)

#How to run?
Download the files and run the below commands on a docker installed machine. 
1. Build the image:
   docker build -t <tag_name> . -f Dockerfile.dockerfile docker images
2. Get the image name:
   docker images
3. Run the image:
   docker run -it 8256c394f432 python "/usr/app/src/taxcalc.py" 

   
   
   
