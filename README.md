# FASTQ2VCF_PIPELINE
Pipeline for .FASTQ files after sequencing.

1.Doing a qulity check with FastQC.  

2.Making a general report on if multiple .FASTQ files went under quality control.  

3.Indexing the reference genome thath you are going to use.  

4.Doing the aligning with BWA.  

5.Sorting the .bam files.  

6.Using the sorted .bam files and the reference genome for variant calling.  

7.Filtering the new .vcf files.  

8.Additionally i have uploaded here a script for annotating the VCF files referenced to GTF or GFF files. Done with snpEff command.

  



  On every step there is a comment if you have to give the path to the needed directory.

  You can change names on the commands that are making new directories.

  On the bottom of the script I have put in a comment the filtering option for the .vcf filtering if you want to tweek that as well.
