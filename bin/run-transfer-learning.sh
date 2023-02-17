#!/bin/sh
set -xe
if [ ! -f DeepSpeech.py ]; then
    echo "Please make sure you run this from DeepSpeech's top level directory."
    exit 1
fi;

cudaDevice=0
alphabet="alphabet.txt"
while getopts d:a:c:t: flag
do
    case "${flag}" in
        d) dataset=${OPTARG};;
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

python3 DeepSpeech.py \
    --drop_source_layers 1 \
    --alphabet_config_path data/$alphabet \
    --save_checkpoint_dir "ckpt/"${dataset} \
    --load_checkpoint_dir "ckpt/"${dataset} \
    --train_files data/cv-corpus/$dataset/clips/train.csv \
    --train_batch_size 128 \
    --dev_files data/cv-corpus/$dataset/clips/dev.csv \
    --dev_batch_size 128 \
    --test_files data/cv-corpus/$dataset/clips/test.csv \
    --test_batch_size 128 \
    --n_hidden 2048 \
    --learning_rate 0.0001 \
    --dropout_rate 0.4 \
    --epochs 200 \
    --cache_for_epochs 10 \
    --export_dir "models/"${dataset} 