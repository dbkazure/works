FROM python:3.12.1-slim
# Or any preferred Python version.

WORKDIR /usr/app/src

#Copy the script/application from local to the container.
COPY taxcalc.py ./

# A non interactive script can be run this way.
#CMD [ "python","./taxcalc.py"]

