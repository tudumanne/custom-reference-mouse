#generate circos plots visualising rDNA-like regions across the genome

#Reference
#https://github.com/mevers/frag_align_rDNA

#load libraries
library(Rsamtools)
library(tidyverse)
library(circlize)

#read in data - rDNA reference, cytoband file and BAM file
rDNA <- readDNAStringSet("BK000964.3.fa")
cyto <- read_delim(
  "cytoband.txt",
  col_types = "ciicc",
  delim = "\t",
  col_names = c("chrom", "start", "end", "name", "giemsa_stain"))
bam <- BamFile("example.bam")

#generate data frames
df_size <- bam2 %>%
  scanBamHeader() %>%
  pluck("targets") %>%
  c(rDNA = width(rDNA)) %>%
  enframe()

df_cyto <- cyto %>%
  mutate(chrom = str_remove(chrom, "chr")) %>%
  mutate(chrom = if_else(chrom == "M", "MT", chrom)) %>%
  filter(chrom %in% df_size$name) %>%
  add_row(chrom = "rDNA", start = 1, end = width(rDNA), name = "", giemsa_stain = "") %>%
  as.data.frame()


#generate rDNA to genome read map based on BAM reads
df_map <- bam %>%
  scanBam() %>%
  pluck(1) %>%
  keep(names(.) %in% c("qname", "rname", "pos", "qwidth")) %>%
  as_tibble() %>%
  separate(qname, c("tmp", "from", "to", "tmp1", "tmp2"), sep = ";") %>%
  select(-tmp, -tmp2, -tmp2) %>%
  mutate(from_chr = "rDNA", from_start = str_remove(from, "BK000964.3_start="), from_end = str_remove(to, "end=")) %>%
  rename(to_chr = rname, to_start = pos, to_end = qwidth) %>%
  mutate(to_end = to_end + to_start) %>%
  select(from_chr, from_start, from_end, to_chr, to_start, to_end) %>%
  as.data.frame()
df_map$from_start=as.integer(df_map$from_start)
df_map$from_end=as.integer(df_map$from_end)


#make sure that chromosome names from `df_size` match those from `df_cyto` and `df_map`
valid_chr <- intersect(df_size$name, df_cyto$chrom)
df_size <- df_size %>% filter(name %in% valid_chr)
df_cyto <- df_cyto %>% filter(chrom %in% valid_chr)
df_map <- df_map %>% filter(to_chr %in% valid_chr)


#title
title <- sprintf("Reference:unmasked overlapFragmentLength=150bp, align default")

#parameters for the circular layout
circos.par("start.degree" = 30)

#initialize the circular layout with an ideogram
circos.initializeWithIdeogram(
  df_cyto,
  chromosome.index = df_size$name,
  sector.width = c(rep(1, nrow(df_size) - 1), 10))
#add links from two sets of genomic positions
circos.genomicLink(df_map[1:3], df_map[4:6], col = rgb(0, 0, 0, max = 255, alpha = 20), border = "black", lwd = 0.01)
title(title, cex.main = 1.0)

#export the mapped regions as a .csv file
write.csv(as.data.frame(df_map), file="regions.csv")
