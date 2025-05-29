#!/bin/bash

# Directory where your BAM files are located
BAM_DIR="/media/pc/748AFB828AFB3EE4/GWAS - DArT - COMMON BEAN/140-159/BAM files"

# Directory where the sorted BAM files will be stored
SORTED_BAM_DIR="/media/pc/748AFB828AFB3EE4/GWAS - DArT - COMMON BEAN/140-159/BAM files/sorted"

# Create output directory if it doesn't exist
mkdir -p "$SORTED_BAM_DIR"

# Loop over all BAM files in the directory
for BAM_FILE in "$BAM_DIR"/*.bam; do
    # Extract the sample name (e.g., "4048141" from "4048141.bam")
    SAMPLE_NAME=$(basename "$BAM_FILE" ".bam")

    # Output sorted BAM file path
    SORTED_BAM_FILE="$SORTED_BAM_DIR/${SAMPLE_NAME}.sorted.bam"

    # Sort the BAM file
    echo "Sorting $BAM_FILE..."
    samtools sort "$BAM_FILE" -o "$SORTED_BAM_FILE"

    # Index the sorted BAM file
    echo "Indexing $SORTED_BAM_FILE..."
    samtools index "$SORTED_BAM_FILE"

    echo "$SAMPLE_NAME sorted and indexed."
done

echo "All BAM files have been sorted and indexed."
