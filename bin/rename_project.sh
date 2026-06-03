#!/bin/bash

# Runt his script at root directory to 
# - replace "Greeter" with new project name in all CMakeLists.txt
# - rename include/greeter to include/<project_name>

# Check if new project name is provided
if [ $# -eq 0 ]; then
    echo "Usage: $0 <new_project_name>"
    echo "Example: $0 MyProject"
    exit 1
fi

OLD_NAME="Greeter"
NEW_NAME="$1"
echo "Replacing '$OLD_NAME' with '$NEW_NAME' in CMakeLists.txt files ... "

# Initialize counters
FILES_PROCESSED=0
REPLACEMENTS_TOTAL=0

# Find and process all Makefiles
while IFS= read -r -d '' file; do
    # Count occurrences before replacement
    OCCURRENCES=$(grep -o "$OLD_NAME" "$file" | wc -l)
    
    if [ "$OCCURRENCES" -gt 0 ]; then
# Make the replacements
        sed -i "s/$OLD_NAME/$NEW_NAME/g" "$file"
        
        # Update counters
        REPLACEMENTS_TOTAL=$((REPLACEMENTS_TOTAL + OCCURRENCES))
        FILES_PROCESSED=$((FILES_PROCESSED + 1))        
    fi
done < <(find . -type f -name CMakeLists.txt -print0)

echo ""
echo "Summary:"
echo "Total Makefiles processed: $FILES_PROCESSED"
echo "Total replacements made: $REPLACEMENTS_TOTAL"

echo " Update include directory and includes"
OLD_NAME_LOWER=$(echo "$OLD_NAME" | tr '[:upper:]' '[:lower:]')
NEW_NAME_LOWER=$(echo "$NEW_NAME" | tr '[:upper:]' '[:lower:]')
mv include/${OLD_NAME_LOWER} include/${NEW_NAME_LOWER}
find . \( -name '*.cpp' -o -name '*.h' \) -exec sed -i "s/#include <${OLD_NAME_LOWER}/#include <${NEW_NAME_LOWER}/g" {} \;

echo "-- Update project version testing --"
OLD_NAME_UPPER=$(echo "$OLD_NAME" | tr '[:lower:]' '[:upper:]')
NEW_NAME_UPPER=$(echo "$NEW_NAME" | tr '[:lower:]' '[:upper:]')
find . -type f -exec sed -i "s/${OLD_NAME_UPPER}_VERSION/${NEW_NAME_UPPER}_VERSION/g" {} \;

# test new project is compiable and tested
cmake -S all -B build
cmake --build build

# run tests
./build/test/${NEW_NAME}Tests
# format code
cmake --build build --target fix-format
# run standalone
./build/standalone/Greeter --help
# build docs
cmake --build build --target GenerateDocs