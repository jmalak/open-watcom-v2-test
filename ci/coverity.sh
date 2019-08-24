#!/bin/sh

. $OWROOT/cmnvars.sh

env | sort

$OWCOVERITY_TOOL_CMD --dir cov-int $OWCOVERITY_SCRIPT
