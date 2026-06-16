#!/bin/bash

# Loop through all .dat files in the current directory
for file in *.dat; do
    # Check if any .dat files exist
    [ -e "$file" ] || continue
    
    echo "Processing $file..."

    # Create a temporary file
    tmp_file=$(mktemp)
    
    # Array to temporarily store diagonal entries for the current block
    diagonals=()

    # Read the file line by line
    while IFS= read -r line || [ -n "$line" ]; do
        
        # If we hit an ImageUp line or a new section header, dump the stored diagonals first
        if [[ "$line" =~ ^ImageUp || "$line" =~ ^FrontImageUp || "$line" =~ ^#WINTER ]]; then
            for diag in "${diagonals[@]}"; do
                echo "$diag" >> "$tmp_file"
            done
            diagonals=() # Clear the array for the next section
        fi

        # Print the original line to the temp file
        echo "$line" >> "$tmp_file"

        # Check for standard Image curves
        if [[ "$line" =~ ^Image\[(NE|NW|SE|SW)\]\[([0-9]+)\]=(.+)$ ]]; then
            dir="${BASH_REMATCH[1]}"
            season="${BASH_REMATCH[2]}"
            value="${BASH_REMATCH[3]}"
            diagonals+=("Diagonal[$dir][$season]=$value")
        
        # Check for FrontImage curves
        elif [[ "$line" =~ ^FrontImage\[(NE|NW|SE|SW)\]\[([0-9]+)\]=(.+)$ ]]; then
            dir="${BASH_REMATCH[1]}"
            season="${BASH_REMATCH[2]}"
            value="${BASH_REMATCH[3]}"
            diagonals+=("FrontDiagonal[$dir][$season]=$value")
        fi
    done < "$file"

    # Flush any remaining diagonals just in case the file ends abruptly
    if [ ${#diagonals[@]} -gt 0 ]; then
        for diag in "${diagonals[@]}"; do
            echo "$diag" >> "$tmp_file"
        done
    fi

    # Replace the original file with the modified one
    mv "$tmp_file" "$file"
done

echo "Done! All .dat files have been updated with Diagonal and FrontDiagonal entries."