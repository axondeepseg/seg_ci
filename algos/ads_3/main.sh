#!/usr/bin/env bash
#DOCKER_IMAGE=jupyter/datascience-notebook:x86_64-latest

# == References ==

git clone https://github.com/axondeepseg/axondeepseg.git ads_v3

cd ads_v3

git checkout 45e7da0

conda install -n base conda-libmamba-solver

conda env create -f environment.yml -n ads_v3 --solver=libmamba
source activate ads_v3

pip install -e .

py.test --cov AxonDeepSeg/ --cov-report term-missing > ../output/log3.txt
