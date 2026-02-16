*** Settings ***
Resource    ../../resources/e2e/open_browser_e2e_keywords.resource
Resource    ../../resources/e2e/login_e2e_keywords.resource
Resource    ../../resources/e2e/products_e2e_keywords.resource
Test Setup    Open My Browser    
Test Teardown    Close My Browser
*** Variables ***
${VALID_USERNAME}    %{API_USERNAME}
${VALID_PASSWORD}    %{API_PASSWORD}

*** Test Cases ***
Products page should show product list for logged-in user
    [Documentation]    Verifies that a logged-in user can navigate to the Products page 
    ...                and that the Products view is rendered successfully.
    [Tags]    e2e    smoke    browser    seppo    
    Click Login Link
    Input Username And Password    ${VALID_USERNAME}    ${VALID_PASSWORD}
    Submit Login
    Logout Link Should Be Visible
    Open Products Page
    Open Products Link Should Be Visible

