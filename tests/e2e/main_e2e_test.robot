*** Settings ***
Documentation    Basic E2E sanity test that verifies the EasyList page opens successfully.
Resource    ../../resources/e2e/open_browser_e2e_keywords.resource
Resource    ../../resources/e2e/login_e2e_keywords.resource
Test Setup    Open My Browser
Test Teardown    Close My Browser


*** Variables ***


*** Test Cases ***
Main Page Should Be Ready
    [Documentation]    EasyList Main page should open
    [Tags]    e2e    smoke    browser    main
    Login Link Should Be Visible    
