#!/bin/bash

# Create a new Git tag with the version specified as an argument
git tag $1

# Get only the latest Git tag name
VERSION=$(git describe --tags --abbrev=0)

# Update version in .toc files
sed -i "s/^## Version: .*/## Version: $VERSION/" C:/Users/looot/OneDrive/Documents/WOW-Addons/CritMatic/CritMatic_Vanila.toc
sed -i "s/^## Version: .*/## Version: $VERSION/" C:/Users/looot/OneDrive/Documents/WOW-Addons/CritMatic/CritMatic_Wrath.toc

# Update version in README.md
sed -i "s/^## CritMatic: .*/## CritMatic: $VERSION/" C:/Users/looot/OneDrive/Documents/WOW-Addons/CritMatic/README.md

# Push the new tag to the remote Git repository
git push origin $VERSION
