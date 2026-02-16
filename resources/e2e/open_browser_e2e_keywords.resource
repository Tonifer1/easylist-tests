*** Settings ***
Library    Browser

*** Variables ***
${BASE_URL}    http://localhost:5173/
${BROWSER}    chromium

*** Keywords ***
Open My Browser
    Log To Console    Browser: ${BROWSER}
    New Browser    ${BROWSER}    headless=True
    New Context
    New Page    ${BASE_URL}

Close My Browser
    Close Browser