*** Settings ***
Library    SeleniumLibrary
Variables    ../../Config/config.py
Resource    ../Common.resource

*** Variables ***
#Dropdown / Select
${FACILITY_SEL}       id=combo_facility

#Checkbox
${READMISSION_CBX}    id=chk_hospotal_readmission

#Input Fields
${VISIT_DATE_TXT}     id=txt_visit_date
${COMMENT_TXT}        id=txt_comment

#Buttons
${BOOK_APPT_BTN}         id=btn-book-appointment

*** Keywords ***
Book Appointment
    [Arguments]    ${facility}    ${readmission}    ${program}    ${visit_date}    ${comment}
    Wait Until Element Is Visible    ${FACILITY_SEL}    10s
    Select From List By Value        ${FACILITY_SEL}    ${facility}

    IF    '${readmission}' == 'Yes'
        Select Checkbox    ${READMISSION_CBX}
    ELSE
        Unselect Checkbox    ${READMISSION_CBX}
    END

    Select Radio Button    programs    ${program}
    
    Input Text    ${VISIT_DATE_TXT}    ${visit_date}
    Input Text    ${COMMENT_TXT}       ${comment}

    Click Button    ${BOOK_APPT_BTN}

Verify Appointment Result
    [Arguments]    ${expected_status}    ${facility}
    
    IF    '${expected_status}' == 'Success'
        Wait Until Page Contains    Appointment Confirmation    10s
        Element Should Contain      id=facility    ${facility}
        
    ELSE IF    '${expected_status}' == 'Error_MissingDate'
        Page Should Contain Element    ${BOOK_APPT_BTN}
        
    ELSE IF    '${expected_status}' == 'Fail'
        Wait Until Page Contains    Appointment Confirmation    10s
        Log    บันทึก: พบ Bug ระบบยอมให้จองวันที่ในอดีต    level=WARN
    END
