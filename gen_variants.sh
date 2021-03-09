#!/bin/bash

set -e

tags=(default flexible) # ensure tags is sorted
src="user.js";

# Search for unexpected tags in the user.js file
found_tags=(`grep -Eo '^\s*user_pref.*<\w+>\s*$' "$src" | grep -Eo '<\w+>\s*' | grep -Eo '\w+' | sort -u`)
unexpected_tags=()
for tag1 in "${found_tags[@]}"; do
    expected=0
    for tag2 in "${tags[@]}"; do
        [[ "$tag1" == "$tag2" ]] && { expected=1; break; }
    done
    (( $expected )) || unexpected_tags+=("$tag1")
done

if (( ${#unexpected_tags[@]} )); then
    echo "Error: found unexpected tags in user.js: ${unexpected_tags[@]}"
    exit
fi

# Generate the tagged files
for tag in "${tags[@]}"; do
    dst="user_$tag.js";

    # generate the tagged user.js file
    (
        printf "/**************************************************************\n"
        printf " * %-58s *\n" "$dst"
        printf " *                                                            *\n"
        printf " * Automatically generated from user.js using gen_variants.sh *\n"
        printf " *                                                            *\n"
        printf " * Repo (fork): https://github.com/fernandokm/user.js         *\n"
        printf " * Upstream:    https://github.com/pyllyukko/user.js          *\n"
        printf " **************************************************************/\n\n"
        grep -P '^\s*user_pref.*([^>]|<'"$tag"'>)\s*$' "$src"
    ) > "$dst";

    echo "Created tagged file $dst";
done
