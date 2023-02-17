1. Vocab txt bauen
python import_cv --train.csv path
2. vocab-500000 txt bauen
   python3 generate_lm.py --input_txt vocab.txt --output_dir . \
  --top_k 500000 --kenlm_bins ../../kenlm/build/bin/ \
  --arpa_order 5 --max_arpa_memory "85%" --arpa_prune "0|0|1" \
  --binary_a_bits 255 --binary_q_bits 8 --binary_type trie
3. scorer generieren
./generate_scorer_package --alphabet ../alphabet-utf8.txt --lm lm.binary --vocab vocab-500000.txt \
  --package kenlm.scorer --default_alpha 0.931289039105002 --default_beta 1.1834137581510284
