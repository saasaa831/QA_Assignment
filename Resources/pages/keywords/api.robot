*** Settings ***
Library      RequestsLibrary
Library      ../utils/fileGen.py
Variables    ../utils/page_variables.py
Variables    ../utils/test_data.py
Resource     common.robot

*** Keywords ***
post_action_single_Insert
     ${hero}  ${heros} =   Single_insert
     ${response}=    POST On Session  ${heros}  ${insert}  json=${hero}  #headers=${headers}
     Log    ${response.status_code}
     FOR    ${scode}   IN   @{statuscode}
        Log    ${scode}
        Exit For Loop If    ${response.status_code} == ${scode}
            # ${scode}=   ${scode}
     END
     [Return]   ${response.status_code}    ${scode}

post_action_invalid_date_Insertion
     ${hero} =   Date_invalid_insertion
     # ${response}=    POST On Session  ${heros}  ${insert}  json=${hero}  #headers=${headers}
     ${get_validation_error}=   Postvalidate    ${hero}
     Log    ${get_validation_error}
     [Return]    ${get_validation_error}

post_action_multiple_Insert
     ${hero}  ${heros} =   Multiple_insert
     ${response}=    POST On Session  ${heros}  ${insertmultiple}  json=${hero}  #headers=${headers}
     Log    ${response.status_code}
     FOR    ${scode}   IN   @{statuscode}
        Log    ${scode}
        Exit For Loop If    ${response.status_code} == ${scode}
            # ${scode}=   ${scode}
     END
     [Return]   ${response.status_code}    ${scode}

get_action_tax_relief_summary
     ${heros}=  Session_create
     ${response} =    GET On Session  ${heros}  ${taxrelief}
     Log    ${response.status_code}
     FOR    ${scode}   IN   @{statuscode}
        Log    ${scode}
        Exit For Loop If    ${response.status_code} == ${scode}
            # ${scode}=   ${scode}
     END
     [Return]   ${response.status_code}    ${scode}

Single_insert
     ${heros}=  Session_create    #Create Session    ${sessionName}    ${url}
     ${record}=     Get Data Insert    ${record1}
     ${hero}=  Create Dictionary On    ${record}
     [Return]    ${hero}    ${heros}

Multiple_insert
     ${heros}=  Session_create    #Create Session    ${sessionName}    ${url}
     ${recordx}=     Get Data Insert    ${record2}
     ${list1}=  Create Dictionary On    ${recordx}
     ${recordxx}=     Get Data Insert    ${record3}
     ${list2}=  Create Dictionary On    ${recordxx}
     ${hero}=   Create List    ${list1}  ${list2}
     [Return]    ${hero}    ${heros}

Date_invalid_insertion
     # ${heros}=  Session_create    #Create Session    ${sessionName}    ${url}
     ${record}=     Get Data Insert    ${record4}
     ${hero}=  Create Dictionary On    ${record}
     [Return]    ${hero}

verify_tax_relief_Json_schema
     ${heros}=  Session_create
     ${response} =    GET On Session  ${heros}  ${taxrelief}
     ${schema}=    Get Schema Build    ${response.content}
     Log    ${schema}
     [Return]    ${schema}