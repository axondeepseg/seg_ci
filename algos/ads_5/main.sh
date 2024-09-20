#!/usr/bin/env bash
#DOCKER_IMAGE=jupyter/datascience-notebook:x86_64-latest

# == References ==

git clone https://github.com/axondeepseg/axondeepseg.git ads_v5

cd ads_v5

git checkout ac/nnunet_migration

## install
./install_ads -y

## activate

source /home/jovyan/.bashrc


source ads_conda/bin/activate ads_conda/envs/venv_ads/

py.test --cov AxonDeepSeg/ --cov-report term-missing

# Run on images

git clone https://github.com/axondeepseg/data_ci.git data

cd data

# SEM

cd sem

axondeepseg -i image.png

cd ..

# TEM

cd tem

axondeepseg -i image.png

cd ..

# Compress

cd ..

tar -zcvf /seg_ci/output/output.tar.gz data

echo 'Done!'