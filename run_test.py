from dotenv import load_dotenv
from robot import run

# Lataa .env-tiedoston ympäristömuuttujat
load_dotenv()

# Aja Robot Framework -testit
run("tests", outputdir="results")