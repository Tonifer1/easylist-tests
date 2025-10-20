from dotenv import load_dotenv
from robot import run
import os

# Lataa .env-tiedoston ympäristömuuttujat
load_dotenv()

# Määritellään testit, jotka ajetaan
# tests_to_run = ["tests/e2e"]
tests_to_run = ["tests/api" , "tests/login"]
#tests_to_run = ["tests/api", "tests/login", "tests/e2e"]


# Luo results-kansio, jos se ei ole olemassa
results_dir = "results"
os.makedirs(results_dir, exist_ok=True)

# Määrittele geckodriverin lokitiedoston polku
geckodriver_log_path = os.path.join(results_dir, "geckodriver.log")

browser = os.getenv("BROWSER", "firefox")

# Aja Robot Framework -testit kahdella selaimella
for browser in ["firefox"]:
    print(f"\n=== Running tests on {browser.upper()} ===\n")
    run(
        *tests_to_run,
        outputdir=os.path.join(results_dir, browser),
        variable=[f"BROWSER:{browser}", f"webdriver.firefox.logfile:{geckodriver_log_path}"]
    )

print("\n=== Running tests on CHROME ===\n")
# run(
#     *tests_to_run,
#     outputdir=os.path.join(results_dir, "chrome"),
#     variable=[
#         f"BROWSER:chrome", 
#         f"webdriver.firefox.logfile:{geckodriver_log_path}",
#         f"API_USERNAME:{os.getenv('API_USERNAME')}",
#         f"API_PASSWORD:{os.getenv('API_PASSWORD')}"],
#     exclude=["ignore"]
# )
