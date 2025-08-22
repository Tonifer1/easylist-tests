*** Settings ***
Library        OperatingSystem
Library        RequestsLibrary
Library        Collections

*** Keywords ***
Init Test IDs    #2. Suite Setup
    [Documentation]    Reset IDs safely
    Set Suite Variable    ${SUITE_PRODUCT_ID}     ${None}
    Set Suite Variable    ${SUITE_CATEGORY_ID}    ${None}
    Log    ${SUITE_PRODUCT_ID}
    Log    ${SUITE_CATEGORY_ID}   


Teardown Product And Category  # Suite Teardown
    [Documentation]    Delete the product first, then the category (FK-dependence)
    Delete Product If Exists
    Delete Category If Exists
Delete Product If Exists
    Run Keyword If    '${SUITE_PRODUCT_ID}' != 'None'
    ...    DELETE On Session    api_auth    /api/products/${SUITE_PRODUCT_ID}/

Delete Category If Exists
    Run Keyword If    '${SUITE_CATEGORY_ID}' != 'None'
    ...    DELETE On Session    api_auth    /api/categories/${SUITE_CATEGORY_ID}/
