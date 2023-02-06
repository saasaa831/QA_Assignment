*** Settings ***
Library      RequestsLibrary
Library    ../utils/fileGen.py
Variables    ../utils/page_variables.py
Variables    ../utils/test_data.py


*** Keywords ***
Session_create
    ${heros}=   Create Session    ${sessionName}    ${url}
    [Return]    ${heros}

Headers
    Create Dictionary  ${headersx}

Csv_validation_first_row
    ${getpath}=     get_path    ${FILE_PATH}
    Log    ${getpath}
    ${csvdata}=     Validate_Csv    ${getpath}    Column headers are correct    First_Row
    [Return]    ${csvdata}

validate_subsequent_row
    ${getpath}=     get_path    ${FILE_PATH}
    Log    ${getpath}
    ${csvdata}=     Validate_Csv    ${getpath}    Column headers are correct    Subsq_Row
    [Return]    ${csvdata}

Age_factor
    ${age}=     Calculate Age       21021989
    [Return]    ${age}

Replace_chars
    ${rchars}=     Repchars   111-222
    [Return]    ${rchars}

Replace_mask_and_calculate_age
    ${agex}=  Age_factor
    Log    ${agex}
    ${gxt}=   Replace_chars
    Log    ${gxt}
    ${getdicx}=     Create Dictionary  natid=${gxt}  name=John sr. Smith  gender=M  age=${agex}  salary=457.81  tax=58
    Log    ${getdicx}
    ${tax_relief}=    Compute Tax Relief    ${getdicx}
    ${masked}=  Get Tax Relief   ${getdicx}   natid
    [Return]    ${masked}   ${getdicx}   ${tax_relief}

Replace_and_calculate_age
    ${agex}=   Age_factor
    ${getdicx}=     Create Dictionary  natid=1231234  name=John Smith  gender=M  age=${agex}  salary=50000  tax=500
    # ${masked}=  Get Tax Relief    ${getdicx}   natid
    [Return]    ${getdicx}

Compute_tax
    ${hero}=    Replace_and_calculate_age
    ${tax_relief}=    Compute Tax Relief    ${hero}
    [Return]    ${tax_relief}

taxation_relief
    ${tax_relief}=  Compute_tax
    ${taxrelief}=   Get Tax Relief    ${tax_relief}  taxrelief
    [Return]    ${taxrelief}

taxation_flat_rate_on_limit
    ${agex}=   Age_factor
    ${getdicx}=     Create Dictionary  natid=112-222  name=John jr. Smith  gender=M  age=${agex}  salary=46.71  tax=3.9
    ${tax_relief}=    Compute Tax Relief    ${getdicx}
    ${taxrelief}=   Get Tax Relief    ${tax_relief}  taxrelief
    [Return]    ${taxrelief}
