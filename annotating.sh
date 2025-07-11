#Download the snpEff program from here: https://pcingola.github.io/SnpEff/

#Go to snpEff directory: cd ~/snpEff/, and here we would create database for our species, 
#if there is none in the snpEff.config file.
#make sure to have the Java version up to date
#check if you are using GFF or GTF format with annotations
#for GFF is gff3    for GTF is gtf22
java -Xmx4g -jar snpEff.jar build -gff3 -v "name of the species without the quotation marks"

#when the database is build we can annotate our files with snpEff
java -Xmx4g -jar snpEff/snpEff.jar -v "name of your database" your_variants.vcf > annotated.vcf


