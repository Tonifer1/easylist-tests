*** Settings ***
Library        RequestsLibrary
Library        Collections
Resource    ../resources/api/auth_keywords.resource
Resource    ../../resources/api/products_keywords.resource
Resource    ../../resources/api/categories_keywords.resource
  

*** Test Cases ***
Get Products Should Return Valid Data
    [Documentation]    Verify products API returns valid product data
    ${response}=    Fetch Products
    Verify Product Structure In Response    ${response}
    
No Token 
    [Documentation]     Try To Get Products without Login and Token
    Create Session    api_auth    ${BASE_URL}
    ${response}=    GET On Session    api_auth    ${PRODUCTS_ENDPOINT}    expected_status=401
    Verify Unauthorized Response    ${response}

POST Chain: Category → Product 
    [Documentation]    Creates a temporary product and category and then deletes them.
    Set Test Variable    ${product_id}    ${None}
    Set Test Variable    ${category_id}   ${None}
    [Teardown]    Teardown Product And Category    ${product_id}    ${category_id}

    ${epoch}=    Get Time    epoch
    ${category_name}=    Set Variable    cat_name${epoch}
    ${category_id}=    Create Category And Save Id    ${category_name}
    ${product_name}=    Set Variable    Test-Product-${epoch}
    ${product_id}=    Create Product With CategoryId    ${product_name}    ${category_id}
    Log    Created: category id=${category_id}, product id=${product_id}

PATCH Product 

    [Documentation]    Creates a temporary product and category, Updates the Product name and then deletes them.
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
    
Create And Verify Multiple Products In Category
    [Documentation]    Creates a temporary products and category.Get products by category ID.
    Set Test Variable    ${category_id}   ${None}
    Set Test Variable    @{product_ids}   @{EMPTY}

    [Teardown]    Teardown Multiple Products And Category    ${category_id}    @{product_ids}
    ${category_name}    Set Variable    multi-temp-cat
    ${category_id}    Create Category And Save Id    ${category_name}
    ${product_id}=    Create Product With CategoryId    Test-Multi-Product-1    ${category_id}
    Append To List    ${product_ids}    ${product_id}
    ${product_id2}=    Create Product With CategoryId    Test-Multi-Product-2    ${category_id}
    Append To List    ${product_ids}    ${product_id2}
    

    Get Products By Category    ${category_id}
    Log    Created: category name=${category_name}, product name=${product_id}, product name2=${product_id2}
    Log To Console    Test completed. Cleaning up product=${product_id}, category=${category_id}
        
 
     



   



  