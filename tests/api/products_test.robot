*** Settings ***
Library        RequestsLibrary
Library        Collections
Library        OperatingSystem
Library    String
Resource    ../login/login_keyword_test.robot
Suite Setup      Init Test IDs
Suite Teardown   Teardown Product And Category


*** Variables ***

${PRODUCTS_ENDPOINT}    /api/products/
${CATEGORIES_ENDPOINT}    /api/categories/

*** Keywords ***
Fetch Products
    [Documentation]    Makes a GET request to the products endpoint
    ${token}=    Login And Get Token
    Create Session    prod    ${BASE_URL}
    ${headers}=    Create Dictionary    Authorization=Bearer ${token}
    Log    ${headers}
    ${response}=    GET On Session    prod    ${PRODUCTS_ENDPOINT}    headers=${headers}
    RETURN    ${response}

Init Test IDs
    [Documentation]    Nollaa id:t turvallista siivousta varten
    Set Suite Variable    ${SUITE_PRODUCT_ID}     ${None}
    Set Suite Variable    ${SUITE_CATEGORY_ID}    ${None}

Delete Product If Exists
    Run Keyword If    '${SUITE_PRODUCT_ID}' != 'None'
    ...    DELETE On Session    prod    /api/products/${SUITE_PRODUCT_ID}

Delete Category If Exists
    Run Keyword If    '${SUITE_CATEGORY_ID}' != 'None'
    ...    DELETE On Session    prod    /api/categories/${SUITE_CATEGORY_ID}

Teardown Product And Category
    [Documentation]    Poista ensin tuote, sitten kategoria (FK-riippuvuus)
    Delete Product If Exists
    Delete Category If Exists



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
    Should Not Be Empty    ${first_product}[product_name]

    Dictionary Should Contain Key    ${first_product}    product_id
    Should Not Be String    ${first_product}[product_id] 

No Token 
    [Documentation]    Try To Get Products without Login and Token
    Create Session    prod    ${BASE_URL}
    ${response}=    GET On Session    prod    ${PRODUCTS_ENDPOINT}    expected_status=401
    
    # Content-Type on JSON
    ${ct}=    Get From Dictionary    ${response.headers}    Content-Type
    Should Start With    ${ct}    application/json
    ${wa}=    Get From Dictionary    ${response.headers}    WWW-Authenticate    
    Should Start With    ${wa}    Bearer

     # Error Body, No Product
    ${body}=    Set Variable    ${response.json()}
    Dictionary Should Contain Key    ${body}    detail

  
    ${keys}=    Get Dictionary Keys    ${body}
    List Should Not Contain Value     ${keys}    id
    List Should Not Contain Value     ${keys}    name


    
    
  
   
    
    
    
           
  

    