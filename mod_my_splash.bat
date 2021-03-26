@echo off
echo.
echo.#------------------------------------------------#
echo.# Redmi Note 7/7s - lavender Splash Image Maker  #
echo.#                                                #
echo.#    adapted by Mark Key from ** Gokul NC *      #
echo.#------------------------------------------------#
echo.
echo.
echo.Creating splash.img ........
echo.
echo.
echo.

set output_file=splash.img
set output_file_path=output\%output_file%

set output_zip=flashable_splash.zip
set output_zip_path=output\%output_zip%

setlocal
if not exist "output\" mkdir "output\"
if not exist "temp\" ( mkdir "temp\"& attrib /S /D +h "temp" )
del /Q temp\* 2>NUL
del /Q %output_file_path% 2>NUL
del /Q %output_zip_path% 2>NUL

set resolution=1080x2340

:VERIFY_FILES
set boot_path="not_found"
if exist "pics\boot.jpg" set boot_path="pics\boot.jpg"
if exist "pics\boot.jpeg" set boot_path="pics\boot.jpeg"
if exist "pics\boot.png" set boot_path="pics\boot.png"
if exist "pics\boot.gif" set boot_path="pics\boot.gif"
if exist "pics\boot.bmp" set boot_path="pics\boot.bmp"
if %boot_path%=="not_found" echo.boot picture not found in 'pics' folder.. EXITING&echo.&echo.&pause&exit

set fastboot_path="not_found"
if exist "pics\fastboot.jpg" set fastboot_path="pics\fastboot.jpg"
if exist "pics\fastboot.jpeg" set fastboot_path="pics\fastboot.jpeg"
if exist "pics\fastboot.png" set fastboot_path="pics\fastboot.png"
if exist "pics\fastboot.gif" set fastboot_path="pics\fastboot.gif"
if exist "pics\fastboot.bmp" set fastboot_path="pics\fastboot.bmp"
if %fastboot_path%=="not_found" echo.fastboot picture not found in 'pics' folder.. EXITING&echo.&echo.&pause&exit

set unlocked_path="not_found"
if exist "pics\unlocked.jpg" set unlocked_path="pics\unlocked.jpg"
if exist "pics\unlocked.jpeg" set unlocked_path="pics\unlocked.jpeg"
if exist "pics\unlocked.png" set unlocked_path="pics\unlocked.png"
if exist "pics\unlocked.gif" set unlocked_path="pics\unlocked.gif"
if exist "pics\unlocked.bmp" set unlocked_path="pics\unlocked.bmp"
if %unlocked_path%=="not_found" echo.unlocked picture not found in 'pics' folder.. EXITING&echo.&echo.&pause&exit

set system_damaged_path="not_found"
if exist "pics\system_damaged.jpg" set system_damaged_path="pics\system_damaged.jpg"
if exist "pics\system_damaged.jpeg" set system_damaged_path="pics\system_damaged.jpeg"
if exist "pics\system_damaged.png" set system_damaged_path="pics\system_damaged.png"
if exist "pics\system_damaged.gif" set system_damaged_path="pics\system_damaged.gif"
if exist "pics\system_damaged.bmp" set system_damaged_path="pics\system_damaged.bmp"
if %system_damaged_path%=="not_found" echo.system_damaged picture not found in 'pics' folder.. EXITING&echo.&echo.&pause&exit

:: Create BMP
bin\ffmpeg.exe -hide_banner -loglevel quiet -i %boot_path% -pix_fmt rgb24 -s %resolution% -y "temp\splash1.bmp" > NUL
bin\ffmpeg.exe -hide_banner -loglevel quiet -i %fastboot_path% -pix_fmt rgb24 -s %resolution% -y "temp\splash2.bmp" > NUL
bin\ffmpeg.exe -hide_banner -loglevel quiet -i %unlocked_path% -pix_fmt rgb24 -s %resolution% -y "temp\splash3.bmp" > NUL
bin\ffmpeg.exe -hide_banner -loglevel quiet -i %system_damaged_path% -pix_fmt rgb24 -s %resolution% -y "temp\splash4.bmp" > NUL

:: Create the full splash.img by concatenating header and all BMP files
copy /b "bin\empty_header.img"+"temp\splash1.bmp"+"bin\placeholder.img"+"temp\splash2.bmp"+"bin\placeholder.img"+"temp\splash3.bmp"+"bin\placeholder.img"+"temp\splash4.bmp" %output_file_path% >NUL

if exist %output_file_path% ( echo.SUCCESS!&echo. %output_file% created in "output" folder
) else ( echo.PROCESS FAILED.. Try Again&echo.&echo.&pause&exit )

echo.&echo.&set /P INPUT=Do you want to create a flashable zip? [yes/no]
If /I "%INPUT%"=="y" goto :CREATE_ZIP
If /I "%INPUT%"=="yes" goto :CREATE_ZIP

echo.&echo.&echo Flashable ZIP not created..&echo.&echo.&pause&exit

:CREATE_ZIP
copy /Y bin\splash.zip %output_zip_path% >NUL
cd output
..\bin\7za a %output_zip% %output_file% >NUL
cd..

if exist %output_zip_path% (
 echo.&echo.&echo.SUCCESS!
 echo.Flashable zip file created in "output" folder
 echo.You can now flash the '%output_zip%' using OrangeFox or TWRP
) else ( echo.&echo.&echo Flashable ZIP not created.. )

echo.&echo.&pause&exit
