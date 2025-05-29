#These are three types of calling FASTQ files, depending on your naming system or formating.


mkdir -p fastqc_results

for file in *.fastq *.FASTQ *.fastq.gz *.FASTQ.GZ; do
    [ -e "$file" ] || continue  # Skip if no match
    fastqc -o fastqc_results "$file"
done




 for i in $(seq 4048200 4048299); do
    fastqc -o "destination folder" "${i}.FASTQ"
done                                           




for file in *.FASTQ; do
    fastqc "$file"
done






