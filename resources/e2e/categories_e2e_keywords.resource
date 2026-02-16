*** Settings ***
Library    Browser

*** Keywords ***
Open Categories Page
    Click    text=Kategoriat

Open Categories Link Should Be Visible
    Wait For Elements State    text=Näytä Kategoriat    visible    7s

Create New Category
     Click    text=Lisää uusi Kategoria
     Wait For Elements State    text=Lisää uusi kategoria    visible    7s