# `pre_git_commit` Function

The `pre_git_commit` function is a custom shell function defined in your `.zshrc` file. It ensures that linting and formatting scripts are automatically executed before committing changes to a Git repository. This helps maintain code quality and consistency across the project.

---

## How It Works

1. **Checks for `package.json`**:
   - The function first checks if a `package.json` file exists in the current directory.
   - If `package.json` is not found, it skips the linting and formatting steps and proceeds with the commit.

2. **Identifies Relevant Scripts**:
   - It uses `jq` to parse the `scripts` section of `package.json` and identifies scripts that:
     - Contain both `"lint"` and `"fix"` in their names (e.g., `lint:fix`, `lint-fix`).
     - Contain `"format:fix"` or `"stylelint-fix"` in their names.

3. **Runs the Scripts**:
   - If matching scripts are found, the function runs them using `npm run`.
   - Even if a script fails, the function continues execution to ensure the commit process is not blocked.

4. **Proceeds with the Commit**:
   - After running the scripts, the function allows the `git commit` command to execute.

---

## Usage

### **Automatic Execution**
The `pre_git_commit` function is automatically invoked whenever you use the `git-commit` alias:
```bash
git-commit -m "Your commit message"
```

---

## Dependencies:
Ensure `jq` is installed on your system. You can install it using Homebrew:
Usage:

Use git-commit instead of git commit to automatically run the scripts before committing.
