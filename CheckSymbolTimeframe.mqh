// Check whether a symbol is available
bool IsSymbol(string symbol)
{
    for(int i = SymbolsTotal(false)-1; i >= 0; i--)
    {
        if(symbol == SymbolName(i, false)) return(true);
    }
    
    return(false);
}

// Check whether a timeframe is available and if available, convert it to an enum type
ENUM_TIMEFRAMES tfStrToEnum(string period)
{
    ENUM_TIMEFRAMES tfList[21] = {
                                  PERIOD_M1, PERIOD_M2, PERIOD_M3,
                                  PERIOD_M4, PERIOD_M5, PERIOD_M6,
                                  PERIOD_M10, PERIOD_M12, PERIOD_M15,
                                  PERIOD_M20, PERIOD_M30, PERIOD_H1,
                                  PERIOD_H2, PERIOD_H3, PERIOD_H4,
                                  PERIOD_H6, PERIOD_H8, PERIOD_H12,
                                  PERIOD_D1, PERIOD_W1, PERIOD_MN1
                                 };
                             
    for(int i = ArraySize(tfList)-1; i >= 0; i--)
    {
        if(period == EnumToString(tfList[i])) return(tfList[i]);
    }
    
    return(WRONG_VALUE);
}