
#Script To Download Historical Data From MetaTrader4

To download the historical data of a symbol for a timeframe, add the symbol into symbols_list.csv and the timeframe into timeframes_list.csv. The script reads the required symbols and timeframes from the two files and will not work without them. Symbols and timeframes which are not valid or available will be ignored.

When the historical data of a symbol for a timeframe is downloaded for the first time, a new comma-separated values (CSV) file is created. Whether the historical data of a symbol for a timeframe is downloaded for the first time is checked via the existence of the CSV file name. The naming of the CSV file is based on the format: “symbol_timeframe”. For example, SPX500USD_D1.

If the CSV file name does not exist, it means that the historical data of a symbol for a timeframe is downloaded for the first time. Historical data, in the format of DtOHLC (Datetime;Open;High;Low;Close), for all the history bars available is downloaded into the CSV file.

In the case the CSV file name exists, historical data for all the history bars available after the latest datetime in the CSV file is updated into the CSV file. There is a maximum to the number of history bars. As new bars are added into the history, old ones are removed. To avoid a break off in the historical data in the CSV file, the script needs to be executed while the next bar of the latest datetime in the CSV file is equal to the last bar’s datetime (earliest datetime) or within the time period of the last and first bars in MT4. Generally, it should be fine if the script is executed daily.

There is a download record, in the form of a CSV file, for each symbol. When the historical data of a symbol for a timeframe is downloaded, the following information is written into the download record: script start time, symbol, timeframe, earliest and latest datetime of the historical data.

##Revising On:
1. Logging
