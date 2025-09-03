*** Settings ***
Resource    ../../resources/selenium/open_browser_keywords.resource
Test Setup    Open My Browser    ${BROWSER}
Test Teardown    Close My Browser

#    robot --variable BROWSER:firefox tests/e2e/first_test.robot
#    robot --variable BROWSER:chrome tests/e2e/first_test.robot

*** Variables ***
${BROWSER}    chrome

*** Test Cases ***
Page Should Contain EasyList
    [Tags]    ignore
    Page Should Contain    EasyList
    



