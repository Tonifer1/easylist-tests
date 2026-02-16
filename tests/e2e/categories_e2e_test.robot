*** Settings ***
Resource    ../../resources/e2e/open_browser_e2e_keywords.resource
Resource    ../../resources/e2e/login_e2e_keywords.resource
Resource    ../../resources/e2e/products_e2e_keywords.resource
Resource    ../../resources/e2e/categories_e2e_keywords.resource
Test Setup    Open My Browser    
Test Teardown    Close My Browser
*** Variables ***
${VALID_USERNAME}    %{API_USERNAME}
${VALID_PASSWORD}    %{API_PASSWORD}

*** Test Cases ***
Categories page should show categories list for logged-in user
    [Documentation]    Verifies that a logged-in user can navigate to the Categories page 
    ...                and that the Categories view is rendered successfully.
    [Tags]    e2e    smoke    browser    categories    
    Click Login Link
    Input Username And Password    ${VALID_USERNAME}    ${VALID_PASSWORD}
    Submit Login
    Logout Link Should Be Visible
    Open Categories Page
    Open Categories Link Should Be Visible

User can create and delete category
    [Tags]    e2e    create    browser    categories2
    Click Login Link
    Input Username And Password    ${VALID_USERNAME}    ${VALID_PASSWORD}
    Submit Login
    Logout Link Should Be Visible
    Open Categories Page
    Open Categories Link Should Be Visible
    Create New Category