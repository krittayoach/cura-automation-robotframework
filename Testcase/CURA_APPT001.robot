*** Settings ***
Documentation     การทดสอบระบบจองคิว (Appointment Function) - CURA Healthcare
Library           SeleniumLibrary
Library           DataDriver    file=${CURDIR}/../Testdata/Appointment_Data.csv    encoding=utf-8    dialect=excel
Resource          ../Keywords/Common.resource
Resource          ../Keywords/Functions/Login_Function.resource
Resource          ../Keywords/Functions/Appointment_Function.resource
Variables         ../Config/config.py

# ใช้ Template สำหรับรับค่าจาก CSV
Test Template     Appointment Workflow Template

Suite Setup       Run Keywords    Set Selenium Timeout    15s    AND    Open Browser To Login Page
Suite Teardown    Close Browser

*** Test Cases ***
# ชื่อ Test Case จะเปลี่ยนตาม test_id ใน CSV อัตโนมัติ
Appointment Scenario ID: ${test_id}
    [Documentation]    ${description}
    [Tags]             Appointment

*** Keywords ***
Appointment Workflow Template
    [Arguments]    ${test_id}    ${facility}    ${readmission}    ${program}    ${visit_date}    ${comment}    ${expected_status}    ${description}
    
    Open Login Page
    Submit Login Form    John Doe    ThisIsNotAPassword
    Book Appointment    ${facility}    ${readmission}    ${program}    ${visit_date}    ${comment}

    Verify Appointment Result    ${expected_status}    ${facility}

    Handle Post-Test Actions    ${test_id}    ${expected_status}

Handle Post-Test Actions
    [Arguments]    ${test_id}    ${expected_status}
    
    # กรณีเคส 005: จองสำเร็จแล้ว Logout แล้วกด Back
    IF    '${test_id}' == 'CURA_APPT001_005'
        Logout Process
        Go Back
        Log    ตรวจสอบการกด Back หลัง Logout สำเร็จ    level=INFO
    
    # กรณีจองสำเร็จทั่วไป (Success หรือ Fail ที่ระบบยอมให้จอง) ให้ Logout เพื่อเริ่มเคสถัดไป
    ELSE IF    '${expected_status}' == 'Success' or '${expected_status}' == 'Fail'
        Logout Process
        # กลับไปหน้า Login เพื่อให้เคสถัดไปเริ่มทำงานต่อได้
        Open Login Page
        
    # กรณี Error (006): บอทจะยังค้างอยู่ที่หน้าจอง ให้กด Menu เพื่อ Logout ออกมาเลย
    ELSE
        Logout Process
        Open Login Page
    END