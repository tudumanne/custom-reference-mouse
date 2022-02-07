# custom-reference-mouse

### Workflow - creating a custom manually masked reference 
<img width="500" alt="Screen Shot 2022-01-13 at 7 45 23 pm" src="https://user-images.githubusercontent.com/36429476/149296322-0f8179b7-e9b2-48c3-b051-80376efff178.png">

### Step 1: Examine if there are any ‘rDNA-like’ regions across the mouse reference genome (GRCm38.mm10) that can interfere with read alignment

1.1 First the rDNA canonical copy was fragmented in-silico to generate overlapping fragments with step size of 1bp

	- Example tool that can be used for in-silico fragment generation - https://www.genecorner.ugent.be/split_fasta.html

	- Fragments of different sizes were used for the analysis (e.g. 50bp, 100bp, 250bp, 500bp and 1000bp)

1.2 The generated fragments were mapped to standard unmasked and hard-masked references (both with and without rDNA copy) using Bowtie2 for the following settings
	
  	- reports best alignment only (default setting)
	
  	- reports all possible alignment (--all)

The following circos plots illustrate the 'rDNA-like' regions present across the genome that can interfere with read alignment for 250bp long fragments.

  
<img width="400" alt="Screen Shot 2022-01-13 at 7 32 03 pm" src="https://user-images.githubusercontent.com/36429476/149294286-2cd18221-385c-4f05-813f-7b55d9d0d9c1.png">



<img width="400" alt="Screen Shot 2022-01-13 at 7 32 24 pm" src="https://user-images.githubusercontent.com/36429476/149294299-ec554279-bf66-4d3f-a9f0-a35fa42cef0f.png">


### Step 2: Identify and mask regions across the genome that can interfere with read mapping across rDNA during ChIP-seq data analysis

2.1 The rDNA canonical copy was fragmented in-silico to generate overlapping fragments of 150bp with step size of 1bp         	

- 150bp fragment length was selected considering the average fragment size of input samples which is between 200-300bp. 


2.2 Generated fragments were aligned to the standard unmasked reference (without incorporating rDNA canonical sequence) using Bowtie2, allowing up to 1000 possible alignments (k=1000)

- Considering the possible sequence variation in experimental samples stringent settings (alignment without rDNA copy and allowing multiple alignments) were used to identify ‘rDNA-like’ regions.


2.3 ‘rDNA-like’ sequences across the genome were extracted as a .bed file (using R packages) and the identified regions were masked in the GRCm38.mm10 reference (without scaffolds) using 'maskfasta' - bedtools. 

- Canonical rDNA reference was incorporated to the resulting fasta file which was then used as the custom reference for ChIP-seq data analysis.  

rDNA reads mapping across rest of the genome - unmasked, hard-masked vs. custom reference

% N’s indicates the unmappable portion in the genome which affects the genome-wide ChIP-seq analysis

150bp fragments generated from canonical copy - best alignment

<img width="400" alt="Screen Shot 2022-01-13 at 7 41 57 pm" src="https://user-images.githubusercontent.com/36429476/149296142-57d8cc40-6db2-4a75-aabd-28f575b24cc4.png">


<img width="400" alt="Screen Shot 2022-01-13 at 7 42 25 pm" src="https://user-images.githubusercontent.com/36429476/149296150-dedb5657-6a75-41ae-a1c7-0df8477820b0.png">


<img width="400" alt="Screen Shot 2022-01-13 at 7 42 51 pm" src="https://user-images.githubusercontent.com/36429476/149296160-7047b059-2108-4b53-a155-d2ab7cc75a03.png">





