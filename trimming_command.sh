#!/bin/bash
# create file with the sequences you want to trim of of your data with text inside in this format: sequence1: AGTCGCTAGCATCACGAGCGCTAGCGACAACG
# for the sequences file, the extension needs to be .fa, i have named my file adapters for instance
# log file is created, so you can check for faults
# for more information on Trimmomatic: https://pmc.ncbi.nlm.nih.gov/articles/PMC4103590/
# set paths

input_dir=""
output_dir=""
trimmomatic_jar=""
adapters="file.fa"

# make sure output directory exists
mkdir -p "$output_dir"

# loop through sample IDs
for id in $(seq 4048611 4048901); do
    input_file="$input_dir/${id}.FASTQ"
    output_file="$output_dir/${id}_trimmed.fq.gz"
    log_file="$output_dir/${id}_trimlog.txt"

    if [[ -f "$input_file" ]]; then
        echo "Processing $input_file..."
        java -jar "$trimmomatic_jar" SE -threads 4 \
            "$input_file" "$output_file" \
            ILLUMINACLIP:$adapters:2:20:7 \
            LEADING:3 TRAILING:3 SLIDINGWINDOW:4:15 MINLEN:36 \
            -trimlog "$log_file"
    else
        echo "Skipping $input_file (not found)."
    fi
done
