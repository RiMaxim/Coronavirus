import sys
from collections import Counter

def load_hla_data(filename):
    with open(filename, "r") as file:
        return [set(line.strip().split(",")) for line in file]

def find_minimal_hla_set(hla_data):
    num_required = int(len(hla_data) * 0.98)  # 98% of the rows

    # Count the frequency of alleles
    allele_counts = Counter(allele for row in hla_data for allele in row)

    # Sort alleles by frequency in descending order
    sorted_alleles = [allele for allele, _ in allele_counts.most_common()]

    selected_alleles = set()
    covered_rows = set()

    # Greedy algorithm: add alleles that cover the most rows
    for allele in sorted_alleles:
        selected_alleles.add(allele)
        covered_rows = {i for i, row in enumerate(hla_data) if row.issubset(selected_alleles)}
        
        # If enough rows are covered, stop
        if len(covered_rows) >= num_required:
            break
    
    # Return the minimal allele set and the rows it covers
    return selected_alleles, [hla_data[i] for i in covered_rows]

def save_minimal_set(output_file, minimal_set):
    # Sort the minimal allele set before saving
    sorted_minimal_set = sorted(minimal_set)
    
    with open(output_file, "w") as file:
        for allele in sorted_minimal_set:
            file.write(allele + "\n")

if __name__ == "__main__":
    if len(sys.argv) != 3:
        print("Usage: python script.py <input_file> <output_file>")
        sys.exit(1)
    
    input_file = sys.argv[1]
    output_file = sys.argv[2]
    
    hla_data = load_hla_data(input_file)
    minimal_set, result_rows = find_minimal_hla_set(hla_data)

    # Output the result to the console
    print("Minimal unique allele set:", minimal_set)
    print("Rows it covers:")
    for row in result_rows:
        print(",".join(row))
    
    # Save the minimal allele set to the output file
    save_minimal_set(output_file, minimal_set)
    print(f"Minimal allele set saved to {output_file}")
