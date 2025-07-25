#!/bin/bash

mkdir -p filtered_vcf

for vcf in *.vcf; do
    sample=$(basename "$vcf" .vcf)

    bcftools view -v snps "$vcf" | \
    bcftools filter -s LOWQUAL -e 'QUAL<30 || INFO/DP<10 || INFO/DP>30 || FILTER!="PASS"' \
    > filtered_vcf/"${sample}.filtered.vcf"

    echo "🔍 Filtered ${sample}.vcf → filtered_vcf/${sample}.filtered.vcf"
done


# On the bottom of the script I have put in a comment the filtering option for the .vcf filtering if you want to tweek that as well.

#QUAL<30 for stricter quality
#MQ<40 to remove variants with low mapping quality
#QD<2.0 (if GATK-style VCFs with quality-by-depth)

