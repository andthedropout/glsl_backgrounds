#!/bin/bash

# Start two HTTP servers on different ports
# Use Ctrl+C to stop both servers

echo "Starting servers for dual monitor setup..."
echo "Monitor 1: http://localhost:8000/shader.html"
echo "Monitor 2: http://localhost:8001/random.html"
echo ""
echo "Add these URLs to Plash and configure which monitor each uses in Plash preferences"
echo "Press Ctrl+C to stop both servers"
echo ""

# Run both servers in background
python3 -m http.server 8000 &
PID1=$!

python3 -m http.server 8001 &
PID2=$!

# Wait and cleanup on exit
trap "kill $PID1 $PID2; echo 'Servers stopped'; exit" INT TERM

wait
