#!/bin/bash

# Run tests on Chrome
echo "Running tests on Chrome..."
robot --variable BROWSER:chrome tests/e2e/first_test.robot


# Run tests on Firefox
echo "Running tests on Firefox..."
robot --variable BROWSER:firefox tests/e2e/first_test.robot




echo "Test run complete."