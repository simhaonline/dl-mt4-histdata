class CCSV
{
    public:
        void ReadFirstLine(string fileName, string& firstLine[]);
        void ReadLastLine(string fileName, string& lastLine[]);
        void WriteMqlRatesDtOHLC(string fileName, ENUM_FILE_POSITION filePos, MqlRates& rates[]);
};

// Read the first line of a csv file into the array passed by reference
void CCSV::ReadFirstLine(string fileName,string& firstLine[])
{
    int handle = FileOpen(fileName, FILE_READ|FILE_CSV);
    FileSeek(handle, 0, SEEK_SET);
    
    int i = 0;
    while(!FileIsLineEnding(handle))
    {
        ArrayResize(firstLine, ++i);
        firstLine[i-1] = FileReadString(handle);
    }
    
    FileClose(handle);
}

// Read the last line of a csv file into the array passed by reference
void CCSV::ReadLastLine(string fileName,string& lastLine[])
{
    int handle = FileOpen(fileName, FILE_READ|FILE_CSV);
    FileSeek(handle, 0, SEEK_SET);
    
    while(!FileIsEnding(handle))
    {
        int i = 0;
        ArrayResize(lastLine, ++i);
        lastLine[i-1] = FileReadString(handle);
        
        while(!FileIsLineEnding(handle))
        {
            ArrayResize(lastLine, ++i);
            lastLine[i-1] = FileReadString(handle);
        }
    }
    
    FileClose(handle);
}


// Write MqlRates array (DtOHLC) into a csv file from the earliest datetime to the latest datetime
// Array indexing direction for rates[] should be from earliest to latest
void CCSV::WriteMqlRatesDtOHLC(string fileName, ENUM_FILE_POSITION filePos, MqlRates& rates[])
{
    int handle = FileOpen(fileName, FILE_READ|FILE_WRITE|FILE_CSV);
    FileSeek(handle, 0, filePos);
    
    int numBars = ArraySize(rates);
    for(int i=0; i < numBars; i++)
    {
        FileWrite(handle, TimeToStr(rates[i].time), rates[i].open,
                    rates[i].high, rates[i].low, rates[i].close);
    }
    
    FileClose(handle);
}