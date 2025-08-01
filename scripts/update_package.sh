#!/bin/bash

# Script to update the DoomScroll Flutter package across multiple projects
PACKAGE_NAME="doom_scroll_flutter"
PACKAGE_SOURCE="/home/batmanwa/Work/FlutterProjects/doomscroll/doom_scroll_flutter"

# Array of project paths that use this package
PROJECTS=(
    "/path/to/project1"
    "/path/to/project2" 
    "/path/to/project3"
)

echo "🚀 Updating $PACKAGE_NAME across projects..."

for PROJECT in "${PROJECTS[@]}"; do
    if [ -d "$PROJECT" ]; then
        echo "📦 Updating package in: $PROJECT"
        
        # Remove old package
        rm -rf "$PROJECT/packages/$PACKAGE_NAME"
        
        # Create packages directory if it doesn't exist
        mkdir -p "$PROJECT/packages"
        
        # Copy updated package
        cp -r "$PACKAGE_SOURCE" "$PROJECT/packages/"
        
        # Run pub get in the project
        cd "$PROJECT"
        flutter pub get
        
        echo "✅ Updated $PROJECT"
    else
        echo "❌ Project not found: $PROJECT"
    fi
done

echo "🎉 Package update complete!"