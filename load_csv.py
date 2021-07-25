import csv
import pandas as pd

def load_data(file_name):
    df = pd.read_csv(file_name, nrows=3500)
    dfd = pd.DataFrame(df)
    # dfd.rename(columns = [{'Circuit Name': 'CircuitName', 'Circuit Location': 'CircuitLocation', 'GP Date': 'GPDate', 'Driver Nationality': 'DriverNationality', 'Driver DOB': 'DriverDOB', 'Constructor Nationality': 'ConstructorNationality', 'Driver Win?': 'DriverWin', 'Constructor Points': 'ConstructorPoints', 'Constructor Rank': 'ConstructorRank'}])
    compression_opts = dict(method='zip', archive_name='out.csv')
    dfd.to_csv('out.zip', index=False, compression=compression_opts, columns=['resultId', 'Year', 'GPName', 'Circuit Name', 'Circuit Location', 'Circuit Country', 'GP Date', 'Driver', 'Driver Nationality', 'Driver DOB', 'Constructor', 'Constructor Nationality', 'Driver Win?', 'points', 'rank', 'Status', 'Constructor Points', 'Constructor Rank'])
load_data('compiled_data.csv')