#!/usr/bin/env bash
#DOCKER_IMAGE=jupyter/datascience-notebook:x86_64-latest

# == References ==

git clone https://github.com/axondeepseg/axondeepseg.git ads_v3

cd ads_v3

git checkout 45e7da0

wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -O miniconda.sh
bash miniconda.sh -b -p miniconda
echo ". miniconda/etc/profile.d/conda.sh" >> ~/.bashrc
source ~/.bashrc
which conda
conda env create -f environment.yml -n ads_v3

source activate ads_v3

pip install -e .

py.test --cov AxonDeepSeg/ --cov-report term-missing 
