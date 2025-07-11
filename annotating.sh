#Download the snpEff program from here: https://pcingola.github.io/SnpEff/

# Go to snpEff directory: cd ~/snpEff/, and here we would create database for our species, 
# if there is none in the snpEff.config file.
# make sure to have the Java version up to date
# check if you are using GFF or GTF format with annotations
# for GFF is gff3    for GTF is gtf22
java -Xmx4g -jar snpEff.jar build -gff3 -v "name of the species without the quotation marks"

# when the database is build we can annotate our files with snpEff
java -Xmx4g -jar snpEff/snpEff.jar -v "name of your database" your_variants.vcf > annotated.vcf

# This below is a loop for multiple VCF files.


#!/bin/bash

# Set paths
input_vcf="Your folder with VCF files"
output_folder="New Folder for results"
snpEff_jar="~/snpEff/snpEff.jar"
reference_databse="name of species"

# Create output directory if it doesn't exist
mkdir -p "$output_folder"

# Loop through all VCF files
for vcf in "$input_vcf"/*.vcf; do
    # Skip if no files matched
    [[ -e "$vcf" ]] || { echo "No .vcf files found in $input_vcf"; exit 1; }

    base=$(basename "$vcf" .vcf)
    outvcf="$output_folder/${base}.annotated.vcf"

    echo "Annotating: $base.vcf"
    java -Xmx4g -jar "$snpEff_jar" -v "$reference_genome" "$vcf" > "$output_folder"
done

echo "Annotation complete. Results are in: $output_folder"
