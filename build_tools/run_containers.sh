#!/bin/sh

name=lokl1;port=4000; docker run -e N=$name -e P=$port --name=$name -p $port:$port -d lokl
name=lokl2;port=4001; docker run -e N=$name -e P=$port --name=$name -p $port:$port -d lokl
name=lokl3;port=4002; docker run -e N=$name -e P=$port --name=$name -p $port:$port -d lokl
