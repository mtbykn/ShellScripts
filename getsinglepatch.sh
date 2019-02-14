#!/bin/bash
# Gets patchset from single server

scp $1:*`date +"%m"`??`date +"%y".`* ../patching
