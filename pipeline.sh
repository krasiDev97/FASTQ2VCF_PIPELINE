
#!/bin/bash

set -euo pipefail

exec > >(tee -i pipeline.log)
exec 2>&1

#MAKING QUALITY CONTROL ON EVERY FASTQ FILE IN CURRENT DIRECTORY

mkdir -p fastqc_results

for file in *.fastq *.FASTQ *.fastq.gz *.FASTQ.GZ; do
    [ -e "$file" ] || continue  # Skip if no match
    fastqc -o fastqc_results "$file"
done


multiqc fastqc_results -o multiqc_results


#--------------------------------------------------------------------------------

#ALIGNING FASTQ FILES WITH THE REFERENCE GENOME


#Index the .fasta.fai file which is the GENOME REFERENCE
bwa index "/home/pc/Documents/ncbi_dataset/data/GCF_000499845.2/GCF_000499845.2_P._vulgaris_v2.0_genomic.fna"


# Directory where your FASTQ files are located
FASTQ_DIR="/home/pc/Desktop/NGS_exp"

# Directory where the results (BAM files) will be stored
OUTPUT_DIR="/home/pc/Desktop/NGS_exp/BAM_files"
mkdir -p $OUTPUT_DIR  # Create output directory if it doesn't exist

# Path to the reference genome (make sure it's indexed)
REFERENCE="/home/pc/Documents/ncbi_dataset/data/GCF_000499845.2/GCF_000499845.2_P._vulgaris_v2.0_genomic.fna"

# Loop over all FASTQ files in the directory
for FASTQ in "$FASTQ_DIR"/*.FASTQ; do
    # Extract the sample name (e.g., "4048141" from "4048141.FASTQ.gz") CHECK IF THE FILES ARE .gz !!
    SAMPLE_NAME=$(basename "$FASTQ" ".FASTQ")  #if the file is .gz, add here .gz too

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


#-------------------------------------------------------------------------------


#VARIANT CALLING WITH THE BAM FILES FROM THE ALIGNMENT



# Using the Reference genome(fasta.fai) from the code above

# Create output directory
mkdir -p vcf

# Make sure the reference is indexed
if [ ! -f "${REFERENCE}.fai" ]; then
    echo "Indexing reference genome..."
    samtools faidx "$REFERENCE"
fi

# Loop through sorted BAMs
for BAM in *.sorted.bam; do
    SAMPLE=$(basename "$BAM" .sorted.bam)
    echo "Calling variants for $SAMPLE..."

    bcftools mpileup -Ou -f "$REFERENCE" "$BAM" | \
    bcftools call -mv -Ov -o "vcf/${SAMPLE}.vcf"

    echo "✅ VCF saved to vcf/${SAMPLE}.vcf"
done

echo "🎉 All variant calling complete. VCFs are in the 'vcf/' directory."


#------------------------------------------------------------------------------------

#FILTERING THE VCF FILES WITH OUR OWN MEASUREMENTS IF NEEDED



mkdir -p filtered_vcf

for vcf in *vcf/*.vcf; do
    sample=$(basename "$vcf" .vcf)

    bcftools filter -s LOWQUAL -e '%QUAL<20 || DP<10' "$vcf" > filtered_vcf/"${sample}.filtered.vcf"

    echo "🔍 Filtered ${sample}.vcf → filtered_vcf/${sample}.filtered.vcf"
done





#QUAL<30 for stricter quality
#MQ<40 to remove variants with low mapping quality
#QD<2.0 (if GATK-style VCFs with quality-by-depth)
