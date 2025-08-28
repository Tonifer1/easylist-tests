*** Settings ***
Resource    ../../resources/browser_keywords.resource
Test Setup    Open Browser To Google    ${BROWSER}
Test Teardown    Close My Browser

#    robot --variable BROWSER:firefox tests/e2e/first_test.robot
#    robot --variable BROWSER:chrome tests/e2e/first_test.robot

*** Variables ***
${BROWSER}    chrome

*** Test Cases ***
Page Should Contain Google
    Page Should Contain    Google

Search Text Should Be Visible
    Page Should Contain    Search

