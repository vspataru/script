#!/bin/bash
if [[ systemctl is-active --quiet apache2.service ]]; then
systemctl start apache2.service
fi

if [[ systemctl is-active --quiet crond.service ]]; then
systemctl start crond.service
fi