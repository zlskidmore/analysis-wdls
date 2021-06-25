version 1.0

task docmAddVariants {
  input {
    File reference
    File reference_fai
    File reference_dict
    File callers_vcf
    File callers_vcf_tbi
    File docm_vcf
    File docm_vcf_tbi
  }

  runtime {
    memory: "9GB"
    bootDiskSizeGb: 25
    docker: "mgibio/gatk-cwl:3.6.0"
  }

  String outfile = "merged.vcf.gz"
  command <<<
    /usr/bin/java -Xmx8g -jar /opt/GenomeAnalysisTK.jar -T CombineVariants \
    -genotypeMergeOptions PRIORITIZE --rod_priority_list callers,docm --setKey null -o ~{outfile} \
    -R ~{reference} --variant:callers ~{callers_vcf} --variant:docm ~{docm_vcf}
  >>>

  output {
    File merged_vcf = outfile
    File merged_vcf_tbi = outfile + ".tbi"
  }
}

workflow wf {
  input {
    File reference
    File reference_fai
    File reference_dict
    File callers_vcf
    File callers_vcf_tbi
    File docm_vcf
    File docm_vcf_tbi
  }

  call docmAddVariants {
    input:
    reference=reference,
    reference_fai=reference_fai,
    reference_dict=reference_dict,
    callers_vcf=callers_vcf,
    callers_vcf_tbi=callers_vcf_tbi,
    docm_vcf=docm_vcf,
    docm_vcf_tbi=docm_vcf_tbi
  }
}