
import csv
from datetime import datetime
from split_csv_file import build_api_endpoint, process_historical_data
from validate_historical_load_structure import process_api_endpoint
import os


def process_api(apihandler: str, endpoint: str):
    print(f"Processing API: {endpoint}")
    api_csv_data_file = f"{endpoint}.csv"
    api_csv_data_file_with_path = f"./csv_data/{api_csv_data_file}"

    if not os.path.exists(api_csv_data_file_with_path):
        print(f"API CSV Data File: {api_csv_data_file} does not exist")
        return

    api_chunk_file_path = f"./csv_output/{
        endpoint}/{endpoint}_chunk_0.csv"
    if os.path.exists(api_chunk_file_path):
        print(f"API chunk file: {api_chunk_file_path} exists")
        return

    # text_match = "rows selected."
    # # check if there is a matching text entry contains in the last row of the csv file
    # with open(api_csv_data_file_with_path,  'r', encoding='mac_roman') as f:
    #     reader = csv.reader(f)
    #     data = list(reader)
    #     last_row = data[-1]
    #     # concatenate all the entries of the string array last_row
    #     last_row = ''.join(last_row)

    #     print(f"Checking if Last row of {
    #           api_csv_data_file_with_path} file: {last_row}  for validity")
    #     if text_match in last_row:
    #         print(f"\n\n!!Invalid CSV data file: API {apihandler}:{
    #             endpoint} has invalid data: {last_row} in the last row")
    #         print(
    #             "It is recommended to open the csv file, and remove the last line and re-process\n\n")
    #         return

    # check if path exisits
    if not os.path.exists("./csv_data"):
        os.makedirs("./csv_data")

    # print(f"API CSV Data File: {api_csv_data_file}")
    # check if file exists in csv_data folder
    if os.path.exists(api_csv_data_file_with_path):
        try:
            log_msg = "*************************".join(
                ["Processing endpoint: ", apihandler, endpoint])
            print(f"{log_msg}\nFile {api_csv_data_file} exists")
            print(f"process api: {apihandler}:{endpoint}")
            process_historical_data(
                apihandler, endpoint, api_csv_data_file)
            api_end_point = build_api_endpoint(apihandler, endpoint)
            process_api_endpoint(
                api=endpoint, api_endpoint=api_end_point)
        except Exception as e:
            print(f"processed {apihandler}:{endpoint}")


if __name__ == "__main__":

    # load csv file SJE-EDW-APIS.csv
    with open('SJE-EDW-APIS.csv', 'r') as f:
        reader = csv.reader(f)
        header = next(reader)
        print(header)
        # get index of a column name
        apihandler_column_name = 'APIHandler'
        endpoint_column_name = 'APIEndPoint'
        historic_load_column_name = 'Status (Historical Load)'
        endpoint_header_index = header.index(endpoint_column_name)
        apihandler_header_index = header.index(apihandler_column_name)
        historic_load_column_index = header.index(
            historic_load_column_name)
        print(f"Index of {apihandler_column_name} is {
              apihandler_header_index}")
        print(f"Index of {endpoint_column_name} is {endpoint_header_index}")
        print(f"Index of {historic_load_column_name} is {
              historic_load_column_index}")

        # read data rows
        data = list(reader)
        num_rows = len(data)
        print(f"Found {num_rows} rows in SJE-EDW-APIS.csv")

        # filter data by historical load value that matches Ready to Start
        historic_load_entries = [
            row for row in data if row[historic_load_column_index] == 'Ready to Start']
        print(f"Found {len(historic_load_entries)
                       } entries with Historical Load as Ready to Start")

        # log the time
        start = datetime.now()
        print("Processing started at: ", start)

        # loop through each row
        for row in historic_load_entries:
            apihandler = row[apihandler_header_index]
            endpoint = row[endpoint_header_index]
            historic_load = row[historic_load_column_index]
            # print(f"APIHandler: {apihandler}, APIEndPoint: {
            #       endpoint}, Status (Historical Load): {historic_load}")
            # process_api_endpoint(apihandler, endpoint)

            process_api(apihandler=apihandler, endpoint=endpoint)
        # calculate the elapsed time
        end = datetime.now()
        elapsed_time = end - start
        print("Processing ended at: ", datetime.now())
        total_seconds = elapsed_time.total_seconds()
        minutes, seconds = divmod(total_seconds, 60)
        print(f"Elapsed time: {int(minutes)} minutes and {
              seconds:.2f} seconds")
