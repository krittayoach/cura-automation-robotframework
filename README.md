# **CURA Healthcare Service \- Automated Testing Project**

## **Project Overview**

โปรเจกต์นี้เป็นการทดสอบระบบอัตโนมัติ (Automated Testing) สำหรับเว็บไซต์จองนัดหมายแพทย์ **CURA Healthcare Service** โดยใช้ **Robot Framework** ร่วมกับ **SeleniumLibrary** โปรเจกต์นี้ถูกออกแบบมาโดยใช้โครงสร้าง **Page Object Model (POM)** เพื่อความง่ายในการบำรุงรักษาโค้ด (Maintainability) และใช้เทคนิค **Data-Driven Testing (DDT)** ผ่านไฟล์ CSV เพื่อทดสอบกรณีต่างๆ (Test Scenarios) ทั้ง Positive, Negative และ Edge Cases อย่างครอบคลุม

**Target Website:** [https://katalon-demo-cura.herokuapp.com/](https://katalon-demo-cura.herokuapp.com/)

## **Architecture & Design Pattern**

โปรเจกต์นี้ใช้โครงสร้างโฟลเดอร์ตามมาตรฐานเพื่อแยก Configuration, Keywords, Test Data และ Test Scripts ออกจากกันอย่างชัดเจน:

CuraTestProject/  
│  
├── Config/  
│   └── config.py                     \# เก็บตัวแปร Global เช่น URL, Browser type  
│  
├── Keywords/  
│   ├── Common.resource               \# Keywords ส่วนกลาง (เปิด/ปิด Browser, Setup Options)  
│   └── Functions/  
│       ├── Login\_Function.resource       \# Locators และ Keywords สำหรับหน้า Login  
│       └── Appointment\_Function.resource \# Locators และ Keywords สำหรับหน้า Appointment  
│  
├── Testdata/  
│   ├── Login\_Data.csv                \# ชุดข้อมูลสำหรับเทส Login (DDT)  
│   └── Appointment\_Data.csv          \# ชุดข้อมูลสำหรับเทส การจองนัดหมาย (DDT)  
│  
└── Testcase/  
    ├── CURA\_LOG001.robot             \# Test Suite หลักสำหรับฟังก์ชัน Login  
    └── CURA\_APPT001.robot            \# Test Suite หลักสำหรับฟังก์ชัน Appointment

## **Features & Test Coverage**

### **1\. Authentication (Login)**

* ทดสอบการ Login ด้วยข้อมูลที่ถูกต้อง (Valid Credentials)  
* ทดสอบกรณีไม่กรอกข้อมูล (Empty Fields)  
* ทดสอบกรณี Username หรือ Password ผิด (Invalid Credentials)  
* ทดสอบ Case Sensitivity ของ Username

### **2\. Appointment Booking**

* ทดสอบการจองนัดหมายครบถ้วนสมบูรณ์ (End-to-End Happy Path)  
* ทดสอบการจองโดยไม่เลือก Hospital Readmission หรือ Comment  
* ตรวจสอบ Error Validation กรณีไม่ใส่วันที่ (Missing Date)  
* ตรวจสอบ Business Logic กรณีใส่วันที่ในอดีต (Past Date Validation)  
* ตรวจสอบ Security Session (Logout แล้วกด Back Browser)

## **Prerequisites & Installation**

ก่อนรันโปรเจกต์ ตรวจสอบให้แน่ใจว่าเครื่องของคุณติดตั้ง Python เรียบร้อยแล้ว จากนั้นติดตั้ง Libraries ที่จำเป็นดังนี้:

\# ติดตั้ง Robot Framework และ Selenium Library  
pip install robotframework  
pip install robotframework-seleniumlibrary

\# ติดตั้ง DataDriver สำหรับอ่านค่าจากไฟล์ CSV  
pip install robotframework-datadriver

## **How to Run Tests**

คุณสามารถรันการทดสอบผ่าน Terminal / Command Line ได้โดยใช้คำสั่งต่อไปนี้:

**รันการทดสอบทั้งหมด (All Suites):**

robot \-d Results Tests/

**รันเฉพาะฟังก์ชัน Login:**

robot \-d Results Tests/CURA\_LOG001.robot

**รันเฉพาะฟังก์ชัน Appointment:**

robot \-d Results Tests/CURA\_APPT001.robot

*(หมายเหตุ: ผลลัพธ์การทดสอบ log.html และ report.html จะถูกบันทึกไว้ในโฟลเดอร์ Results/)*

## **Key Technical Highlights**

* **Browser Options:** มีการจัดการ Chrome Options เพื่อปิดกั้น Popup กวนใจ (เช่น Password Manager, Notifications) ทำให้ Test รันได้อย่างเสถียร  
* **Dynamic Data Handling:** มีการสร้าง Logic เพื่อจัดการกับค่าว่าง (${EMPTY}) ใน Data-Driven Testing โดยใช้คำสั่ง Clear Element Text แทนเพื่อความแม่นยำ  
* **Smart Teardown:** มีการทำ Post-Test Actions เพื่อ Reset State ของระบบ (เช่น บังคับ Logout ถ้าระบบยังค้างอยู่) เพื่อเตรียมความพร้อมให้ Test Case ถัดไปทำงานได้โดยไม่มีผลกระทบ (No Dependency)

*Created by QA/Tester as a Portfolio Project.*