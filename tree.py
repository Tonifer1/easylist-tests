import os
import sys

def print_tree(startpath, prefix=''):
    for item in os.listdir(startpath):
        if item in ['.venv', '__pycache__', '.git']:  # Ohitetaan tietyt kansiot
            continue
        
        path = os.path.join(startpath, item)
        if os.path.isdir(path):
            print(prefix + '├── ' + item + '/')
            print_tree(path, prefix + '│   ')
        else:
            print(prefix + '├── ' + item)

if __name__ == "__main__":
    print_tree('.')