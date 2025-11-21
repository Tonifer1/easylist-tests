from dotenv import load_dotenv
from robot import run
import os
import sys
# Lataa .env-tiedoston ympäristömuuttujat
load_dotenv()

 
#Lue komentoriviparametrit (esim. --include api)
include_tag = None
if len(sys.argv) > 1 and sys.argv[1] == "--include":
    include_tag = sys.argv[2] if len(sys.argv) > 2 else None


# Määritellään testit, jotka ajetaan
#tests_to_run = ["tests/api" ]
#tests_to_run = ["tests/e2e"]
tests_to_run = ["tests/api","tests/e2e"]


# Luo results-kansio, jos se ei ole olemassa
results_dir = "results"
os.makedirs(results_dir, exist_ok=True)

# Määrittele geckodriverin lokitiedoston polku
geckodriver_log_path = os.path.join(results_dir, "geckodriver.log")

browser = os.getenv("BROWSER", "firefox")

# Aja testit (esim. vain tietyllä tagilla)
for browser in ["firefox"]:
    print(f"\n=== Running tests on {browser.upper()} ===\n")

run_args = dict(
        outputdir=os.path.join(results_dir, browser),
        variable=[f"BROWSER:{browser}", f"webdriver.firefox.logfile:{geckodriver_log_path}"],
    )

    # Lisää tagisuodatus vain jos annettu
if include_tag:
        run_args["include"] = include_tag

run(*tests_to_run, **run_args)


