#!/bin/sh

xcodefolder=/Applications/Xcode45-DP2.app
resultdir=./app/Sparrow.app
identity=8272e46d228750c44ca2c666badfd9d85ed47858

cp embedded.mobileprovision $resultdir

$xcodefolder/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin/clang -arch armv7 \
 -isysroot $xcodefolder/Contents/Developer/Platforms/iPhoneOS.platform/Developer/SDKs/iPhoneOS6.0.sdk \
 Sparrow-main.a \
 -dead_strip -all_load \
 -Llib \
 -licucore -lCrashReporter-ios-Static -lGDataTouchStaticLib -letPanKit-ios -lsnappy -lctemplate -lxml2 -ltokyodystopia -ltokyocabinet -lsasl2 -licudata -licuuc -licui18n -letpan -lbz2 -lz \
 -lSparrowBackend \
 -fobjc-link-runtime -miphoneos-version-min=5.0 \
 -framework StoreKit -framework Accounts -framework Twitter -framework MediaPlayer -framework AssetsLibrary -framework QuickLook -framework CFNetwork -framework AudioToolbox -framework ImageIO -framework CoreText -framework QuartzCore -lstdc++ -framework SystemConfiguration \
 -lresolv -liconv -framework CoreFoundation -framework Security -framework AddressBook -framework AddressBookUI -framework UIKit -framework Foundation -framework CoreGraphics \
 -o $resultdir/Sparrow

plutil -convert xml1 -o "Sparrow.xcent" "Entitlements.plist"

export CODESIGN_ALLOCATE=$xcodefolder/Contents/Developer/Platforms/iPhoneOS.platform/Developer/usr/bin/codesign_allocate
export PATH="$xcodefolder/Contents/Developer/Platforms/iPhoneOS.platform/Developer/usr/bin:$xcodefolder/Contents/Developer/usr/bin:/usr/bin:/bin:/usr/sbin:/sbin"
/usr/bin/codesign --force --sign $identity --resource-rules=$resultdir/ResourceRules.plist --entitlements Sparrow.xcent $resultdir