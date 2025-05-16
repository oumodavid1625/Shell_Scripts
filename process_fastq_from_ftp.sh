#!/bin/bash

# Script: process_fastq_from_ftp.sh
# Description: Download, decompress, and manipulate a gzipped FASTQ file

# Define the FTP link
FTP_LINK="ftp://ftp.sra.ebi.ac.uk/vol1/fastq/SRR334/052/SRR33413752/SRR33413752_1.fastq.gz"
FILE_NAME="SRR33413752_1.fastq.gz"
RAW_FASTQ="SRR33413752_1.fastq"

echo "[0] Downloading FASTQ file..."
wget $FTP_LINK

echo "[1] Decompressing file..."
gunzip -k "$FILE_NAME"  # -k keeps original .gz file

# Count total reads
echo "[2] Counting total reads..."
total_reads=$(wc -l < "$RAW_FASTQ")
echo "Total reads: $((total_reads / 4))"

# Filter sequences ≥ 50 bp
echo "[3] Extracting sequences ≥ 50 bp..."
awk 'NR%4==1 {h=$0} NR%4==2 {s=$0} NR%4==3 {plus=$0} NR%4==0 {q=$0; if(length(s) >= 50) print h"\n"s"\n"plus"\n"q > "length_filtered.fastq"}' "$RAW_FASTQ"
echo "Saved to: length_filtered.fastq"

# Convert to FASTA
echo "[4] Converting to FASTA format..."
awk 'NR%4==1 {printf(">%s\n", substr($0,2))} NR%4==2 {print}' "$RAW_FASTQ" > "SRR33413752.fasta"
echo "Saved to: SRR33413752.fasta"

# Done
echo "Processing complete!"
