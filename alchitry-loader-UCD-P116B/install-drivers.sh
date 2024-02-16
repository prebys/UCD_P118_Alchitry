#!/bin/bash
# This will install the Futura drivers on a Mac.
echo "Installing D2XX Libraries..."
cp -f libftd2xx.1.4.16.dylib /usr/local/lib/
ln -sf /usr/local/lib/libftd2xx.1.4.16.dylib /usr/local/lib/libftd2xx.dylib
cp -f ftd2xx.h /usr/local/include/
cp -f WinTypes.h /usr/local/include/
echo "Done."