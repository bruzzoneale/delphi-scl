{
  @SCL.Types(standard base class and helpers for file manage)
  @author(bruzzoneale)
}

unit SCL.Files;

interface

uses
{$IFDEF MSWINDOWS}
  WinApi.Windows,
  WinApi.ShellApi,
{$ENDIF}
{$IFDEF LINUX}
  Posix.Unistd,
  Posix.Stdio,
{$ENDIF}
  System.SysUtils,
  System.Classes,
  System.DateUtils,
  System.IOUtils,
  System.Masks,
  System.Generics.Collections;

type
{$REGION 'Aliases'}
  TPath = System.IOUtils.TPath;
  TFile = System.IOUtils.TFile;
  TDirectory = System.IOUtils.TDirectory;
{$ENDREGION}


  TPathHelper = record helper for TPath
  public
    class function GetDirectoryPath(const aFileName: string): string; static;
    class function ChangeDirectoryPath(const aFileName, aNewPath: string): string; static;
    class function ChangeFileName(const aFileName, aNewFileName: string): string; static;
    class function ChangeFileNameWithoutExtension(const aFileName, aNewFileName: string): string; static;
    class function ChangeExtension(const aFileName, aNewExtension: string): string; static;
    class function ExpandRelativePath(const aPath: string ): string; static ;
    class function DecodePathFromURL(const aUrlPath: string): string; static;
  end;


  TFileHelper = record helper for TFile
  public
    /// <summary>
    /// Creates a new temporary unique file and returns its name or NullString if errors occurs
    /// the default destination path is the system temporary folder
    /// the files crated with this method are automatically delete at application shutdown or manually
    /// calling @link(TFile.DeleteCreatedTempFiles) method
    /// </summary>
    class function CreateTempFile( const aFilePrefix: string = 'tpt'; const aDestPath: string = ''; const aFileExtension: string = '.tmp' ): string ; static ;
    /// <summary>
    /// Deletes temporary file created with @link(TFile.CreateTempFile) method
    /// </summary>
    class procedure DeleteCreatedTempFiles ; static ;
    /// <summary>
    ///  Move a file into the recycle bin (only windows)
    /// </summary>
    class procedure Recycle(const aFileName: string; aDeleteReadOnly: Boolean = False); overload ; static ;
    class procedure Rename(const aFileName, aNewFileName: string; aRenameReadOnly: Boolean = False ) ; static ;

    /// <summary> Reads entire content of a file into a string </summary>
    class function toString(const aFileName: string; aEncoding: TEncoding = nil): string ; static ;
    /// <summary>
    /// Returns total dymension of multiple files or returns -1 if no files found
    /// </summary>
    class function GetSize(const aFileNameOrMask: string): Int64; static;
    /// <summary>
    /// Remove the BOM from a Unicode file (if exists)
    /// </summary>
    class procedure RemoveBOMFromFile(const aFileName: string; aEncoding: TEncoding = nil); static ;
  end;

  TFileSignature = record
  public
    type TFormatType = (fmtUnknown, fmtBMP, fmtPNG, fmtJPG, fmtOLECF);
  public
    class function GetFormat(const aFileName: string): TFormatType; overload ; static;
    class function GetFormat(aStream: TStream       ): TFormatType; overload ; static;
  end;


  TFileTextReader = class
  private
    const BUFFER_SIZE = 51200;
    const CR  = 13;
    const LF  = 10;
    const NUL =  0;

  private
    FFileName: string;
    FStream  : TFileStream;
    FBuffer  : TBytes;
    FEofPosition: Int64;
    FBufferIndexStart: Integer;
    FBufferCount: Integer;

  public
    constructor Create(const aFileName: string);
    destructor Destroy; override;

    procedure Open;
    procedure Close;

    function ReadLine: string;
    function IsOpen: Boolean;
    function Eof   : Boolean;
    function Size  : Int64;
  end;


implementation

uses
  SCL.Types;


