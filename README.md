# dnaSeqQC

Calls the bwaMem-bamQC alignment as a single step.

## Overview

## Dependencies

* [bwa 0.7.12](https://github.com/lh3/bwa/archive/0.7.12.tar.gz)
* [samtools 1.9](https://github.com/samtools/samtools/archive/0.1.19.tar.gz)
* [cutadapt 1.8.3](https://cutadapt.readthedocs.io/en/v1.8.3/)
* [slicer 0.3.0](https://github.com/OpenGene/slicer/archive/v0.3.0.tar.gz)
* [picard 2.21.2](https://broadinstitute.github.io/picard/command-line-overview.html)
* [python 3.6](https://www.python.org/downloads/)
* [bam-qc-metrics 0.2.5](https://github.com/oicr-gsi/bam-qc-metrics.git)
* [mosdepth 0.2.9](https://github.com/brentp/mosdepth)


## Usage

### Cromwell
```
java -jar cromwell.jar run dnaSeqQC.wdl --inputs inputs.json
```

### Inputs

#### Required workflow parameters:
Parameter|Value|Description
---|---|---
`fastqR1`|File|fastq file for read 1
`fastqR2`|File|fastq file for read 2
`reference`|String|Reference Assembly id
`bwamem2.runBwamem2_readGroups`|String|The readgroup information to be injected into the bam header
`bamQC.bamQCMetrics_workflowVersion`|String|Workflow version string
`bamQC.bamQCMetrics_refSizesBed`|String|Path to human genome BED reference with chromosome sizes
`bamQC.bamQCMetrics_refFasta`|String|Path to human genome FASTA reference
`bamQC.metadata`|Map[String,String]|JSON file containing metadata
`bamQC.mode`|String|running mode for the workflow, only allow value 'lane_level' and 'call_ready'


#### Optional workflow parameters:
Parameter|Value|Default|Description
---|---|---|---
`outputFileNamePrefix`|String|basename(fastqR1)|Optional output prefix for the output


#### Optional task parameters:
Parameter|Value|Default|Description
---|---|---|---
`bwamem2.adapterTrimmingLog_timeout`|Int|48|Hours before task timeout
`bwamem2.adapterTrimmingLog_jobMemory`|Int|12|Memory allocated indexing job
`bwamem2.indexBam_timeout`|Int|48|Hours before task timeout
`bwamem2.indexBam_modules`|String|"samtools/1.9"|Modules for running indexing job
`bwamem2.indexBam_jobMemory`|Int|12|Memory allocated indexing job
`bwamem2.bamMerge_timeout`|Int|72|Hours before task timeout
`bwamem2.bamMerge_modules`|String|"samtools/1.9"|Required environment modules
`bwamem2.bamMerge_jobMemory`|Int|32|Memory allocated indexing job
`bwamem2.runBwamem2_timeout`|Int|96|Hours before task timeout
`bwamem2.runBwamem2_jobMemory`|Int|32|Memory allocated for this job
`bwamem2.runBwamem2_threads`|Int|8|Requested CPU threads
`bwamem2.runBwamem2_addParam`|String?|None|Additional BWA parameters
`bwamem2.adapterTrimming_timeout`|Int|48|Hours before task timeout
`bwamem2.adapterTrimming_jobMemory`|Int|16|Memory allocated for this job
`bwamem2.adapterTrimming_addParam`|String?|None|Additional cutadapt parameters
`bwamem2.adapterTrimming_adapter2`|String|"AGATCGGAAGAGCGTCGTGTAGGGAAAGAGTGT"|Adapter sequence to trim from read 2
`bwamem2.adapterTrimming_adapter1`|String|"AGATCGGAAGAGCACACGTCTGAACTCCAGTCAC"|Adapter sequence to trim from read 1
`bwamem2.adapterTrimming_trimMinQuality`|Int|0|Minimum quality of read ends to keep
`bwamem2.adapterTrimming_trimMinLength`|Int|1|Minimum length of reads to keep
`bwamem2.adapterTrimming_umiLength`|Int|5|The number of bases to trim when doUMItrim is true. If the given length is positive, the bases are removed from the beginning of each read. If it is negative, the bases are removed from the end
`bwamem2.adapterTrimming_doUMItrim`|Boolean|false|If true, do umi trimming
`bwamem2.adapterTrimming_modules`|String|"cutadapt/1.8.3"|Required environment modules
`bwamem2.extractUMIs_timeout`|Int|12|Time in hours before task timeout
`bwamem2.extractUMIs_jobMemory`|Int|24|Memory allocated for this job
`bwamem2.extractUMIs_modules`|String|"barcodex-rs/0.1.2 rust/1.45.1"|Required environment modules
`bwamem2.extractUMIs_pattern2`|String|"(?P<umi_1>^[ACGT]{3}[ACG])(?P<discard_1>T)|(?P<umi_2>^[ACGT]{3})(?P<discard_2>T)"|UMI RegEx pattern 2
`bwamem2.extractUMIs_pattern1`|String|"(?P<umi_1>^[ACGT]{3}[ACG])(?P<discard_1>T)|(?P<umi_2>^[ACGT]{3})(?P<discard_2>T)"|UMI RegEx pattern 1
`bwamem2.extractUMIs_outputPrefix`|String|"extractUMIs_output"|Specifies the start of the output files
`bwamem2.extractUMIs_umiList`|String|"umiList"|Reference file with valid UMIs
`bwamem2.slicerR2_timeout`|Int|48|Hours before task timeout
`bwamem2.slicerR2_jobMemory`|Int|16|Memory allocated for this job
`bwamem2.slicerR2_modules`|String|"slicer/0.3.0"|Required environment modules
`bwamem2.slicerR1_timeout`|Int|48|Hours before task timeout
`bwamem2.slicerR1_jobMemory`|Int|16|Memory allocated for this job
`bwamem2.slicerR1_modules`|String|"slicer/0.3.0"|Required environment modules
`bwamem2.countChunkSize_timeout`|Int|48|Hours before task timeout
`bwamem2.countChunkSize_jobMemory`|Int|16|Memory allocated for this job
`bwamem2.countChunkSize_modules`|String|"python/3.7"|Required environment modules
`bwamem2.numChunk`|Int|1|Number of chunks to split fastq file [1, no splitting]
`bwamem2.doUMIextract`|Boolean|false|If true, UMI will be extracted before alignment [false]
`bwamem2.doTrim`|Boolean|false|If true, adapters will be trimmed before alignment [false]
`bwamem2.numReads`|Int?|None|Number of reads
`bamQC.collateResults_timeout`|Int|1|hours before task timeout
`bamQC.collateResults_threads`|Int|4|Requested CPU threads
`bamQC.collateResults_jobMemory`|Int|8|Memory allocated for this job
`bamQC.collateResults_modules`|String|"python/3.6"|required environment modules
`bamQC.cumulativeDistToHistogram_timeout`|Int|1|hours before task timeout
`bamQC.cumulativeDistToHistogram_threads`|Int|4|Requested CPU threads
`bamQC.cumulativeDistToHistogram_jobMemory`|Int|8|Memory allocated for this job
`bamQC.cumulativeDistToHistogram_modules`|String|"python/3.6"|required environment modules
`bamQC.runMosdepth_timeout`|Int|4|hours before task timeout
`bamQC.runMosdepth_threads`|Int|4|Requested CPU threads
`bamQC.runMosdepth_jobMemory`|Int|16|Memory allocated for this job
`bamQC.runMosdepth_modules`|String|"mosdepth/0.2.9"|required environment modules
`bamQC.bamQCMetrics_timeout`|Int|4|hours before task timeout
`bamQC.bamQCMetrics_threads`|Int|4|Requested CPU threads
`bamQC.bamQCMetrics_jobMemory`|Int|16|Memory allocated for this job
`bamQC.bamQCMetrics_modules`|String|"bam-qc-metrics/0.2.5"|required environment modules
`bamQC.bamQCMetrics_normalInsertMax`|Int|1500|Maximum of expected insert size range
`bamQC.markDuplicates_timeout`|Int|4|hours before task timeout
`bamQC.markDuplicates_threads`|Int|4|Requested CPU threads
`bamQC.markDuplicates_jobMemory`|Int|16|Memory allocated for this job
`bamQC.markDuplicates_modules`|String|"picard/2.21.2"|required environment modules
`bamQC.markDuplicates_picardMaxMemMb`|Int|6000|Memory requirement in MB for running Picard JAR
`bamQC.markDuplicates_opticalDuplicatePixelDistance`|Int|100|Maximum offset between optical duplicate clusters
`bamQC.downsampleRegion_timeout`|Int|4|hours before task timeout
`bamQC.downsampleRegion_threads`|Int|4|Requested CPU threads
`bamQC.downsampleRegion_jobMemory`|Int|16|Memory allocated for this job
`bamQC.downsampleRegion_modules`|String|"samtools/1.14"|required environment modules
`bamQC.downsample_timeout`|Int|4|hours before task timeout
`bamQC.downsample_threads`|Int|4|Requested CPU threads
`bamQC.downsample_jobMemory`|Int|16|Memory allocated for this job
`bamQC.downsample_modules`|String|"samtools/1.14"|required environment modules
`bamQC.downsample_randomSeed`|Int|42|Random seed for pre-downsampling (if any)
`bamQC.downsample_downsampleSuffix`|String|"downsampled.bam"|Suffix for output file
`bamQC.findDownsampleParamsMarkDup_timeout`|Int|4|hours before task timeout
`bamQC.findDownsampleParamsMarkDup_threads`|Int|4|Requested CPU threads
`bamQC.findDownsampleParamsMarkDup_jobMemory`|Int|16|Memory allocated for this job
`bamQC.findDownsampleParamsMarkDup_modules`|String|"python/3.6"|required environment modules
`bamQC.findDownsampleParamsMarkDup_customRegions`|String|""|Custom downsample regions; overrides chromosome and interval parameters
`bamQC.findDownsampleParamsMarkDup_intervalStart`|Int|100000|Start of interval in each chromosome, for very large BAMs
`bamQC.findDownsampleParamsMarkDup_baseInterval`|Int|15000|Base width of interval in each chromosome, for very large BAMs
`bamQC.findDownsampleParamsMarkDup_chromosomes`|Array[String]|["chr12", "chr13", "chrXII", "chrXIII"]|Array of chromosome identifiers for downsampled subset
`bamQC.findDownsampleParamsMarkDup_threshold`|Int|10000000|Minimum number of reads to conduct downsampling
`bamQC.findDownsampleParams_timeout`|Int|4|hours before task timeout
`bamQC.findDownsampleParams_threads`|Int|4|Requested CPU threads
`bamQC.findDownsampleParams_jobMemory`|Int|16|Memory allocated for this job
`bamQC.findDownsampleParams_modules`|String|"python/3.6"|required environment modules
`bamQC.findDownsampleParams_preDSMultiplier`|Float|1.5|Determines target size for pre-downsampled set (if any). Must have (preDSMultiplier) < (minReadsRelative).
`bamQC.findDownsampleParams_precision`|Int|8|Number of decimal places in fraction for pre-downsampling
`bamQC.findDownsampleParams_minReadsRelative`|Int|2|Minimum value of (inputReads)/(targetReads) to allow pre-downsampling
`bamQC.findDownsampleParams_minReadsAbsolute`|Int|10000|Minimum value of targetReads to allow pre-downsampling
`bamQC.findDownsampleParams_targetReads`|Int|100000|Desired number of reads in downsampled output
`bamQC.updateMetadata_timeout`|Int|4|hours before task timeout
`bamQC.updateMetadata_threads`|Int|4|Requested CPU threads
`bamQC.updateMetadata_jobMemory`|Int|16|Memory allocated for this job
`bamQC.updateMetadata_modules`|String|"python/3.6"|required environment modules
`bamQC.filter_timeout`|Int|4|hours before task timeout
`bamQC.filter_threads`|Int|4|Requested CPU threads
`bamQC.filter_jobMemory`|Int|16|Memory allocated for this job
`bamQC.filter_modules`|String|"samtools/1.14"|required environment modules
`bamQC.filter_minQuality`|Int|30|Minimum alignment quality to pass filter
`bamQC.mergeFiles_modules`|String|"gatk/4.1.6.0"|Environment module name and version to load (space separated) before command execution.
`bamQC.mergeFiles_timeout`|Int|24|Maximum amount of time (in hours) the task can run for.
`bamQC.mergeFiles_cores`|Int|1|The number of cores to allocate to the job.
`bamQC.mergeFiles_overhead`|Int|6|Java overhead memory (in GB). jobMemory - overhead == java Xmx/heap memory.
`bamQC.mergeFiles_jobMemory`|Int|24|Memory allocated to job (in GB).
`bamQC.mergeFiles_suffix`|String|".merge"|suffix to use for merged bam
`bamQC.mergeSplitByIntervalFiles_modules`|String|"gatk/4.1.6.0"|Environment module name and version to load (space separated) before command execution.
`bamQC.mergeSplitByIntervalFiles_timeout`|Int|24|Maximum amount of time (in hours) the task can run for.
`bamQC.mergeSplitByIntervalFiles_cores`|Int|1|The number of cores to allocate to the job.
`bamQC.mergeSplitByIntervalFiles_overhead`|Int|6|Java overhead memory (in GB). jobMemory - overhead == java Xmx/heap memory.
`bamQC.mergeSplitByIntervalFiles_jobMemory`|Int|24|Memory allocated to job (in GB).
`bamQC.mergeSplitByIntervalFiles_suffix`|String|".merge"|suffix to use for merged bam
`bamQC.preFilter_timeout`|Int|4|hours before task timeout
`bamQC.preFilter_threads`|Int|4|Requested CPU threads
`bamQC.preFilter_minMemory`|Int|2|Minimum amount of RAM allocated to the task
`bamQC.preFilter_jobMemory`|Int|6|Memory allocated for this job
`bamQC.preFilter_modules`|String|"samtools/1.14"|required environment modules
`bamQC.preFilter_filterAdditionalParams`|String?|None|Additional parameters to pass to samtools.
`bamQC.preFilter_minMapQuality`|Int?|None|Minimum alignment quality to pass filter
`bamQC.preFilter_filterFlags`|Int|260|Samtools filter flags to apply.
`bamQC.getChrCoefficient_modules`|String|"samtools/1.14"|Names and versions of modules to load
`bamQC.getChrCoefficient_timeout`|Int|1|Hours before task timeout
`bamQC.getChrCoefficient_memory`|Int|2|Memory allocated for this job
`bamQC.splitStringToArray_modules`|String|""|Environment module name and version to load (space separated) before command execution.
`bamQC.splitStringToArray_timeout`|Int|1|Maximum amount of time (in hours) the task can run for.
`bamQC.splitStringToArray_cores`|Int|1|The number of cores to allocate to the job.
`bamQC.splitStringToArray_jobMemory`|Int|1|Memory allocated to job (in GB).
`bamQC.splitStringToArray_recordSeparator`|String|"+"|Record separator - a delimiter for joining records
`bamQC.splitStringToArray_lineSeparator`|String|","|Interval group separator - these are the intervals to split by.
`bamQC.intervalsToParallelizeByString`|String|"chr1,chr2,chr3,chr4,chr5,chr6,chr7,chr8,chr9,chr10,chr11,chr12,chr13,chr14,chr15,chr16,chr17,chr18,chr19,chr20,chr21,chr22,chrX,chrY,chrM"|Comma separated list of intervals to split by (e.g. chr1,chr2,chr3,chr4).


### Outputs

Output | Type | Description | Labels
---|---|---|---
`log`|File?|log file for bwaMem task|vidarr_label: log
`cutAdaptAllLogs`|File?|log file for cutadapt task|vidarr_label: cutAdaptAllLogs
`result`|File|bamQC report|vidarr_label: result


## Commands
This section lists command(s) run by dnaseqQC workflow
 
 * Running dnaseqQC
 
This workflow imports two other workflows, bwaMem and bamQC. See the commands in README files for these workflows.
 
## Support

For support, please file an issue on the [Github project](https://github.com/oicr-gsi) or send an email to gsi@oicr.on.ca .

_Generated with generate-markdown-readme (https://github.com/oicr-gsi/gsi-wdl-tools/)_
