import os
import sys
import shutil
from dotenv import load_dotenv
from robot import run

def execute_tests():
    # 1. Load environment variables
    load_dotenv()

    # 2. Define paths
    results_dir = "results"
    tests_to_run = ["tests/api", "tests/e2e"]

    # 3. Clean old results
    if os.path.exists(results_dir):
        print(f"Cleaning old results from '{results_dir}'...")
        shutil.rmtree(results_dir)

    os.makedirs(results_dir)

    # 4. Handle --include tag
    include_tag = None
    if len(sys.argv) > 1 and sys.argv[1] == "--include":
        include_tag = sys.argv[2] if len(sys.argv) > 2 else None

    # 5. Robot arguments (Browser library only)
    run_args = {
        "outputdir": results_dir,
        "variable": [f"BROWSER:{os.getenv('BROWSER', 'chromium')}"],
        "loglevel": "INFO"
    }

    if include_tag:
        run_args["include"] = include_tag
        print(f"Filtering tests by tag: {include_tag}")

    print("\n=== Starting Robot Framework tests ===\n")

    run(*tests_to_run, **run_args)

    print(f"\n=== Run complete. Results are in '{results_dir}' ===\n")

if __name__ == "__main__":
    execute_tests()
