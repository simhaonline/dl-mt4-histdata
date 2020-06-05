#include <CSV.mqh>
#include <CheckSymbolTimeframe.mqh>
#include <Array.mqh>
#include <stdlib.mqh>

void OnStart()
{
    string scriptStartTime = TimeToStr(TimeLocal());
    string symLsFileName = "GetHistoricalData/symbols_list.csv";
    string tfLsFileName = "GetHistoricalData/timeframes_list.csv";
    
    if(FileIsExist(symLsFileName) && FileIsExist(tfLsFileName))
    {
        CCSV CSVFile;
        string symbolsList[];
        string timeframesList[];
        
        // Get the required symbols and timeframes from the csv files
        CSVFile.ReadFirstLine(symLsFileName, symbolsList);
        CSVFile.ReadFirstLine(tfLsFileName, timeframesList);
        
        for(int i = ArraySize(symbolsList)-1; i >= 0; i--)
        {
            // Check whether a symbol is valid and if invalid, skip to the next symbol
            if(!IsSymbol(symbolsList[i]))
            {
                Print(symbolsList[i] + " is an invalid symbol");
                continue;
            }
            
            string symUpdatesFileName = "GetHistoricalData/" + symbolsList[i] + "/" +
                                            symbolsList[i] + "_dl_records.csv";
            int updatesFileHandle = FileOpen(symUpdatesFileName, FILE_READ|FILE_WRITE|FILE_CSV);
            FileSeek(updatesFileHandle, 0, SEEK_END);
            
            for(int j = ArraySize(timeframesList)-1; j >= 0; j--)
            {
                ENUM_TIMEFRAMES timeframe = tfStrToEnum(timeframesList[j]);
                
                // Check whether a timeframe is valid and if invalid, remove from timeframesList and skip to the next timeframe
                if(timeframe == WRONG_VALUE)
                {
                    Print(timeframesList[j] + " is an invalid timeframe");
                    RmArrElement(timeframesList, j); // Does not affect the loop because j is decremental
                    continue;
                }
                
                string splitedStr[];
                ushort sepChar = StringGetChar("_", 0);
                int numSubStr = StringSplit(EnumToString(timeframe), sepChar, splitedStr);
    
                string symFileName = "GetHistoricalData/" + symbolsList[i] + "/" +
                                        symbolsList[i] + "_" + splitedStr[numSubStr-1] + ".csv";                
                MqlRates rates[];
                int barsCopied;
                int lastErr;
                
                if(FileIsExist(symFileName))
                {
                    string csvLastLine[];
                    CSVFile.ReadLastLine(symFileName, csvLastLine);
                    
                    // Get data on all the available history bars after the latest datetime in the csv file
                    int lastBarIndex = iBarShift(symbolsList[i], timeframe, StrToTime(csvLastLine[0]));
                    int startBarIndex = lastBarIndex - 1;
                    barsCopied = CopyRates(symbolsList[i], timeframe, 1, startBarIndex, rates);
                    if(barsCopied <= 0)
                    {
                        lastErr = GetLastError();
                        if(lastBarIndex == 1) Print(symbolsList[i] + EnumToString(timeframe)
                                                        + "Data is up-to-date. Latest datetime is " + csvLastLine[0]);
                        else Print(symbolsList[i] + " " + EnumToString(timeframe)
                                    + "Error " + IntegerToString(lastErr) + " " + ErrorDescription(lastErr));
                        continue;
                    }
                    
                    CSVFile.WriteMqlRatesDtOHLC(symFileName, SEEK_END, rates);
                }
                else
                {
                    // Get data on all the available history bars
                    int totalHistBars = Bars(symbolsList[i], timeframe);
                    barsCopied = CopyRates(symbolsList[i], timeframe, 1, totalHistBars, rates);
                    if(barsCopied <= 0)
                    {
                        lastErr = GetLastError();
                        Print(symbolsList[i] + " " + EnumToString(timeframe)
                                + "Error " + IntegerToString(lastErr) + " " + ErrorDescription(lastErr));
                        continue;
                    }
    
                    CSVFile.WriteMqlRatesDtOHLC(symFileName, SEEK_SET, rates);
                }
                
                FileWrite(updatesFileHandle, scriptStartTime, symbolsList[i],
                            splitedStr[numSubStr-1], TimeToStr(rates[0].time), TimeToStr(rates[barsCopied-1].time));
            }
            
            FileClose(updatesFileHandle);
        }
    }
    else if(!FileIsExist(symLsFileName))
    {
        if(!FileIsExist(tfLsFileName)) Print("symbols_list.csv and timeframes_list.csv not found");
        else Print("symbols_list.csv not found");
    }
    else Print("timeframes_list.csv not found");
}