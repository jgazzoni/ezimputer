#! /bin/bash
#$ -q 1-day
#$ -l h_vmem=10G
#$ -t 1-zzz:1
#$ -M Zhang.Yiwei@mayo.edu
#$ -m a
#$ -V
#$ -cwd
#$ -e zzz
#$ -o zzz
k=`cat  zzz |head -$SGE_TASK_ID |tail -1`
zzz $k -seed 123456789
