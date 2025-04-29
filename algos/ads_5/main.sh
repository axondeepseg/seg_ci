#!/usr/bin/env bash
#DOCKER_IMAGE=jupyter/datascience-notebook:x86_64-latest

# == References ==

git clone https://github.com/axondeepseg/axondeepseg.git ads_v5

cd ads_v5

git clone -b mb/ubc https://github.com/axondeepseg/data_ci.git data

git checkout master

## install
./install_ads -y

## activate

source /home/jovyan/.bashrc


source ads_conda/bin/activate ads_conda/envs/venv_ads/

py.test --cov AxonDeepSeg/ --cov-report term-missing

# Run on images

cd data

# SEM

cd sem

axondeepseg -i image.png
ls
cp image_grayscale_seg-axonmyelin.png image_seg-axonmyelin.png
cp image_grayscale.png image.png
cp image_grayscale_seg-axon.png image_seg-axon.png
cp image_grayscale_seg-myelin.png image_seg-myelin.png
ls
cd ..

# TEM

cd tem

axondeepseg -i image.png

cd ..

# UBC TEM

cd ubc

axondeepseg -i image.tif

cd ..

# Compress

cd ..

tar -zcvf /seg_ci/output/ads_5.tar.gz data

echo 'Done!'
