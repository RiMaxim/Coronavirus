awk -F',' '
# Function to sort alleles in the format HLA (X*XX:YY)
function sort_alleles(alleles_str,    arr, n, i, j, part1, part2, temp) {
    if (alleles_str == "") return ""  # If the string is empty, return an empty string
    
    split(alleles_str, arr, ",")  # Split the string into an array
    n = length(arr)

    # Bubble sort
    for (i = 1; i < n; i++) {
        for (j = i + 1; j <= n; j++) {
            split(arr[i], part1, ":")
            split(arr[j], part2, ":")
            if (part1[1] > part2[1] || (part1[1] == part2[1] && part1[2] > part2[2])) {
                temp = arr[i]
                arr[i] = arr[j]
                arr[j] = temp
            }
        }
    }

    return join(arr, n)  # Return the sorted string
}

# Function to join an array into a string separated by commas
function join(arr, n,    result, k) {
    result = arr[1]
    for (k = 2; k <= n; k++) {
        result = result "," arr[k]
    }
    return result
}

# Create a hash table to store unique strings
BEGIN {
    PROCINFO["sorted_in"] = "@ind_str_asc"
}

{
    # Variables to store alleles of groups A, B, C
    alleles_A = ""
    alleles_B = ""
    alleles_C = ""

    # Process each column
    for (i = 1; i <= NF; i++) {
        split($i, alleles, "/")  # Split by "/"
        first_allele = alleles[1]  # Take only the first allele

        if (match(first_allele, /^([ABC]\*[0-9]+):([0-9]+)/, matches)) {
            formatted = matches[1] ":" matches[2]  # Format the allele

            # Classify alleles into A, B, or C
            if (match(formatted, /^A\*/)) {
                alleles_A = (alleles_A == "" ? formatted : alleles_A "," formatted)
            } else if (match(formatted, /^B\*/)) {
                alleles_B = (alleles_B == "" ? formatted : alleles_B "," formatted)
            } else if (match(formatted, /^C\*/)) {
                alleles_C = (alleles_C == "" ? formatted : alleles_C "," formatted)
            }
        }
    }

    # Sort alleles within each group
    alleles_A = sort_alleles(alleles_A)
    alleles_B = sort_alleles(alleles_B)
    alleles_C = sort_alleles(alleles_C)

    # Check if each group has exactly 2 alleles
    split(alleles_A, A_array, ",")
    split(alleles_B, B_array, ",")
    split(alleles_C, C_array, ",")

    if (length(A_array) == 2 && length(B_array) == 2 && length(C_array) == 2) {
        # Combine alleles in the correct order with commas
        sorted_line = alleles_A "," alleles_B "," alleles_C

        # Print the line if it is unique
        if (sorted_line != "" && !seen[sorted_line]) {
            print sorted_line
            seen[sorted_line] = 1  # Mark the string as printed
        }
    }
}' data.csv >data2.csv
