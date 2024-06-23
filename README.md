# csv_file_splitter

This project has artifacts that help process data extracted from IFS cloud databases for downstream datasources

# setup python virtual environment

python -m venv nt_venv

# activate python environment

source nt_venv/bin/activate

# install all modules

pip install -r requirements.txt

# .env set up

create a .env file with the following keys

```

TOKEN_URL=
CLIENT_ID=
CLIENT_SECRET=
JWKS_URL=
BASE_URL='https://nwstest.nayotech.com/main/ifsapplications/projection/v1/'
SUFFIX='?$skip=0&$top=1&odata-debug=json'
AUDIENCE='nwsapp03test'
ISSUER='https://nwstest.nayotech.com/auth/realms/nwsapp03test'

```

> You can get the token and jwks urls from IFS_BASE_URL/.well-known/openid-configuration

> e.g [Internal WS openid config wellknown endpoint](https://nwstest.nayotech.com/.well-known/openid-configuration)

# using the scripts:

1. Process all APIs
   > make sure the input csv file has all the neccessary entries to be processed

```
python process_apis.py
```
Sample Output:
![Sample ouput](https://github.com/KalyanAtNayo/csv_file_splitter/blob/main/process_apis_output_log.png)

2. Process one API
   > grab the APIService and APIEndpoint from one of the spreadsheets

```
python split_csv_file.py
```

3. Validate JSON & CSV
   > grab the APIService and APIEndpoint from one of the spreadsheets

```
python validate_historical_load_structure.py
```

# Documentation & Project Management

IFS Bronze APIs for both Incremental and Historical loads are maintained here:
[Sharepoint Link](https://nayotechnologies.sharepoint.com/:x:/s/SJE/EcQcqg7lUWlDsR8MwItY8mUBWTnjttvaD8OTMjsiAZn5bA?e=8YnpqU)
This sharepoint document is for NAYO internal use.

Historical Loads:

- The entries in that spreadsheet can be filtered by Status (Historical Load) column for the value "Ready to Start"
- The SourceSystem column has a link to the odata-json debug endpoint
- APIHandler and APIEndpoint are used to process all the apis
- The column "Select query" has the SQL query to extract the data for the given date range

For external parties we use Smartsheets, where we allow customers and 3rd party vendors access.

- [Master list](https://app.smartsheet.com/sheets/PHQg37j8WhrRqhJ5Vm2p7XcQcr92HH4C5xM49Hx1?view=grid)
- [Collaborate Column Validations](https://app.smartsheet.com/sheets/jQpPmpPV6PwqG2MMwFcWj43vMmPWVVW729Qh86V1?filterId=3195781860249476&view=grid)
- [Daily Report](https://app.smartsheet.com/reports/Jr2mjxVv8Fm99j3wJqhJC63RG7JmrGccMjQ6Xv61?view=grid)
- [Status Dashboard](https://app.smartsheet.com/b/publish?EQBCT=daf22bfcb16345f091885807f7652cee)
