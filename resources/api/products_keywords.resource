*** Settings ***
Library        OperatingSystem
Library        String
Library    Telnet
Resource       ../resources/api/auth_keywords.resource

*** Variables ***
${PRODUCTS_ENDPOINT}    /api/products/

*** Keywords ***
Fetch Products
    [Documentation]    Makes a GET request to the products endpoint
    Create Authenticated Session
    ${response}=    GET On Session    api_auth    ${PRODUCTS_ENDPOINT}    
    RETURN    ${response}

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
    Should Be Equal As Numbers    ${response.status_code}    401 

Create Product With CategoryId
    [Arguments]    ${product_name}    ${category_id}   
    Create Authenticated Session

    ${payload}=    Create Dictionary    product_name=${product_name}    category=${category_id}
    # Creates payload: {"product_name": "Test-Product-1755701234",  "category": 27}
    ${response}=       POST On Session    api_auth    ${PRODUCTS_ENDPOINT}    json=${payload}
    Should Be Equal As Integers    ${response.status_code}    201
    ${body}=       Set Variable    ${response.json()}
    ${product_id}=        Get From Dictionary    ${body}    product_id    

    Log    ${product_id}        
    RETURN       ${product_id}

Patch Product Name   
    [Arguments]    ${product_id}    ${new_name}
    Create Authenticated Session
    
    ${payload}=    Create Dictionary    product_name=${new_name}
    ${response}=       PATCH On Session    api_auth    ${PRODUCTS_ENDPOINT}${product_id}/    json=${payload}
    ${body}=       Set Variable    ${response.json()}
    ${product_name}=    Get From Dictionary    ${body}    product_name
    RETURN    ${product_name}        

Teardown Product And Category
    [Arguments]    ${product_id}    ${category_id}
    [Documentation]    Deletes product and category if their IDs are available.
    Delete Product If Exists    ${product_id}
    Delete Category If Exists    ${category_id}

Teardown Multiple Products And Category
    [Arguments]    ${category_id}    @{product_ids}    
    FOR    ${product_id}    IN    @{product_ids}
        Run Keyword If    '${product_id}' != 'None'
        ...    Run Keywords
        ...    Log    Deleting product: ${product_id}
        ...    AND
        ...    DELETE On Session    api_auth    /api/products/${product_id}/    expected_status=any
    END
    Delete Category If Exists    ${category_id}


Delete Product If Exists
    [Arguments]    ${product_id}
    Log    Checking product_id: ${product_id}
    Run Keyword If    '${product_id}' != 'None'
    ...    DELETE On Session    api_auth    /api/products/${product_id}/    expected_status=any

Delete Category If Exists
    [Arguments]    ${category_id}
    Run Keyword If    '${category_id}' != 'None'
    ...    DELETE On Session    api_auth    /api/categories/${category_id}/    expected_status=any
      

Get Product By Id
    [Arguments]    ${product_id}
    Create Authenticated Session
    ${resp}=    GET On Session    api_auth    /api/products/${product_id}/
    RETURN    ${resp}
    #
Get Products By Category
    [Arguments]    ${category_id}
    Create Authenticated Session
    ${response}=    GET On Session    api_auth    url=/api/products/    params=category=${category_id}
    Run Keyword And Continue On Failure    Should Be Equal As Integers    ${response.status_code}    200
    Should Be Equal As Integers    ${response.status_code}    200      
    ${json}=    Set Variable    ${response.json()}
    Should Not Be Empty    ${json}
    ${first_product}=    Get From List    ${json}    0
    Dictionary Should Contain Key    ${first_product}    product_name
    Should Be Equal As Integers    ${first_product['category']}    ${category_id}
    Log To Console    ${category_id}
    Log To Console    Response status: ${response.status_code}





