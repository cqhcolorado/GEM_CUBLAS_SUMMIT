#!/bin/bash
#BSUB -q batch
#BSUB -P fus123
#BSUB -nnodes 1
#BSUB -W 0:10
# #BSUB -alloc_flags "gpumps"
#BSUB -J gem_main
#BSUB -o gem_main.out.%J

rundir=${LS_SUBCWD}
cd $rundir
. ./set_modules_gem_nvcc
echo "Running at $(date) on $(hostname -f) in $(pwd) with SW env modules"
module list

ulimit -s unlimited
ulimit -c unlimited
ulimit -a

mkdir -p matrix
mkdir -p out
mkdir -p dump

t=1
# export NVCOMPILER_ACC_NOTIFY=1
export OMP_PROC_BIND=false
export OMP_NUM_THREADS=$t
export OMP_STACKSIZE=1G
#tag=nsys_prof.bld_5.src_9.run_13
tag=ncu_grid1.bld_5.src_13.run_16
x=./gem_main
o=${x}.out.$tag
# c="jsrun -n 6 -a 1 -c 7      -r 6 -l cpu-cpu $x >> $o 2>&1"
# c="jsrun -n 6 -a 1 -c 7 -g 1 -r 6 -l gpu-cpu $x >> $o 2>&1"
#  c="jsrun -n 6 -a 1 -c 7 -g 1 -r 6 -l gpu-cpu nsys profile --stats=true -o ${x}.$tag.rank_%q{OMPI_COMM_WORLD_RANK} $x >> $o 2>&1"
# c="jsrun -n 6 -a 1 -c 7 -g 1 -r 6 -l gpu-cpu ncu -k nvkernel_ppush__F1L736_1_  --set full -o ${x}.$tag.rank_%q{OMPI_COMM_WORLD_RANK} $x >> $o 2>&1"
# c="jsrun -n 6 -a 1 -c 7 -g 1 -r 6 -l gpu-cpu ncu -k nvkernel_cpush__F1L1234_2_ --set full -o ${x}.$tag.rank_%q{OMPI_COMM_WORLD_RANK} $x >> $o 2>&1"
 c="jsrun -n 6 -a 1 -c 7 -g 1 -r 6 -l gpu-cpu ncu -k nvkernel_grid1__F1L1871_3_ --set full -o ${x}.$tag.rank_%q{OMPI_COMM_WORLD_RANK} $x >> $o 2>&1"
echo $c >> $o
t0=$SECONDS
eval $c >> $o 2>&1
t1=$SECONDS
echo "Running $x took $(( t1 - t0 )) wallclock seconds."