const
  SIGNATURE_MAXBYTES = 8 ;
  SIGNATURE_PNG: array[0..7] of Byte = (
     $89, $50, $4E, $47, $0D, $0A, $1A, $0A );
  SIGNATURE_JPG: array[0..2] of Byte = (
     $FF, $D8, $FF );
  SIGNATURE_BMP: array[0..1] of Byte = (
     $42, $4D );
  SIGNATURE_OFFICE_OLECF: array[0..7] of Byte = (
     $D0, $CF, $11, $E0, $A1, $B1, $1A, $E1 );


var
  FCreatedTempFiles: TStringList ;

{$REGION 'TPathHelper'}

class function TPathHelper.ChangeDirectoryPath(const aFileName, aNewPath: string): string;
begin
  Result := TPath.Combine(aNewPath, TPath.GetFileName(aFileName));
end;

class function TPathHelper.ChangeExtension(const aFileName, aNewExtension: string): string;
begin
  if aNewExtension.FirstChar <> '.' then
    Result := ChangeFileExt(aFileName, '.' + aNewExtension)
  else
    Result := ChangeFileExt(aFileName, aNewExtension);
end;

class function TPathHelper.ChangeFileName(const aFileName, aNewFileName: string): string;
begin
  Result := TPath.GetDirectoryPath(aFileName) +
            TPath.GetFileName(aNewFileName) ;
end;

class function TPathHelper.ChangeFileNameWithoutExtension(const aFileName, aNewFileName: string): string;
begin
  Result := TPath.GetDirectoryPath(aFileName) +
            TPath.GetFileNameWithoutExtension(aNewFileName) +
            TPath.GetExtension(aFileName);
end;

