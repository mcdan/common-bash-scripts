#!/bin/bash

#Containername
IsContainerRunning () {
	data=$(docker inspect ${1} 2>&1)
	status=$?
  if [ ${status} -ne 0 ]; then
    return ${status}
  fi

  local runningState=$(docker inspect ${1} | jq '.[0].State.Running' |  sed 's/^\"//;s/\"$//')

  if [[ "$runningState" == "false" ]]; then
    #echo Container ${1} NOT running but name is taken, removing the name
    docker rm ${1} > /dev/null
    return 127
  else
    return 0
  fi
}

#Containername, port, protocol
GetPortNumberFromContainer () {
  IsContainerRunning ${1}
  if [ $? -ne 0 ]; then
    echo Could not find container: ${1}
    exit -1
  fi
  local portnum=${2}
  local protocol=${3}

  docker inspect ${1} | jq '.[0].NetworkSettings.Ports["'${portnum}'/'${protocol}'"][0].HostPort' |  sed 's/^\"//;s/\"$//'
}