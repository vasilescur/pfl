@echo off

if exist main.dart.snapshot (
    echo Deleting main.dart.snapshot
    del main.dart.snapshot
)

echo Creating snapshot...
dart --snapshot=main.dart.snapshot bin/main.dart

if exist ..\dartbin-master\main.dart.snapshot (
    echo Deleting snapshot from dartbin...
    del ..\dartbin-master\main.dart.snapshot
)

echo Moving shapshot file...
move main.dart.snapshot ..\dartbin-master

cd ..\dartbin-master

echo Generating Go files...
dart bin/main.dart main.dart.snapshot

cd go_src

if exist go_src.exe (
    echo Deleting go_src.exe ...
    del go_src.exe
)

if exist pfl.exe (
    echo Deleting pfl.exe ...
    del pfl.exe
)

echo Running Go build...
env GOPATH=C:\Users\vasil\Desktop\Programming\Dart\dartbin-master\go_src go build -v
echo Go build finished.

echo Renaming file...
rename go_src.exe pfl.exe

echo Done.
cd ..\..\pfl