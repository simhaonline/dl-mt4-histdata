class CCSV
{
    public:
        void WriteArray(string fileName, ENUM_FILE_POSITION filePos, MqlRates& rates[]);
        void ReadLastLine(string fileName, string& lastLine[]);
};

void CCSV::WriteArray(string fileName, ENUM_FILE_POSITION filePos, MqlRates& rates[])
{
    int handle = FileOpen(fileName, FILE_WRITE|FILE_CSV);
    FileSeek(handle, 0, filePos);
    
    int numBars = ArraySize(rates);
    for(int i = 0; i < numBars; i++)
    {
        FileWrite(handle, rates[i].time, rates[i].open,
                    rates[i].high, rates[i].low, rates[i].close);
    }
    
    FileClose(handle);
}

void CCSV::ReadLastLine(string fileName,string &lastLine[])
{
    int handle = FileOpen(fileName, FILE_READ|FILE_CSV);
    while(!FileIsEnding(handle))
    {
        lastLine[0] = FileReadString(handle);
        int i = 1;
        while(!FileIsLineEnding(handle))
        {
            lastLine[i] = FileReadString(handle);
            i++;
        }
    }
    
    FileClose(handle);
}







//    while(!FileIsEnding(fileHandle))
//        {
//
//            //thisStr0 = thisStr1;
//            //thisStr1 = thisStr2;
//            //thisStr2 = thisStr3;
//            //thisStr3 = thisStr4;
//            //thisStr4 = FileReadString(fileHandle);
//            
//            Print(FileReadString(fileHandle));  // Put before while loop so that last execution is not an empty string
//            
//            //while(!FileIsLineEnding(fileHandle))
//            //{
//            //    FileReadString(fileHandle); // Read until the last field of the line
//            //}
//            
//           // Print(FileReadString(fileHandle)); // Move to next line. Last execution is an empty string
//
//        }
//    
//    //Print(TimeToStr(thisStr0));