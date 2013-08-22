import random
import os
import datetime
import time

for fl in os.listdir('.'):
    # choose a random second between now
    # and the epoch
    now = int(time.time())
    timestamp = int(random.random()*now)
    os.utime(fl, (timestamp, timestamp))
