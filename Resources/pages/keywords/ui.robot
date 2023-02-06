*** Settings ***
Library      SeleniumLibrary
Library    ../utils/fileGen.py
Variables    ../utils/page_variables.py
Variables    ../locators/page_locators.py
Variables    ../utils/test_data.py
Library    Collections

*** Keywords ***
Launch_browser
    Open Browser    ${url}     ${brower}
    Maximize Browser Window

Upload_csv_file
    ${getpath}=     get_path    ${FILE_PATH}
    Log    ${getpath}
    Choose File     ${uploadcsv}    ${getpath}
    SLEEP    5
    RELOAD PAGE

Upload_invalid_date_csv_file
    ${getpath}=     get_path    ${File_invalid_data}
    Log    ${getpath}
    Choose File     ${uploadcsv}    ${getpath}
    SLEEP    5
    RELOAD PAGE

red_colored_button
    ${colored}=     Execute JavaScript  ${coloredscript}
    [Return]    ${colored}

reload_page_details
    Execute JavaScript  ${reloadedPage}

get_dispense_text
    ${tget}=    Get Text    ${get_dispense_text}
    [Return]    ${tget}

get_click_element
    Click Element   ${get_dispense_click}

get_natid_details
    ${tget1}=     Get Text    ${get_details_natid}
    [Return]    ${tget1}

get_relief_details
    ${tget2}=     Get Text    ${get_details_relief}
    [Return]    ${tget2}

get_total_tax
    ${tget3}=     Get Text    ${total_tax_relief}
    [Return]    ${tget3}

get_relief_all
    ${textlink}=    Create List
    ${tget4}=     Get Webelements    ${get_details_relief}
    Log    ${tget4}
    FOR    ${items}     IN      @{tget4}
        ${link_text}=   Get Text    ${items}
        Log    ${link_text}
        Append To List      ${textlink}     ${link_text}
    END
    [Return]    ${textlink}

get_total_relief
    ${tget5}=     Get Webelements    ${get_details_natid}
    ${trel}=    Get_relief_all
    Log    ${trel}
    ${tget6}    ${tget7}=   Getall Total    nat=${tget5}    ref=${trel}
    ${natval}=  Convert To String    ${tget6}
    ${relval}=  Convert To Number    ${tget7}
    Log    ${natval}
    Log    ${relval}
    [Return]    ${natval}   ${relval}

get_all_natid_details
    ${textlink}=    Create List
    ${tget5}=     Get Webelements    ${get_details_natid}
    Log    ${tget5}
    FOR    ${items}     IN      @{tget5}
        ${link_text}=   Get Text    ${items}
        Log    ${link_text}
        Append To List      ${textlink}     ${link_text}
    END
    [Return]    ${textlink}