*** Settings ***
Documentation    API tests for category management in EasyList
Library        RequestsLibrary
Library        Collections
Resource    ../resources/api/auth_keywords.resource
Resource    ../resources/api/categories_keywords.resource
Resource    ../../resources/api/products_keywords.resource

*** Variables ***

# === TARGET STRUCTURE FOR CATEGORIES TESTS ===

# 1) READ
*** Test Cases ***
Get Categories Should Return Valid Data
    [Documentation]    Verify categories API returns valid data
    [Tags]    api    categories    reads    smoke
    ${category_id}=    Create Category And Save Id    Read_Setup_Category
    ${response}=    Fetch Categories
    Verify Category Structure In Response    ${response}
    [Teardown]    Delete Category If Exists    ${category_id}    
    Log    ${response.content}

# 2) CREATE
Create Category
    [Teardown]    Delete Category If Exists    ${category_id}    
    [Documentation]    Create category and delete it
    [Tags]    api    categories    create    smoke
    Set Test Variable    ${category_id}    ${None}
    VAR    ${category_name}    cat_test_create
    ${category_id}=    Create Category And Save Id    ${category_name}
    Log    Created: category id=${category_id}, category name=${category_name}

# 3) UPDATE
Patch Category Name
    [Teardown]    Delete Category If Exists    ${category_id}
    [Documentation]    Create category, update and delete it.
    [Tags]    api    categories    update    smoke
    Set Test Variable    ${category_id}    ${None}
    VAR    ${category_name}      cat_test_update
    ${category_id}=    Create Category And Save Id    ${category_name}
    VAR    ${new_name}    patch_cat_test_update
    ${patch_resp}=    Patch Category Name    ${category_id}    ${new_name}

    Log    Created: new category name=${new_name}
    Log    ${category_name}

# 4) DELETE
Delete Existing Category Should Succeed
    [Documentation]    Create temporary category and delete it
    [Tags]    api    categories    delete    smoke
    Set Test Variable    ${category_id}    ${None}
    VAR    ${category_name}      cat_test_delete
    ${category_id}=    Create Category And Save Id    ${category_name}
    ${response}=    Delete Category By Id    ${category_id}

    Log    ${response.status_code}

Delete Category Twice Should Return 404
    [Documentation]    Create temporary category and try delete it twice
    [Tags]    api    categories    error    twice    smoke
    Set Test Variable    ${category_id}    ${None}
    VAR    ${category_name}      cat_test_delete_twice
    ${category_id}=    Create Category And Save Id    ${category_name}
    ${response}=    Delete Category By Id    ${category_id}
    ${response2}=    Delete Category Twice By Id    ${category_id}

Delete Category Without Token Should Return 401
    [Documentation]    Try to delete Category without Login and Token
    [Tags]    api    categories    error    no_token    smoke
    Set Test Variable    ${category_id}    ${None}
    VAR    ${category_name}      cat_test_delete_no_token2
    ${category_id}=    Create Category And Save Id    ${category_name}
    ${response}=    Delete Category without token    ${category_id}
    Verify Unauthorized Response    ${response} 

No Token 
    [Documentation]    Try to Get Categories without Login and Token
    [Tags]    api    categories    read    error    smoke
    Create Session    api_auth_no_token    ${BASE_URL}
    ${response}=    GET On Session    api_auth_no_token    ${CATEGORIES_ENDPOINT}    expected_status=401
    Verify Unauthorized Response    ${response}      