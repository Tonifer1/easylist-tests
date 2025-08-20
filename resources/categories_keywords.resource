*** Settings ***
Library          RequestsLibrary
Library          Collections
Library         OperatingSystem
Resource   ./auth_keywords.resource

*** Variables ***
${BASE_URL}              http://127.0.0.1:8000
${CATEGORIES_ENDPOINT}    /api/categories/

*** Keywords ***

Ensure Categories Session
    ${token}=    Login And Get Token
    Create Session    cat    ${BASE_URL}    headers={"Authorization":"Bearer ${token}","Content-Type":"application/json"}
Create Category And Save Id
    [Arguments]    ${name}
    Ensure Categories Session
    ${payload}=    Create Dictionary    category_name=${name}
    ${resp}=       POST On Session    cat    ${CATEGORIES_ENDPOINT}    json=${payload}
    Should Be Equal As Integers    ${resp.status_code}    201
    ${body}=       Set Variable    ${resp.json()}
    ${cat_id}=         Get From Dictionary    ${body}    category_id
    Set Suite Variable    ${SUITE_CATEGORY_ID}    ${cat_id}
    RETURN       ${cat_id}