while true; do temp=$(echo "$(</sys/class/thermal/thermal_zone0/temp)/1000" | bc -l); printf "$(hostname) CPU Temp: %.3f°C\n" $temp; sleep 1; done
