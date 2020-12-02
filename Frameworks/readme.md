Put libmagic.1.dylib in here, and change the id of it to point to the library as an rpath

You can get libmagic.1.dylib from brew with this command:
```
brew install libmagic
```

Then, copy it out of the location that brew put it in to here with this:
```
cp /usr/local/opt/libmagic/lib/libmagic.1.dylib .
```

And finally, adjust the id to not point to brew's location:
```
install_name_tool -id "@rpath/libmagic.1.dylib" ./libmagic.1.dylib
```

You can check what the current id is by using `otool -L ./libmagic.1.dylib`. If it's set to rpath, it will be bundled into this application. Otherwise, it will require the library to be installed from brew.

To make a multi-platform binary, use lipo, and provide paths to the other libmagics:
```
lipo -create arm64/libmagic.1.dylib x86_64/libmagic.1.dylib -output libmagic.universal
mv libmagic.universal libmagic.1.dylib
```
