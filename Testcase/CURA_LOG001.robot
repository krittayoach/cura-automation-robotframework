*** Settings ***
Documentation     การทดสอบระบบ CURA Healthcare Service - Login Function
Library           SeleniumLibrary
Resource          ../Keywords/Common.resource
Resource          ../Keywords/Functions/Login_Function.resource
Variables         ../Config/config.py

Test Template     Local Login Template

Library           DataDriver    file=../Testdata/Login_Data.csv    encoding=utf-8-sig    dialect=excel

Suite Setup       Run Keywords
...               Set Selenium Timeout    15s
...               AND    Open Browser To Login Page
Suite Teardown    Close Browser

*** Test Cases ***
Login Scenario ID: ${test_id}
    [Documentation]    ${description}
    [Tags]    Login

*** Keywords ***
Local Login Template
    [Arguments]    ${test_id}    ${username}    ${password}    ${expected_error}    ${description}
    
    Login Template    ${test_id}    ${username}    ${password}    ${expected_error}