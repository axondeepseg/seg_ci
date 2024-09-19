#!/usr/bin/env bash
#DOCKER_IMAGE=jupyter/datascience-notebook:x86_64-latest

# == References ==

git clone https://github.com/axondeepseg/axondeepseg.git ads_v3

cd ads_v3

git checkout ads_v3_ci

conda env create -f environment.yml -n ads_v3

source activate miniconda/envs/ads_v3

pip install -e .

py.test --cov AxonDeepSeg/ --cov-report term-missing 
