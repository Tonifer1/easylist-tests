*** Settings ***
Library          RequestsLibrary
Library          Collections
Library         OperatingSystem
Resource   ./auth_keywords.resource

*** Variables ***

${CATEGORIES_ENDPOINT}    /api/categories/

*** Keywords ***


Create Category And Save Id
    [Arguments]    ${category_name}    #6. Tähän tulee products_test.robotissa luotu {categoryname}: cat_name1755701234
    Create Authenticated Session
    ${payload}=    Create Dictionary    category_name=${category_name}    #7.Rakentaa payloadin: {"category_name": "cat_name1755701234"}.
    ${response}=       POST On Session    api_auth    ${CATEGORIES_ENDPOINT}    json=${payload}    #8. Lähettää POST /api/categories/
    Should Be Equal As Integers    ${response.status_code}    201    #9. Vastaus:{"category_id": 27, "category_name": "cat_name1755701234"} 
    ${body}=       Set Variable    ${response.json()}
    ${category_id}=         Get From Dictionary    ${body}    category_id    #10. Poimii sieltä luodun category_id = 27.
    Set Suite Variable    ${SUITE_CATEGORY_ID}    ${category_id}    #11.Tallentaa myös ${SUITE_CATEGORY_ID}=${category_id}=27 Teardown saa nyt arvon.
    RETURN       ${category_id}    #12. Palauttaa arvon testille ${category_id}=27  --> products_test.robot