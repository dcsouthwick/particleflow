#!/bin/bash
# Download the particleflow dataset from Zenodo
set -e

# each split is about 50MB pickled and gzipped
MIRROR=https://zenodo.org/record/4559324/files

DOWNLOAD_DIR=/tmp/data/zenodo
DELPHES_DIR=$DOWNLOAD_DIR/delphes_pf
echo "Download directory: $DOWNLOAD_DIR"

PF_DIR=$HOME/particleflow
DATA_DIR=$PF_DIR/tensorflow_datasets
echo "Data directory: $DATA_DIR"

# create the download dir
mkdir -p $DELPHES_DIR

# Test splits
for i in $(seq 0 19) ; do
    TARGET=tev14_pythia8_ttbar_0_${i}.pkl.bz2
    echo "Downloading train split: $TARGET"
    wget -q -P $DELPHES_DIR $MIRROR/$TARGET
done

# Train splits
for i in $(seq 0 1) ; do
    TARGET=tev14_pythia8_qcd_10_${i}.pkl.bz2
    echo "Downloading test split: $TARGET"
    wget -q -P $DELPHES_DIR $MIRROR/$TARGET
done

# build TDFS datasets
cd $PF_DIR
tfds build  mlpf/heptfds/delphes_pf --download_dir $DOWNLOAD_DIR --data_dir $DATA_DIR

rm -rf $DOWNLOAD_DIR
