*** Settings ***
Library          RequestsLibrary
Library          Collections
Library         OperatingSystem
Resource   ../resources/api/auth_keywords.resource

*** Variables ***

${CATEGORIES_ENDPOINT}    /api/categories/

*** Keywords ***


Create Category And Save Id
    [Arguments]    ${category_name}    # Here comes created value from products_test.robot {categoryname}: cat_name1755701234
    Create Authenticated Session
    ${payload}=    Create Dictionary    category_name=${category_name}    #7.Builds payload: {"category_name": "cat_name1755701234"}.
    ${response}=       POST On Session    api_auth    ${CATEGORIES_ENDPOINT}    json=${payload}    # Sends POST /api/categories/
    Should Be Equal As Integers    ${response.status_code}    201    #Response:{"category_id": 27, "category_name": "cat_name1755701234"} 
    ${body}=       Set Variable    ${response.json()}
    ${category_id}=         Get From Dictionary    ${body}    category_id    #10. Pick created category_id = 27.
   
    RETURN       ${category_id}    #Return value example ${category_id}=27  to --> products_test.robot



Delete Category By Id
    [Arguments]    ${category_id}
    Create Authenticated Session
    ${resp}=    DELETE On Session    api_auth    /api/categories/${category_id}/
    RETURN    ${resp}


