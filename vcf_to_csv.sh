#!/bin/bash

input_folder=/home/pc/Downloads/annotated_vcfs
output_folder=/home/pc/Downloads/snpEff/annotated_csvs

# Create output directory
mkdir -p "$output_folder"

for vcf in "$input_folder"/*.annotated.vcf; do
    base=$(basename "$vcf" .annotated.vcf)
    outfile="$output_folder/${base}.csv"

    echo "Converting $vcf to $outfile"

    # Write header
    echo -e "CHROM,POS,REF,ALT,INFO" > "$outfile"

    # Extract basic fields (adjust for deeper parsing later)
    grep -v "^#" "$vcf" | awk -F'\t' '{split($8,a,";"); print $1","$2","$4","$5","a[1]}' >> "$outfile"
done

echo "Done. CSVs saved in: $output_folder"
