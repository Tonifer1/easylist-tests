*** Settings ***
Library    Browser

*** Keywords ***
Open Products Page
    Click    text=Tuotteet

Open Products Link Should Be Visible
    Wait For Elements State    text=Näytä Tuotteet    visible    7s

