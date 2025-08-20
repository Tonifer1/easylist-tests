*** Settings ***
Library        OperatingSystem
Library        String
Resource       ../resources/auth_keywords.resource    # Bring Login And Get Token

*** Variables ***
${PRODUCTS_ENDPOINT}    /api/products/


*** Keywords ***
Fetch Products
    [Documentation]    Makes a GET request to the products endpoint
    ${token}=    Login And Get Token
    Create Session    prod    ${BASE_URL}
    ${headers}=    Create Dictionary    Authorization=Bearer ${token}
    Log    ${headers}
    ${response}=    GET On Session    prod    ${PRODUCTS_ENDPOINT}    headers=${headers}
    RETURN    ${response}

Ensure Products Session
    ${token}=    Login And Get Token
    Create Session    prod    ${BASE_URL}    headers={"Authorization":"Bearer ${token}","Content-Type":"application/json"}

Create Product With CategoryId
    [Arguments]    ${product_name}    ${category_id}
    Ensure Products Session
    ${payload}=    Create Dictionary    product_name=${product_name}    category=${category_id}
    ${resp}=       POST On Session    prod    ${PRODUCTS_ENDPOINT}    json=${payload}
    Should Be Equal As Integers    ${resp.status_code}    201
    ${body}=       Set Variable    ${resp.json()}
    ${pid}=        Get From Dictionary    ${body}    product_id
    Set Suite Variable    ${SUITE_PRODUCT_ID}    ${pid}
    RETURN       ${pid}