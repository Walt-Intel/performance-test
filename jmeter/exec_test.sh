#!/bin/bash

if [ ${slave1} != ${slave2} ] && [ ${slave1} != ${slave3} ]; then
    docker-compose run --rm jmeter -n -t script/testplan/core-metadata-uploadprofile.jmx -q script/testplan/edgex.properties -l script/logs/core-metadata-uploadprofile.jtl -J influxdbHost=${influxDBHost} -J test.machine=${slave1} &
    sleep 10s
    docker-compose run --rm jmeter -n -t script/testplan/core-metadata-createaddressable.jmx -q script/testplan/edgex.properties -l script/logs/core-metadata-createaddressable.jtl -J influxdbHost=${influxDBHost} -J test.machine=${slave2} &
    sleep 10s
    docker-compose run --rm jmeter -n -t script/testplan/core-data-sendingevent.jmx -q script/testplan/edgex.properties -l script/logs/core-data-sendingevent.jtl -J influxdbHost=${influxDBHost} -J test.machine=${slave3}
elif [ ${slave1} = ${slave3} ] && [ ${slave2} != ${slave3} ]; then
    docker-compose run --rm jmeter -n -t script/testplan/core-data-sendingevent.jmx -q script/testplan/edgex.properties -l script/logs/core-data-sendingevent.jtl -J influxdbHost=${influxDBHost} -J test.machine=${slave2} &
    sleep 10s
    docker-compose run --rm jmeter -n -t script/testplan/core-metadata-uploadprofile.jmx -q script/testplan/edgex.properties -l script/logs/core-metadata-uploadprofile.jtl -J influxdbHost=${influxDBHost} -J test.machine=${slave1} 
    docker-compose run --rm jmeter -n -t script/testplan/core-metadata-createaddressable.jmx -q script/testplan/edgex.properties -l script/logs/core-metadata-createaddressable.jtl -J influxdbHost=${influxDBHost} -J test.machine=${slave3}    
else
    docker-compose run --rm jmeter -n -t script/testplan/core-metadata-uploadprofile.jmx -q script/testplan/edgex.properties -l script/logs/core-metadata-uploadprofile.jtl -J influxdbHost=${influxDBHost} -J test.machine=${slave1}
    docker-compose run --rm jmeter -n -t script/testplan/core-metadata-createaddressable.jmx -q script/testplan/edgex.properties -l script/logs/core-metadata-createaddressable.jtl -J influxdbHost=${influxDBHost} -J test.machine=${slave3}
    docker-compose run --rm jmeter -n -t script/testplan/core-data-sendingevent.jmx -q script/testplan/edgex.properties -l script/logs/core-data-sendingevent.jtl -J influxdbHost=${influxDBHost} -J test.machine=${slave2}
fi
