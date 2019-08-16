@set OWECHO=off
@if "%OWDEBUG%" == "1" set OWECHO=on
@echo %OWECHO%
SETLOCAL EnableExtensions
REM Script to build the Open Watcom bootstrap tools
REM By Microsoft Visual Studio
REM ...
set OWROOT=%CD%
REM ...
call "C:\Program Files (x86)\Microsoft Visual Studio 14.0\VC\vcvarsall.bat" amd64
REM ...
@echo %OWECHO%
REM ...
REM setup DOSBOX
REM ...
set OWDOSBOXPATH=%OWROOT%\travis\dosbox
set OWDOSBOX=dosbox.exe
set SDL_VIDEODRIVER=dummy
set SDL_AUDIODRIVER=disk
set SDL_DISKAUDIOFILE=NUL
REM ...
REM setup Help Compilers
REM ...
set OWGHOSTSCRIPTPATH=%OWROOT%\travis\gs927w64
set OWWIN95HC=%OWROOT%\travis\hcw\hcrtf.exe
set OWHHC=%OWROOT%\travis\hhc\hhc.exe
REM ...
call cmnvars.bat
REM ...
@echo %OWECHO%
REM ...
if "%OWDEBUG%" == "1" (
    echo INCLUDE="%INCLUDE%"
    echo LIB="%LIB%"
    echo LIBPATH="%LIBPATH%"
)
REM ...
set RC=0
cd %OWSRCDIR%
if "%OWBUILD_STAGE%" == "boot" (
    mkdir %OWBINDIR%
    cd %OWSRCDIR%
    cd wmake
    mkdir %OWOBJDIR%
    cd %OWOBJDIR%
    nmake -f ..\nmake clean >>%OWBINDIR%\bootx.log 2>&1
    nmake -f ..\nmake >>%OWBINDIR%\bootx.log 2>&1
    set RC=%ERRORLEVEL%
    cd %OWSRCDIR%
    if not %RC% == 1 (
        cd builder
        mkdir %OWOBJDIR%
        cd %OWOBJDIR%
        %OWBINDIR%\wmake -f ..\binmake clean >>%OWBINDIR%\bootx.log 2>&1
        %OWBINDIR%\wmake -f ..\binmake bootstrap=1 builder.exe >>%OWBINDIR%\bootx.log 2>&1
        set RC=%ERRORLEVEL%
        cd %OWSRCDIR%
        if not %RC% == 1 (
            builder boot
        )
    )
)
if "%OWBUILD_STAGE%" == "build" (
    builder rel
    set RC=%ERRORLEVEL%
)
if "%OWBUILD_STAGE%" == "tests" (
REM    builder rel
REM    set RC=%ERRORLEVEL%
)
if "%OWBUILD_STAGE%" == "docs" (
    REM register all Help Compilers DLL's
    regsvr32 -u -s itcc.dll
    regsvr32 -s %OWROOT%\travis\hhc\itcc.dll
    builder docs %OWDOCTARGET%
    set RC=%ERRORLEVEL%
)
if "%OWBUILD_STAGE%" == "inst" (
    builder missing
    builder install os_nt cpu_x64
    set RC=%ERRORLEVEL%
)
cd %OWROOT%
exit %RC%
