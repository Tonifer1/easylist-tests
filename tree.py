import os
import sys

def print_tree(startpath, prefix=''):
    for item in os.listdir(startpath):
        # Ohitetaan tietyt kansiot
        if item in ['.venv', '__pycache__', '.git']:
            continue
        # Ohitetaan tietyt tiedostot
        if (
            ('selenium-screenshot' in item and item.endswith('.png'))
            or ('geckodriver' in item and item.endswith('.log'))
        ):
            continue
        path = os.path.join(startpath, item)
        if os.path.isdir(path):
            if item == 'documents':
                continue  # Ohitetaan documents-kansio ja sen sisältö
            print(prefix + '├── ' + item + '/')
            print_tree(path, prefix + '│   ')
        else:
            print(prefix + '├── ' + item)

if __name__ == "__main__":
    print_tree('.')