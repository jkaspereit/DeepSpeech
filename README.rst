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
1. Download and extract the CommonVoice Corpus (cv-corpus): 

   `Download the latest release <https://commonvoice.mozilla.org/de>`_.
      
2. Build the Dockerfile: Dockerfile.train 

      docker build -f Dockerfile.train . -t deepspeech/training

   Example for projects structure:

   -App
      --cv-corpus
         de
      --Docker
         Dockerfile.train

3. Start the Container, it's important to load the cv-corpus as a volume and use GPU support:

      docker run -it -v $(pwd)/cv-corpus:/DeepSpeech/data/cv-corpus --gpus all deepspeech/training sh

   Container structure:

   -DeepSpeech
      --bin
         run-cv-de.sh
      --data
         --cv-corpus
            de

4. Run the CommonVoice importer:

      ./bin/import_cv2.py --filter_alphabet data/alphabet.txt data/cv-corpus/de

5. Start the Training.

      ./bin/run-cv-de.sh

Language Specific Adjustments 
==================

1. Overwrite data/alphabet.txt with all characters of your language. 

2. Create your own training script (e.g. ./bin/run-cv-en.sh)

3. Watch out for paths (e.g. /de -> /en)

- If your alphabet doesn't fit your language, you have to replace /data/alphabet.txt with the following output:

   python -m deepspeech_training.util.check_characters -csv data/cv-corpus/de/clips/train.csv,data/cv-corpus/de/clips/dev.csv,data/cv-corpus/de/clips/test.csv -unicode -alpha

// Warning: This ignores the unicode, it's possible that this causes erros or unpreciouse results 
// Probably i wongly parametarise the import script.
// Probably import with NFKC normalization?
// Probably remove unnecessary signs and lowercase every letter.

Open Questions:
- Do i have to set the local --validate_label_local my_validation.py? 
- Should i activate Training with automatic mixed precision? 
- What Training Options are provided? How does the optimal training cmd look like? 
- Language model (scorer) already important for training? Probably not...