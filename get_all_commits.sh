#!/bin/bash

# Fetch all branches and tags
git fetch --all
git fetch --all --tags

# Create or clear the output file
output_file="main_and_merged_commits.csv"
> $output_file

# Ensure we are on the main branch
git checkout main

# Get a list of branches merged into main
merged_branches=$(git branch --merged main | grep -v "main")

# Add header to CSV file
echo -e "Author\tDate\tCommit Hash\tCommit Message\tBranch" >> $output_file

# Function to append commits to CSV
append_commits_to_csv() {
    git log $1 --pretty=format:"%an\t%ad\t%H\t%s\t$1" --date=iso >> $output_file
 
}

# Append main branch commits to CSV
append_commits_to_csv main

# Append merged branches commits to CSV
for branch in $merged_branches; do
    append_commits_to_csv $branch
done

echo "CSV file with commits from main and merged branches has been created: $output_file"
