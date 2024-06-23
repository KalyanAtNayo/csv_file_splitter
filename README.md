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

```
python process_apis.py
```

# access to documentation

IFS Bronze APIs for both Incremental and Historical loads are maintained here:
[Sharepoint Link](https://nayotechnologies.sharepoint.com/:x:/s/SJE/EcQcqg7lUWlDsR8MwItY8mUBWTnjttvaD8OTMjsiAZn5bA?e=8YnpqU)

Historical Loads:

> The entries in that spreadsheet can be filtered by Status (Historical Load) column for the value "Ready to Start"

> The SourceSystem column has a link to the odata-json debug endpoint
