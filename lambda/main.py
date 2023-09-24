import json
import re

def lambda_handler(event, context):

    input_string = json.loads(event.get('body')).get('input_string')
    
    
    res_body = {}
    #res_body['input'] = input_string

    # Define the find and replace mappings
    replacements = {
        ' ABN': ' ABN AMRO',
        ' ING': ' ING Bank',
        ' Rabo': ' Rabobank',
        ' Triodos': ' Triodos Bank',
        ' Volksbank': ' de Volksbank',
        # Add more mappings as needed
    }

    # Perform find and replace
    for target, replacement in replacements.items():
        bank = re.compile(re.escape(target), re.IGNORECASE)
        input_string = bank.sub(replacement,input_string)
    
    # adding the the sentence after the text manupulation is one
    res_body['output'] = input_string
    
    #adding the http response 
    https_res = {}
    https_res['statusCode'] = 200 
    https_res['headers'] = {}
    https_res['headers']['Context-Type'] =  'application/json'
    https_res['body'] = json.dumps(res_body)
    
    return https_res