class function TPathHelper.DecodePathFromURL(const aUrlPath: string): string;
begin
  Result := TNetEncoding.URL.Decode(aUrlPath);
  if TPath.DirectorySeparatorChar = '\' then
    Result := Result.Replace('/', '\')
  else
    Result := Result.Replace('\', TPath.DirectorySeparatorChar);
end;

class function TPathHelper.ExpandRelativePath(const aPath: string): string;
begin
  Result := ExpandFileName(aPath);
end;

class function TPathHelper.GetDirectoryPath(const aFileName: string): string;
begin
  Result := TPath.GetDirectoryName(aFileName);
  if Result.IsNotEmpty then
    Result := Result.EnsureSuffix(TPath.DirectorySeparatorChar);
end;

{$ENDREGION}

{$REGION 'TFileHelper'}

class function TFileHelper.CreateTempFile(const aFilePrefix, aDestPath,AFileExtension: string): string;
var
  fileName, fileExt: string ;
  HFile: Integer ;
begin
  if Trim(aDestPath).IsNotNull then
    Result := TPath.ExpandRelativePath(aDestPath)
  else
    Result := TPath.GetTempPath;

  Result := Result.EnsureSuffix(TPath.DirectorySeparatorChar);

  if aFileExtension.IsNotNull then
    fileExt := aFileExtension.EnsurePrefix('.')
  else
    fileExt := '.tmp';

  repeat
    fileName := AFilePrefix + Int32.Random(100000).toStringZero(5) + fileExt ;
  until not FileExists( Result + fileName ) ;

  Result := Result + fileName  ;
  HFile  := FileCreate(Result) ;
  if HFile = -1 then
    Result := ''
  else
  begin
    FCreatedTempFiles.Add(Result) ;
    FileClose(HFile);
  end;
end;

class procedure TFileHelper.DeleteCreatedTempFiles;
var
  fileName: string;
begin
  for fileName in FCreatedTempFiles do
    if FileExists(fileName) then
      DeleteFile(fileName);

  FCreatedTempFiles.Clear;
end;

class function TFileHelper.GetSize(const AFileNameOrMask: string): Int64;
var
  SearchRec: TSearchRec;
begin
  if FindFirst(ExpandFileName(AFileNameOrMask), faAnyFile, SearchRec) = 0 then
  begin
    Result := 0;
    repeat
      Result := Result + SearchRec.Size;
    until FindNext(SearchRec) <> 0;
    FindClose(SearchRec);
  end
  else
    Result := -1;
end;
{$WARNINGS OFF}

class procedure TFileHelper.Recycle(const AFileName: string; ADeleteReadOnly: Boolean);
{$IFDEF MSWINDOWS}
var
  attr: TFileAttributes;
  ShStruct: TSHFileOpStruct;
  P1: array [byte] of char;
{$ENDIF}
begin
  if not FileExists(AFileName) then
    Exit;

{$IFDEF MSWINDOWS}

  attr := TFile.GetAttributes(AFileName);
  if ADeleteReadOnly and (TFileAttribute.faReadOnly in attr) then
    TFile.SetAttributes(AFileName, attr - [TFileAttribute.faReadOnly]);

  FillChar(P1,sizeof(P1),0);
  StrPCopy(P1,ExpandFileName(AFileName)+#0#0);
  with ShStruct do
  begin
    wnd := 0;
    wFunc := FO_DELETE;
    pFrom := P1;
    pTo   := nil;
    fFlags:= FOF_ALLOWUNDO or FOF_NOCONFIRMATION;
    fAnyOperationsAborted := false;
    hNameMappings := nil;
  end;

  if (ShFileOperation(ShStruct) <> 0) or FileExists(AFileName) then
    raise EFilerError.CreateFmt( 'Error Deleting file %s', [AFileName] ) ;

{$ELSE}
  Delete(AFileName) ;
{$ENDIF}
end;

class procedure TFileHelper.RemoveBOMFromFile(const AFileName: string;
  AEncoding: TEncoding);
var
  fs: TFileStream;
  buffer, preamble: TBytes;

  function PreambleCompare: Boolean;
  var
    idx: Integer;
  begin
    Result := True;
    for idx := 0 to Length(preamble)-1 do
      if buffer[idx] <> preamble[idx] then
        Exit(False);
  end;

begin
  if AEncoding = nil then
    AEncoding := TEncoding.UTF8;

  preamble := AEncoding.GetPreamble;
  fs := TFileStream.Create(AFileName, fmOpenReadWrite);
  try
    if fs.Size > Length(Preamble) then
    begin
      SetLength(buffer,fs.Size);
      fs.Read(buffer,fs.Size);
      if PreambleCompare then
      begin
        fs.Seek(0, soBeginning);
        fs.Write(buffer,Length(preamble),fs.Size-Length(preamble));
        fs.Size := fs.Size-Length(preamble);
      end;
    end;
  finally
    fs.Free;
  end;
end;

class procedure TFileHelper.Rename(const AFileName, ANewFileName: string; ARenameReadOnly: Boolean);
{$IFDEF MSWINDOWS}
var
  attr: TFileAttributes;
{$ENDIF}
begin
  if not FileExists(AFileName) then
    Exit;

{$IFDEF MSWINDOWS}
  attr := TFile.GetAttributes(AFileName);
  if ARenameReadOnly and (TFileAttribute.faReadOnly in attr) then
    TFile.SetAttributes(AFileName, attr - [TFileAttribute.faReadOnly]);
{$ENDIF}

  if FileExists(ANewFileName) then
    DeleteFile(ANewFileName);

  RenameFile(AFileName, ANewFileName) ;
end;

{$WARNINGS ON}

class function TFileHelper.toString(const AFileName: string; AEncoding: TEncoding ): string;
begin
  if AEncoding = nil then
    AEncoding := TEncoding.Default;

  Result := TFile.ReadAllText(AFileName, AEncoding);
end;

{$ENDREGION}

{$REGION 'TFileSignature'}

class function TFileSignature.GetFormat(aStream: TStream): TFormatType;
var
  buffer: TBytes;
  idx: Integer;

  function CheckBuff(arr: array of Byte): boolean;
  var
    idx: Integer;
  begin
    for idx := 0 to High(arr) do
      if buffer[idx] <> arr[idx] then
        Exit(False);

    Result := true;
  end;

begin
  SetLength(buffer,SIGNATURE_MAXBYTES);
  for idx := 0 to High(buffer) do
    buffer[idx] := 0;

  idx := aStream.Position;
  aStream.Position := 0;
  aStream.Read(buffer, SIGNATURE_MAXBYTES);
  aStream.Position := idx;

  if CheckBuff(SIGNATURE_PNG) then
    Result := fmtPNG
  else
  if CheckBuff(SIGNATURE_JPG) then
    Result := fmtJPG
  else
  if CheckBuff(SIGNATURE_BMP) then
    Result := fmtBMP
  else
  if CheckBuff(SIGNATURE_OFFICE_OLECF) then
    Result := fmtOLECF
  else
    Result := fmtUnknown;
end;

class function TFileSignature.GetFormat(const aFileName: string): TFormatType;
var
  stream: TFileStream;
begin
  stream := TFileStream.Create(aFileName, fmOpenRead);
  try
    Result := GetFormat(stream);
  finally
    stream.Free;
  end;
end;

{$ENDREGION}

{$REGION 'TFileTextReader' }

constructor TFileTextReader.Create(const aFileName: string);
begin
  FFileName := aFileName;
  SetLength(FBuffer, BUFFER_SIZE);
end;

destructor TFileTextReader.Destroy;
begin
  Close;
  inherited;
end;

function TFileTextReader.IsOpen: Boolean;
begin
  Result := Assigned(FStream) ;
end;

procedure TFileTextReader.Open;
begin
  if not IsOpen then
  begin
    FStream      := TFileStream.Create(FFileName, fmOpenRead or fmShareDenyWrite);
    FEofPosition := FStream.Size;

    FBufferIndexStart := 0;
    FBufferCount      := 0;
  end;
end;

procedure TFileTextReader.Close;
begin
  FreeAndNil(FStream);
end;

function TFileTextReader.Eof: Boolean;
begin
  if not IsOpen then
    Open;

  Result := (FStream.Position >= FEofPosition) and (FBufferCount = 0);
end;

function TFileTextReader.Size: Int64;
begin
  if IsOpen then
    Result := FEofPosition
  else
    Result := TFile.GetSize(FFileName);
end;

function TFileTextReader.ReadLine: string;
var
  eolFound: Boolean;
  idx, eolIdx: Integer;
begin
  Result   := '';
  eolFound := False;
  eolIdx   := 0;
  while not eolFound and not Eof do
  begin
    if FBufferCount = 0 then
    begin
      FBufferCount := FStream.Read(FBuffer,Length(FBuffer));
      FBufferIndexStart := 0 ;
    end;

    for idx := FBufferIndexStart to FBufferCount do
      if FBuffer[idx] in [NUL,CR,LF] then
      begin
        eolIdx   := idx ;
        eolFound := True;
        Break;
      end;

    if not eolFound then
    begin
      eolIdx := FBufferCount;
      FBufferCount := 0 ;
    end;

    try
      Result := Result + TEncoding.UTF8.GetString(FBuffer,FBufferIndexStart,eolIdx-FBufferIndexStart);
    except
      on E: EEncodingError do
        Result := Result + TEncoding.ANSI.GetString(FBuffer,FBufferIndexStart,eolIdx-FBufferIndexStart)
    else
        raise;
    end;

    if eolFound then
    begin
      FBufferIndexStart := eolIdx;
      while (FBufferIndexStart < FBufferCount) and (FBuffer[FBufferIndexStart] in [NUL,CR,LF]) do
        Inc(FBufferIndexStart);

      if FBufferIndexStart = FBufferCount then
        FBufferCount := 0;
    end;
  end;
end;

{$ENDREGION}

initialization
  FCreatedTempFiles := TStringList.Create ;

finalization
  TFile.DeleteCreatedTempFiles ;
  FreeAndNil(FCreatedTempFiles) ;

end.
