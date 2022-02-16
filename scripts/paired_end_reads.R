library('Biostrings')
library('RADami')

s = readDNAStringSet("rDNA_250bp_overlap.fa")
read1 = subseq(s, start=c(1), end=c(50)) 

write.DNAStringSet(read1, format= c('fasta'), padding = 30,
                   filename = "rDNA_250bp_50bpR1.fasta",
                   fastaPrefix = ">")

read2 = subseq(s, start=c(201), end=c(250)) 
read2_rev=reverseComplement(read2, content=c("dna"), case=c("as is"))

write.DNAStringSet(read2_rev, format= c('fasta'), padding = 30,
                   filename = "rDNA_250bp_50bpR2.fasta",
                   fastaPrefix = ">")
