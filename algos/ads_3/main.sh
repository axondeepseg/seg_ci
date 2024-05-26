#!/usr/bin/env bash
#DOCKER_IMAGE=jupyter/datascience-notebook:x86_64-latest

# == References ==

git clone https://github.com/axondeepseg/axondeepseg.git ads_v3

cd ads_v3

git checkout ads_v3_ci

## prioritize 'conda-forge' channel
conda config --add channels conda-forge

## update existing packages to use 'conda-forge' channel
conda update -n base --all

## install 'mamba'
conda install -n base mamba

conda update -n base -c conda-forge conda

mamba env create -f environment.yml -n ads_v3
source activate ads_v3

pip install -e .

py.test --cov AxonDeepSeg/ --cov-report term-missing > ../output/log3.txt
