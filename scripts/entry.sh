#!/bin/bash


[ "$#" -eq 0 ] && { bash; exit; }

python3 /opt/cxcli/cli_proxy.py "$@"
