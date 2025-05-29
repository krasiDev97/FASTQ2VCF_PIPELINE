#!/bin/bash

# Reference genome
REF=""
BAMfiles ="" 
# Create output directory
mkdir -p vcf

# Make sure the reference is indexed
if [ ! -f "${REF}.fai" ]; then
    echo "Indexing reference genome..."
    samtools faidx "$REF"
fi

# Loop through sorted BAMs
for BAM in *.sorted.bam; do
    SAMPLE=$(basename "$BAM" .sorted.bam)
    echo "Calling variants for $SAMPLE..."

    bcftools mpileup -Ou -f "$REF" "$BAM" | \
    bcftools call -mv -Ov -o "vcf/${SAMPLE}.vcf"

    echo "✅ VCF saved to vcf/${SAMPLE}.vcf"
done

echo " All variant calling complete. VCFs are in the 'vcf/' directory."



