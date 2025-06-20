#!/bin/bash
cd /home/ubuntu/app
nohup python3 app.py > app.log 2>&1 &
