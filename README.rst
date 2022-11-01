Project DeepSpeech
==================


.. image:: https://readthedocs.org/projects/deepspeech/badge/?version=latest
   :target: https://deepspeech.readthedocs.io/?badge=latest
   :alt: Documentation

.. image:: https://github.com/mozilla/DeepSpeech/actions/workflows/lint.yml/badge.svg
   :target: https://github.com/mozilla/DeepSpeech/actions/workflows/lint.yml
   :alt: Linters

.. image:: https://github.com/mozilla/DeepSpeech/actions/workflows/docker.yml/badge.svg
   :target: https://github.com/mozilla/DeepSpeech/actions/workflows/docker.yml
   :alt: Docker Images


DeepSpeech is an open-source Speech-To-Text engine, using a model trained by machine learning techniques based on `Baidu's Deep Speech research paper <https://arxiv.org/abs/1412.5567>`_. Project DeepSpeech uses Google's `TensorFlow <https://www.tensorflow.org/>`_ to make the implementation easier.

Documentation for installation, usage, and training models are available on `deepspeech.readthedocs.io <https://deepspeech.readthedocs.io/?badge=latest>`_.

For the latest release, including pre-trained models and checkpoints, `see the latest release on GitHub <https://github.com/mozilla/DeepSpeech/releases/latest>`_.


DeepSpeech 4 CommonVoice
==================
1. Download and extract the CommonVoice Corpus (cv-corpus).
2. Build the Dockerfile: Dockerfile.train 

      docker build -f Dockerfile.train . -t deepspeech/training

   Example for projects structure:

   -App
      --cv-corpus
         --de
            -- clips & etc. 
      --Docker
         -- Dockerfile.train

3. Start the Container, it's important to load the cv-corpus as a volume and use GPU support:

      docker run -it -v $(pwd)/cv-corpus:/cv-corpus --gpus all deepspeech/training sh

4. Start the Training.

      python3 DeepSpeech.py --train_files ../cv-corpus/de/clips/train.csv --dev_files ../cv-corpus/de/clips/dev.csv --test_files ../cv-corpus/de/clips/test.csv --checkpoint_dir ../checkpoints --export_dir ../output --automatic_mixed_precision

- If your alphabet doesn't fit your language, you have to replace /data/alphabet.txt with the following output:

   python -m deepspeech_training.util.check_characters -csv ../cv-corpus/de/clips/train.csv,../cv-corpus/de/clips/dev.csv,../cv-corpus/de/clips/test.csv -unicode -alpha

// Warning: This ignores the unicode, it's possible that this causes erros or unpreciouse results 
// Probably i wongly parametarise the import script.
// Probably import with NFKC normalization?
// Probably remove unnecessary signs and lowercase every letter.

Open Questions:
- Do i have to set the local --validate_label_local my_validation.py? 
- Should i activate Training with automatic mixed precision? 
- What Training Options are provided? How does the optimal training cmd look like? 
- Language model (scorer) already important for training? Probably not...