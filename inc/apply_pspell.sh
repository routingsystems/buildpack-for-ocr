#!/usr/bin/env bash

echo '-----> Applying pspell'
cp -rp $BP_DIR/user $BUILD_DIR
echo "extension=/app/user/src/pspell/modules/pspell.so" >> /app/.heroku/php/etc/php/php.ini
echo '       - ext-pspell'
echo '       Done'