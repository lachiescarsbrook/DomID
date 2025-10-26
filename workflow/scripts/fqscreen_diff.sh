# Total number of arguments
N=$#

# Last argument = target species
TARGET="${!N}"

# All arguments as an array
ARGS=("$@")

# Output = second-to-last argument
OUTPUT="${ARGS[$((N-2))]}"

# Input files = all arguments except last two
FILES=("${ARGS[@]:0:$((N-2))}")

# Ensure output file is empty
> "$OUTPUT"

# Loop over each input file
for INPUT in "${FILES[@]}"; do
    # Extract sample name safely
    SAMPLE=$(basename "$INPUT")
    SAMPLE=${SAMPLE%_hits.txt}

    # Check if all counts are zero (or file empty)
    total_counts=$(awk '{sum+=$2} END{print sum}' "$INPUT")
    if [[ -z "$total_counts" || "$total_counts" -eq 0 ]]; then
        printf "%s\tNA\tNA\tNA\n" "$SAMPLE" >> "$OUTPUT"
        continue
    fi

    # Get top hit (species with highest percent)
    read top_hit top_count top_percent < <(
        sort -k3 -nr "$INPUT" | head -n1 | awk '{gsub("%","",$3); print $1, $2, $3}'
    )

    # Initialize min_diff to a high number
    min_diff=100

    if [[ ! " $TARGET " =~ " $top_hit " ]]; then
        # Top hit is NOT a canid
        for species in $TARGET; do
            species_percent=$(awk -v sp="$species" '$1==sp {gsub("%","",$3); print $3}' "$INPUT")
            if [[ -n "$species_percent" ]]; then
                diff=$(echo "$top_percent - $species_percent" | bc)
                diff=${diff#-}  # Absolute value
                if (( $(echo "$diff < $min_diff" | bc -l) )); then
                    min_diff=$diff
                fi
            fi
        done
    else
        # Top hit IS a canid
        while read species count percent; do
            percent=$(echo "$percent" | tr -d '%')
            if [[ ! " $TARGET " =~ " $species " ]]; then
                diff=$(echo "$top_percent - $percent" | bc)
                diff=${diff#-}  # Absolute value
                if (( $(echo "$diff < $min_diff" | bc -l) )); then
                    min_diff=$diff
                fi
            fi
        done < <(sort -k3 -nr "$INPUT")
    fi

    # Write sample, top hit, percentage difference, and top hit count
    printf "%s\t%s\t%.2f%%\t%s\n" "$SAMPLE" "$top_hit" "$min_diff" "$top_count" >> "$OUTPUT"
done
