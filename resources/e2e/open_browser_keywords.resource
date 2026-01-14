*** Settings ***
Library    Browser

*** Keywords ***
Open My Browser
    New Browser    chromium    headless=True
    New Context
    New Page    http://localhost:4173/


Close My Browser
    Close Browser