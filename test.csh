#! /bin/bash
#$ -q 4-days
#$ -l h_vmem=15G
#$ -M prodduturi.naresh@mayo.edu
#$ -m abe
#$ -V
#$ -cwd
#/usr/bin/perl /data4/bsi/bioinf_int/s106381.borawork/naresh_scripts/PAPER/EasyImputer_v2/Phase_Impute_by_parallel_proc.pl -run_config  /data4/bsi/bioinf_int/s106381.borawork/naresh_scripts/PAPER/EasyImputer_v2/config_phase_impute -tool_config /data4/bsi/bioinf_int/s106381.borawork/naresh_scripts/PAPER/EasyImputer_v2/tool_info.config
/usr/bin/perl /data4/bsi/bioinf_int/s106381.borawork/naresh_scripts/PAPER/EasyImputer_v2/QC_fwd_structure.pl  -run_config /data4/bsi/bioinf_int/s106381.borawork/naresh_scripts/PAPER/EasyImputer_v2/run_info1.config -tool_config /data4/bsi/bioinf_int/s106381.borawork/naresh_scripts/PAPER/EasyImputer_v2/tool_info.config
