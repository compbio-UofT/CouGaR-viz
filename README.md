CouGaR-viz
==========

This is a visualization package for laying out complex genomic rearrangements. More specifically focusing on those occuring in amplified regions. Special thanks to Gary Baumgartner (@gfb) for helping get it started in Racket.

Running
-----------
./gracket-text cougar-viz.rkt

Input
-----------
* Gene annotations file
* Genomic regions file
* Output file prefix

Gene annotations file
-----------
Please see sample files in "gene_annotations"

Genomic regions file
-----------
The genomic regions file is made up from two lines, the first describing germ line regions (edges) and the second describing somatic linkings found in the tumour. 
Each edge is described by two coordinates (from , to) and 4 additional values (edge type [0-4], copy-count, germ-line coverage, somatic coverage).

As an example input the following can be used,
 
```	[((8 128653052) (8 128666609) 0 15 4336 62294) ((8 128683093) (8 128930932) 0 15 63400 992056) ((8 129034194) (8 129171189) 0 15 40646 661124) ((8 129845335) (8 129907084) 0 15 19436 255340) ((8 129923821) (8 130953544) 0 15 337694 4782172) ((8 130953544) (8 130955944) 0 0 498 1296) ((10 46735974) (10 47109482) 0 0 94272 256012) ((10 47109482) (10 47145556) 0 15 22512 174292) ((10 47145556) (10 47430085) 0 0 19740 52768) ((10 48888502) (10 49223973) 0 0 7844 22616) ((10 49223973) (10 49253846) 0 15 1290 16080) ((10 49253846) (10 49261028) 0 0 180 496) ((22 38349390) (22 38406654) 0 0 12352 40300) ((22 38406654) (22 38442167) 0 15 7864 145856) ((22 38442167) (22 38456549) 0 0 3182 8008) ((22 39540082) (22 39621582) 0 0 17928 64472) ((22 39621582) (22 39698822) 0 15 17830 342626)]```

```	[((8 128666609) (8 129034194) 0 15 2 181) ((10 49253846) (22 39621582) 0 15 2 54) ((8 128930932) (8 129171189) 2 15 2 96) ((22 38442167) (22 39698822) 2 15 2 124) ((8 128683093) (10 47145556) 1 15 2 69) ((8 129845335) (10 49223973) 3 15 2 8) ((10 47109482) (22 38406654) 3 15 2 107) ((8 128653052) (8 130953544) 1 15 2 107)]```

Output image
-----------
The output image produced is an SVG format image depicting the genomic regions and somatic linkings as a graph structure. The width of edges will be proportional to the log of the copy count in the input file. Genes are annotated on genomic intervals and are coloured for positive (green'ish) and negative (purple) strand genes.

Red lines represent parts of the reference genome and the thickness of the red line is proportional to the log predicted copy count. Blue lines represent tumor adjacencies and the thickness of the blue lines is proportional to the log predicted copy count of the tumor adjacency in the tumor genome. The copy counts for the tumor adjacencies represents the number of times the two regions appear adjacent in the tumor genome. 

The direction of the arrows connecting the adjacency represents the strand connectivity.  
`>-->`  there is no change of strand through the adjacency  
`>--<`  the adjacency can only be traversed from the left breakpoint on the positive strand or the right breakpoint on the negative strand  
`<-->`  the adjacency can only be traversed from the left breakpoint on the negative strand or the right breakpoint on the positive strand  

The numbers on the red line represent length of the genomic interval. The numbers above the red line is the predicted copy count of the region in the tumor genome. The images are not to genomic scale as it was impossible to keep genomic scale and still represent these graphs in a reasonable format..


Genomic intervals are laid out in order of appearance in the genome (i.e. , chr5:5,000 before chr:7,000 and chr2 before chr3).


