#include <CSV.mqh>

void OnStart()
{
    CCSV CSVFile;
    
    string symbolsList[] = {"SPX500USD", "NAS100USD", "US30USD", "BCOUSD", "WTICOUSD"};
    int timeframesList[] = {PERIOD_M1, PERIOD_M5, PERIOD_H1, PERIOD_D1, PERIOD_W1, PERIOD_MN1};
    
    for(int i = ArraySize(symbolsList)-1; i >= 0; i--)
    {
        for(int j = ArraySize(timeframesList)-1; j >= 0; j--)
        {
            string tempStr[];
            ushort sepChar = StringGetChar("_", 0);
            int numSubStr = StringSplit(EnumToString(ENUM_TIMEFRAMES(timeframesList[j])), sepChar, tempStr);
            
            string symFileName = symbolsList[i] + "/" + symbolsList[i] + "_" + tempStr[numSubStr-1] + ".csv";
            MqlRates rates[];
            int barsCopied;
            
            if(FileIsExist(symFileName))
            {
                string csvLastLine[];
                CSVFile.ReadLastLine(symFileName, csvLastLine);
                
                int barIndex = iBarShift(symbolsList[i], timeframesList[j], StrToTime(csvLastLine[0]));
                int startBarIndex = barIndex - 1;
                barsCopied = CopyRates(symbolsList[i], timeframesList[j], 1, startBarIndex, rates);
                if(barsCopied <= 0) Print("Error" + (string)barsCopied);
                
                CSVFile.WriteArray(symFileName, SEEK_END, rates);
            }
            else
            {
                int totalHistBars = Bars(symbolsList[i], timeframesList[j]);
                barsCopied = CopyRates(symbolsList[i], timeframesList[j], 1, totalHistBars, rates);
                if(barsCopied <= 0) Print("Error" + (string)barsCopied);
                
                CSVFile.WriteArray(symFileName, SEEK_SET, rates);
            }
        }
    }
}