*** Settings ***
Library          RequestsLibrary
Library          Collections
Library         OperatingSystem
Library    String
Resource   ../resources/api/auth_keywords.resource

*** Variables ***

${CATEGORIES_ENDPOINT}    /api/categories/

*** Keywords ***
# 1) READ
Fetch Categories
    [Documentation]    Makes a GET request to the categories endpoint
    Create Authenticated Session
    ${response}=    GET On Session    api_auth    ${CATEGORIES_ENDPOINT}
    RETURN    ${response}

# 2) CREATE
Create Category And Save Id
    [Arguments]    ${category_name}    # Here comes created value from products_test.robot {categoryname}: cat_name1755701234
    Create Authenticated Session
    ${payload}=    Create Dictionary    category_name=${category_name}    #7.Builds payload: {"category_name": "cat_name1755701234"}.
    ${response}=       POST On Session    api_auth    ${CATEGORIES_ENDPOINT}    json=${payload}    # Sends POST /api/categories/
    Should Be Equal As Integers    ${response.status_code}    201    #Response:{"category_id": 27, "category_name": "cat_name1755701234"} 
    ${body}=       Set Variable    ${response.json()}
    ${category_id}=         Get From Dictionary    ${body}    category_id    # Pick created category_id = for example 27   
    RETURN       ${category_id}    #Return value example ${category_id}=27  to --> products_test.robot

# 3) UPDATE

Patch Category Name
    [Arguments]    ${category_id}    ${new_name}
    Create Authenticated Session
    ${payload}=    Create Dictionary    category_name=${new_name}
    ${response}=    PATCH On Session    api_auth    ${CATEGORIES_ENDPOINT}${category_id}/    json=${payload}
    ${body}=    Set Variable    ${response.json()}
    ${category_name}=    Get From Dictionary    ${body}    category_name
    RETURN    ${category_name}

# 4) DELETE
Delete Category By Id
    [Arguments]    ${category_id}
    Create Authenticated Session
    ${response}=    DELETE On Session    api_auth    /api/categories/${category_id}/
    Should Be Equal As Integers    ${response.status_code}    204
    RETURN    ${response}

Delete Category without token
    [Arguments]    ${category_id}
    Create Session    api_auth_no_token    ${BASE_URL}       
    ${response}=    DELETE On Session    api_auth_no_token    /api/categories/${category_id}/    expected_status=any
    Delete Category If Exists    ${category_id}
    RETURN    ${response}

Delete Category Twice By Id
    [Arguments]    ${category_id}
    Create Authenticated Session
    ${response}=    DELETE On Session    api_auth    /api/categories/${category_id}/    expected_status=any
    Should Be Equal As Integers    ${response.status_code}    404
    RETURN    ${response}

Delete Category If Exists
    [Arguments]    ${category_id}
    Run Keyword If    '${category_id}' != 'None'
    ...    DELETE On Session    api_auth    /api/categories/${category_id}/    expected_status=any

Verify Category Structure In Response
    [Arguments]    ${response}
    Should Be Equal As Numbers    ${response.status_code}    200    
    ${categories}=    Set Variable    ${response.json()}
    Should Not Be Empty    ${categories}
    ${first_category}=    Get From List    ${categories}    0
    Dictionary Should Contain Key    ${first_category}    category_id
    Dictionary Should Contain Key    ${first_category}    category_name
    Should Not Be Empty    ${first_category}[category_name]
    Should Not Be String    ${first_category}[category_id]