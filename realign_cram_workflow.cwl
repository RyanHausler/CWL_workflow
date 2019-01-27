#!/usr/bin/env cwl-runner

cwlVersion: v1.0
class: Workflow
inputs:
  cram: File
  name_of_file_to_output: string
  thread_cram2fastq: int?
  ref:
    type: File
    secondaryFiles:
        - .amb
        - .ann
        - .bwt
        - .pac
        - .sa 
  min_seed: int?
  min_std: int[]?
  thread_bwa: int?
  name_of_alignment: string
  name_of_new_cram: string
  ref_final: File 

outputs:
  fastq:
    type: File[]
    outputSource: cram2fastq/output
  realigned_sam:
    type: File
    outputSource: bwa-mem/output
  realign_cram:
    type: File[]
    outputSource: sam2cram/output

steps:
  cram2fastq:
    run: cram2fastq.cwl
    in:
      src: cram
      output_filename: name_of_file_to_output
      threads: thread_cram2fastq 
    out: [output]

  bwa-mem:
    run: bwa_align.cwl
    in:
      reads: cram2fastq/output
      reference: ref
      minimum_seed_length: min_seed
      min_std_max_min: min_std
      threads: thread_bwa
      output_filename: name_of_alignment
    out: [output]
  sam2cram:
    run: sam2cram.cwl
    in:
      sam: bwa-mem/output
      output_filename: name_of_new_cram
      reference: ref_final
    out: [output]





