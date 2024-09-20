#!/usr/bin/env bash
#DOCKER_IMAGE=jupyter/datascience-notebook:x86_64-latest

# == References ==

git clone https://github.com/axondeepseg/axondeepseg.git ads_v4

cd ads_v4

git checkout ads_v4_ci

conda env create -f environment.yml -n ads_v4

source activate ads_v4

pip install -e .

py.test --cov AxonDeepSeg/ --cov-report term-missing 

# Run on images

git clone https://github.com/axondeepseg/data_ci.git data

cd data

# SEM

cd sem

axondeepseg -t SEM --no-patch -i image.png

cd ..

# TEM

cd tem

axondeepseg -t TEM --no-patch -i image.png

cd ..

# Compress

cd ..

tar -zcvf /seg_ci/output.tar.gz data

echo 'Done!'