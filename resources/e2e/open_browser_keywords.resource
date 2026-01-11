*** Settings ***
Library    Browser

*** Keywords ***
Open My Browser
    New Browser    chromium    headless=True
    New Context
    New Page    http://localhost:4173/
    Wait For Elements State    h1.text-2xl >> text="EasyList"    visible    5s
    Wait For Elements State    text="Tervetuloa EasyList-sovellukseen"    visible    5s

Close My Browser
    Close Browser
