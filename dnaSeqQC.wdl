version 1.0

import "imports/pull_bwamem2.wdl" as bwaMem
import "imports/pull_bamQC.wdl" as bamQC

struct InputGroup {
  File bam
  File bamIndex
}

struct genomicResources {
  String runBwaMem_bwaRef
  String runBwaMem_modules
}


workflow dnaSeqQC {
    input {
        File fastqR1
        File fastqR2
        String reference
        String outputFileNamePrefix = basename(fastqR1)
    }

    parameter_meta {
        fastqR1: "fastq file for read 1"
        fastqR2: "fastq file for read 2"
        reference: "Reference Assembly id"
        outputFileNamePrefix: "Optional output prefix for the output"
    }

    Map[String,genomicResources] resources = {
      "hg19": {
        "runBwaMem_bwaRef": "$HG19_BWA_INDEX_ROOT/hg19_random.fa", 
        "runBwaMem_modules": "samtools/1.9 bwa/0.7.12 hg19-bwa-index/0.7.12"
      },
      "hg38": {
        "runBwaMem_bwaRef": "$HG38_BWA_INDEX_ROOT/hg38_random.fa",
        "runBwaMem_modules": "samtools/1.9 bwa/0.7.12 hg38-bwa-index/0.7.12"
      },
      "mm10": {
        "runBwaMem_bwaRef": "$MM10_BWA_INDEX_ROOT/mm10.fa",
        "runBwaMem_modules": "samtools/1.9 bwa/0.7.12 mm10-bwa-index/0.7.12"
      }
    }


    call bwaMem.bwamem2 {
      input:
        fastqR1 = fastqR1,
        fastqR2 = fastqR2,
        reference = reference,
        outputFileNamePrefix = outputFileNamePrefix
    }

    InputGroup bamQcInput = {"bam": bwamem2.bwamem2Bam, "bamIndex": bwamem2.bwamem2Index}

    call bamQC.bamQC {
      input:
        inputGroups = [bamQcInput],
        outputFileNamePrefix = outputFileNamePrefix
    }

    meta {
      author: "Fenglin Chen"
      email: "g3chen@oicr.on.ca"
      description: "Calls the bwaMem-bamQC alignment as a single step."
      dependencies: [
      {
        name: "bwa/0.7.12",
        url: "https://github.com/lh3/bwa/archive/0.7.12.tar.gz"
      },
      {
        name: "samtools/1.9",
        url: "https://github.com/samtools/samtools/archive/0.1.19.tar.gz"
      },
      {
        name: "cutadapt/1.8.3",
        url: "https://cutadapt.readthedocs.io/en/v1.8.3/"
      },
      {
        name: "slicer/0.3.0",
        url: "https://github.com/OpenGene/slicer/archive/v0.3.0.tar.gz"
      },
      {
        name: "picard/2.21.2",
        url: "https://broadinstitute.github.io/picard/command-line-overview.html"
      },
      {
        name: "python/3.6",
        url: "https://www.python.org/downloads/"
      },
      {
        name: "bam-qc-metrics/0.2.5",
        url: "https://github.com/oicr-gsi/bam-qc-metrics.git"
      },
      {
        name: "mosdepth/0.2.9",
        url: "https://github.com/brentp/mosdepth"
      }
      ]
      output_meta: {
        log: "log file for bwaMem task",
        cutAdaptAllLogs: "log file for cutadapt task",
        result: "bamQC report"
      }
    }

 

  output {
     # bwaMem outputs
     File? log = bwamem2.log
     File? cutAdaptAllLogs = bwamem2.cutAdaptAllLogs

     # bamQC outputs
     File result = bamQC.result
  }
}

