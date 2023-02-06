*** Settings ***
Documentation   Page Object in Robot Framework
Library    SeleniumLibrary
Library    BuiltIn
Resource    ../Resources/pages/keywords/api.robot
Resource    ../Resources/pages/keywords/ui.robot
Variables   ../Resources/pages/utils/test_data.py


*** Test Cases ***
UStory01_Insert Single Working Class Hero
    [Documentation]    AC1 : Insert single record of Working class hero with Natural Id(natid), Name, Gender, Birthday, Salary and Tax paid
    [Tags]     api  regression
    ${status_code}  ${scode}=  post_action_Single_Insert
    Log    ${status_code} ${scode}
    Should Be Equal    ${status_code}   ${scode}
    log    Hero with Status code ${scode}

UStory01_Insertion Invalid date for Working Class Hero
    [Documentation]    AC1-1 : Insert single record of Working class hero with invalid Birthday
    [Tags]     api  regression
    ${status_message}=  Post_action_invalid_date_Insertion
    Should Contain    ${status_message}      Internal Server Error

UStory02_Insert Multiple Working Class Hero
    [Documentation]    AC1 : Ability to Inserting Working class hero multiple records in form of list.
    [Tags]     api  regression
    ${status_code}  ${scode}=  Post_action_multiple_Insert
    Log    ${status_code} ${scode}
    Should Be Equal    ${status_code}   ${scode}
    log    Hero with Status code ${scode}

UStory03_Check First Row must be with column names
    [Documentation]     AC1 : Check first row csv must be with columns(natid, name, gender, salary, birthday, tax)
    [Tags]     api  regression
    ${results}=  Csv_validation_first_row
     Log    ${results}

UStory03_Check other subsquent rows should be with relevant details
    [Documentation]     AC2 : Check subsquent rows are with relevant details
    [Tags]     api  regression
    ${results}=  Validate_subsequent_row
     Log    ${results}

UStory03_Upload CSV File with details of Working Class Heros
    [Documentation]  AC3 : Upload the working class heros details in form of csv file via portal
    [Tags]     ui  regression
    Launch_browser
    # Click the button to navigate to the file upload page
    Upload_csv_file
     ${getnat_list}=     Get_all_natid_details
    Log    ${getnat_list}
    Should Contain        ${getnat_list}      115-$$$$$$$$$$$$$

UStory03_Upload CSV File with details of invalid birthday date format of Working Class Heros
    [Documentation]  AC3-1 : Upload working class details with invalid date format for birthday
    [Tags]     ui  regression
    # Click the button to navigate to the file upload page
    Upload_invalid_date_csv_file
    ${getnat_list}=     Get_all_natid_details
    Log    ${getnat_list}
    Should Not Contain    ${getnat_list}      222-$$$$

UStory04_Retrieve the list of tax relief
    [Documentation]  AC1 : Retrieve the list of details consists of natid, tax relief and name.
    [Tags]     api  regression
    ${status_code}  ${scode}=  Get_action_tax_relief_summary
    Log    ${status_code} ${scode}
    Should Be Equal    ${status_code}   ${scode}
    log    Hero with Status code ${scode}

UStory04_Validate json schema for tax relief api
    [Documentation]  AC1-1 : Validate json schema for tax relief get api method
    [Tags]     regression   api
    ${tax_relief_get_schema}=  Verify_tax_relief_Json_schema
    Should Contain    ${tax_relief_get_schema}      ${schemavalid}

UStory04_Check natid 5th char masked with '$'
    [Documentation]     AC2 : Validate natid field must be masked from the 5th character onwards.
    [Tags]     regression   ui
    ${gxt}  ${getdicxx}  ${tax_relief}=  Replace_mask_and_calculate_age
    Should Be Equal    ${gxt}    111-$$$
    log    ${gxt}
    ${tget}=    Get_natid_details
    Should Be Equal    ${tget}    1231$$$
    Log    ${tget}

UStory04_Validate tax relief computation based described formula
    [Documentation]  AC3 : validate tax relief computation based described formula
    [Tags]     ui   regression
    ${tax_relief}=    Compute_tax
    log    ${tax_relief}
    ${tget1}=    Get_relief_details
    Should Be Equal    ${tget1}    39200.00
    Log    ${tget1}

UStory04_Validate removal any decimal places after tax relief
    [Documentation]  AC4 : Validate after tax relief amount should be remove any decimal places
    [Tags]     regression
    ${taxrelief}=   Taxation_relief
    Should Be Equal    ${taxrelief}    ${x_relief}
    log    ${taxrelief}

UStory04_Validate tax relief is > 0.00 and < 50.00
    [Documentation]  AC5 : Validate calculated tax is >0.00 and <50.00 should has flat final rate of 50.00
    [Tags]     regression
    ${taxrelief}=   Taxation_flat_rate_on_limit
    Should Be Equal    ${taxrelief}    ${50.00}
    log    ${taxrelief}

UStory04_Validate tax relief computation before applying normal rounding rule
    [Documentation]  AC6-1: Validate after tax relief before remove decimal places
    [Tags]     api  regression
    ${gxt}  ${getdicxx}  ${tax_relief}=  Replace_mask_and_calculate_age
    ${taxrelief}=   Get Tax Relief    ${tax_relief}  taxrelief
    Should Be Equal    ${taxrelief}    ${rounding1}

UStory04_Validate tax relief computation after applying normal rounding rule
    [Documentation]  AC6-2 : Validate after tax relief after subject to rounding rule
    [Tags]     regression
    ${gxt}  ${getdicxx}  ${tax_relief}=  Replace_mask_and_calculate_age
    ${tax_relief}=    Compute Tax Relief    ${getdicxx}   Yes
    ${taxrelief}=   Get Tax Relief    ${tax_relief}  taxrelief
    Should Be Equal    ${taxrelief}    ${rounding2}

UStory05_Check dispenses action button is red-colored
    [Documentation]  AC1 : Button must be 'red-colored'
    [Tags]     ui  regression

    ${gettotal}=    Get_total_tax
    ${natval}   ${relval}=   Get_total_relief
    Should Contain    ${gettotal}   ${natval} ${totaltax2}

    ${color}=    Red_colored_button
    Should Be Equal    ${color}    ${rededcolor}
    Log    ${color}

UStory05_Check text on button should be Dispense Now
    [Documentation]  AC2 : Text on button must be 'Dispense Now'
    [Tags]     ui  regression
    ${text} =    Get_dispense_text
    Should Be Equal    ${text}    ${dispbtn}

UStory05_Governor Dispenses Tax Relief
    [Documentation]  AC3 : Page should contain 'Cash dispensed'
    [Tags]     ui  regression
    Get_click_element
    Wait Until Page Contains    ${dispensed}
    Close Browser
