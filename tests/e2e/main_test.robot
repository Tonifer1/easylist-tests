*** Settings ***
Documentation    Basic E2E sanity test that verifies the EasyList page opens successfully.
Resource    ../../resources/selenium/open_browser_keywords.resource
Test Setup    Open My Browser    ${BROWSER}
Test Teardown    Close My Browser


*** Variables ***


*** Test Cases ***
Page Should Contain EasyList
    [Tags]    e2e    selenium    smoke    
    Page Should Contain    EasyList
    



