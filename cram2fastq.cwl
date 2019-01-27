#!/usr/bin/env cwl-runner

cwlVersion: v1.0
class: CommandLineTool
baseCommand:
- samtools
- fastq

inputs:
  # Source cram file
  src:
    type: File
    inputBinding:
      position: 3
  
  # Output only a single read (not paired reads)
  output_filename: 
    type: string
    inputBinding:
      position: 2
      prefix: "-0"
  
  # Number of threads to run algorithm
  threads:
    type: int?
    inputBinding:
      position: 1
      prefix: --threads  

stdout: $(inputs.output_filename)

outputs:
  output:
    type: File[]
    outputBinding:
      glob: $(inputs.output_filename)

doc: |
  Usage: samtools fastq [options...] <in.bam>
  Options:
    -0 FILE              write paired reads flagged both or neither READ1 and READ2 to FILE
    -1 FILE              write paired reads flagged READ1 to FILE
    -2 FILE              write paired reads flagged READ2 to FILE
    -f INT               only include reads with all  of the FLAGs in INT present [0]
    -F INT               only include reads with none of the FLAGS in INT present [0]
    -G INT               only EXCLUDE reads with all  of the FLAGs in INT present [0]
    -n                   don't append /1 and /2 to the read name
    -N                   always append /1 and /2 to the read name
    -O                   output quality in the OQ tag if present
    -s FILE              write singleton reads to FILE [assume single-end]
    -t                   copy RG, BC and QT tags to the FASTQ header line
    -T TAGLIST           copy arbitrary tags to the FASTQ header line
    -v INT               default quality score if not given in file [1]
    -i                   add Illumina Casava 1.8 format entry to header (eg 1:N:0:ATCACG)
    -c                   compression level [0..9] to use when creating gz or bgzf fastq files
    --i1 FILE            write first index reads to FILE
    --i2 FILE            write second index reads to FILE
    --barcode-tag TAG    Barcode tag [default: BC]
    --quality-tag TAG    Quality tag [default: QT]
    --index-format STR   How to parse barcode and quality tags

        --input-fmt-option OPT[=VAL]
                 Specify a single input file format option in the form
                 of OPTION or OPTION=VALUE
        --reference FILE
                 Reference sequence FASTA FILE [null]
    -@, --threads INT
                 Number of additional threads to use [0]

     The index-format string describes how to parse the barcode and quality tags, for example:
     i14i8       the first 14 characters are index 1, the next 8 characters are index 2
     n8i14       ignore the first 8 characters, and use the next 14 characters for index 1
     If the tag contains a separator, then the numeric part can be replaced with '*' to mean
     'read until the separator or end of tag', for example:
     n*i*        ignore the left part of the tag until the separator, then use the second part
                 of the tag as index 1
