import argparse


def buildVocab(cv_csv_path):
    with open(cv_csv_path, newline='') as csvfile:
        with open("vocab.txt", "w") as vocabfile:
            for row in csvfile:
                sentence = row.split(",")[2]
                vocabfile.write(sentence)

def main():
    parser = argparse.ArgumentParser(
        description="Generates a vocab.txt file out of a cv-corups which can be used to generate a language model."
    )
    parser.add_argument(
        "--train_csv",
        help="Path to the train.csv of your cv-corpus.",
        type=str,
        required=True,
    )
    args = parser.parse_args()

    buildVocab(args.train_csv)

if __name__ == "__main__":
    main()