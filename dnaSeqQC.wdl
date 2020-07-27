version 1.0

import "imports/pull_bwaMem.wdl" as bwaMem
import "imports/pull_bamQC.wdl" as bamQC
import "imports/pull_fastQC.wdl" as fastQC

workflow dnaSeqQC {
    input {
        # bwaMem inputs
        Int adapterTrimmingLog_timeout = 48
        Int adapterTrimmingLog_jobMemory = 12
        Int indexBam_timeout = 48
        String indexBam_modules = "samtools/1.9"
        Int indexBam_jobMemory = 12
        Int bamMerge_timeout = 72
        String bamMerge_modules = "samtools/1.9"
        Int bamMerge_jobMemory = 32
        Int runBwaMem_timeout = 96
        Int runBwaMem_jobMemory = 32
        Int runBwaMem_threads = 8
        String? runBwaMem_addParam
        String runBwaMem_bwaRef
        String runBwaMem_modules
        Int adapterTrimming_timeout = 48
        Int adapterTrimming_jobMemory = 16
        String? adapterTrimming_addParam
        String adapterTrimming_modules = "cutadapt/1.8.3"
        Int slicerR2_timeout = 48
        Int slicerR2_jobMemory = 16
        String slicerR2_modules = "slicer/0.3.0"
        Int slicerR1_timeout = 48
        Int slicerR1_jobMemory = 16
        String slicerR1_modules = "slicer/0.3.0"
        Int countChunkSize_timeout = 48
        Int countChunkSize_jobMemory = 16
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

        # bamQC inputs minus bamFile (from bwaMem out instead)
        Int collateResults_timeout = 1
        Int collateResults_threads = 4
        Int collateResults_jobMemory = 8
        String collateResults_modules = "python/3.6"
        Int cumulativeDistToHistogram_timeout = 1
        Int cumulativeDistToHistogram_threads = 4
        Int cumulativeDistToHistogram_jobMemory = 8
        String cumulativeDistToHistogram_modules = "python/3.6"
        Int runMosdepth_timeout = 4
        Int runMosdepth_threads = 4
        Int runMosdepth_jobMemory = 16
        String runMosdepth_modules = "mosdepth/0.2.9"
        Int bamQCMetrics_timeout = 4
        Int bamQCMetrics_threads = 4
        Int bamQCMetrics_jobMemory = 16
        String bamQCMetrics_modules = "bam-qc-metrics/0.2.5"
        Int bamQCMetrics_normalInsertMax = 1500
        String bamQCMetrics_workflowVersion
        String bamQCMetrics_refSizesBed
        String bamQCMetrics_refFasta
        Int markDuplicates_timeout = 4
        Int markDuplicates_threads = 4
        Int markDuplicates_jobMemory = 16
        String markDuplicates_modules = "picard/2.21.2"
        Int markDuplicates_picardMaxMemMb = 6000
        Int markDuplicates_opticalDuplicatePixelDistance = 100
        Int downsampleRegion_timeout = 4
        Int downsampleRegion_threads = 4
        Int downsampleRegion_jobMemory = 16
        String downsampleRegion_modules = "samtools/1.9"
        Int downsample_timeout = 4
        Int downsample_threads = 4
        Int downsample_jobMemory = 16
        String downsample_modules = "samtools/1.9"
        Int downsample_randomSeed = 42
        String downsample_downsampleSuffix = "downsampled.bam"
        Int findDownsampleParamsMarkDup_timeout = 4
        Int findDownsampleParamsMarkDup_threads = 4
        Int findDownsampleParamsMarkDup_jobMemory = 16
        String findDownsampleParamsMarkDup_modules = "python/3.6"
        String findDownsampleParamsMarkDup_customRegions = ""
        Int findDownsampleParamsMarkDup_intervalStart = 100000
        Int findDownsampleParamsMarkDup_baseInterval = 15000
        Array[String] findDownsampleParamsMarkDup_chromosomes = ["chr12", "chr13", "chrXII", "chrXIII"]
        Int findDownsampleParamsMarkDup_threshold = 10000000
        Int findDownsampleParams_timeout = 4
        Int findDownsampleParams_threads = 4
        Int findDownsampleParams_jobMemory = 16
        String findDownsampleParams_modules = "python/3.6"
        Float findDownsampleParams_preDSMultiplier = 1.5
        Int findDownsampleParams_precision = 8
        Int findDownsampleParams_minReadsRelative = 2
        Int findDownsampleParams_minReadsAbsolute = 10000
        Int findDownsampleParams_targetReads = 100000
        Int indexBamFile_timeout = 4
        Int indexBamFile_threads = 4
        Int indexBamFile_jobMemory = 16
        String indexBamFile_modules = "samtools/1.9"
        Int countInputReads_timeout = 4
        Int countInputReads_threads = 4
        Int countInputReads_jobMemory = 16
        String countInputReads_modules = "samtools/1.9"
        Int updateMetadata_timeout = 4
        Int updateMetadata_threads = 4
        Int updateMetadata_jobMemory = 16
        String updateMetadata_modules = "python/3.6"
        Int filter_timeout = 4
        Int filter_threads = 4
        Int filter_jobMemory = 16
        String filter_modules = "samtools/1.9"
        Int filter_minQuality = 30
        # File bamFile
        Map[String, String] metadata
        String bamqc_outputFileNamePrefix = "bamQC"

        # fastQC inputs minus the two fastqs (dup)
        Int secondMateZip_timeout = 1
        Int secondMateZip_jobMemory = 2
        Int secondMateHtml_timeout = 1
        Int secondMateHtml_jobMemory = 2
        String secondMateFastQC_modules = "perl/5.28 java/8 fastqc/0.11.8"
        Int secondMateFastQC_timeout = 20
        Int secondMateFastQC_jobMemory = 6
        Int firstMateZip_timeout = 1
        Int firstMateZip_jobMemory = 2
        Int firstMateHtml_timeout = 1
        Int firstMateHtml_jobMemory = 2
        String firstMateFastQC_modules = "perl/5.28 java/8 fastqc/0.11.8"
        Int firstMateFastQC_timeout = 20
        Int firstMateFastQC_jobMemory = 6
        # File fastqR1 
        # File? fastqR2
        String fastqc_outputFileNamePrefix = ""
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
            adapterTrimmingLog_timeout = adapterTrimmingLog_timeout,
            adapterTrimmingLog_jobMemory = adapterTrimmingLog_jobMemory,
            indexBam_timeout = indexBam_timeout,
            indexBam_modules = indexBam_modules,
            indexBam_jobMemory = indexBam_jobMemory,
            bamMerge_timeout = bamMerge_timeout,
            bamMerge_modules = bamMerge_modules,
            bamMerge_jobMemory = bamMerge_jobMemory,
            runBwaMem_timeout = runBwaMem_timeout,
            runBwaMem_jobMemory = runBwaMem_jobMemory,
            runBwaMem_threads = runBwaMem_threads,
            runBwaMem_addParam = runBwaMem_addParam,
            runBwaMem_bwaRef = runBwaMem_bwaRef,
            runBwaMem_modules = runBwaMem_modules,
            adapterTrimming_timeout = adapterTrimming_timeout,
            adapterTrimming_jobMemory = adapterTrimming_jobMemory,
            adapterTrimming_addParam = adapterTrimming_addParam,
            adapterTrimming_modules = adapterTrimming_modules,
            slicerR2_timeout = slicerR2_timeout,
            slicerR2_jobMemory = slicerR2_jobMemory,
            slicerR2_modules = slicerR2_modules,
            slicerR1_timeout = slicerR1_timeout,
            slicerR1_jobMemory = slicerR1_jobMemory,
            slicerR1_modules = slicerR1_modules,
            countChunkSize_timeout = countChunkSize_timeout,
            countChunkSize_jobMemory = countChunkSize_jobMemory,
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
            collateResults_timeout = collateResults_timeout,
            collateResults_threads = collateResults_threads,
            collateResults_jobMemory = collateResults_jobMemory,
            collateResults_modules = collateResults_modules,
            cumulativeDistToHistogram_timeout = cumulativeDistToHistogram_timeout,
            cumulativeDistToHistogram_threads = cumulativeDistToHistogram_threads,
            cumulativeDistToHistogram_jobMemory = cumulativeDistToHistogram_jobMemory,
            cumulativeDistToHistogram_modules = cumulativeDistToHistogram_modules,
            runMosdepth_timeout = runMosdepth_timeout,
            runMosdepth_threads = runMosdepth_threads,
            runMosdepth_jobMemory = runMosdepth_jobMemory,
            runMosdepth_modules = runMosdepth_modules,
            bamQCMetrics_timeout = bamQCMetrics_timeout,
            bamQCMetrics_threads = bamQCMetrics_threads,
            bamQCMetrics_jobMemory = bamQCMetrics_jobMemory,
            bamQCMetrics_modules = bamQCMetrics_modules,
            bamQCMetrics_normalInsertMax = bamQCMetrics_normalInsertMax,
            bamQCMetrics_workflowVersion = bamQCMetrics_workflowVersion,
            bamQCMetrics_refSizesBed = bamQCMetrics_refSizesBed,
            bamQCMetrics_refFasta = bamQCMetrics_refFasta,
            markDuplicates_timeout = markDuplicates_timeout,
            markDuplicates_threads = markDuplicates_threads,
            markDuplicates_jobMemory = markDuplicates_jobMemory,
            markDuplicates_modules = markDuplicates_modules,
            markDuplicates_picardMaxMemMb = markDuplicates_picardMaxMemMb,
            markDuplicates_opticalDuplicatePixelDistance = markDuplicates_opticalDuplicatePixelDistance,
            downsampleRegion_timeout = downsampleRegion_timeout,
            downsampleRegion_threads = downsampleRegion_threads,
            downsampleRegion_jobMemory = downsampleRegion_jobMemory,
            downsampleRegion_modules = downsampleRegion_modules,
            downsample_timeout = downsample_timeout,
            downsample_threads = downsample_threads,
            downsample_jobMemory = downsample_jobMemory,
            downsample_modules = downsample_modules,
            downsample_randomSeed = downsample_randomSeed,
            downsample_downsampleSuffix = downsample_downsampleSuffix,
            findDownsampleParamsMarkDup_timeout = findDownsampleParamsMarkDup_timeout,
            findDownsampleParamsMarkDup_threads = findDownsampleParamsMarkDup_threads,
            findDownsampleParamsMarkDup_jobMemory = findDownsampleParamsMarkDup_jobMemory,
            findDownsampleParamsMarkDup_modules = findDownsampleParamsMarkDup_modules,
            findDownsampleParamsMarkDup_customRegions = findDownsampleParamsMarkDup_customRegions,
            findDownsampleParamsMarkDup_intervalStart = findDownsampleParamsMarkDup_intervalStart,
            findDownsampleParamsMarkDup_baseInterval = findDownsampleParamsMarkDup_baseInterval,
            findDownsampleParamsMarkDup_chromosomes = findDownsampleParamsMarkDup_chromosomes,
            findDownsampleParamsMarkDup_threshold = findDownsampleParamsMarkDup_threshold,
            findDownsampleParams_timeout = findDownsampleParams_timeout,
            findDownsampleParams_threads = findDownsampleParams_threads,
            findDownsampleParams_jobMemory = findDownsampleParams_jobMemory,
            findDownsampleParams_modules = findDownsampleParams_modules,
            findDownsampleParams_preDSMultiplier = findDownsampleParams_preDSMultiplier,
            findDownsampleParams_precision = findDownsampleParams_precision,
            findDownsampleParams_minReadsRelative = findDownsampleParams_minReadsRelative,
            findDownsampleParams_minReadsAbsolute = findDownsampleParams_minReadsAbsolute,
            findDownsampleParams_targetReads = findDownsampleParams_targetReads,
            indexBamFile_timeout = indexBamFile_timeout,
            indexBamFile_threads = indexBamFile_threads,
            indexBamFile_jobMemory = indexBamFile_jobMemory,
            indexBamFile_modules = indexBamFile_modules,
            countInputReads_timeout = countInputReads_timeout,
            countInputReads_threads = countInputReads_threads,
            countInputReads_jobMemory = countInputReads_jobMemory,
            countInputReads_modules = countInputReads_modules,
            updateMetadata_timeout = updateMetadata_timeout,
            updateMetadata_threads = updateMetadata_threads,
            updateMetadata_jobMemory = updateMetadata_jobMemory,
            updateMetadata_modules = updateMetadata_modules,
            filter_timeout = filter_timeout,
            filter_threads = filter_threads,
            filter_jobMemory = filter_jobMemory,
            filter_modules = filter_modules,
            filter_minQuality = filter_minQuality,
            bamFile = bwaMem.bwaMemBam,
            metadata = metadata,
            outputFileNamePrefix = bamqc_outputFileNamePrefix
    }

    call fastQC.fastQC {
        input:
            secondMateZip_timeout =  secondMateZip_timeout,
            secondMateZip_jobMemory = secondMateZip_jobMemory,
            secondMateHtml_timeout = secondMateHtml_timeout,
            secondMateHtml_jobMemory = secondMateHtml_jobMemory,
            secondMateFastQC_modules = secondMateFastQC_modules,
            secondMateFastQC_timeout = secondMateFastQC_timeout,
            secondMateFastQC_jobMemory = secondMateFastQC_jobMemory,
            firstMateZip_timeout = firstMateZip_timeout,
            firstMateZip_jobMemory = firstMateZip_jobMemory,
            firstMateHtml_timeout = firstMateHtml_timeout,
            firstMateHtml_jobMemory = firstMateHtml_jobMemory,
            firstMateFastQC_modules = firstMateFastQC_modules,
            firstMateFastQC_timeout = firstMateFastQC_timeout,
            firstMateFastQC_jobMemory = firstMateFastQC_jobMemory,
            fastqR1 = fastqR1,
            fastqR2 = fastqR2,
            outputFileNamePrefix = fastqc_outputFileNamePrefix,
            r1Suffix = r1Suffix,
            r2Suffix = r2Suffix
    }

    meta {
        author: "Fenglin Chen"
        email: "g3chen@oicr.on.ca"
        description: "Feeds bwaMem into bamQC and fastQC."
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