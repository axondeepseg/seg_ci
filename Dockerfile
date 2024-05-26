FROM jupyter/datascience-notebook:x86_64-latest

USER root

RUN cd $HOME/work;\
    git clone --single-branch -b debug https://github.com/axondeepseg/seg_ci.git;                            \
    chmod -R 777 $HOME/work/seg_ci; 

WORKDIR $HOME/work/seg_ci

USER $NB_UID

