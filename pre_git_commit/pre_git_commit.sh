pre_git_commit() {
    # Check for package.json file exists in the current directory
    if [[ -f package.json ]]; then
        echo -e "${YELLOW}Detected package.json in the current directory.${RESET}"

        # Extract scripts from package.json
        # Finds scripts with names matching "lint.*fix" (e.g., lint:fix, lint-fix)
        lint_fix_scripts=$(jq -r '.scripts | to_entries[] | select(.key | test("lint.*fix")) | .key' package.json)

        # Finds scripts with names matching "format.*fix" or "stylelint.*fix" (e.g., format:fix, stylelint-fix)
        format_fix_scripts=$(jq -r '.scripts | to_entries[] | select(.key | test("format.*fix|stylelint.*fix")) | .key' package.json)

        # Run lint fix scripts
        if [[ -n "$lint_fix_scripts" ]]; then
            echo -e "${GREEN}Running lint fix scripts...${RESET}"
            for script in $lint_fix_scripts; do
                echo -e "${LIGHT_BLUE}Running: npm run $script${RESET}"
                npm run "$script" || true # Error Handling: Continue even if the script fails
            done
        fi

        # Run format fix scripts
        if [[ -n "$format_fix_scripts" ]]; then
            echo -e "${GREEN}Running format fix scripts...${RESET}"
            for script in $format_fix_scripts; do
                echo -e "${LIGHT_BLUE}Running: npm run $script${RESET}"
                npm run "$script" || true # Error Handling: Continue even if the script fails
            done
        fi
    else
        echo -e "${RED}No package.json found in the current directory.${RESET}"
    fi
}

# Alias git commit to include the pre_git_commit function
alias git-commit='pre_git_commit && git commit'
