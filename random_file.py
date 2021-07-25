import csv
import random
import pandas as pd

def load_file(file_name):
    df = pd.read_csv(file_name, usecols=['resultId', 'Year', 'GP Name', 'Circuit Name', 'Circuit Location', 'Circuit Country', 'GP Date', 'Driver', 'Driver Nationality', 'Driver DOB', 'Constructor', 'Constructor Nationality', 'Driver Win?', 'points', 'laps', 'rank', 'Status', 'Constructor Points', 'Constructor Rank'])
    df3500 = df.sample(3500)
    dfd = pd.DataFrame(df3500)
    compression_opts = dict(method='zip', archive_name='out.csv')
    dfd.to_csv('out.zip', index=False, compression=compression_opts, columns=['resultId', 'Year', 'GP Name', 'Circuit Name', 'Circuit Location', 'Circuit Country', 'GP Date', 'Driver', 'Driver Nationality', 'Driver DOB', 'Constructor', 'Constructor Nationality', 'Driver Win?', 'points', 'laps', 'rank', 'Status', 'Constructor Points', 'Constructor Rank'])
    print("Done")

if __name__ == "__main__":
    load_file('compiled_data.csv')
