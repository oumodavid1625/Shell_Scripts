#!/bin/bash

# Input: FASTA file (file named 'tubby_mrna.fasta')
input="tubby_mrna.fasta"

# ------------------------------------------------------------------------
# 1. Extract Metadata
# ------------------------------------------------------------------------
echo "===== METADATA ====="
id=$(grep "^>" "$input" | awk '{print $1}' | sed 's/>//')
description=$(grep "^>" "$input" | cut -d " " -f 2-)
echo "ID: $id"
echo "Description: $description"

# ------------------------------------------------------------------------
# 2. Calculate Sequence Length and GC Content
# ------------------------------------------------------------------------
sequence=$(grep -v "^>" "$input" | tr -d '\n')
seq_length=${#sequence}
gc_count=$(echo "$sequence" | grep -o "[GC]" | wc -l)
gc_percent=$(echo "scale=2; ($gc_count / $seq_length) * 100" | bc)

echo -e "\n===== SEQUENCE ANALYSIS ====="
echo "Sequence length: $seq_length bp"
echo "GC content: $gc_percent%"

# ------------------------------------------------------------------------
# 3. Extract CDS (66..890) and Translate to Protein
# ------------------------------------------------------------------------
# CDS positions (1-based to 0-based adjustment)
cds_start=66
cds_end=890
cds_length=$((cds_end - cds_start + 1))
cds_sequence="${sequence:$((cds_start - 1)):$cds_length}"

echo -e "\n===== CODING SEQUENCE (CDS) ====="
echo "CDS length: $cds_length bp (positions $cds_start-$cds_end)"
echo "First 10 bases: ${cds_sequence:0:10}..."
echo "Last 10 bases: ...${cds_sequence: -10}"

# Translate CDS to protein (requires EMBOSS transeq)
if command -v transeq &> /dev/null; then
    echo -e "\n>CDS_$id" > cds.fasta
    echo "$cds_sequence" >> cds.fasta
    transeq cds.fasta protein.fasta -frame=1
    echo -e "\nProtein translation:"
    grep -v "^>" protein.fasta
else
    echo -e "\n[Warning] EMBOSS 'transeq' not installed. Skipping translation."
fi

# ------------------------------------------------------------------------
# 4. Validate Start/Stop Codons
# ------------------------------------------------------------------------
start_codon="${cds_sequence:0:3}"
stop_codon="${cds_sequence: -3}"

echo -e "\n===== START/STOP CODON CHECK ====="
if [[ "$start_codon" == "ATG" ]]; then
    echo "Start codon: $start_codon (valid)"
else
    echo "Start codon: $start_codon (invalid)"
fi

if [[ "$stop_codon" =~ (TAA|TAG|TGA) ]]; then
    echo "Stop codon: $stop_codon (valid)"
else
    echo "Stop codon: $stop_codon (invalid)"
fi

# --------------------------------------------------------------------------
# Restriction Site Search (EcoRI: GAATTC)
# --------------------------------------------------------------------------
echo "EcoRI sites (GAATTC): $(echo "$sequence" | grep -o "GAATTC" |wc -l)"
# ----------------------------------------------------------------------------
# Restriction Site Search (BamHI: GGATCC)
# ----------------------------------------------------------------------------
echo "BamHI sites (GGATCC): $(echo "$sequence" | grep -o "GGATCC" | wc -l)"
