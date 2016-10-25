#!/bin/sh

work=$((25*60))
rest=$((5*60))

notify-send "25 minute pomodoro sprint started" 
for i in $(seq 100); do
    echo "pomodoro:set_value(${i})" | awesome-client
    sleep $(echo "scale=3;${work}/100" | bc)
done
 
notify-send "5 minute pomodoro rest started"
for i in $(seq 100); do
    j=$((100-i))
    echo "pomodoro:set_value(${j})" | awesome-client
    sleep $(echo "scale=3;${rest}/100" | bc)
done
