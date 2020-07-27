version 1.0

import "imports/pull_bwaMem_module.wdl" as bwaMem
import "imports/pull_bamQC_module.wdl" as bamQC
import "imports/pull_fastQC_module.wdl" as fastQC

workflow dnaSeqQC {
    input {
        # bwaMem inputs
        File fastqR1
        File fastqR2
        String readGroups
        String bwaMem_outputFileNamePrefix = "output"
        Int numChunk = 1
        Boolean doTrim = false
        Int trimMinLength = 1
        Int trimMinQuality = 0
        String adapter1 = "AGATCGGAAGAGCACACGTCTGAACTCCAGTCAC"
        String adapter2 = "AGATCGGAAGAGCGTCGTGTAGGGAAAGAGTGT"
        String runBwaMem_modules
        String runBwaMem_bwaRef

        # bamQC inputs minus bamFile
        String bamQCMetrics_refSizesBed
        String bamQCMetrics_refFasta
        String bamQCMetrics_workflowVersion
        Int findDownsampleParams_targetReads = "100000"
        Map[String, String] metadata
        String bamQC_outputFileNamePrefix = "bamQC"

        # fastQC inputs minus the two fastqs
        String runFastQC_modules = "perl/5.28 java/8 fastqc/0.11.8"
        String fastQC_outputFileNamePrefix = ""
        String r1Suffix = "_R1"
        String r2Suffix = "_R2"
    }

    parameter_meta {
        fastqR1: "fastq file for read 1"
        fastqR2: "fastq file for read 2"
        readGroups: "Complete read group header line"
        bwaMem_outputFileNamePrefix: "Prefix for output file"
        numChunk: "number of chunks to split fastq file [1, no splitting]"
        doTrim: "if true, adapters will be trimmed before alignment"
        trimMinLength: "minimum length of reads to keep [1]"
        trimMinQuality: "minimum quality of read ends to keep [0]"
        adapter1: "adapter sequence to trim from read 1 [AGATCGGAAGAGCACACGTCTGAACTCCAGTCAC]"
        adapter2: "adapter sequence to trim from read 2 [AGATCGGAAGAGCGTCGTGTAGGGAAAGAGTGT]"
    
        bamFile: "Input BAM file on which to compute QC metrics"
        metadata: "JSON file containing metadata"
        bamQC_outputFileNamePrefix: "Prefix for output files"

        fastqR1: "Input file with the first mate reads."
        fastqR2: " Input file with the second mate reads (if not set the experiments will be regarded as single-end)."
        fastQC_outputFileNamePrefix: "Output prefix, customizable. Default is the first file's basename."
        r1Suffix: "Suffix for R1 file."
        r2Suffix: "Suffix for R2 file."
    }

    call bwaMem.bwaMem {
        input:
            runBwaMem_bwaRef = runBwaMem_bwaRef,
            runBwaMem_modules = runBwaMem_modules,
            fastqR1 = fastqR1,
            fastqR2 = fastqR2,
            readGroups = readGroups,
            outputFileNamePrefix = bwaMem_outputFileNamePrefix,
            numChunk = numChunk,
            doTrim = doTrim,
            trimMinLength = trimMinLength,
            trimMinQuality = trimMinQuality,
            adapter1 = adapter1,
            adapter2 = adapter2
    }

    call bamQC.bamQC {
        input:
            bamQCMetrics_refSizesBed = bamQCMetrics_refSizesBed,
        	bamQCMetrics_refFasta = bamQCMetrics_refFasta,
        	bamQCMetrics_workflowVersion = bamQCMetrics_workflowVersion,
        	findDownsampleParams_targetReads = findDownsampleParams_targetReads,
        	bamFile = bwaMem.bwaMemBam,
        	metadata = metadata,
        	outputFileNamePrefix = bamQC_outputFileNamePrefix
    }

    call fastQC.fastQC {
        input:
            runFastQC_modules = runFastQC_modules,
            fastqR1 = fastqR1,
            fastqR2 = fastqR2,
            outputFileNamePrefix = fastQC_outputFileNamePrefix,
            r1Suffix = r1Suffix,
            r2Suffix = r2Suffix
    }

    meta {
        author: "Fenglin Chen"
        email: "g3chen@oicr.on.ca"
        description: "DNASeqQC Runs bwaMem and bamQC as a single step"
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
            name: "samtools/1.9",
            url: "https://github.com/samtools/samtools"
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
        },
        {
            name: "fastqc/0.11.8",
            url: "https://www.bioinformatics.babraham.ac.uk/projects/fastqc/"
        }
      ]
      output_meta: {
        html_report_R1: "HTML report for the first mate fastq file.",
        zip_bundle_R1: "zipped report from FastQC for the first mate reads.",
        html_report_R2: "HTML report for read second mate fastq file.",
        zip_bundle_R2: "zipped report from FastQC for the second mate reads.",
        result: "bamQC report"
      }
    }

    output {
        File result = bamQC.result
        File? html_report_R1 = fastQC.html_report_R1
        File? zip_bundle_R1 = fastQC.zip_bundle_R1
        File? html_report_R2 = fastQC.html_report_R2
        File? zip_bundle_R2 = fastQC.zip_bundle_R2
    }
}