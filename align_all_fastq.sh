#!/bin/bash

# Directory where your FASTQ files are located
FASTQ_DIR=""

# Directory where the results (BAM files) will be stored
OUTPUT_DIR=""
mkdir -p $OUTPUT_DIR  # Create output directory if it doesn't exist

# Path to the reference genome (make sure it's indexed)
REFERENCE=""

# Loop over all FASTQ files in the directory
for FASTQ in "$FASTQ_DIR"/*.FASTQ.gz; do
    # Extract the sample name (e.g., "4048141" from "4048141.FASTQ.gz") CHECK IF THE FILES ARE .gz !!
    SAMPLE_NAME=$(basename "$FASTQ" ".FASTQ.gz")

    # Output BAM file path
    BAM_FILE="$OUTPUT_DIR/${SAMPLE_NAME}.bam"

    # Align the reads with BWA and convert to BAM with SAMtools
    echo "Aligning $FASTQ..."
    bwa mem $REFERENCE "$FASTQ" | samtools view -Sb - > "$BAM_FILE"

    # Sort and index the BAM file
    echo "Sorting and indexing $SAMPLE_NAME..."
    samtools sort "$BAM_FILE" -o "${BAM_FILE%.bam}.sorted.bam"
    samtools index "${BAM_FILE%.bam}.sorted.bam"

    # Clean up the unsorted BAM file (optional)
    rm "$BAM_FILE"
done

