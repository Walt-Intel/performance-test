#!/bin/ash
echo "Jmeter execution"
rm -rf /jmeter/script/logs
exec jmeter "$@"
