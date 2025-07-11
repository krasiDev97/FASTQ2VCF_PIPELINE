# FASTQ2VCF_PIPELINE
Pipeline for .FASTQ files after sequencing.

    The pipeline.sh program does everything automated from step 1 to step 7, without the trimming and annotating, so if you are not sure about those steps to make them individually and with finer tunning.

1.Doing a qulity check with FastQC.  

1.5 If after the quality check some adapters are seen or overrepresented sequences are vissible, you can use the trimming_command.sh

2.Making a general report on if multiple .FASTQ files went under quality control.  

3.Indexing the reference genome thath you are going to use.  

4.Doing the aligning with BWA.  

5.Sorting the .bam files.  

6.Using the sorted .bam files and the reference genome for variant calling.  

7.Filtering the new .vcf files.  

    8.Annotating the VCF files referenced to GTF or GFF files. Done with snpEff.

    9. Convert the annotated VCf files into CSV(Comma separated) for easier visualisation and forward analysis. 

  


  On every step there is a comment if you have to give the path to the needed directory.

  You can change names on the commands that are making new directories.

  
