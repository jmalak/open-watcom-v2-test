echo on
call "C:\Program Files (x86)\Microsoft Visual Studio 14.0\VC\vcvarsall.bat" amd64

echo on
set OWDOSBOXPATH=%OWCIBIN%
set OWDOSBOX=dosbox.exe
set SDL_VIDEODRIVER=dummy
set SDL_AUDIODRIVER=disk
set SDL_DISKAUDIOFILE=NUL

call %OWROOT%\cmnvars.bat

echo on
%OWCOVERITY_TOOL_CMD% --dir cov-int %OWCOVERITY_SCRIPT%
