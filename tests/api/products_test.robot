*** Settings ***
Documentation    API tests for product management in EasyList.
...              Verify product creation, retrieval, deletion and multi-product category handling.
Library        RequestsLibrary
Library        Collections
Resource    ../resources/api/auth_keywords.resource
Resource    ../resources/api/products_keywords.resource
Resource    ../resources/api/categories_keywords.resource
  

*** Test Cases ***

# === TARGET STRUCTURE FOR PRODUCTS TESTS ===

# 1) READ
Get Products Should Return Valid Data
    [Documentation]    Verify products API returns valid product data
    [Tags]    api    products    read    smoke
    ${category_id}=    Create Category And Save Id    Read_Setup_Category
    ${product_id}=    Create Product With CategoryId    Read_Setup_Product    ${category_id}
    [Teardown]    Teardown Product And Category    ${product_id}    ${category_id}
    ${response}=    Fetch Products
    Verify Product Structure In Response    ${response}

Fetch Products By Name
    [Documentation]    Verify products by name
    [Tags]    api    products    read    smoke    quick
    ${category_id}=    Create Category And Save Id    Name_Category
    ${product_id}=    Create Product With CategoryId    By_Name_Product    ${category_id}
    [Teardown]    Teardown Product And Category    ${product_id}    ${category_id}
    ${response}=    Get Products By Name
    Verify Product Structure In Response    ${response}

Fetch Products By Id
    [Documentation]    Verify products by id
    [Tags]    api    products    read    smoke    quick    id
    ${category_id}=    Create Category And Save Id    Id_Category
    ${product_id}=    Create Product With CategoryId    By_Id_Product    ${category_id}
    [Teardown]    Teardown Product And Category    ${product_id}    ${category_id}
    ${response}=    Get Product By Id    ${product_id}
    Should Be Equal As Integers        ${category_id}    ${category_id}
    Verify Single Product Structure    ${response}

# 2) CREATE   
Create Category and Product
    [Documentation]    Creates a temporary category and product and then deletes them.
    [Tags]    api    products    create    smoke
    Set Test Variable    ${product_id}    ${None}
    Set Test Variable    ${category_id}   ${None}
    [Teardown]    Teardown Product And Category    ${product_id}    ${category_id}

    ${epoch}=    Get Time    epoch
    ${category_name}=    Set Variable    cat_name${epoch}
    ${category_id}=    Create Category And Save Id    ${category_name}
    ${product_name}=    Set Variable    Test-Product-${epoch}
    ${product_id}=    Create Product With CategoryId    ${product_name}    ${category_id}
    Log    Created: category id=${category_id}, product id=${product_id}

# 3) UPDATE
PATCH Product 
    [Documentation]    Creates a temporary category and product, Updates the Product name and then deletes them.
    [Tags]    api    products    patch    smoke 
    Set Test Variable    ${product_id}    ${None}
    Set Test Variable    ${category_id}   ${None}   
    [Teardown]    Teardown Product And Category    ${product_id}    ${category_id}

    ${category_name}=       Set Variable    dummycat    
    ${category_id}=    Create Category And Save Id    ${category_name}                                                                                      
    ${product_name}=      Set Variable    Test-Patch-Product    
    ${product_id}=     Create Product With CategoryId    ${product_name}    ${category_id}
    ${new_name}=       Set Variable    Test-Patch-Product-UPDATED
    ${patch_resp}=     Patch Product Name    ${product_id}    ${new_name}
   
    Log    Created: new name=${new_name}

# 4) DELETE


# 5) EXTRA TESTS (AFTER CRUD)

No Token 
    [Documentation]     Try To Get Products without Login and Token
    [Tags]    api    auth    security    error
    Create Session    api_auth_no_token    ${BASE_URL}
    ${response}=    GET On Session    api_auth_no_token    ${PRODUCTS_ENDPOINT}    expected_status=401
    Verify Unauthorized Response    ${response}
    
Create And Verify Multiple Products In Category
    [Documentation]    Creates a temporary products and category. Get products by category ID.
    [Tags]    api    products    multi    cleanup    regression
    Set Test Variable    ${category_id}   ${None}
    Set Test Variable    @{product_ids}   @{EMPTY}
    [Teardown]    Teardown Multiple Products And Category    ${category_id}    @{product_ids}

    ${category_name}    Set Variable    multi-temp-cat
    ${category_id}    Create Category And Save Id    ${category_name}
    ${product_id}=    Create Product With CategoryId    Test-Multi-Product-1    ${category_id}
    Append To List    ${product_ids}    ${product_id}
    ${product_id2}=    Create Product With CategoryId    Test-Multi-Product-2    ${category_id}
    Append To List    ${product_ids}    ${product_id2}
    ${products}=    Get Products By Category    ${category_id}
    Log    ${products}
    Length Should Be    ${products}    2

    FOR    ${product}    IN    @{products}
        Should Be Equal As Integers        ${product}[category]    ${category_id}      
    END

    Log    Created: category name=${category_name}, product name=${product_id}, product name2=${product_id2}
    Log To Console    Test completed. Cleaning up product=${product_id}, category=${category_id}