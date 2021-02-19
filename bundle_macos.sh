#!/bin/bash

# macos release
./build.sh release macos
rm lite-macos.zip 2>/dev/null
rm –rf lite.app 2>/dev/null
mkdir -p lite.app/Contents/{Frameworks,MacOS,Resources}

# frameworks
cp -RH /Library/Frameworks/SDL2.framework lite.app/Contents/Frameworks/
rm -fr lite.app/Contents/Frameworks/SDL2.framework/Versions/A/Headers/ 
rm -fr lite.app/Contents/Frameworks/SDL2.framework/Headers

# resources
cp icon.icns lite.app/Contents/Resources/icon.icns
cp Info.plist lite.app/Contents/Info.plist
cp -R data lite.app/Contents/MacOS/data

# executable
cp lite lite.app/Contents/MacOS/lite
chmod +x lite.app/Contents/MacOS/lite

# relink
install_name_tool -change @rpath/SDL2.framework/Versions/A/SDL2 @executable_path/../Frameworks/SDL2.framework/Versions/A/SDL2 lite
install_name_tool -change @rpath/SDL2.framework/Versions/A/SDL2 @executable_path/../Frameworks/SDL2.framework/Versions/A/SDL2 lite.app/Contents/MacOS/lite

# zip
zip lite-macos.zip lite.app -r