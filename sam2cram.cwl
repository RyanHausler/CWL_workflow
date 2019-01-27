#!/usr/bin/env cwl-runner

cwlVersion: v1.0
class: CommandLineTool
baseCommand:
- samtools
- view
arguments: ["-b"]
# samtools view $sam -T $ref -b -o ${outdir}/sam2cram_test.cram

inputs:
  # Source sam file
  sam:
    type: File
    inputBinding:
      position: 3

  # Output cram file
  output_filename:
    type: string
    inputBinding:
      position: 2
      prefix: -o

  # Number of threads to run algorithm
  reference:
    type: File
    inputBinding:
      position: 1
      prefix: -T

stdout: $(inputs.output_filename)

outputs:
  output:
    type: File[]
    outputBinding:
      glob: $(inputs.output_filename)
