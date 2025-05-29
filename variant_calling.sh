#!/bin/bash

# Reference genome
REF="/home/pc/Documents/ncbi_dataset/data/GCF_000499845.2/GCF_000499845.2_P._vulgaris_v2.0_genomic.fna"
BAMfiles ="/media/pc/748AFB828AFB3EE4/GWAS_DArT_COMMON_BEAN/200-300/BAM_files" 
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

echo "🎉 All variant calling complete. VCFs are in the 'vcf/' directory."



