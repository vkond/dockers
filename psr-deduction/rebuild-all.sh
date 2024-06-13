#!/bin/bash
#
sudo singularity build -F deduction101.sif deduction101.def
sudo singularity build -F deduction-pre-pulsar.sif deduction-pre-pulsar.def
sudo singularity build -F deduction-pulsar.sif deduction-pulsar.def
sudo singularity build -F deduction-dspsr.sif deduction-dspsr.def
sudo singularity build -F deduction-presto.sif deduction-presto.def
