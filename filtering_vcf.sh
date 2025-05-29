mkdir -p filtered_vcf

for vcf in *.vcf; do
    sample=$(basename "$vcf" .vcf)

    bcftools filter -s LOWQUAL -e '%QUAL<20 || DP<10' "$vcf" > filtered_vcf/"${sample}.filtered.vcf"

    echo "🔍 Filtered ${sample}.vcf → filtered_vcf/${sample}.filtered.vcf"
done



#QUAL<30 for stricter quality
#MQ<40 to remove variants with low mapping quality
#QD<2.0 (if GATK-style VCFs with quality-by-depth)

