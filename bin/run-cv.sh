#!/bin/sh
set -xe
if [ ! -f DeepSpeech.py ]; then
    echo "Please make sure you run this from DeepSpeech's top level directory."
    exit 1
fi;

cudaDevice=0
argumentation=false
alphabet="alphabet.txt"
while getopts d:a:c:t: flag
do
    case "${flag}" in
        d) dataset=${OPTARG};;
        a) argumentation=${OPTARG};;
        c) cudaDevice=${OPTARG};;
        t) alphabet=${OPTARG};;
    esac
done

if [ -z "$dataset" ]; then
    echo "Please specify the dataset in data/cv-corpus/ by the parameter -d."
    exit 1
fi; 

if [ ! -f "data/cv-corpus/"${dataset}"/clips/train.csv" ] || [ ! -f "data/cv-corpus/"${dataset}"/clips/test.csv" ] || [ ! -f "data/cv-corpus/"${dataset}"/clips/dev.csv" ]; then
    echo "Please provide imported Common Voice data: data/cv-corpus/"${dataset}
    exit 1
fi;

# DeepSpeech works with one visible device (GPU) only and if you try to run it on multiple devices (GPUs), the training process will fail. 
export CUDA_VISIBLE_DEVICES=$cudaDevice

# TODO: Language Model bauen und lm_alpha, lm_beta zur Verfügung stellen für die optimale Dekodierung?

if [ "$argumentation" = "true" ]; then
python -u DeepSpeech.py --noshow_progressbar \
  --train_files data/cv-corpus/$dataset/clips/train.csv \
  --train_batch_size 128 \
  --dev_files data/cv-corpus/$dataset/clips/dev.csv \
  --dev_batch_size 128 \
  --test_files data/cv-corpus/$dataset/clips/test.csv \
  --test_batch_size 128 \
  --alphabet_config_path data/$alphabet \
  --n_hidden 2048 \
  --learning_rate 0.0001 \
  --dropout_rate 0.4 \
  --epochs 200 \
  --augment pitch[pitch=1~0.1] \
  --augment tempo[factor=1~0.1] \
  --augment resample[p=0.2,rate=12000~4000] \
  --augment codec[p=0.2,bitrate=32000~16000] \
  --augment reverb[p=0.2,decay=0.7~0.15,delay=10~8] \
  --augment volume[p=0.2,dbfs=-10~10] \
  --cache_for_epochs 10 \
  --checkpoint_dir "ckpt/"${dataset} \
  --export_dir "models/"${dataset} 
else
python DeepSpeech.py --noshow_progressbar \
  --train_files data/cv-corpus/$dataset/train.csv \
  --train_batch_size 128 \
  --dev_files data/cv-corpus/$dataset/dev.csv \
  --dev_batch_size 128 \
  --test_files data/cv-corpus/$dataset/test.csv \
  --test_batch_size 128 \
  --alphabet_config_path data/$alphabet \
  --n_hidden 2048 \
  --learning_rate 0.0001 \
  --dropout_rate 0.4 \
  --epochs 200 \
  --cache_for_epochs 10 \
  --checkpoint_dir "ckpt/"${dataset} \
  --export_dir "models/"${dataset} 
fi; 