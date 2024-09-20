#!/usr/bin/env bash
#DOCKER_IMAGE=jupyter/datascience-notebook:x86_64-latest

# == References ==

git clone https://github.com/axondeepseg/axondeepseg.git ads_v3

cd ads_v3

git clone https://github.com/axondeepseg/data_ci.git data

git checkout ads_v3_ci

conda env create -f environment.yml -n ads_v3

source activate ads_v3

pip install -e .

py.test --cov AxonDeepSeg/ --cov-report term-missing 

# Run on images

cd data

# SEM

cd sem

axondeepseg -t SEM -i image.png

cd ..

# TEM

cd tem

axondeepseg -t TEM -i image.png

cd ..

# Compress

cd ..

tar -zcvf /seg_ci/output/output.tar.gz data

echo 'Done!'