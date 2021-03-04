#!/bin/bash
files=/var/log/*.log
for f in $files
do
less $f | grep -E 'err | warn | fail' >> ~/Errors.log
done