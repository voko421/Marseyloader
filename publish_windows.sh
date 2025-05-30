#!/bin/bash

cd "$(dirname "$0")"

./download_net_runtime.py windows

# Clear out previous build.
rm -r **/bin bin/publish/Windows
rm SS14.Launcher_Windows.zip

dotnet publish SS14.Launcher/SS14.Launcher.csproj /p:FullRelease=True -c Release --no-self-contained -r win-x64 /nologo /p:RobustILLink=true
dotnet publish SS14.Loader/SS14.Loader.csproj -c Release --no-self-contained -r win-x64 /nologo
dotnet publish SS14.Launcher.Strap/SS14.Launcher.Strap.csproj -c Release /nologo

./exe_set_subsystem.py "SS14.Launcher/bin/Release/net9.0/win-x64/publish/SS14.Launcher.exe" 2
./exe_set_subsystem.py "SS14.Loader/bin/Release/net9.0/win-x64/publish/SS14.Loader.exe" 2

# Create intermediate directories.
mkdir -p bin/publish/Windows/bin
mkdir -p bin/publish/Windows/bin/loader
mkdir -p bin/publish/Windows/dotnet
mkdir -p bin/publish/Windows/Marsey/Mods
mkdir -p bin/publish/Windows/Marsey/ResourcePacks

cp -r Dependencies/dotnet/windows/* bin/publish/Windows/dotnet
cp "SS14.Launcher.Strap/bin/Release/net45/publish/Marseyloader.exe" bin/publish/Windows
cp "SS14.Launcher.Strap/console.bat" bin/publish/Windows
cp SS14.Launcher/bin/Release/net9.0/win-x64/publish/* bin/publish/Windows/bin
cp SS14.Loader/bin/Release/net9.0/win-x64/publish/* bin/publish/Windows/bin/loader

pushd bin/publish/Windows
zip -r ../../../SS14.Launcher_Windows.zip *
popd
