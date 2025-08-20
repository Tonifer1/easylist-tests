*** Settings ***
Library        RequestsLibrary
Library        Collections
Resource    ../resources/auth_keywords.resource
Resource    ../../resources/products_keywords.resource
Resource    ../../resources/categories_keywords.resource
Resource    ../../resources/common_teardown.resource
Suite Setup      Init Test IDs
Suite Teardown   Teardown Product And Category


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



POST Chain: Category → Product
    ${epoch}=          Get Time    epoch
    ${cat_name}=       Set Variable    cat_name${epoch}
    ${category_id}=    Create Category And Save Id    ${cat_name}

    ${prod_name}=      Set Variable    Test-Product-${epoch}
    ${product_id}=     Create Product With CategoryId    ${prod_name}    ${category_id}

    Log    Created: category id=${category_id}, product id=${product_id} 