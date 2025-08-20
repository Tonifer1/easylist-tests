*** Settings ***
Library        OperatingSystem
Library        RequestsLibrary
Library        Collections
*** Keywords ***
Init Test IDs
    [Documentation]    Nollaa id:t turvallista siivousta varten
    Set Suite Variable    ${SUITE_PRODUCT_ID}     ${None}
    Set Suite Variable    ${SUITE_CATEGORY_ID}    ${None}

Delete Product If Exists
    Run Keyword If    '${SUITE_PRODUCT_ID}' != 'None'
    ...    DELETE On Session    prod    /api/products/${SUITE_PRODUCT_ID}/

Delete Category If Exists
    Run Keyword If    '${SUITE_CATEGORY_ID}' != 'None'
    ...    DELETE On Session    prod    /api/categories/${SUITE_CATEGORY_ID}/

Teardown Product And Category
    [Documentation]    Poista ensin tuote, sitten kategoria (FK-riippuvuus)
    Delete Product If Exists
    Delete Category If Exists