
import csv
from datetime import datetime
from split_csv_file import build_api_endpoint, process_historical_data
from validate_historical_load_structure import process_api_endpoint
import os
import pandas as pd


def clean_csv(input_csv_path, output_csv_path):
    with open(input_csv_path, 'r', newline='', encoding='utf-8') as infile, \
            open(output_csv_path, 'w', newline='', encoding='utf-8') as outfile:

        # Create a CSV reader and writer
        reader = csv.reader(infile)
        writer = csv.writer(outfile, quoting=csv.QUOTE_ALL)

        for row in reader:
            # Clean each cell in the row by replacing newline characters with a space
            cleaned_row = [cell.replace('\n', ' ').replace(
                '\r', ' ') for cell in row]
            # Write the cleaned row to the output file
            writer.writerow(cleaned_row)

    print(f"Cleaned CSV file saved to {output_csv_path}")


def process_api(apihandler: str, endpoint: str):
    print(f"Processing API: {endpoint}")
    api_csv_data_file = f"{endpoint}.csv"
    api_csv_data_file_with_path = f"./csv_data/{api_csv_data_file}"

    if not os.path.exists(api_csv_data_file_with_path):
        print(f"API CSV Data File: {api_csv_data_file} does not exist")
        return
    api_clean_csv_data_file_with_path = f"./csv_data/clean_{api_csv_data_file}"
    api_bak_csv_data_file_with_path = f"./csv_data/bak_{api_csv_data_file}"
    clean_csv(api_csv_data_file_with_path, api_clean_csv_data_file_with_path)

    print(f"Renaming {api_csv_data_file_with_path} to {
          api_bak_csv_data_file_with_path}")
    # rename file of input file to bak file name
    os.rename(api_csv_data_file_with_path, api_bak_csv_data_file_with_path)
    print(f"Renaming {api_clean_csv_data_file_with_path} to {
          api_csv_data_file_with_path}")
    # rename file of clean file name to input file
    os.rename(api_clean_csv_data_file_with_path, api_csv_data_file_with_path)

    api_output_file_path = f"./csv_output/{
        endpoint}/"
    api_chunk_file_path = f"{api_output_file_path}{endpoint}_chunk_0.csv"
    if os.path.exists(api_output_file_path):
        # check number of csv files in given directory path
        chunk_files = os.listdir(f"./csv_output/{endpoint}")
        num_chunk_files = len(chunk_files)
        print(f"API already processed. {
              num_chunk_files} chunk file(s) found in: {api_output_file_path}")
        return

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
    input_file_name = input(
        "Enter the name of the input file (e.g. SJE-EDW-APIS.csv): ") or 'SJE-EDW-APIS.csv'

    # check if file is in path
    if not os.path.exists(input_file_name):
        print(f"File {input_file_name} does not exist")
        exit(1)

    # load csv file SJE-EDW-APIS.csv
    with open(input_file_name, 'r') as f:
        reader = csv.reader(f)
        header = next(reader)

        # get index of a column name
        apihandler_column_name = 'APIHandler'
        endpoint_column_name = 'APIEndPoint'
        historic_load_column_name = 'Status (Historical Load)'
        try:
            endpoint_header_index = header.index(endpoint_column_name)
            apihandler_header_index = header.index(apihandler_column_name)
            historic_load_column_index = header.index(
                historic_load_column_name)
            print(f"Index of {apihandler_column_name} is {
                apihandler_header_index}")
            print(f"Index of {endpoint_column_name} is {
                  endpoint_header_index}")
            print(f"Index of {historic_load_column_name} is {
                historic_load_column_index}")
        except Exception:
            print("One or more columns do not match expected names")
            print(f"Expected column names \n {apihandler_column_name}, {
                endpoint_column_name}, {historic_load_column_name}")
            exit(1)

        # read data rows
        data = list(reader)
        num_rows = len(data)
        print(f"Found {num_rows} rows in SJE-EDW-APIS.csv")

        # filter data by historical load value that matches Ready to Start
        historic_load_entries = [
            row for row in data if row[historic_load_column_index] == 'Ready to Start']
        print(f"Found {len(historic_load_entries)
                       } entries with Historical Load as Ready to Start")

        # if there are no entries return
        if len(historic_load_entries) == 0:
            print("No entries found with Historical Load as Ready to Start")
            exit()

        # log the time
        start = datetime.now()
        print(f"Processing started at: {start}\n")

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
