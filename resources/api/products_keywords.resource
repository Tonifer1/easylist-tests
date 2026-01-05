*** Settings ***
Library        OperatingSystem
Library        String
Library    RequestsLibrary
Resource    ../resources/api/auth_keywords.resource
Resource    ../resources/api/categories_keywords.resource

*** Variables ***
${PRODUCTS_ENDPOINT}    /api/products/

*** Keywords ***
# 1) READ
Fetch Products
    [Documentation]    Makes a GET request to the products endpoint
    Create Authenticated Session
    ${response}=    GET On Session    api_auth    ${PRODUCTS_ENDPOINT}    
    RETURN    ${response}

Get Product By Id
    [Arguments]    ${product_id}
    Create Authenticated Session
    ${response}=    GET On Session    api_auth    ${PRODUCTS_ENDPOINT}${product_id}/
    RETURN    ${response}

Get Products By Name
    Create Authenticated Session
    &{PARAMS}=    Create Dictionary    productname    A_Setup_Product
    ${response}=    GET On Session    api_auth    /api/products/    
    Should Be Equal As Strings    ${response.status_code}    200
    RETURN    ${response}

Get Products By Category
    [Arguments]    ${category_id}
    Create Authenticated Session
    ${response}=    GET On Session    api_auth    url=/api/products/    params=category=${category_id}
    Run Keyword And Continue On Failure    Should Be Equal As Integers    ${response.status_code}    200     
    ${json}=    Set Variable    ${response.json()}
    Should Not Be Empty    ${json}
    ${first_product}=    Get From List    ${json}    0
    Dictionary Should Contain Key    ${first_product}    product_name
    RETURN    ${json}




# 2) CREATE
Create Product With CategoryId
    [Arguments]    ${product_name}    ${category_id}   
    Create Authenticated Session

    ${payload}=    Create Dictionary    product_name=${product_name}    category=${category_id}
    # Creates payload: {"product_name": "Test-Product-1755701234",  "category": 27}
    ${response}=       POST On Session    api_auth    ${PRODUCTS_ENDPOINT}    json=${payload}
    Should Be Equal As Integers    ${response.status_code}    201
    ${json}=       Set Variable    ${response.json()}
    ${product_id}=        Get From Dictionary    ${json}    product_id    

    Log    ${product_id}        
    RETURN       ${product_id}

# 3) UPDATE
Patch Product Name   
    [Arguments]    ${product_id}    ${new_name}
    Create Authenticated Session    
    ${payload}=    Create Dictionary    product_name=${new_name}
    ${response}=       PATCH On Session    api_auth    ${PRODUCTS_ENDPOINT}${product_id}/    json=${payload}
    ${json}=       Set Variable    ${response.json()}
    ${product_name}=    Get From Dictionary    ${json}    product_name
    RETURN    ${product_name}

# 4) DELETE
Delete Product If Exists
    [Arguments]    ${product_id}
    Log    Checking product_id: ${product_id}
    IF    $product_id is not None
        Run Keyword And Ignore Error    DELETE On Session    api_auth    /api/products/${product_id}/    expected_status=any
    END 


Delete Product And Expect 404
    [Arguments]    ${product_id}
    DELETE On Session    api_auth    /api/products/${product_id}/    expected_status=404 

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

Teardown Multiple Products And Multiple Categories
    [Arguments]    ${product_id_a}    ${product_id_b}    ${category_id_a}    ${category_id_b}
    [Documentation]    Deletes products and categories if their IDs are available.
    Delete Product If Exists    ${product_id_a}
    Delete Product If Exists    ${product_id_b}
    Delete Category If Exists    ${category_id_a}
    Delete Category If Exists    ${category_id_b}

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

Verify Single Product Structure
    [Arguments]    ${response}
    Should Be Equal As Numbers    ${response.status_code}    200    
    ${product}=    Set Variable    ${response.json()}
    Should Not Be Empty    ${product}
    Dictionary Should Contain Key    ${product}    product_name
    Should Not Be Empty    ${product}[product_name]
    Dictionary Should Contain Key    ${product}    product_id
    Should Not Be String    ${product}[product_id]
Verify Unauthorized Response
    [Arguments]    ${response}
    Should Start With    ${response.headers}[Content-Type]    application/json
    Should Start With    ${response.headers}[WWW-Authenticate]    Bearer
    ${json}=    Set Variable    ${response.json()}
    Dictionary Should Contain Key    ${json}    detail
    Should Be Equal As Numbers    ${response.status_code}    401

Verify Products Are Filtered By Category
    [Arguments]    ${response}    ${expected_category_id}   
    Should Not Be Empty    ${response}
    FOR    ${product}    IN    @{response}
    Should Be Equal As Integers        ${product}[category]    ${expected_category_id}
    END 