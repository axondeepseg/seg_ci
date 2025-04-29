#!/usr/bin/env bash
#DOCKER_IMAGE=jupyter/datascience-notebook:x86_64-latest

# == References ==

git clone https://github.com/axondeepseg/axondeepseg.git ads_v2

cd ads_v2

git clone -b mb/ubc https://github.com/axondeepseg/data_ci.git data

git checkout ads_v1_ci

conda create -n ads_v1 python=2.7
source activate ads_v1

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

axondeepseg -t SEM -i image.png

cd ..

# TEM

cd tem

axondeepseg -t TEM -i image.png

cd ..

# UBC TEM

cd ubc

axondeepseg -t TEM -i image.tif

cd ..

# Compress

cd ..

tar -zcvf /seg_ci/output/ads_1.tar.gz data

ls

echo 'Done!'