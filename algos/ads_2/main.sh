#!/usr/bin/env bash
#DOCKER_IMAGE=jupyter/datascience-notebook:x86_64-latest

# == References ==

git clone https://github.com/axondeepseg/axondeepseg.git ads_v2

cd ads_v2

git checkout b31988d532e25dbe125549946e6766ef569f7950

conda create -n ads_v2 python=3.6
conda activate ads_v2

pip install -e .  --ignore-installed certifi

py.test --cov AxonDeepSeg/ --cov-report term-missing
