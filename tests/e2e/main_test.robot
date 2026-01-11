*** Settings ***
Documentation    Basic E2E sanity test that verifies the EasyList page opens successfully.
Resource    ../../resources/e2e/open_browser_keywords.resource
Test Setup    Open My Browser
Test Teardown    Close My Browser


*** Variables ***


*** Test Cases ***
Page Should Contain EasyList
    [Documentation]    EasyList Main page should open
    [Tags]    e2e    smoke    browser    
    Get Element States    h1.text-2xl >> text="EasyList"    validate    value & visible
    Get Text    h1.text-4xl    contains    Tervetuloa EasyList-sovellukseen
