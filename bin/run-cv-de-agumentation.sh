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

//python3 DeepSpeech.py --train_files ../cv-corpus/de/clips/train.csv --dev_files ../cv-corpus/de/clips/dev.csv --test_files ../cv-corpus/de/clips/test.csv --checkpoint_dir ../checkpoints --export_dir ../output --automatic_mixed_precision

# TODO: Language Model bauen und lm_alpha, lm_beta zur Verfügung stellen für die optimale Dekodierung.  

python -u DeepSpeech.py --noshow_progressbar \
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
  --augment pitch[pitch=1~0.1]
  --augment tempo[factor=1~0.1]
  --augment resample[p=0.2,rate=12000~4000]
  --augment codec[p=0.2,bitrate=32000~16000]
  --augment reverb[p=0.2,decay=0.7~0.15,delay=10~8]
  --augment volume[p=0.2,dbfs=-10~10]
  --cache_for_epochs 10 \
  --checkpoint_dir "/ckpt" \
  --export_dir "/models/cv/de" \
  "$@"
