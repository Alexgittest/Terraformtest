#!/bin/bash
pub_ip=`terraform output | cut -d "\\"" -f 2`
echo -e "[dev]\nAWS-ubuntu ansible_host=$pub_ip" > hosts
