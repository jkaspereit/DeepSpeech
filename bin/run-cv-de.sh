#!/bin/sh
set -xe
if [ ! -f DeepSpeech.py ]; then
    echo "Please make sure you run this from DeepSpeech's top level directory."
    exit 1
fi;

if [ ! -f "data/cv-corpus/de/clips/train.csv" ] || [ ! -f "data/cv-corpus/de/clips/test.csv" ] || [ ! -f "data/cv-corpus/de/clips/dev.csv" ]; then
    echo "Please provide imported Common Voice data: data/cv-corpus/de/clips"
    exit 1
fi;

# DeepSpeech only works with one visible device (GPU) and when trying to run on multiple devices (GPUs), the training process will break
# Therefore, make only CUDA Device 0 visible.
export CUDA_VISIBLE_DEVICES=0

# TODO: Language Model bauen und lm_alpha, lm_beta zur Verfügung stellen für die optimale Dekodierung.  

python DeepSpeech.py --noshow_progressbar \
  --train_files data/cv-corpus/de/clips/train.csv \
  --train_batch_size 128 \
  --dev_files data/cv-corpus/de/clips/dev.csv \
  --dev_batch_size 128 \
  --test_files data/cv-corpus/de/clips/test.csv \
  --test_batch_size 128 \
  --n_hidden 2048 \
  --learning_rate 0.0001 \
  --dropout_rate 0.4 \
  --epochs 200 \
  --cache_for_epochs 10 \
  --checkpoint_dir "/ckpt" \
  --export_dir "/models/cv/de" \
  "$@"
