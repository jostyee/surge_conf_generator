#!/bin/sh

set -ex

proxy=$(<proxy.conf)
rule=$(<surge-cn.conf)
placeholder='\#placeholder'
echo "${rule/$placeholder/$proxy}" > surge.conf
