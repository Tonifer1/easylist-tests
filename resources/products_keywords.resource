*** Settings ***
Library        OperatingSystem
Library        String
Resource       ../resources/auth_keywords.resource    # Bring Login And Get Token

*** Variables ***
${PRODUCTS_ENDPOINT}    /api/products/


*** Keywords ***
Fetch Products
    [Documentation]    Makes a GET request to the products endpoint
    Create Authenticated Session
    ${response}=    GET On Session    api_auth    ${PRODUCTS_ENDPOINT}    
    RETURN    ${response}

*** Keywords ***
Verify Product Structure In Response
    [Arguments]    ${response}
    Should Be Equal As Numbers    ${response.status_code}    200    
    ${products}=    Set Variable    ${response.json()}
    Should Not Be Empty    ${products}
    ${first_product}=    Get From List    ${products}    0
    Dictionary Should Contain Key    ${first_product}    product_name
    Should Not Be Empty    ${first_product}[product_name]
    Dictionary Should Contain Key    ${first_product}    product_id
    Should Not Be String    ${first_product}[product_id] 



Verify Unauthorized Response
    [Arguments]    ${response}
    Should Start With    ${response.headers}[Content-Type]    application/json
    Should Start With    ${response.headers}[WWW-Authenticate]    Bearer
    ${body}=    Set Variable    ${response.json()}
    Dictionary Should Contain Key    ${body}    detail




Create Product With CategoryId
    [Arguments]    ${product_name}    ${category_id}    #15. Ottaa vastaan arvot esim. Test-Product-1755701234 ja 27 
    Create Authenticated Session

    ${payload}=    Create Dictionary    product_name=${product_name}    category=${category_id}
    # 16. Rakentaa payloadin: {"product_name": "Test-Product-1755701234",  "category": 27}

    ${response}=       POST On Session    api_auth    ${PRODUCTS_ENDPOINT}    json=${payload}
    Should Be Equal As Integers    ${response.status_code}    201
    ${body}=       Set Variable    ${response.json()}
    ${product_id}=        Get From Dictionary    ${body}    product_id    #17. Poimii product_id = esim. 175
    Set Suite Variable    ${SUITE_PRODUCT_ID}    ${product_id}    #18.Tallentaa myös common_teardown.resourceen.  ${SUITE_PRODUCT_ID} = 175
    Log    ${SUITE_PRODUCT_ID}        
    RETURN       ${product_id}    #19. Palauttaa arvon testille ${product_id} = 175

Get Product By Id
    [Arguments]    ${product_id}
    Create Authenticated Session
    ${response}=    GET On Session    api_auth    /api/products/${product_id}/
    RETURN     ${response}
