#!/bin/sh

if [ $(osascript -e 'application "Cinc Client" is running') = 'true' ]; then
  echo "Closing Cinc Client..."
  sudo osascript -e 'quit app "Cinc Client"' > /dev/null 2>&1;
fi
echo "Uninstalling Cinc Client..."
echo "  -> Removing files..."
sudo rm -rf '/opt/cinc'
sudo rm -rf '/Applications/Cinc Client.app'
echo "  -> Removing binary links in /usr/local/bin..."
sudo find /usr/local/bin -lname '/opt/cinc/*' -delete
echo "  -> Forgeting com.cc-build.pkg.cinc package..."
sudo pkgutil --forget com.cc-build.pkg.cinc > /dev/null 2>&1;
echo "Cinc Client Uninstalled."
