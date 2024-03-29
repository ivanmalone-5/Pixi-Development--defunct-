{------------------------------------------------------------------------------}
{                                                                              }
{  TFindFile v4.12                                                             }
{  by Kambiz R. Khojasteh                                                      }
{                                                                              }
{  kambiz@delphiarea.com                                                       }
{  http://www.delphiarea.com                                                   }
{                                                                              }
{------------------------------------------------------------------------------}
{ Edit: Source unmodified, formatting, captilization, tabs etc have been changed
  to my own style. Ivan. 23/11/2011

  Added TSearch - a wrapper for quicker access to TFindFile functionality

  Note: if using threaded mode code must be kept threadsafe when using TFindFile
}


{$IFDEF COMPILER6_UP}
  {$WARN SYMBOL_PLATFORM OFF} // This is Win32, no warning for FindData record
{$ENDIF}

unit uFindFile;

interface

uses
  Windows, Messages, Classes, SysUtils;

// =============================================================================
const
  FILE_ATTRIBUTE_READONLY            = $00000001;
  {$IFDEF COMPILER4_UP}
  {$EXTERNALSYM FILE_ATTRIBUTE_READONLY}
  {$ENDIF}
  FILE_ATTRIBUTE_HIDDEN              = $00000002;
  {$IFDEF COMPILER4_UP}
  {$EXTERNALSYM FILE_ATTRIBUTE_HIDDEN}
  {$ENDIF}
  FILE_ATTRIBUTE_SYSTEM              = $00000004;
  {$IFDEF COMPILER4_UP}
  {$EXTERNALSYM FILE_ATTRIBUTE_SYSTEM}
  {$ENDIF}
  FILE_ATTRIBUTE_DIRECTORY           = $00000010;
  {$IFDEF COMPILER4_UP}
  {$EXTERNALSYM FILE_ATTRIBUTE_DIRECTORY}
  {$ENDIF}
  FILE_ATTRIBUTE_ARCHIVE             = $00000020;
  {$IFDEF COMPILER4_UP}
  {$EXTERNALSYM FILE_ATTRIBUTE_ARCHIVE}
  {$ENDIF}
  FILE_ATTRIBUTE_DEVICE              = $00000040;
  {$IFDEF COMPILER4_UP}
  {$EXTERNALSYM FILE_ATTRIBUTE_DEVICE}
  {$ENDIF}
  FILE_ATTRIBUTE_NORMAL              = $00000080;
  {$IFDEF COMPILER4_UP}
  {$EXTERNALSYM FILE_ATTRIBUTE_NORMAL}
  {$ENDIF}
  FILE_ATTRIBUTE_TEMPORARY           = $00000100;
  {$IFDEF COMPILER4_UP}
  {$EXTERNALSYM FILE_ATTRIBUTE_TEMPORARY}
  {$ENDIF}
  FILE_ATTRIBUTE_SPARSE_FILE         = $00000200;
  {$IFDEF COMPILER4_UP}
  {$EXTERNALSYM FILE_ATTRIBUTE_SPARSE_FILE}
  {$ENDIF}
  FILE_ATTRIBUTE_REPARSE_POINT       = $00000400;
  {$IFDEF COMPILER4_UP}
  {$EXTERNALSYM FILE_ATTRIBUTE_REPARSE_POINT}
  {$ENDIF}
  FILE_ATTRIBUTE_COMPRESSED          = $00000800;
  {$IFDEF COMPILER4_UP}
  {$EXTERNALSYM FILE_ATTRIBUTE_COMPRESSED}
  {$ENDIF}
  FILE_ATTRIBUTE_OFFLINE             = $00001000;
  {$IFDEF COMPILER4_UP}
  {$EXTERNALSYM FILE_ATTRIBUTE_OFFLINE}
  {$ENDIF}
  FILE_ATTRIBUTE_NOT_CONTENT_INDEXED = $00002000;
  {$IFDEF COMPILER4_UP}
  {$EXTERNALSYM FILE_ATTRIBUTE_NOT_CONTENT_INDEXED}
  {$ENDIF}
  FILE_ATTRIBUTE_ENCRYPTED           = $00004000;
  {$IFDEF COMPILER4_UP}
  {$EXTERNALSYM FILE_ATTRIBUTE_ENCRYPTED}
  {$ENDIF}
  FILE_ATTRIBUTE_VIRTUAL             = $00010000;
  {$IFDEF COMPILER4_UP}
  {$EXTERNALSYM FILE_ATTRIBUTE_VIRTUAL}
  {$ENDIF}
// =============================================================================




// =============================================================================
Type        TTargetPath         =         class(TObject)
            PRIVATE
            fFolder             :         String;
            fFileMasks          :         TStringList;
            fRecursive          :         Boolean;
            fMinLevel           :         Word;
            fMaxLevel           :         Word;
            PUBLIC
            CONSTRUCTOR Create;
            DESTRUCTOR Destroy; override;
            PROPERTY Folder: string read fFolder write fFolder;
            PROPERTY FileMasks: TStringList read fFileMasks;
            PROPERTY Recursive: Boolean read fRecursive write fRecursive;
            PROPERTY MinLevel: Word read fMinLevel write fMinLevel;
            PROPERTY MaxLevel: Word read fMaxLevel write fMaxLevel;
end;
// -----------------------------------------------------------------------------
Type        TTargetPaths        =         class(TList)
            PRIVATE
              FUNCTION GetItems(Index: Integer): TTargetPath;
            PROTECTED
               {$IFDEF COMPILER5_UP}
               PROCEDURE Notify(Ptr: Pointer; Action: TListNotification); override;
               {$ENDIF}
               FUNCTION ExtractMeta(const Info: String; var Recursive: Boolean;
                                    var MinLevel, MaxLevel: Integer): String;
            PUBLIC
              {$IFNDEF COMPILER5_UP}
                PROCEDURE Clear; override;
                PROCEDURE Delete(Index: Integer);
              {$ENDIF}
                FUNCTION Find(const Folder: String): TTargetPath;
                FUNCTION AddPath(const PathInfo: String; Recursive: Boolean;
                                  MinLevel, MaxLevel: Integer): TTargetPath;
                FUNCTION AddFolderAndMasks(const FolderInfo: String; FileMasks: TStringList;
                                           Recursive: Boolean; MinLevel, MaxLevel: Integer): TTargetPath;
                PROPERTY Items[Index: Integer]: TTargetPath read GetItems; default;
            end;
// -----------------------------------------------------------------------------
type        TCustomCriteria      =       class(TPersistent)
              PUBLIC
                PROCEDURE Clear; virtual; abstract;
              end;
// -----------------------------------------------------------------------------
type          TFileCriteria = class(TCustomCriteria)
            PRIVATE
              fFileName: String;
              fLocation: String;
              fPaths: TStringList;
              fSubfolders: Boolean;
              fMinLevel: Word;
              fMaxLevel: Word;
              fFilters: TStringList;
              fTargetPaths: TTargetPaths;
              FUNCTION GetTargetPaths: TTargetPaths;
              PROCEDURE SetFileName(const Value: String);
              PROCEDURE SetLocation(const Value: String);
              PROCEDURE SetPaths(Value: TStringList);
              PROCEDURE SetMinLevel(Value: Word);
              PROCEDURE SetMaxLevel(Value: Word);
              PROCEDURE SetSubfolders(Value: Boolean);
              PROCEDURE SetFilters(Value: TStringList);
              PROCEDURE TargetPathsChanged(Sender: TObject);
          PROTECTED
              PROPERTY TargetPaths: TTargetPaths read GetTargetPaths;
          PUBLIC
            CONSTRUCTOR Create;
            DESTRUCTOR Destroy; override;
            PROCEDURE Clear; override;
            PROCEDURE Assign(Source: TPersistent); override;
            FUNCTION Matches(const Folder, FileName: String): Boolean;
          PUBLISHED
            PROPERTY FileName: String read fFileName write SetFileName;
            PROPERTY Location: String read fLocation write SetLocation;
            PROPERTY Paths: TStringList read fPaths write SetPaths;
            PROPERTY Subfolders: Boolean read fSubfolders write SetSubfolders default True;
            PROPERTY MinLevel: Word read fMinLevel write SetMinLevel default 0;
            PROPERTY MaxLevel: Word read fMaxLevel write SetMaxLevel default 0;
            PROPERTY Filters: TStringList read fFilters write SetFilters;
        end;
// -----------------------------------------------------------------------------
type      TFileAttributeStatus = (fsIgnore, fsSet, fsUnset, fsAnySet, fsAnyUnset);
// -----------------------------------------------------------------------------
type      TAttributesCriteria = class(TCustomCriteria)
          PRIVATE
            fOnAttributes: DWORD;
            fOffAttributes: DWORD;
            fAnyOnAttributes: DWORD;
            fAnyOffAttributes: DWORD;
            FUNCTION GetAttribute(Index: Integer): TFileAttributeStatus;
            PROCEDURE SetAttribute(Index: Integer; Value: TFileAttributeStatus);
          PROTECTED
            PROPERTY OnAttributes: DWORD read fOnAttributes write fOnAttributes;
            PROPERTY OffAttributes: DWORD read fOffAttributes write fOffAttributes;
            PROPERTY AnyOnAttributes: DWORD read fAnyOnAttributes write fAnyOnAttributes;
            PROPERTY AnyOffAttributes: DWORD read fAnyOffAttributes write fAnyOffAttributes;
          PUBLIC
            CONSTRUCTOR Create;
            PROCEDURE Assign(Source: TPersistent); override;
            PROCEDURE Clear; override;
            FUNCTION Matches(Attr: DWORD): Boolean;
          PUBLISHED
            PROPERTY Readonly: TFileAttributeStatus index 1 read GetAttribute write SetAttribute default fsIgnore;
            PROPERTY Hidden: TFileAttributeStatus index 2 read GetAttribute write SetAttribute default fsUnset;
            PROPERTY System: TFileAttributeStatus index 3 read GetAttribute write SetAttribute default fsUnset;
            PROPERTY Directory: TFileAttributeStatus index 5 read GetAttribute write SetAttribute default fsUnset;
            PROPERTY Archive: TFileAttributeStatus index 6 read GetAttribute write SetAttribute default fsIgnore;
            PROPERTY Device: TFileAttributeStatus index 7 read GetAttribute write SetAttribute default fsIgnore;
            PROPERTY Normal: TFileAttributeStatus index 8 read GetAttribute write SetAttribute default fsIgnore;
            PROPERTY Temporary: TFileAttributeStatus index 9 read GetAttribute write SetAttribute default fsIgnore;
            PROPERTY SparseFile: TFileAttributeStatus index 10 read GetAttribute write SetAttribute default fsIgnore;
            PROPERTY ReparsePoint: TFileAttributeStatus index 11 read GetAttribute write SetAttribute default fsIgnore;
            PROPERTY Compressed: TFileAttributeStatus index 12 read GetAttribute write SetAttribute default fsIgnore;
            PROPERTY Offline: TFileAttributeStatus index 13 read GetAttribute write SetAttribute default fsIgnore;
            PROPERTY NotContentIndexed: TFileAttributeStatus index 14 read GetAttribute write SetAttribute default fsIgnore;
            PROPERTY Encrypted: TFileAttributeStatus index 15 read GetAttribute write SetAttribute default fsIgnore;
            PROPERTY Virtual: TFileAttributeStatus index 17 read GetAttribute write SetAttribute default fsIgnore;
        end;
// -----------------------------------------------------------------------------
type        TDateTimeCriteria = class(TCustomCriteria)
            PRIVATE
             fCreatedBefore: TDateTime;
             fCreatedAfter: TDateTime;
             fModifiedBefore: TDateTime;
             fModifiedAfter: TDateTime;
             fAccessedBefore: TDateTime;
             fAccessedAfter: TDateTime;
          PUBLIC
            PROCEDURE Assign(Source: TPersistent); override;
            PROCEDURE Clear; override;
            FUNCTION Matches(const Created, Modified, Accessed: TFileTime): Boolean;
          PUBLISHED
            PROPERTY CreatedBefore: TDateTime read fCreatedBefore write fCreatedBefore;
            PROPERTY CreatedAfter: TDateTime read fCreatedAfter write fCreatedAfter;
            PROPERTY ModifiedBefore: TDateTime read fModifiedBefore write fModifiedBefore;
            PROPERTY ModifiedAfter: TDateTime read fModifiedAfter write fModifiedAfter;
            PROPERTY AccessedBefore: TDateTime read fAccessedBefore write fAccessedBefore;
            PROPERTY AccessedAfter: TDateTime read fAccessedAfter write fAccessedAfter;
      end;
// -----------------------------------------------------------------------------
type  TFileSize = {$IFDEF COMPILER4_UP} Int64 {$ELSE} DWORD {$ENDIF};
// -----------------------------------------------------------------------------
type  TSizeCriteria = class(TCustomCriteria)
          PRIVATE
            fMin: TFileSize;
            fMax: TFileSize;
          PUBLIC
            PROCEDURE Assign(Source: TPersistent); override;
            PROCEDURE Clear; override;
            FUNCTION Matches(const Size: TFileSize): Boolean;
          PUBLISHED
            PROPERTY Min: TFileSize read fMin write fMin default 0;
            PROPERTY Max: TFileSize read fMax write fMax default 0;
  end;
// -----------------------------------------------------------------------------
type      TContentSearchOption = (csoCaseSensitive, csoWholeWord, csoNegate);
type      TContentSearchOptions = set of TContentSearchOption;
// -----------------------------------------------------------------------------
type      PStringVariants = ^TStringVariants;
            TStringVariants = record
            Ansi: AnsiString;
            Unicode: WideString;
            Utf8: AnsiString;
          end;
// -----------------------------------------------------------------------------
type      TContentCriteria = class(TCustomCriteria)
          PRIVATE
            fPhrase: String;
            fPhraseVariants: TStringVariants;
            fOptions: TContentSearchOptions;
            PROCEDURE SetPhrase(const Value: String);
          PROTECTED
            PROPERTY PhraseVariants: TStringVariants read fPhraseVariants;
          PUBLIC
            PROCEDURE Assign(Source: TPersistent); override;
            PROCEDURE Clear; override;
            FUNCTION Matches(const FileName: String): Boolean;
          PUBLISHED
            PROPERTY Phrase: String read fPhrase write SetPhrase;
            PROPERTY Options: TContentSearchOptions read fOptions write fOptions default [];
  end;
// -----------------------------------------------------------------------------
type      TSearchCriteria = class(TCustomCriteria)
          PRIVATE
            fFiles: TFileCriteria;
            fAttributes: TAttributesCriteria;
            fTimeStamp: TDateTimeCriteria;
            fSize: TSizeCriteria;
            fContent: TContentCriteria;
            PROCEDURE SetFiles(Value: TFileCriteria);
            PROCEDURE SetAttributes(Value: TAttributesCriteria);
            PROCEDURE SetTimeStamp(Value: TDateTimeCriteria);
            PROCEDURE SetSize(Value: TSizeCriteria);
            PROCEDURE SetContent(Value: TContentCriteria);
          PUBLIC
            CONSTRUCTOR Create;
            DESTRUCTOR Destroy; override;
            PROCEDURE Assign(Source: TPersistent); override;
            PROCEDURE Clear; override;
            FUNCTION Matches(const Folder: String; const FindData: TWin32FindData): Boolean;
          PUBLISHED
            PROPERTY Files: TFileCriteria read fFiles write SetFiles;
            PROPERTY Attributes: TAttributesCriteria read fAttributes write SetAttributes;
            PROPERTY TimeStamp: TDateTimeCriteria read fTimeStamp write SetTimeStamp;
            PROPERTY Size: TSizeCriteria read fSize write SetSize;
            PROPERTY Content: TContentCriteria read fContent write SetContent;
  end;
// -----------------------------------------------------------------------------
type  TFolderIgnore = (fiNone, fiJustThis, fiJustSubfolders, fiThisAndSubfolders);
// -----------------------------------------------------------------------------
type  TFolderChangeEvent = PROCEDURE (Sender: TObject; const Folder: String;
    var IgnoreFolder: TFolderIgnore) of object;
// -----------------------------------------------------------------------------
type        PFileDetails = ^TFileDetails;
            TFileDetails = record
            Location: String;
            Name: TFileName;
            Attributes: DWORD;
            Size: TFileSize;
            CreatedTime: TDateTime;
            ModifiedTime: TDateTime;
            AccessedTime: TDateTime;
  end;
// -----------------------------------------------------------------------------
type        TFileMatchEvent = PROCEDURE (Sender: TObject; const FileInfo: TFileDetails) of object;
// -----------------------------------------------------------------------------
type        TFindFile = class(TComponent)
          PRIVATE
            fCriteria: TSearchCriteria;
            fThreaded: Boolean;
            fThreadPriority: TThreadPriority;
            fAborted: Boolean;
            fBusy: Boolean;
            fCurrentLevel: Word;
            fOnFileMatch: TFileMatchEvent;
            fOnFolderChange: TFolderChangeEvent;
            fOnSearchBegin: TNotifyEvent;
            fOnSearchFinish: TNotifyEvent;
            fThreadWnd: HWND;
            ActiveCriteria: TSearchCriteria;
            ActiveTarget: TTargetPath;
            SubfolderOffAttrs: DWORD;
            SearchThread: TThread;
            PROCEDURE SetCriteria(Value: TSearchCriteria);
            PROCEDURE InitializeSearch;
            PROCEDURE FinalizeSearch;
            PROCEDURE SearchForFiles;
            PROCEDURE SearchIn(const Path: String);
            PROCEDURE ThreadWndCallback(var Msg: TMessage);
          PROTECTED
            PROCEDURE DoSearchBegin; virtual;
            PROCEDURE DoSearchFinish; virtual;
            FUNCTION DoFolderChange(const Folder: String): TFolderIgnore; virtual;
            PROCEDURE DoFileMatch(const Folder: String; const FindData: TWin32FindData); virtual;
            FUNCTION IsAcceptable(const Folder: String; const FindData: TWin32FindData): Boolean; virtual;
            PROPERTY ThreadWnd: HWND read fThreadWnd;
          PUBLIC
            CONSTRUCTOR Create(AOwner: TComponent); override;
            DESTRUCTOR Destroy; override;
            PROCEDURE Execute;
            PROCEDURE Abort;
            PROPERTY Busy: Boolean read fBusy;
            PROPERTY Aborted: Boolean read fAborted;
            PROPERTY CurrentLevel: Word read fCurrentLevel;
          PUBLISHED
            PROPERTY Criteria: TSearchCriteria read fCriteria write SetCriteria;
            PROPERTY Threaded: Boolean read fThreaded write fThreaded default False;
            PROPERTY ThreadPriority: TThreadPriority read fThreadPriority write fThreadPriority default tpNormal;
            PROPERTY OnFileMatch: TFileMatchEvent read fOnFileMatch write fOnFileMatch;
            PROPERTY OnFolderChange: TFolderChangeEvent read fOnFolderChange write fOnFolderChange;
            PROPERTY OnSearchBegin: TNotifyEvent read fOnSearchBegin write fOnSearchBegin;
            PROPERTY OnSearchFinish: TNotifyEvent read fOnSearchFinish write fOnSearchFinish;
          end;
// =============================================================================
PROCEDURE Register;


// =============================================================================
      FUNCTION FormatFileSize(const Size: TFileSize): String;
      FUNCTION FileTimeToDateTime(const FileTime: TFileTime): TDateTime;
      FUNCTION WildcardMatches(S, M: PChar): Boolean;
      FUNCTION FileContains(const FileName: String; const Phrase: String;
                            Options: TContentSearchOptions): Boolean;
// =============================================================================






// =============================================================================
// TSearch is a simplified wrapper for TFindFile - added for my own use
// 24/11/2011 - Ivan
// =============================================================================
Type        TOnFoundFileEvent       =       PROCEDURE(Sender : TObject; aFileName : TFileName) of object;

Type        TSearch                 =       class(TComponent)
            Private
            FFoundFiles             :       TStringList;
            FOnFoundFileEvent       :       TOnFoundFileEvent;
            FOnFinishedSearch       :       TNotifyEvent;
            FOnStartSearch          :       TNotifyEvent;
            PROCEDURE FFileSearch();
            Public
            CONSTRUCTOR Create(AOwner : TComponent); override;
            DESTRUCTOR Destroy(); override;
            PROCEDURE BeginSearch();
            PROCEDURE StopSearch();
            Published
            PROPERTY OnFoundFile : TOnFoundFileEvent read FOnFoundFileEvent write FOnFoundFileEvent;
            PROPERTY OnFinishedSearch : TNotifyEvent read FOnFinishedSearch write FOnFinishedSearch;
            PROPERTY OnStartSearch : TNotifyEvent read FOnStartSearch write FOnStartSearch;

            Protected
end;
implementation

{$IFNDEF COMPILER6_UP}

uses Forms;
{$ENDIF}


// =============================================================================
const
  Delimiter   = ';';
  IncludeSign = '>';
  ExcludeSign = '<';
// -----------------------------------------------------------------------------
const
  FF_THREADTERMINATED = WM_USER + 1;
// -----------------------------------------------------------------------------
const
  SubfolderOffAttrsMask =
    FILE_ATTRIBUTE_HIDDEN or FILE_ATTRIBUTE_SYSTEM or
    FILE_ATTRIBUTE_DEVICE or FILE_ATTRIBUTE_TEMPORARY or
    FILE_ATTRIBUTE_OFFLINE or FILE_ATTRIBUTE_ENCRYPTED or
    FILE_ATTRIBUTE_VIRTUAL;
// -----------------------------------------------------------------------------
{ Character Map for faster case-insensitive search }
// -----------------------------------------------------------------------------
// =============================================================================



// =============================================================================
type
  PAnsiCharMap = ^TAnsiCharMap;
  TAnsiCharMap = array[AnsiChar] of AnsiChar;
  PWideCharMap = ^TWideCharMap;
  TWideCharMap = array[WideChar] of WideChar;
// -----------------------------------------------------------------------------
var
  AnsiCharMap: TAnsiCharMap;
  AnsiLowerCharMap: TAnsiCharMap;
  AnsiIsDelimiter: array[AnsiChar] of Boolean;
  WideCharMap: TWideCharMap;
  WideLowerCharMap: TWideCharMap;
  WideIsDelimiter: array[WideChar] of Boolean;
// =============================================================================


// =============================================================================
PROCEDURE InitFastContentSearch;
var
  AC: AnsiChar;
  WC: WideChar;
begin
  for AC := Low(TAnsiCharMap) to High(TAnsiCharMap) do
  begin
    AnsiCharMap[AC] := AC;
    AnsiLowerCharMap[AC] := AC;
    AnsiIsDelimiter[AC] := not IsCharAlphaNumericA(AC);
  end;
  AnsiLowerBuff(PAnsiChar(@AnsiLowerCharMap), SizeOf(AnsiLowerCharMap));
  for WC := Low(TWideCharMap) to High(TWideCharMap) do
  begin
    WideCharMap[WC] := WC;
    WideLowerCharMap[WC] := WC;
    WideIsDelimiter[WC] := not IsCharAlphaNumericW(WC);
  end;
  AnsiLowerBuff(PAnsiChar(@WideLowerCharMap), SizeOf(WideLowerCharMap));
end;





// =============================================================================
{ Helper FUNCTIONs }
{$IFNDEF COMPILER5_UP}
FUNCTION IncludeTrailingBackslash(const Path: String): String;
begin
  Result := Path;
  if (Length(Result) > 0) and (Result[Length(Result)] <> '\') then
    Result := Result + '\';
end;
{$ENDIF}
// =============================================================================
{$IFNDEF COMPILER6_UP}
FUNCTION UTF8Encode(const S: WideString): AnsiString;
var
  Size: Integer;
begin
  if S <> '' then
  begin
    SetString(Result, nil, Length(S) * 6); // assume worst case
    Size := WideCharToMultiByte(CP_UTF8, 0, PWideChar(S), Length(S),
      PAnsiChar(Result), Length(Result), nil, nil);
    SetLength(Result, Size);
  end
  else
    Result := '';
end;
{$ENDIF}
// =============================================================================
FUNCTION DecodeUTF8Char(Buffer: PAnsiChar; Count: Integer): WideChar;
  {$IFDEF COMPILER2005_UP} inline; {$ENDIF}
begin
  Result := #0;
  MultiByteToWideChar(CP_UTF8, 0, Buffer, Count, @Result, 1);
end;
// =============================================================================
{$IFNDEF UNICODE}
FUNCTION AnsiStringToWideString(const S: AnsiString): WideString;
var
  Len: Integer;
begin
  if S <> '' then
  begin
    Len := MultiByteToWideChar(CP_ACP, MB_PRECOMPOSED, PAnsiChar(S), -1, nil, 0);
    SetString(Result, nil, Len - 1);
    MultiByteToWideChar(CP_ACP, MB_PRECOMPOSED, PAnsiChar(S), -1, PWideChar(Result), Len);
  end
  else
    Result := '';
end;
{$ENDIF}
// =============================================================================
FUNCTION StringVariantsOf(const S: String): TStringVariants;
begin
  with Result do
  begin
    {$IFDEF UNICODE}
    Ansi := AnsiString(S);
    Unicode := WideString(S);
    {$ELSE}
    Ansi := S;
    Unicode := AnsiStringToWideString(S);
    {$ENDIF}
    Utf8 := UTF8Encode(Unicode);
  end;
end;
// =============================================================================
FUNCTION StreamContainsPhraseAnsi(Stream: TStream; const Phrase: PAnsiChar;
  PhraseLen: Integer; Options: TContentSearchOptions): Boolean;
const
  MaxBufferSize = $F000;
var
  CharMap: PAnsiCharMap;
  PrvChar, NxtChar: AnsiChar;
  Buffer: array[0..MaxBufferSize-1] of AnsiChar;
  BufferSize: Integer;
  BufferEnd: PAnsiChar;
  PhraseEnd: PAnsiChar;
  bp, pp: PAnsiChar;
begin
  if csoCaseSensitive in Options then
    CharMap := @AnsiCharMap
  else
    CharMap := @AnsiLowerCharMap;
  PrvChar := #0;
  PhraseEnd := Phrase;
  Inc(PhraseEnd, PhraseLen);
  pp := Phrase;
  BufferSize := Stream.Read(Buffer, MaxBufferSize);
  while BufferSize > 0 do
  begin
    bp := @Buffer;
    BufferEnd := @Buffer[BufferSize];
    repeat
      if (CharMap^[bp^] = CharMap^[pp^]) and ((pp <> Phrase) or
         not (csoWholeWord in Options) or AnsiIsDelimiter[PrvChar]) then
      begin
        Inc(pp);
        if pp = PhraseEnd then
        begin
          if csoWholeWord in Options then
          begin
            Inc(bp);
            if bp = BufferEnd then
            begin
    if Stream.Read(NxtChar, SizeOf(NxtChar)) = 0 then
      NxtChar := #0;
            end
            else
    NxtChar := bp^;
            if AnsiIsDelimiter[NxtChar] then
            begin
    Result := not (csoNegate in Options);
    Exit;
            end;
            if bp = BufferEnd then
    Stream.Seek(-SizeOf(NxtChar), soFromCurrent);
            Dec(bp);
            pp := Phrase;
          end
          else
          begin
            Result := not (csoNegate in Options);
            Exit;
          end;
        end;
      end
      else if pp <> Phrase then
      begin
        pp := Phrase;
        Continue;
      end;
      PrvChar := bp^;
      Inc(bp);
    until bp = BufferEnd;
    BufferSize := Stream.Read(Buffer, MaxBufferSize);
  end;
  Result := (csoNegate in Options);
end;
// =============================================================================
FUNCTION StreamContainsPhraseWide(Stream: TStream; const Phrase: PWideChar;
  PhraseLen: Integer; Options: TContentSearchOptions; Swapped: Boolean): Boolean;
const
  MaxBufferSize = $F000;
var
  CharMap: PWideCharMap;
  PrvChar, NxtChar: WideChar;
  Buffer: array[0..MaxBufferSize-1] of WideChar;
  BufferSize: Integer;
  BufferEnd: PWideChar;
  PhraseEnd: PWideChar;
  bp, pp: PWideChar;
begin
  if csoCaseSensitive in Options then
    CharMap := @WideCharMap
  else
    CharMap := @WideLowerCharMap;
  PrvChar := #0;
  PhraseEnd := Phrase;
  Inc(PhraseEnd, PhraseLen);
  pp := Phrase;
  BufferSize := Stream.Read(Buffer, MaxBufferSize) shr 1;
  while BufferSize > 0 do
  begin
    bp := @Buffer;
    BufferEnd := @Buffer[BufferSize];
    repeat
      if Swapped then
        PWORD(bp)^ := MakeWord(HiByte(PWORD(bp)^), LoByte(PWORD(bp)^));
      if (CharMap^[bp^] = CharMap^[pp^]) and ((pp <> Phrase) or
         not (csoWholeWord in Options) or WideIsDelimiter[PrvChar]) then
      begin
        Inc(pp);
        if pp = PhraseEnd then
        begin
          if csoWholeWord in Options then
          begin
            Inc(bp);
            if bp = BufferEnd then
            begin
    if Stream.Read(NxtChar, SizeOf(NxtChar)) = 0 then
      NxtChar := #0;
            end
            else
    NxtChar := bp^;
            if Swapped then
    NxtChar := WideChar(MakeWord(HiByte(WORD(NxtChar)), LoByte(WORD(NxtChar))));
            if WideIsDelimiter[NxtChar] then
            begin
    Result := not (csoNegate in Options);
    Exit;
            end;
            if bp = BufferEnd then
    Stream.Seek(-SizeOf(NxtChar), soFromCurrent);
            Dec(bp);
            pp := Phrase;
          end
          else
          begin
            Result := not (csoNegate in Options);
            Exit;
          end;
        end;
      end
      else if pp <> Phrase then
      begin
        pp := Phrase;
        Continue;
      end;
      PrvChar := bp^;
      Inc(bp);
    until bp = BufferEnd;
    BufferSize := Stream.Read(Buffer, MaxBufferSize) shr 1;
  end;
  Result := (csoNegate in Options);
end;
// =============================================================================
FUNCTION StreamContainsPhraseUtf8(Stream: TStream; const Phrase: PAnsiChar;
  PhraseLen: Integer; Options: TContentSearchOptions): Boolean;
const
  MaxBufferSize = $F000;
var
  CharMap: PAnsiCharMap;
  PrvChars, NxtChars: array[0..7] of AnsiChar;
  PrvLen, NxtLen: Integer;
  PrvReady: Boolean;
  Rollback: Integer;
  Buffer: array[0..MaxBufferSize-1] of AnsiChar;
  BufferSize: Integer;
  BufferEnd: PAnsiChar;
  PhraseEnd: PAnsiChar;
  bp, pp, np: PAnsiChar;
begin
  if csoCaseSensitive in Options then
    CharMap := @AnsiCharMap
  else
    CharMap := @AnsiLowerCharMap;
  PrvReady := True;
  PrvLen := 0;
  PhraseEnd := Phrase;
  Inc(PhraseEnd, PhraseLen);
  pp := Phrase;
  BufferSize := Stream.Read(Buffer, MaxBufferSize);
  while BufferSize > 0 do
  begin
    bp := @Buffer;
    BufferEnd := @Buffer[BufferSize];
    repeat
      if (PrvReady or (pp <> Phrase)) and
         (CharMap^[bp^] = CharMap^[pp^]) and
         ((pp <> Phrase) or not (csoWholeWord in Options) or
         WideIsDelimiter[DecodeUTF8Char(PrvChars, PrvLen)]) then
      begin
        Inc(pp);
        if pp = PhraseEnd then
        begin
          if csoWholeWord in Options then
          begin
            np := bp;
            Inc(np);
            NxtLen := 0;
            Rollback := 0;
            repeat
    if np = BufferEnd then
    begin
      if Stream.Read(NxtChars[NxtLen], 1) = 1 then
        Inc(Rollback)
      else
        Break;
    end
    else
    begin
      NxtChars[NxtLen] := np^;
      Inc(np);
    end;
    if (NxtLen > 0) and ((Ord(NxtChars[NxtLen]) and $C0) = $C0) then
      Break;
    Inc(NxtLen);
            until ((Ord(NxtChars[NxtLen-1]) and $80) = 0) or (NxtLen > High(NxtChars));
            if WideIsDelimiter[DecodeUTF8Char(NxtChars, NxtLen)] then
            begin
    Result := not (csoNegate in Options);
    Exit;
            end;
            if Rollback <> 0 then
    Stream.Seek(-Rollback, soFromCurrent);
            pp := Phrase;
          end
          else
          begin
            Result := not (csoNegate in Options);
            Exit;
          end;
        end;
      end
      else if pp <> Phrase then
      begin
        pp := Phrase;
        Continue;
      end;
      if PrvReady then
        PrvLen := 0;
      PrvChars[PrvLen] := bp^;
      Inc(PrvLen);
      PrvReady := ((Ord(bp^) and $80) = 0) or (PrvLen > High(PrvChars));
      Inc(bp);
      PrvReady := PrvReady or ((Ord(bp^) and $C0) = $C0);
    until bp = BufferEnd;
    BufferSize := Stream.Read(Buffer, MaxBufferSize);
  end;
  Result := (csoNegate in Options);
end;
// =============================================================================
FUNCTION FileContainsPhrase(const FileName: String;
  const Phrase: TStringVariants; Options: TContentSearchOptions): Boolean;
const
  UNICODE_BOM: WideChar = #$FEFF;
  UNICODE_BOM_SWAPPED: WideChar = #$FFFE;
  UTF8_BOM: array[1..3] of AnsiChar = (#$EF, #$BB, #$BF);
var
  Stream: TFileStream;
  BOMBytes: array[1..3] of AnsiChar;
  BOM: WideChar absolute BOMBytes;
  BOMSize: Integer;
begin
  Stream := TFileStream.Create(FileName, fmOpenRead or fmShareDenyNone);
  try
    BOMSize := Stream.Read(BOM, SizeOf(BOM));
    if BOMSize = SizeOf(BOM) then
    begin
      if (BOM = UNICODE_BOM) or (BOM = UNICODE_BOM_SWAPPED) then
      begin
        Result := StreamContainsPhraseWide(Stream, PWideChar(Phrase.Unicode),
          Length(Phrase.Unicode), Options, BOM = UNICODE_BOM_SWAPPED);
        Exit;
      end
      else if (BOMBytes[1] = UTF8_BOM[1]) and (BOMBytes[2] = UTF8_BOM[2]) then
      begin
        Inc(BOMSize, Stream.Read(BOMBytes[3], SizeOf(BOMBytes[3])));
        if (BOMSize = SizeOf(UTF8_BOM)) and (BOMBytes[3] = UTF8_BOM[3]) then
        begin
          Result := StreamContainsPhraseUtf8(Stream, PAnsiChar(Phrase.Utf8),
            Length(Phrase.Utf8), Options);
          Exit;
        end;
      end;
    end;
    Stream.Seek(-BOMSize, soFromCurrent);
    Result := StreamContainsPhraseAnsi(Stream, PAnsiChar(Phrase.Ansi),
      Length(Phrase.Ansi), Options);
  finally
    Stream.Free;
  end;
end;
// =============================================================================
FUNCTION FileContains(const FileName: String;
  const Phrase: String; Options: TContentSearchOptions): Boolean;
begin
  if Length(Phrase) > 0 then
    Result := FileContainsPhrase(FileName, StringVariantsOf(Phrase), Options)
  else
    Result := True;
end;
// =============================================================================
FUNCTION FormatFileSize(const Size: TFileSize): String;
const
  KB = 1024;
  MB = 1024 * KB;
  GB = 1024 * MB;
begin
  if Size < KB then
    Result := FormatFloat('#,##0 Bytes', Size)
  else if Size < MB then
    Result := FormatFloat('#,##0.0 KB', Size / KB)
  else if Size < GB then
    Result := FormatFloat('#,##0.0 MB', Size / MB)
  else
    Result := FormatFloat('#,##0.0 GB', Size / GB);
end;
// =============================================================================
FUNCTION FileTimeToDateTime(const FileTime: TFileTime): TDateTime;
var
  LocalFileTime: TFileTime;
  SystemTime: TSystemTime;
begin
  FileTimeToLocalFileTime(FileTime, LocalFileTime);
  FileTimeToSystemTime(LocalFileTime, SystemTime);
  Result := SystemTimeToDateTime(SystemTime);
end;
// =============================================================================
FUNCTION IsDateBetween(const aDate, Before, After: TDateTime): Boolean;
begin
  Result := True;
  if Before <> 0 then
    if Frac(Before) = 0 then      { Checks date only }
      Result := Result and (Int(aDate) <= Before)
    else if Int(Before) = 0 then  { Checks time only }
      Result := Result and (Frac(aDate) <= Before)
    else                { Checks date and time }
      Result := Result and (aDate <= Before);
  if After <> 0 then
    if Frac(After) = 0 then       { Checks date only }
      Result := Result and (Int(aDate) >= After)
    else if Int(After) = 0 then   { Checks time only }
      Result := Result and (Frac(aDate) >= After)
    else                { Checks date and time }
      Result := Result and (aDate >= After);
end;
// =============================================================================
FUNCTION WildcardMatches(S, M: PChar): Boolean;
const
  {$IFDEF UNICODE}
  CharMap: PWideCharMap = @WideLowerCharMap;
  {$ELSE}
  CharMap: PAnsiCharMap = @AnsiLowerCharMap;
  {$ENDIF}
var
  Stop: Char;
begin
  Result := False;
  while (S^ <> #0) and (M^ <> #0) and (M^ <> '*') do
  begin
    if (M^ <> '?') and (CharMap^[M^] <> CharMap^[S^]) then
      Exit;
    Inc(S);
    Inc(M);
  end;
  if (S^ = #0) or (M^ = '*') then
  begin
    while (M^ = '*') or (M^ = '?') do
      Inc(M);
    if (S^ = #0) or (M^ = #0) then
      Result := (M^ = #0)
    else
    begin
      Stop := CharMap^[M^];
      Inc(M);
      while (S^ <> #0) and not Result do
      begin
        while (CharMap^[S^] <> Stop) and (S^ <> #0) do
          Inc(S);
        if S^ <> #0 then
        begin
          Inc(S);
          Result := WildcardMatches(S, M);
        end;
      end;
    end;
  end;
end;
// =============================================================================
FUNCTION StringListFromString(const Str: String; Delimiter: Char): TStringList;
var
  Item: String;
  StartIndex: Integer;
  DelimiterPos: Integer;
  StrLen: Integer;
begin
  Result := TStringList.Create;
  StrLen := Length(Str);
  StartIndex := 1;
  repeat
    DelimiterPos := StartIndex;
    while (DelimiterPos <= StrLen) and (Str[DelimiterPos] <> Delimiter) do
      Inc(DelimiterPos);
    if StartIndex <> DelimiterPos then
    begin
      Item := Trim(Copy(Str, StartIndex, DelimiterPos - StartIndex));
      if (Item <> '') and (Result.IndexOf(Item) < 0) then
        Result.Add(Item);
    end;
    StartIndex := DelimiterPos + 1;
  until StartIndex > StrLen;
end;


// =============================================================================
{ TTargetPath }
CONSTRUCTOR TTargetPath.Create;
begin
  inherited Create;
  fFileMasks := TStringList.Create;
  fFileMasks.Duplicates := dupIgnore;
  {$IFDEF COMPILER6_UP}
  fFileMasks.CaseSensitive := False;
  {$ENDIF}
end;
// -----------------------------------------------------------------------------
DESTRUCTOR TTargetPath.Destroy;
begin
  fFileMasks.Free;
  inherited Destroy;
end;
// -----------------------------------------------------------------------------
{ TTargetPaths }
{$IFDEF COMPILER5_UP}
PROCEDURE TTargetPaths.Notify(Ptr: Pointer; Action: TListNotification);
begin
  if (Action = lnDeleted) and Assigned(Ptr) then
    TTargetPath(Ptr).Free;
end;
{$ENDIF}
// -----------------------------------------------------------------------------
{$IFNDEF COMPILER5_UP}
PROCEDURE TTargetPaths.Clear;
var
  I: Integer;
  Ptr: Pointer;
begin
  for I := Count - 1 downto 0 do
  begin
    Ptr := Get(I);
    if Assigned(Ptr) then
      TTargetPath(Ptr).Free;
  end;
  inherited Clear;
end;
{$ENDIF}
// -----------------------------------------------------------------------------
{$IFNDEF COMPILER5_UP}
PROCEDURE TTargetPaths.Delete(Index: Integer);
var
  Ptr: Pointer;
begin
  Ptr := Get(Index);
  if Assigned(Ptr) then
    TTargetPath(Ptr).Free;
  inherited Delete(Index);
end;
{$ENDIF}
// -----------------------------------------------------------------------------
FUNCTION TTargetPaths.Find(const Folder: String): TTargetPath;
var
  I: Integer;
begin
  for I := 0 to Count - 1 do
  begin
    Result := Items[I];
    if CompareText(Result.Folder, Folder) = 0 then
      Exit;
  end;
  Result := nil;
end;
// -----------------------------------------------------------------------------
FUNCTION TTargetPaths.AddPath(const PathInfo: String; Recursive: Boolean;
  MinLevel, MaxLevel: Integer): TTargetPath;
var
  FileMask: String;
  Folder: String;
begin
  FileMask := ExtractFileName(PathInfo);
  Folder := ExtractMeta(ExtractFilePath(PathInfo), Recursive, MinLevel, MaxLevel);
  Result := Find(Folder);
  if not Assigned(Result) then
  begin
    Result := TTargetPath.Create;
    Add(Result);
  end;
  Result.Folder := Folder;
  Result.Recursive := Recursive;
  Result.MinLevel := MinLevel;
  Result.MaxLevel := MaxLevel;
  if FileMask <> '' then
    Result.FileMasks.Add(FileMask)
  else
    Result.FileMasks.Add('*.*');
end;
// -----------------------------------------------------------------------------
FUNCTION TTargetPaths.AddFolderAndMasks(const FolderInfo: String;
  FileMasks: TStringList; Recursive: Boolean;
  MinLevel, MaxLevel: Integer): TTargetPath;
var
  Folder: String;
begin
  Folder := ExtractMeta(FolderInfo, Recursive, MinLevel, MaxLevel);
  Result := Find(Folder);
  if not Assigned(Result) then
  begin
    Result := TTargetPath.Create;
    Add(Result);
  end;
  Result.Folder := Folder;
  Result.Recursive := Recursive;
  Result.MinLevel := MinLevel;
  Result.MaxLevel := MaxLevel;
  if Assigned(FileMasks) and (FileMasks.Count > 0) then
    Result.FileMasks.AddStrings(FileMasks)
  else
    Result.FileMasks.Add('*.*');
end;
// -----------------------------------------------------------------------------
FUNCTION TTargetPaths.ExtractMeta(const Info: String; var Recursive: Boolean;
  var MinLevel, MaxLevel: Integer): String;
var
  P, L: Integer;
  Level: String;
begin
  Result := Info;
  P := Pos(IncludeSign, Info);
  if P <> 0 then
  begin
    System.Delete(Result, 1, P);
    Recursive := True;
    if P > 1 then
    begin
      Level := Trim(Copy(Info, 1, P - 1));
      P := Pos('-', Level);
      if P = 0 then
      begin
        L := StrToIntDef(Level, MaxLevel);
        MinLevel := 0;
        MaxLevel := L;
      end
      else
      begin
        MinLevel := StrToIntDef(Trim(Copy(Level, 1, P - 1)), MinLevel);
        MaxLevel := StrToIntDef(Trim(Copy(Level, P + 1, Length(Level) - P)), MaxLevel);
      end;
    end;
  end
  else
  begin
    P := Pos(ExcludeSign, Info);
    if P <> 0 then
    begin
      System.Delete(Result, 1, P);
      Recursive := False;
    end;
  end;
  Result := ExpandUNCFileName(Trim(Result));
  {$IFDEF COMPILER7_UP}
  Result := IncludeTrailingPathDelimiter(Result);
  {$ELSE}
  Result := IncludeTrailingBackslash(Result);
  {$ENDIF}
end;
// -----------------------------------------------------------------------------
FUNCTION TTargetPaths.GetItems(Index: Integer): TTargetPath;
begin
  Result := TTargetPath(Get(Index));
end;
// =============================================================================


// =============================================================================
{ TFileCriteria }
CONSTRUCTOR TFileCriteria.Create;
begin
  inherited Create;
  fPaths := TStringList.Create;
  fPaths.Duplicates := dupIgnore;
  {$IFDEF COMPILER6_UP}
  fPaths.CaseSensitive := False;
  {$ENDIF}
  fPaths.OnChange := TargetPathsChanged;
  fSubfolders := True;
  fMinLevel := 0;
  fMaxLevel := 0;
  fFilters := TStringList.Create;
  fFilters.Duplicates := dupIgnore;
  {$IFDEF COMPILER6_UP}
  fFilters.CaseSensitive := False;
  {$ENDIF}
end;
// -----------------------------------------------------------------------------
DESTRUCTOR TFileCriteria.Destroy;
begin
  fPaths.Free;
  fFilters.Free;
  if Assigned(fTargetPaths) then
    fTargetPaths.Free;
  inherited Destroy;
end;
// -----------------------------------------------------------------------------
PROCEDURE TFileCriteria.Assign(Source: TPersistent);
begin
  if Source is TFileCriteria then
  begin
    FileName := TFileCriteria(Source).FileName;
    Location := TFileCriteria(Source).Location;
    Paths := TFileCriteria(Source).Paths;
    Filters := TFileCriteria(Source).Filters;
    Subfolders := TFileCriteria(Source).Subfolders;
    MinLevel := TFileCriteria(Source).MinLevel;
    MaxLevel := TFileCriteria(Source).MaxLevel;
  end
  else
    inherited Assign(Source);
end;
// -----------------------------------------------------------------------------
PROCEDURE TFileCriteria.Clear;
begin
  FileName := '';
  Location := '';
  Paths.Clear;
  Subfolders := True;
  MinLevel := 0;
  MaxLevel := 0;
  Filters.Clear;
end;
// -----------------------------------------------------------------------------
FUNCTION TFileCriteria.Matches(const Folder, FileName: String): Boolean;
var
  I: Integer;
  Path: String;
  Mask: PChar;
begin
  Result := True;
  if Filters.Count <> 0 then
  begin
    Path := Folder + FileName;
    if ExtractFileExt(FileName) = '' then
      Path := Path + '.';
    for I := 0 to Filters.Count - 1 do
    begin
      Mask := PChar(Filters[I]);
      if Mask^ = IncludeSign then
      begin
        Inc(Mask);
        if WildcardMatches(PChar(Path), Mask) then
           Exit;
      end
      else
      begin
        if Mask^ = ExcludeSign then
          Inc(Mask);
        if WildcardMatches(PChar(Path), Mask) then
        begin
          Result := False;
          Exit;
        end;
      end;
    end;
  end;
end;
// -----------------------------------------------------------------------------
FUNCTION TFileCriteria.GetTargetPaths: TTargetPaths;
var
  I: Integer;
  Files: TStringList;
  Folders: TStringList;
  Path: String;
begin
  if not Assigned(fTargetPaths) then
  begin
    fTargetPaths := TTargetPaths.Create;
    // Add FileName and Location properties
    Files := StringListFromString(FileName, Delimiter);
    try
      if Files.Count = 0 then
        Files.Add('*.*');
      Folders := StringListFromString(Location, Delimiter);
      try
        for I := 0 to Folders.Count - 1 do
          fTargetPaths.AddFolderAndMasks(Folders[I], Files,
            Subfolders, MinLevel, MaxLevel);
      finally
        Folders.Free;
      end;
    finally
      Files.Free;
    end;
    // Add Paths PROPERTY
    for I := 0 to Paths.Count - 1 do
    begin
      Path := Trim(Paths[I]);
      if Path <> '' then
        fTargetPaths.AddPath(Path, Subfolders, MinLevel, MaxLevel)
    end;
  end;
  Result := fTargetPaths;
end;
// -----------------------------------------------------------------------------
PROCEDURE TFileCriteria.SetFileName(const Value: String);
begin
  if fFileName <> Value then
  begin
    fFileName := Value;
    TargetPathsChanged(nil);
  end;
end;
// -----------------------------------------------------------------------------
PROCEDURE TFileCriteria.SetLocation(const Value: String);
begin
  if fLocation <> Value then
  begin
    fLocation := Value;
    TargetPathsChanged(nil);
  end;
end;
// -----------------------------------------------------------------------------
PROCEDURE TFileCriteria.SetPaths(Value: TStringList);
begin
  fPaths.Assign(Value);
end;
// -----------------------------------------------------------------------------
PROCEDURE TFileCriteria.SetFilters(Value: TStringList);
begin
  fFilters.Assign(Value);
end;
// -----------------------------------------------------------------------------
PROCEDURE TFileCriteria.SetSubfolders(Value: Boolean);
begin
  if fSubfolders <> Value then
  begin
    fSubfolders := Value;
    TargetPathsChanged(nil);
  end;
end;
// -----------------------------------------------------------------------------
PROCEDURE TFileCriteria.SetMinLevel(Value: Word);
begin
  if fMinLevel <> Value then
  begin
    fMinLevel := Value;
    TargetPathsChanged(nil);
  end;
end;
// -----------------------------------------------------------------------------
PROCEDURE TFileCriteria.SetMaxLevel(Value: Word);
begin
  if fMaxLevel <> Value then
  begin
    fMaxLevel := Value;
    TargetPathsChanged(nil);
  end;
end;
// -----------------------------------------------------------------------------
PROCEDURE TFileCriteria.TargetPathsChanged(Sender: TObject);
begin
  if Assigned(fTargetPaths) then
  begin
    fTargetPaths.Free;
    fTargetPaths := nil;
  end;
end;
// =============================================================================



// =============================================================================
{ TAttributesCriteria }
CONSTRUCTOR TAttributesCriteria.Create;
begin
  inherited Create;
  fOnAttributes := 0;
  fOffAttributes := FILE_ATTRIBUTE_HIDDEN or FILE_ATTRIBUTE_SYSTEM or FILE_ATTRIBUTE_DIRECTORY;
  fAnyOnAttributes := 0;
  fAnyOffAttributes := 0;
end;
// -----------------------------------------------------------------------------
PROCEDURE TAttributesCriteria.Assign(Source: TPersistent);
begin
  if Source is TAttributesCriteria then
  begin
    OnAttributes := TAttributesCriteria(Source).OnAttributes;
    OffAttributes := TAttributesCriteria(Source).OffAttributes;
    AnyOnAttributes := TAttributesCriteria(Source).AnyOnAttributes;
    AnyOffAttributes := TAttributesCriteria(Source).AnyOffAttributes;
  end
  else
    inherited Assign(Source);
end;
// -----------------------------------------------------------------------------
PROCEDURE TAttributesCriteria.Clear;
begin
  OnAttributes := 0;
  OffAttributes := 0;
  AnyOnAttributes := 0;
  AnyOffAttributes := 0;
end;
// -----------------------------------------------------------------------------
FUNCTION TAttributesCriteria.Matches(Attr: DWORD): Boolean;
begin
  Result := False;
  if ((Attr and OnAttributes) = OnAttributes) and
     ((not Attr and OffAttributes) = OffAttributes) then
  begin
    if (AnyOnAttributes <> 0) and not LongBool(Attr and AnyOnAttributes) then
      Exit;
    if (AnyOffAttributes <> 0) and not LongBool(not Attr and AnyOffAttributes) then
      Exit;
    Result := True;
  end;
end;
// -----------------------------------------------------------------------------
FUNCTION TAttributesCriteria.GetAttribute(Index: Integer): TFileAttributeStatus;
var
  Attr: DWORD;
begin
  Attr := $00000001 shl (Index - 1);
  if LongBool(Attr and fOnAttributes) then
    Result := fsSet
  else if LongBool(Attr and fOffAttributes) then
    Result := fsUnset
  else if LongBool(Attr and fAnyOnAttributes) then
    Result := fsAnySet
  else if LongBool(Attr and fAnyOffAttributes) then
    Result := fsAnyUnset
  else
    Result := fsIgnore;
end;
// -----------------------------------------------------------------------------
PROCEDURE TAttributesCriteria.SetAttribute(Index: Integer; Value: TFileAttributeStatus);
var
  Attr: DWORD;
begin
  Attr := $00000001 shl (Index - 1);
  fOnAttributes := fOnAttributes and not Attr;
  fOffAttributes := fOffAttributes and not Attr;
  fAnyOnAttributes := fAnyOnAttributes and not Attr;
  fAnyOffAttributes := fAnyOffAttributes and not Attr;
  case Value of
    fsSet: fOnAttributes := fOnAttributes or Attr;
    fsUnset: fOffAttributes := fOffAttributes or Attr;
    fsAnySet: fAnyOnAttributes := fAnyOnAttributes or Attr;
    fsAnyUnset: fAnyOffAttributes := fAnyOffAttributes or Attr;
  end;
end;
// =============================================================================




// =============================================================================
{ TDateTimeCriteria }
PROCEDURE TDateTimeCriteria.Assign(Source: TPersistent);
begin
  if Source is TDateTimeCriteria then
  begin
    CreatedBefore := TDateTimeCriteria(Source).CreatedBefore;
    CreatedAfter := TDateTimeCriteria(Source).CreatedAfter;
    ModifiedBefore := TDateTimeCriteria(Source).ModifiedBefore;
    ModifiedAfter := TDateTimeCriteria(Source).ModifiedAfter;
    AccessedBefore := TDateTimeCriteria(Source).AccessedBefore;
    AccessedAfter := TDateTimeCriteria(Source).AccessedAfter;
  end
  else
    inherited Assign(Source);
end;
// -----------------------------------------------------------------------------
PROCEDURE TDateTimeCriteria.Clear;
begin
  CreatedBefore := 0;
  CreatedAfter := 0;
  ModifiedBefore := 0;
  ModifiedAfter := 0;
  AccessedBefore := 0;
  AccessedAfter := 0;
end;
// -----------------------------------------------------------------------------
FUNCTION TDateTimeCriteria.Matches(const Created, Modified, Accessed: TFileTime): Boolean;
var
  DateTime: TDateTime;
begin
  Result := False;
  if (CreatedBefore <> 0) or (CreatedAfter <> 0) then
  begin
    DateTime := FileTimeToDateTime(Created);
    if not IsDateBetween(DateTime, CreatedBefore, CreatedAfter) then Exit;
  end;
  if (ModifiedBefore <> 0) or (ModifiedAfter <> 0) then
  begin
    DateTime := FileTimeToDateTime(Modified);
    if not IsDateBetween(DateTime, ModifiedBefore, ModifiedAfter) then Exit;
  end;
  if (AccessedBefore <> 0) or (AccessedAfter <> 0) then
  begin
    DateTime := FileTimeToDateTime(Accessed);
    if not IsDateBetween(DateTime, AccessedBefore, AccessedAfter) then Exit;
  end;
  Result := True;
end;
// =============================================================================


// =============================================================================
{ TSizeCriteria }
PROCEDURE TSizeCriteria.Assign(Source: TPersistent);
begin
  if Source is TSizeCriteria then
  begin
    Min := TSizeCriteria(Source).Min;
    Max := TSizeCriteria(Source).Max;
  end
  else
    inherited Assign(Source);
end;
// -----------------------------------------------------------------------------
PROCEDURE TSizeCriteria.Clear;
begin
  fMin := 0;
  fMax := 0;
end;
// -----------------------------------------------------------------------------
FUNCTION TSizeCriteria.Matches(const Size: TFileSize): Boolean;
begin
  Result := ((Min = 0) or (Size >= Min)) and ((Max = 0) or (Size <= Max));
end;
// =============================================================================


// =============================================================================
{ TContentCriteria }
PROCEDURE TContentCriteria.Assign(Source: TPersistent);
begin
  if Source is TContentCriteria then
  begin
    Phrase := TContentCriteria(Source).Phrase;
    Options := TContentCriteria(Source).Options;
  end
  else
    inherited Assign(Source);
end;
// -----------------------------------------------------------------------------
PROCEDURE TContentCriteria.Clear;
begin
  Phrase := '';
  Options := [];
end;
// -----------------------------------------------------------------------------
FUNCTION TContentCriteria.Matches(const FileName: String): Boolean;
begin
  if Length(Phrase) > 0 then
    try
      Result := FileContainsPhrase(FileName, PhraseVariants, Options);
    except
      Result := False;
    end
  else
    Result := True;
end;
// -----------------------------------------------------------------------------
PROCEDURE TContentCriteria.SetPhrase(const Value: String);
begin
  if fPhrase <> Value then
  begin
    fPhrase := Value;
    fPhraseVariants := StringVariantsOf(fPhrase);
  end;
end;
// =============================================================================



// =============================================================================
{ TSearchCriteria }
CONSTRUCTOR TSearchCriteria.Create;
begin
  inherited Create;
  fFiles := TFileCriteria.Create;
  fAttributes := TAttributesCriteria.Create;
  fTimeStamp := TDateTimeCriteria.Create;
  fSize := TSizeCriteria.Create;
  fContent := TContentCriteria.Create;
end;
// -----------------------------------------------------------------------------
DESTRUCTOR TSearchCriteria.Destroy;
begin
  fFiles.Free;
  fAttributes.Free;
  fTimeStamp.Free;
  fSize.Free;
  fContent.Free;
  inherited Destroy;
end;
// -----------------------------------------------------------------------------
PROCEDURE TSearchCriteria.Assign(Source: TPersistent);
begin
  if Source is TSearchCriteria then
  begin
    Files := TSearchCriteria(Source).Files;
    Attributes := TSearchCriteria(Source).Attributes;
    TimeStamp := TSearchCriteria(Source).TimeStamp;
    Size := TSearchCriteria(Source).Size;
    Content := TSearchCriteria(Source).Content;
  end
  else
    inherited Assign(Source);
end;
// -----------------------------------------------------------------------------
PROCEDURE TSearchCriteria.Clear;
begin
  Files.Clear;
  Attributes.Clear;
  TimeStamp.Clear;
  Size.Clear;
  Content.Clear;
end;
// -----------------------------------------------------------------------------
FUNCTION TSearchCriteria.Matches(const Folder: String;
  const FindData: TWin32FindData): Boolean;
begin
  with FindData do
  begin
    Result :=
      Attributes.Matches(dwFileAttributes) and
      Size.Matches(nFileSizeLow {$IFDEF COMPILER4_UP} or (Int64(nFileSizeHigh) shl 32) {$ENDIF}) and
      TimeStamp.Matches(ftCreationTime, ftLastWriteTime, ftLastAccessTime) and
      Files.Matches(Folder, String(FindData.cFileName)) and
      Content.Matches(Folder + String(FindData.cFileName));
  end;
end;
// -----------------------------------------------------------------------------
PROCEDURE TSearchCriteria.SetFiles(Value: TFileCriteria);
begin
  Files.Assign(Value);
end;
// -----------------------------------------------------------------------------
PROCEDURE TSearchCriteria.SetAttributes(Value: TAttributesCriteria);
begin
  Attributes.Assign(Value);
end;
// -----------------------------------------------------------------------------
PROCEDURE TSearchCriteria.SetTimeStamp(Value: TDateTimeCriteria);
begin
  TimeStamp.Assign(Value);
end;
// -----------------------------------------------------------------------------
PROCEDURE TSearchCriteria.SetSize(Value: TSizeCriteria);
begin
  Size.Assign(Value);
end;
// -----------------------------------------------------------------------------
PROCEDURE TSearchCriteria.SetContent(Value: TContentCriteria);
begin
  Content.Assign(Value);
end;
// =============================================================================



// =============================================================================
{ TSearchThread }
type
  TSearchThread = class(TThread)
  PRIVATE
    Owner: TFindFile;
  PROTECTED
    CONSTRUCTOR Create(AOwner: TFindFile);
    PROCEDURE Execute; override;
  end;
// =============================================================================




// =============================================================================
CONSTRUCTOR TSearchThread.Create(AOwner: TFindFile);
begin
  inherited Create(True);
  Owner := AOwner;
  Priority := Owner.ThreadPriority;
  Resume;
end;
// -----------------------------------------------------------------------------
PROCEDURE TSearchThread.Execute;
begin
  try
    try
      Owner.SearchForFiles;
    except
      ShowException(ExceptObject, ExceptAddr);
    end;
  finally
    PostMessage(Owner.ThreadWnd, FF_THREADTERMINATED, 0, 0);
  end;
end;
// =============================================================================




// =============================================================================
{ TFindFile }
CONSTRUCTOR TFindFile.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  fThreadWnd := AllocateHWnd(ThreadWndCallback);
  fCriteria := TSearchCriteria.Create;
  fThreaded := False;
  fThreadPriority := tpNormal;
  fAborted := False;
  fBusy := False;
end;
// -----------------------------------------------------------------------------
DESTRUCTOR TFindFile.Destroy;
begin
  if Busy then Abort;
  fCriteria.Free;
  DeallocateHWnd(fThreadWnd);
  inherited Destroy;
end;
// -----------------------------------------------------------------------------
PROCEDURE TFindFile.Abort;
begin
  if Busy then
    fAborted := True;
end;
// -----------------------------------------------------------------------------
PROCEDURE TFindFile.DoFileMatch(const Folder: String;
  const FindData: TWin32FindData);
var
  FileInfo: TFileDetails;
begin
  if not Aborted and Assigned(fOnFileMatch) then
  begin
    FileInfo.Location := Folder;
    FileInfo.Name := String(FindData.cFileName);
    FileInfo.Attributes := FindData.dwFileAttributes;
    FileInfo.Size := FindData.nFileSizeLow {$IFDEF COMPILER4_UP} or Int64(FindData.nFileSizeHigh) shl 32 {$ENDIF};
    FileInfo.CreatedTime := FileTimeToDateTime(FindData.ftCreationTime);
    FileInfo.ModifiedTime := FileTimeToDateTime(FindData.ftLastWriteTime);
    FileInfo.AccessedTime := FileTimeToDateTime(FindData.ftLastAccessTime);
    fOnFileMatch(Self, FileInfo);
  end;
end;
// -----------------------------------------------------------------------------
FUNCTION TFindFile.DoFolderChange(const Folder: String): TFolderIgnore;
begin
  Result := fiNone;
  if not Aborted and Assigned(fOnFolderChange) then
    fOnFolderChange(Self, Folder, Result);
end;
// -----------------------------------------------------------------------------
PROCEDURE TFindFile.DoSearchBegin;
begin
  if Assigned(fOnSearchBegin) then
    fOnSearchBegin(Self);
end;
// -----------------------------------------------------------------------------
PROCEDURE TFindFile.DoSearchFinish;
begin
  if Assigned(fOnSearchFinish) and not (csDestroying in ComponentState) then
    fOnSearchFinish(Self);
end;
// -----------------------------------------------------------------------------
FUNCTION TFindFile.IsAcceptable(const Folder: String;
  const FindData: TWin32FindData): Boolean;
begin
  Result := not Aborted and ActiveCriteria.Matches(Folder, FindData);
end;
// -----------------------------------------------------------------------------
PROCEDURE TFindFile.InitializeSearch;
begin
  fBusy := True;
  fAborted := False;
  ActiveCriteria := TSearchCriteria.Create;
  ActiveCriteria.Assign(fCriteria);
  SubfolderOffAttrs := ActiveCriteria.Attributes.OffAttributes and SubfolderOffAttrsMask;
  DoSearchBegin;
end;
// -----------------------------------------------------------------------------
PROCEDURE TFindFile.FinalizeSearch;
begin
  ActiveCriteria.Free;
  ActiveCriteria := nil;
  fBusy := False;
  DoSearchFinish;
end;
// -----------------------------------------------------------------------------
PROCEDURE TFindFile.SearchForFiles;
var
  I: Integer;
begin
  with ActiveCriteria.Files.TargetPaths do
    for I := 0 to Count - 1 do
    begin
      if Aborted then Exit;
      fCurrentLevel := 0;
      ActiveTarget := Items[I];
      SearchIn(ActiveTarget.Folder);
    end;
end;
// -----------------------------------------------------------------------------
PROCEDURE TFindFile.SearchIn(const Path: String);
var
  I: Integer;
  FindData: TWin32FindData;
  IgnoreFolder: TFolderIgnore;
  Handle: THandle;
begin
  if Aborted then Exit;
  Inc(fCurrentLevel);
  try
    IgnoreFolder := DoFolderChange(Path);
    with ActiveTarget do
    begin
      // Searches in the current folder for all file masks
      if (IgnoreFolder in [fiNone, fiJustSubfolders]) and (CurrentLevel >= MinLevel) then
      begin
        for I := 0 to FileMasks.Count - 1 do
        begin
          Handle := Windows.FindFirstFile(PChar(Path + FileMasks[I]), FindData);
          if Handle <> INVALID_HANDLE_VALUE then
           try
             repeat
     if Aborted then Exit;
     if (not LongBool(FindData.dwFileAttributes and FILE_ATTRIBUTE_DIRECTORY) or
        ((FindData.cFileName[0] <> '.') or ((FindData.cFileName[1] <> #0) and
        ((FindData.cFileName[1] <> '.') or (FindData.cFileName[2] <> #0))))) and
        IsAcceptable(Path, FindData)
     then
       DoFileMatch(Path, FindData);
             until not Windows.FindNextFile(Handle, FindData);
           finally
             Windows.FindClose(Handle);
           end;
        end;
      end;
      // Searches in subfolders
      if Recursive and (IgnoreFolder in [fiNone, fiJustThis]) and
        ((MaxLevel = 0) or (CurrentLevel < MaxLevel)) then
      begin
        Handle := Windows.FindFirstFile(PChar(Path + '*.*'), FindData);
        if Handle <> INVALID_HANDLE_VALUE then
          try
            repeat
    if Aborted then Exit;
    if LongBool(FindData.dwFileAttributes and FILE_ATTRIBUTE_DIRECTORY) and
       not LongBool(FindData.dwFileAttributes and SubfolderOffAttrs) and
      ((FindData.cFileName[0] <> '.') or ((FindData.cFileName[1] <> #0) and
      ((FindData.cFileName[1] <> '.') or (FindData.cFileName[2] <> #0))))
    then
      SearchIn(Path + String(FindData.cFileName) + '\');
            until not Windows.FindNextFile(Handle, FindData);
          finally
            Windows.FindClose(Handle);
          end;
      end;
    end;
  finally
    Dec(fCurrentLevel);
  end;
end;
// -----------------------------------------------------------------------------
PROCEDURE TFindFile.Execute;
begin
  if not Busy then
  begin
    if not Threaded then
    begin
      InitializeSearch;
      try
        SearchForFiles;
      finally
        FinalizeSearch;
      end;
    end
    else
    begin
      InitializeSearch;
      try
       SearchThread := TSearchThread.Create(Self);
      except
        FinalizeSearch;
        raise;
      end;
    end;
  end;
end;
// -----------------------------------------------------------------------------
PROCEDURE TFindFile.SetCriteria(Value: TSearchCriteria);
begin
  Criteria.Assign(Value);
end;
// -----------------------------------------------------------------------------
PROCEDURE TFindFile.ThreadWndCallback(var Msg: TMessage);
begin
  case Msg.Msg of
    FF_THREADTERMINATED:
    begin
      SearchThread.Free;
      SearchThread := nil;
      FinalizeSearch;
    end;
  else
    with Msg do Result := DefWindowProc(ThreadWnd, Msg, WParam, LParam);
  end;
end;
// =============================================================================



// =============================================================================
PROCEDURE Register;
begin
  RegisterComponents('Pixi', [TFindFile]);
end;
// =============================================================================








// =============================================================================
CONSTRUCTOR TSearch.Create(AOwner : TComponent);
Begin
Inherited Create(AOwner);

End;
// -----------------------------------------------------------------------------
DESTRUCTOR TSearch.Destroy();
Begin
Inherited Destroy();
End;
// -----------------------------------------------------------------------------
PROCEDURE TSearch.FFileSearch();
begin
end;
// -----------------------------------------------------------------------------
PROCEDURE TSearch.BeginSearch();
Begin

End;
// -----------------------------------------------------------------------------
PROCEDURE TSearch.StopSearch();
Begin

End;
// =============================================================================




initialization
  InitFastContentSearch;



end.
