#!/bin/bash
SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
aawmtt --config "$SCRIPT_DIR/rc.lua"
# aawmtt --config 
