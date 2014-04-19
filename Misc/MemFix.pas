unit MemFix;

interface

uses PT4;

procedure New(var P : PNode);
procedure Dispose(var P : PNode);

implementation

uses System.Runtime.InteropServices;

[DllImport('kernel32', EntryPoint = 'GetProcessHeap')]
function GetProcessHeap : integer;
external;

[DllImport('kernel32', EntryPoint = 'HeapAlloc')]
function HeapAlloc(hHeap, flags, size : integer) : pointer;
external;
   
[DllImport('kernel32', EntryPoint = 'HeapFree')]
function HeapFree(hHeap, flags : integer; block : pointer) : boolean;
external;

const
  HEAP_ZERO_MEMORY = 8;

var
  HeapID : integer := GetProcessHeap;

procedure New(var P : PNode);
begin
  P := HeapAlloc(HeapID, HEAP_ZERO_MEMORY, 6*Sizeof(pointer));
end;

procedure Dispose(var P : PNode);
begin
  HeapFree(HeapID, 0, P);
  P := nil;
end;

end.
