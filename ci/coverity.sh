#!/bin/sh

export OWDOSBOX=dosbox
export SDL_VIDEODRIVER=dummy
export SDL_AUDIODRIVER=disk
export SDL_DISKAUDIOFILE=/dev/null

. $OWROOT/cmnvars.sh

$OWCOVERITY_TOOL_CMD --dir cov-int $OWCOVERITY_SCRIPT
