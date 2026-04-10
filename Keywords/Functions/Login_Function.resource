*** Settings ***
Library          SeleniumLibrary
Variables        ../../Config/config.py
Resource         ../Common.resource

*** Variables ***
# Buttons
${APPT_BTN}         id=btn-make-appointment
${LOGIN_BTN}        id=btn-login

# Text Inputs
${USERNAME_INPUT}   id=txt-username
${PASSWORD_INPUT}   id=txt-password

# Error Message
${ERROR_MSG_LABEL}  xpath=//p[contains(@class, 'text-danger')]

#Locators สำหรับ Logout
${MENU_TOGGLE}      id=menu-toggle
${LOGOUT_LINK}      xpath=//a[text()='Logout']

*** Keywords ***
Login Template
    [Arguments]    ${test_id}    ${username}    ${password}    ${expected_error}
    Open Login Page
    Submit Login Form    ${username}    ${password}
    Verify Login Result    ${expected_error}

Open Login Page
    [Documentation]    เปิดหน้าแรกและนำทางไปยังหน้า Login
    Go To    ${URL}
    Wait Until Element Is Visible    ${APPT_BTN}    10s
    Click Element    ${APPT_BTN}
    Wait Until Element Is Visible    ${USERNAME_INPUT}    10s

Submit Login Form
    [Arguments]    ${username}    ${password}
    [Documentation]    กรอกข้อมูล Login และกดปุ่มยืนยัน
    
    Run Keyword If    '${username}' == '${EMPTY}'    Clear Element Text    ${USERNAME_INPUT}
    ...    ELSE    Input Text    ${USERNAME_INPUT}    ${username}
    
    Run Keyword If    '${password}' == '${EMPTY}'    Clear Element Text    ${PASSWORD_INPUT}
    ...    ELSE    Input Password    ${PASSWORD_INPUT}    ${password}
    
    Click Button    ${LOGIN_BTN}

Verify Login Result
    [Arguments]    ${expected_error}
    IF    '${expected_error}' == '${EMPTY}'
        Wait Until Page Contains    Make Appointment    10s
        Logout Process
    ELSE
        Wait Until Element Is Visible    ${ERROR_MSG_LABEL}    10s
        Element Text Should Be    ${ERROR_MSG_LABEL}    ${expected_error}
    END

Logout Process
    Click Element    ${MENU_TOGGLE}
    Wait Until Element Is Visible    ${LOGOUT_LINK}    5s
    Click Element    ${LOGOUT_LINK}