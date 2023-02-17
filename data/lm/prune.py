def prune_line(line):
    # Remove whitespace from the line
    line = line.strip()
    # Split the line into individual characters
    chars = list(line)
    # Join the characters with spaces and return the result
    return " ".join(chars)

def prune_file(input_file, output_file):
    # Open the input file for reading and the output file for writing
    with open(input_file, "r") as input_file, open(output_file, "w") as output_file:
        # Loop over each line in the input file
        for line in input_file:
            # Prune the line and write the result to the output file
            pruned_line = prune_line(line)
            output_file.write(pruned_line + "\n")

if __name__ == "__main__":
    input_file = "vocab-500000.txt"
    output_file = "vocab.pruned.txt"
    prune_file(input_file, output_file)
