#!/bin/bash
EtcdSetKey() {
  curl -s -L ${1}${2} -XPUT -d value="${3}" > /dev/null
}

EtcdMakeDir() {
  curl -s -L ${1}${2} -XPUT -d dir=true > /dev/null
}