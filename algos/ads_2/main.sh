#!/usr/bin/env bash
#DOCKER_IMAGE=jupyter/datascience-notebook:x86_64-latest

# == References ==

git clone https://github.com/axondeepseg/axondeepseg.git ads_v2

cd ads_v2

git clone https://github.com/axondeepseg/data_ci.git data

git checkout b31988d532e25dbe125549946e6766ef569f7950

conda create -n ads_v2 python=3.6
source activate ads_v2

pip install numpy==
python -V

sudo apt-get update
sudo apt-get install build-essential libatlas-base-dev gfortran

pip install -e . --ignore-installed certifi
pip uninstall h5py
pip install h5py==2.10.0

py.test --cov AxonDeepSeg/ --cov-report term-missing

# Run on images

cd data

# SEM

cd sem

axondeepseg -t SEM -i image.png -v 2
ls
pwd
cd ..

# TEM

cd tem

axondeepseg -t TEM -i image.png -v 2
ls
pwd

cd ..

# Compress

cd ..

tar -zcvf /seg_ci/output/ads_2.tar.gz data


echo 'Done!   '