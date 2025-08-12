*** Settings ***
Library        RequestsLibrary
Library        Collections
Library        OperatingSystem
Resource    ../login/login_keyword_test.robot

*** Variables ***

${PRODUCTS_ENDPOINT}    /api/products/

*** Keywords ***
Fetch Products
    [Documentation]    Makes a GET request to the products endpoint
    ${token}=    Login And Get Token
    Create Session    prod    ${BASE_URL}
    ${headers}=    Create Dictionary    Authorization=Bearer ${token}
    ${response}=    GET On Session    prod    ${PRODUCTS_ENDPOINT}    headers=${headers}
    RETURN    ${response}

*** Test Cases ***
Get Products Should Return Valid Data
    [Documentation]    Verify products API returns valid product data
    ${response}=    Fetch Products
    Should Be Equal As Numbers    ${response.status_code}    200
    ${products}=    Set Variable    ${response.json()}
    Should Not Be Empty    ${products}
    
    # Verify first product structure
    ${first_product}=    Get From List    ${products}    0
    Dictionary Should Contain Key    ${first_product}    product_name
    Dictionary Should Contain Key    ${first_product}    product_id
    Should Not Be Empty    ${first_product}[product_name]
    
    
           
  

    