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
You can get the token and jwks urls from IFS_BASE_URL/.well-known/openid-configuration
e.g https://nwstest.nayotech.com/.well-known/openid-configuration

# using the scripts:
python process_apis.py

