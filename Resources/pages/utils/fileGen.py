import csv
import json
import jsonschema
import requests
from datetime import datetime
from pathlib import Path
from jsonschema import validate
import page_variables

mypath = Path.cwd()


def get_path(px):
    return mypath / 'Resources' / 'pages' / 'utils' / px


def validate_csv(file_path, cCheck, cRow):
    # csv_check = 'Column headers are correct and correct number of columns in other subsquent rows'
    csv_check = cCheck
    file_path = mypath / 'Resources' / 'pages' / 'utils' / file_path
    with open(file_path, 'r') as file:
        reader = csv.reader(file)
        # Check that the first row contains the correct column headers
        first_row = next(reader)
        if cRow == 'First_Row':
            if first_row != ['natid', 'name', 'gender', 'salary', 'birthday', 'tax']:
                csv_check = ValueError('Invalid column headers')
        else:
            # Check that all subsequent rows have the correct number of columns
            for i, row in enumerate(reader):
                if len(row) != 6:
                    csv_check = ValueError(f'Invalid number of columns on row {i + 2}')
    return csv_check


def compute_tax_relief(person, rrule=None):
    # compute variable based on age
    age = person['age']
    if age <= 18:
        variable = 1
    elif age <= 35:
        variable = 0.8
    elif age <= 50:
        variable = 0.5
    elif age <= 75:
        variable = 0.367
    else:
        variable = 0.05

    # compute gender bonus
    gender_bonus = 0 if person['gender'] == 'M' else 500

    # compute tax relief
    tax_relief = ((float(person['salary']) - float(person['tax'])) * variable) + gender_bonus

    # truncate to 2 decimal place
    tax_relief = round(tax_relief, 2)

    # rounding rule
    if rrule:
        tax_relief = round(tax_relief)
        tax_relief = max(tax_relief, 50)

    if tax_relief < 0.00:
        tax_relief = 0.00
    else:
        if tax_relief > 0.00 and tax_relief < 50.00:
            tax_relief = 50.00

    return {
        'natid': '$' + person['natid'][:4],
        'relief': tax_relief,
        'name': person['name']
    }


def repchars(id):
    return id[:4] + "$" * (len(id) - 4)


def get_tax_relief(people, xname):
    print(people, xname)
    if xname == 'taxrelief':
        people = people['relief']
    else:
        people = people[xname]
    return people


def calculate_age(birthday):
    birth_date = datetime.strptime(str(birthday), '%d%m%Y')
    # age = relativedelta(datetime.now(), birth_date).years
    today = datetime.now()
    age = today.year - birth_date.year - ((today.month, today.day) < (birth_date.month, birth_date.day))
    return age


def create_dictionary_on(rec):
    data = dict(item.split("=") for item in rec.split(","))
    return data


def getall_total(nat=None, ref=None):
    if nat:
        nat = len(nat)
    if ref:
        apn = []
        for xrel in ref:
            apn.append(float(xrel))
        ref = round(sum(apn), 2)
    return nat, ref


def get_schema_build(resp_content):
    schema = {
        "type": "object",
        "properties": {
            "natid": {
                "type": "string"
            },
            "name": {
                "type": "string"
            },
            "relief": {
                "type": "string"
            }
        }
    }
    getschema = validatejson(resp_content, schema)
    return getschema


def validatejson(jsoncontent, validschema):
    getarrx = []
    respContent = json.loads(jsoncontent)
    for respcont in respContent:
        try:
            validate(instance=respcont, schema=validschema)
            getarrx.append('SchemaValidation : JSON Data is valid')
        except jsonschema.exceptions.ValidationError as err:
            print(err)
            getarrx.append('SchemaValidation : JSON Data is not valid')
    return list(set(getarrx))[0]


def validate_date(date_text):
    try:
        if date_text != datetime.strptime(date_text, "%d-%m-%Y").strftime('%d-%m-%Y'):
            raise ValueError
        return date_text
    except ValueError:
        return 'error'


def get_data_insert(test_date):
    record_repl = test_date
    getxx = record_repl.split(',')
    bDate = getxx[3].split('=')[1]
    gdate = validate_date(date_text=bDate)
    if gdate != 'error':
        gedjoin = gdate.split('-')
        gdate = ''.join(gedjoin)
        record_repl = record_repl.replace(bDate, gdate)
    return record_repl


def postvalidate(jsondata):
    getpost = requests.post(url=page_variables.url + page_variables.insert, json=jsondata)
    resp_text = json.loads(getpost.content)
    return resp_text['status'], resp_text['error'], resp_text['message']