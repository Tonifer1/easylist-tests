*** Settings ***
Library        RequestsLibrary
Library        Collections
Resource    ../resources/auth_keywords.resource
Resource    ../../resources/products_keywords.resource
Resource    ../../resources/categories_keywords.resource
  

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
    
    # Creates Temporary Product and Category
    ${epoch}=    Get Time    epoch
    ${category_name}=    Set Variable    cat_name${epoch}
    ${category_id}=    Create Category And Save Id    ${category_name}

    ${product_name}=    Set Variable    Test-Product-${epoch}
    ${product_id}=    Create Product With CategoryId    ${product_name}    ${category_id}
    Log    Created: category id=${category_id}, product id=${product_id}
    [Teardown]    Teardown Product And Category    ${product_id}    ${category_id}

#PATCH Product 

    # ${epoch}=          Get Time    epoch    #3. Robot hakee järjestelmän ajan sekunteina (epoch).  

    # ${category_name}=       Set Variable    cat_name${epoch}    #4. ${category_name} = cat_name1755701234  Done
    # ${category_id}=    Create Category And Save Id    ${category_name}    #5. --> categories_keywords.resource."Tilataan" category_id funktiolta.                                                                          # Saadaan vastaus: 27
    # ${product_name}=      Set Variable    Test-Product-${epoch}    #13. Muodostuu esim. Test-Product-1755701234. Tallentuu = ${product_name} 
    # ${product_id}=     Create Product With Local CategoryId    ${product_name}    ${category_id}    #14. --> products_keywords.resource saa argumentit
    # ${new_name}=       Set Variable    Test-Product-UPDATED-${epoch}
    # ${patch_resp}=     Patch Product Name    ${product_id}    ${new_name}
    # Delete Product By Id    ${product_id}
    # Delete Category By Id    ${category_id}    

    # Log    Created: category id=${category_id}, product id=${product_id}
    # Log     ${epoch}  



   



  