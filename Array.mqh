// Remove an array's element while maintaining the order
void RmArrElement(string& arr[], int index)
{
    for(int iLast = ArraySize(arr)-1; index < iLast; index++) arr[index] = arr[index+1];
    ArrayResize(arr, iLast);
}
