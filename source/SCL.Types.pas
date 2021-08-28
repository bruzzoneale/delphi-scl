{
  @SCL.Types(standard base class and helpers for standard data types)
  @author(bruzzoneale)
}
unit SCL.Types;

interface

uses
  System.Character,
  System.StrUtils,
  System.SysUtils,
  System.Classes,
  System.Types,
  System.Math,
  System.DateUtils,
  System.Masks,
  System.Hash,
  System.NetEncoding,
  System.Generics.Collections;

const
  DEFAULT_FORMATFLOAT = '#,##0.00';
  CRLF = #13#10;
  CR   = #13;
  LF   = #10;
  QUOTE_SINGLE = #39;
  QUOTE_DOUBLE = #34;

type
  ECommonTypesException = class(Exception)
  end;

  EInvalidArgument = class(ECommonTypesException)
  end;

{$REGION 'Aliases'}
  TNetEncoding    = System.NetEncoding.TNetEncoding;
  TStringDynArray = System.Types.TStringDynArray;
{$ENDREGION}

  TTimeConvFormat = ( HHMM, HHMMSS, HHMMSSMSS );

  TIntegerHelper = record helper for Integer
  public
    const  MaxValue = 2147483647;
    const  MinValue = -2147483648;

    function Inc: Integer                      ; overload; inline ;

    function IncBy( aIncBy: Integer ): Integer ; overload; inline ;

    function Dec: Integer                      ; overload; inline ;

    function DecBy( aDecBy: Integer ): Integer ; overload; inline ;

    //-------- query methods  ---------------------------------------

    function Abs: Integer ; overload ; inline ;

    //-------- conversion methods -------------------------------------------

    function ToString: string ; overload ; inline ;

    function ToString( aLength: Integer; aLeadingChar: Char=' ' ): string ; overload ; inline ;

    function ToStringZero( aLength: Integer ): string ; inline;

    function ToStringHex: string                      ; inline ;

    function ToStringRoman: string;

    function ToStringFormat( const aFormat: string ): string ; overload ; inline ;

    function ToStringFormat( const aFormat: string; const aFormatSettings: TFormatSettings ): string ; overload ; inline ;

    /// <summary> Converts integer in a date: assuming integer value format as YYYYMMDD </summary>
    function ToDate: TDate ;

    /// <summary> Converts integer in time: assuming integer value format as HHMMSSMMS or HHMMSS or HHMM </summary>
    function ToTime(aFormat: TTimeConvFormat = HHMMSSMSS): TTime ; inline ;

    /// <summary>
    ///   Converts integer value to double assuming fixed decimal digits
    ///   Example:  ToFloatWithDecimals(20099, 2) => 200.99
    /// </summary>
    function ToFloatWithDecimals(aDecimalDigits: Integer): Double; inline ;

    //-------- utlities ----------------------------

    /// <summary>
    ///  Simple random number generator: aTotValues assuming maximun values
    ///  Example: Random(100) => a random number between 0 and 99
    /// </summary>
    class function Random( aTotValues: Integer = MaxValue): Integer ; static ;

    class procedure Swap(var aValue1, aValue2: Integer)   ; static ; inline ;
  end;



  TInt64Helper = record helper for Int64
  public
    const  MaxValue = 9223372036854775807;
    const  MinValue = -9223372036854775808;

    function Inc: Int64        ; overload ; inline ;

    function IncBy( aIncBy: Integer ): Int64 ; overload; inline ;

    //-------- query methods  ---------------------------------------

    function Abs: Int64             ; overload ; inline ;

    //-------- conversion methods -----------------------------------

    function ToString: string ; overload ; inline ;

    function ToString( aLength: Integer; aLeadingChar: Char=' ' ): string ; overload ; inline;

    function ToStringZero( aLength: Integer ): string ; inline ;

    function ToStringFormat( const aFormat: string ): string                ; overload ; inline ;

    function ToStringFormat( const aFormat: string; const aFormatSettings: TFormatSettings ): string ; overload ; inline ;
  end;


  TFloatHelper = record helper for Double
  public
    const  MaxValue:Double =  1.7976931348623157081e+308;
    const  MinValue:Double = -1.7976931348623157081e+308;

    //-------- query methods  ---------------------------------------

    function Abs : Double ; inline ;

    function Int : Double ; inline ;

    function Frac: Double ; inline ;

    //-------- conversion methods -----------------------------------

    function ToInt: Int64  ; inline ;

    function ToIntWithDecimals(aDecimalDigits: Integer): Int64 ; inline ;

    function ToRoundInt: Int64                  ; inline ;

    function ToString: string                                             ; overload ; inline ;

    function ToString(aDecimalSeparator: Char): string                    ; overload ; inline ;

    function ToString( aLength: Integer; aLeadingChar: Char=' ' ): string ; overload ; inline ;

    function ToString( aLength: Integer; aLeadingChar: Char; aDecimalSeparator: Char): string ; overload ; inline ;

    function ToStringZero( aLength: Integer ): string                         ; overload ; inline ;

    function ToStringZero( aLength: Integer; aDecimalSeparator: Char): string ; overload ; inline ;

    function ToStringFormat( const aFormat: string=DEFAULT_FORMATFLOAT ): string; overload ; inline ;

    function ToStringFormat(const aFormat: string; const aFormatSettings: TFormatSettings ): string; overload ; inline ;

    //-------- utilities ----------------------------

          function RoundTo( aDecimalDigits: Integer ): Double                ; overload ; inline ;
    class function RoundTo( aValue: Double; aDecimalDigits: Integer ): Double; overload ; static ;
  end;


  TCurrencyHelper = record helper for Currency
  public
    const MinValue: Currency = -922337203685477.5807 {$IFDEF LINUX} + 1 {$ENDIF};
    const MaxValue: Currency =  922337203685477.5807 {$IFDEF LINUX} - 1 {$ENDIF};

    //-------- query methods  ---------------------------------------

    function Abs : Currency ; overload ;

    //-------- conversion methods -----------------------------------
   
    function ToInt: Int64                 ; inline ;
    
    function ToIntWithDecimals(aDecimalDigits: Integer): Int64 ; inline ;
    
    function ToString: string                                             ; overload ; inline ;
    
    function ToString(aDecimalSeparator: Char): string                    ; overload ; inline ;
    
    function ToString( aLength: Integer; aLeadingChar: Char=' ' ): string ; overload ; inline;
    
    function ToString( aLength: Integer; aLeadingChar: Char; aDecimalSeparator: Char): string ; overload ; inline ;
    
    function ToStringZero(aLength: Integer ): string                          ; overload ;inline ;
    
    function ToStringZero( aLength: Integer; aDecimalSeparator: Char): string ; overload ; inline ;
    
    function ToStringFormat( const aFormat: string=DEFAULT_FORMATFLOAT ): string  ; overload ; inline ;

    function ToStringFormat( const aFormat: string; const aFormatSettings: TFormatSettings ): string; overload ; inline ;


          function RoundTo( aDecimalDigits: Integer ): Currency                  ; overload ; inline ;
    class function RoundTo( aValue: Currency; aDecimalDigits: Integer ): Currency; overload ; static ;
  end;



  TBaseCharSet = class
  public
    const
    VisualRangeSet: TSysCharSet = ['\','$','%','&','@','*','+','/','A'..'Z',
                                   'a'..'z','{','}','(',')','>','<','?',
                                   '0'..'9','[',']'] ;

    AlphabeticCharSet: TSysCharSet =  ['A'..'Z','a'..'z'] ;
    WordSeparatorsSet: TSysCharSet = [' ',',','.',';','/','\',':','''','"','`','(',')','[',']','{','}'] ;
    NumericSet   : TSysCharSet = ['0','1','2','3','4','5','6','7','8','9',',','.','-','+'] ;
    IntegerSet   : TSysCharSet = ['0','1','2','3','4','5','6','7','8','9','-','+'] ;
    HexIntegerSet: TSysCharSet = ['0','1','2','3','4','5','6','7','8','9','A','B','C','D','E','F','a','b','c','d','e','f','-','+'] ;
    ScientificSet: TSysCharSet = ['0','1','2','3','4','5','6','7','8','9',',','.','-','+','E','e'] ;
    BooleanTrueSet: TSysCharSet = ['1','T','t','Y','y','S','s'] ;
    BracketsSet   : TSysCharSet = ['(',')','[',']','{','}'] ;

  const
    b64_MIMEBase64 = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/';
    b64_UUEncode   = ' !"#$%&''()*+,-./0123456789:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ[\]^_';
    b64_XXEncode   = '+-0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz';
    ASCII_Standard = ' !"#$%&''()*+,-./0123456789:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ[\]^_`abcdefghijklmnopqrstuvwxyz{|}';
  end;


  /// <summary>
  ///  record helper for strings
  ///  as opposite to RTL System.SysUtils.TStringHelper, in this helper all methods manage
  ///  index string contents as 1-based for all platform
  /// </summary>
  TStringHelper = record helper for String
  private
    function GetChars(AIndex: Integer): Char; inline;
    function GetLastChar : Char; inline;
    function GetFirstChar: Char; inline;
  public
    const NullString: string = '';
    type  TCompareOption = ( coCaseInsensitive, coCaseSensitive ) ;
    type  TOptionBOM = (obWithoutBOM, obIncludeBOM);

    //-------- conversion methods -----------------------------------


    function ToInt(aDefault: Integer = 0): Integer                        ; inline ;

    function ToHexInt(aDefault: Integer = 0): Integer                     ; inline ;

    function ToRomanInt(aDefault:Integer = 0): Integer                    ;

    function ToInt64(aDefault: Int64 = 0): Int64                          ; inline ;

    function ToFloat(aDefault: Double = 0; aDecimalSeparator: Char = #0): Double                       ; inline ;

    function ToCurrency(aDefault: Currency = 0; aDecimalSeparator: Char = #0): Currency                ; inline ;

    function ToDate(aDefault: TDateTime = 0.0; aDateSeparator: Char = #0; aDateFormat: string=''):TDate; inline ;

    function ToTime(aDefault: TDateTime = 0.0; aTimeSeparator: Char = #0):TTime                        ; inline ;

    function ToDateTime(aDefault: TDateTime = 0.0; aDateSeparator: Char = #0; aTimeSeparator: Char = #0):TDateTime; inline ;

    function ToDateTimeISO(aDefault: TDateTime = 0.0):TDateTime; inline ;

    function ToDateTimeUTC(aDefault: TDateTime = 0.0):TDateTime; inline ;

    function ToUpper: string                       ; inline ;

    function ToLower: string                       ; inline ;

    function ToHTML: string                        ; inline ;

    function ToURL: string                         ; inline ;

    function ToBase64: string                      ; overload ; inline ;

    function ToBase64(aCharsPerLine: Integer; const aSeparator: string = CRLF): string ; overload ;

    function FromBase64: string                                  ; overload ; inline ;
    function FromBase64(const aSeparator: string): string        ; overload ; inline ;

    procedure ToFile(const aFileName: string; aEncoding: TEncoding = nil; aOptionBOM: TOptionBOM = obWithoutBOM);

    function ToMD5: string; inline;
    
    //-------- query methods  --------------------------------


    function IsNull: Boolean                          ; inline ;

    function IsNotNull: Boolean                       ; inline ;

    function IsEmpty: Boolean                         ; inline ;

    function IsNotEmpty: Boolean                      ; inline ;

    function IfNull(const aDefault: string): string   ; inline ;

    function IfEmpty(const aDefault: string): string  ; inline ;

    procedure IfNotEmpty(aProc: TProc<string>)        ; overload ; inline ;

    function IfNotEmpty(aFunc: TFunc<string,string>; aDefault: string=''): string; overload ; inline ;

    function Len: Integer                      ; inline;

    function Left( aCount: Integer ): string   ; inline ;

    function Right( aCount: Integer ): string  ; inline ;

    function Copy ( aStart: Integer; aCount: Integer ): string ; inline ;

    function CopyFrom ( aStart: Integer): string               ; inline ;

    function Pos(const aSubStr: string ; aStartChar: Integer = 0): Integer     ; inline ;

    function PosRight(const aSubStr: string ; aStartChar: Integer = 0): Integer; inline ;


    function IndexInArray(const aValues: TStringDynArray; aCompareOption: TCompareOption): Integer; overload ; inline ;
    function IndexInArray(const aValues: TStringDynArray): Integer                                ; overload ; inline ;

    function IsInArray(const aValues: TStringDynArray; aCompareOption: TCompareOption): Boolean; overload ; inline ;
    function IsInArray(const aValues: TStringDynArray): Boolean                                ; overload ; inline ;

    function SameAs(const aValue: string): Boolean           ; inline ;

    function Equals(const aValue: string): Boolean           ; inline ;

    function StartsWith(const aSubStr: string): Boolean                                 ; overload ; inline ;
    function StartsWith(const aSubStr: string; aCompareOption: TCompareOption): Boolean ; overload ; inline ;

    function EndsWith(const aSubStr: string): Boolean                                   ; overload ; inline ;
    function EndsWith(const aSubStr: string; aCompareOption: TCompareOption): Boolean   ; overload ; inline ;

    function Contains( const aSubStr: string): Boolean                                  ; overload ; inline ;
    function Contains( const aSubStr: string; aCompareOption: TCompareOption): Boolean  ; overload ; inline ;

    function MatchesMask( const aMask: string): Boolean      ; inline ;


    function WordCount(aWordSeparators: TSysCharSet = [] ): Integer                        ; inline ;

    function WordPos(aWordNum: Integer; aWordSeparators: TSysCharSet = []): Integer        ; inline ;

    function WordAt(aWordNum: Integer; aWordSeparators: TSysCharSet = []): string          ; inline ;

    function IsWordPresent(const aWord: string; aWordSeparators: TSysCharSet = []): Boolean; inline ;


    function IsInteger: Boolean   ; inline;
    function IsInt64  : Boolean   ; inline;
    function IsFloat  : Boolean   ; overload; inline;
    function IsFloat(aDecimalSeparator: Char): Boolean ; overload; inline;
    function IsDate(aDateSeparator: Char = #0; const aDateFormat: string = ''): Boolean; inline;
    function IsTime(aTimeSeparator: Char = #0): Boolean                                ; inline;

    //-------- string manipulation methods ----------------------------


    function PadLeft  ( aLength: Integer; ALeadingChar: char =' ' ): string  ;

    function PadRight ( aLength: Integer; ALeadingChar: char =' ' ): string  ;

    function PadCenter( aLength: Integer; ALeadingChar: char =' ' ): string  ;

    function TrimLeft: string            ; inline;

    function TrimRight: string; overload ; inline;

    function Trim: string                ; inline;

    function QuotedString: string                                                     ; overload; inline ;
    function QuotedString(const aQuoteChar: Char): string                             ; overload; inline ;

    function DeQuotedString: string                                                   ; overload; inline ;
    function DeQuotedString(const aQuoteChar: Char): string                           ; overload; inline ;

    function UppercaseLetter: string  ; inline ;

    function UppercaseWordLetter(aWordSeparators: TSysCharSet = [] ): string;

    function EnsurePrefix(const aPrefix: string): string        ; inline;

    function EnsureSuffix(const aSuffix: string): string        ; inline ;

    function Replace( const aSearchStr, aReplaceStr: string): string                                 ; overload ; inline ;
    function Replace( const aSearchStr, aReplaceStr: string; aCompareOption: TCompareOption): string ; overload ; inline ;

    function RemoveChars(aRemoveChars: TSysCharSet): string  ;

    function ReplaceInvalidChars(aValidStrChars: TSysCharSet; const aReplaceStr: string): string       ; overload ;
    function ReplaceInvalidChars(const aValidStrChars, aReplaceStr: string): string                    ; overload ;

    function Concat(const aSeparator, aConcatValue: string): string          ; inline;

    function ConcatIfNotEmpty(const aSeparator, aConcatValue: string): string; inline;

    function ConcatIfNotNull(const aSeparator, aConcatValue: string): string ; inline;

    function Extract( AStart: Integer; aCount: Integer = -1 ): string ;

    class function Duplicate(aChar: Char; aCount: Integer): string; overload ; static ; inline ;
    class function Duplicate(const aValue: string; aCount: Integer): string; overload ; static ; inline ;
    
          function Split(aSeparator: Char; aQuote: Char ='"'): TStringDynArray; inline;

    class function Join(aValues: TStringDynArray; aSeparator: Char; aQuote: Char ='"'): string; static;

    /// <summary>
    ///  Char content access always 1-based index, allowed negative number (starts at the end)
    ///  Example: myVal := 'one'; // myVal.Chars[1] => 'o'   myVal.Chars[-1] => 'e'
    /// </summary>
    property Chars[AIndex: Integer]: Char read GetChars;
    /// <summary> Get first char even if null string (returns #0) </summary>
    property FirstChar: Char read GetFirstChar;
    /// <summary> Get last char even if null string (returns #0) </summary>
    property LastChar : Char read GetLastChar;
  end;


  /// <summary>
  ///  Custom data type to manage a tokenized string
  /// </summary>
  TTokenString = record
  private
  type
    TTokenStringEnumerator = class(TEnumerator<string>)
    private
      FCurrent: Integer;
      FList: TStringDynArray;
    protected
      function DoGetCurrent: string; override;
      function DoMoveNext : Boolean; override;
    public
      constructor Create(ATokenString: TTokenString);
    end;

  private
    FValue: string;
    FSepChar  : Char; // default  ;
    FQuoteChar: Char; // default  "
  public
  {$REGION 'operators' }
    class operator Implicit(a: string): TTokenString;
    class operator Implicit(a: TTokenString): string;
  {$ENDREGION}
    constructor Create(const aValue: string); overload ;
    constructor Create(const aValue: string; aSepChar: Char; aQuoteChar: Char = '"'); overload ;

    function TokenCount: Integer;
    function TokenAt(aTokenNum: Integer): string ;
    procedure TokenToList(ADestList: TStrings);
    function TokenFromList(ASourceList: TStrings): TTokenString ;
    function GetEnumerator: TEnumerator<string>;
    function ToArray: TStringDynArray;
    function Sep(aSepChar: Char): TTokenString;
    function Quote(aQuoteChar: Char): TTokenString;

    property SepChar  : Char read FSepChar   write FSepChar ;
    property QuoteChar: Char read FQuoteChar write FQuoteChar;
  end;


  TDateHelper = record helper for TDate
  private
  {$REGION 'Property Accessors'}
      function GetDay: Word; inline ;
      function GetMonth: Word; inline ;
      function GetYear: Word; inline ;
      function GetDayOfWeek: Integer; inline;
      function GetDayOfYear: Integer; inline;
      function GetWeek: Word; inline ;
  {$ENDREGION}
  public
    const NullDate: TDate = 0.0;

    //-------- conversion methods -----------------------------------


    function ToString: string                  ; inline ;

    function ToStringUTC: string               ; inline ;

    function ToStringFormat(const aFormat: string): string                                  ; overload ; inline ;
    function ToStringFormat(const aFormat: string; aDateSeparator: Char): string            ; overload ; inline ;
    function ToStringFormat(const aFormat: string; AFormatSettings: TFormatSettings): string; overload ; inline ;

    function ToInt: Integer               ; inline ;

    procedure Decode( out aYear, aMonth, aDay: Word )         ; inline ;

    class function Encode( aYear, aMonth, aDay: Word ): TDate ; inline ; static ;
    class function Create( aYear, aMonth, aDay: Word ): TDate ; inline ; static ;

    //-------- query methods  ---------------------------------------


    function IsNull: Boolean                  ; inline ;

    function IsNotNull: Boolean               ; inline ;

    function IsInLeapYear: Boolean            ; inline ;

    function IsInRange(aFromDate, aEndDate: TDate): Boolean; inline;
    function Equals( aValue: TDate ): Boolean ; inline ;

    function IfNull(aDefault: TDate): TDate   ; inline ;

    procedure IfNotEmpty(aProc: TProc<TDate>) ; inline ;


    function IsToday: Boolean; inline;

    function IsNotToday: Boolean; inline;

    property Day  : Word read GetDay;

    property Month: Word read GetMonth;

    property Year : Word read GetYear;

    property Week : Word read GetWeek;

    property DayOfWeek: Integer read GetDayOfWeek;

    property DayOfYear: Integer read GetDayOfYear;


          function DaysInMonth: Integer                        ; overload ;
    class function DaysInMonth( aYear, aMonth: Word ): Integer ; overload ; static ; inline ;

    function FirstDayOfMonth: TDate               ; inline ;

    function LastDayOfMonth: TDate                ; inline ;

    function DaysBetween(aValue: TDate)  : Integer; inline;

    function MonthsBetween(aValue: TDate): Integer; inline;

    function YearsBetween(aValue: TDate) : Integer; inline;








    function IncDay( aDays: Integer = 1 ): TDate                      ; inline ;

    function IncMonth( aMonths: Integer = 1 ): TDate                  ; inline ;

    function IncYear( aYears: Integer = 1 ): TDate                    ; inline ;

    class function Today: TDate ; inline ; static ;
    class function Tomorrow : TDate ; inline ; static ;
    class function Yesterday: TDate ; inline ; static ;

    class function Max(const aDateA, aDateB: TDate): TDate; inline ; static ;
  end;



  TTimeHelper = record helper for TTime
  private
  {$REGION 'Property Accessors'}
    function GetHour: Word; inline;
    function GetMilliSecond: Word; inline;
    function GetMinute: Word; inline;
    function GetSecond: Word; inline;
    function GetSecondOfDay: Integer; inline;
    function GetMilliSecondOfDay: Integer; inline;
    function GetMinuteOfDay: Integer; inline;

  {$ENDREGION}
  public
    const NullTime: TTime = 0.0;

    //-------- conversion methods -----------------------------------

    
    function ToString: string                  ; inline ;
    
    function ToStringFormat(const aFormat: string): string                                  ; overload ; inline ;
    function ToStringFormat(const aFormat: string; aTimeSeparator: Char): string            ; overload ; inline ;
    function ToStringFormat(const aFormat: string; aFormatSettings: TFormatSettings): string; overload ; inline ;
    
    function ToInt(aFormat: TTimeConvFormat = HHMMSSMSS): Integer                          ; inline ;
    
    class function Create( aHour, aMin: Word; aSec: Word = 0; aMilliSec: Word = 0 ): TTime ; inline ; static ;
    class function Encode( aHour, aMin: Word; aSec: Word = 0; aMilliSec: Word = 0 ): TTime ; inline ; static ;

    procedure Decode(out aHour, aMin: Word )                     ; overload ; inline ;

    procedure Decode(out aHour, aMin, aSec: Word )               ; overload ; inline ;

    procedure Decode(out aHour, aMin, aSec, aMilliSec: Word )    ; overload ; inline ;

    //-------- query methods -------------------------------------------

    
    function IsNull: Boolean                     ; inline ;
    function IsNotNull: Boolean                  ; inline ;
    
    function Equals( aValue: TTime ): Boolean    ; inline ;
    
    function IsPM: Boolean; inline ;
    
    function IsAM: Boolean; inline ;

    
    property Hour   : Word read GetHour;
    
    property Minute : Word read GetMinute;
    
    property Second : Word read GetSecond;
    
    property MilliSecond : Word read GetMilliSecond;


    property MinuteOfDay: Integer read GetMinuteOfDay;

    property SecondOfDay: Integer read GetSecondOfDay;

    property MilliSecondOfDay: Integer read GetMilliSecondOfDay;

    function HoursBetween(aValue: TTime)       : Integer; inline;
    function MinutesBetween(aValue: TTime)     : Integer; inline;
    function SecondsBetween(aValue: TTime)     : Integer; inline;
    function MillisecondsBetween(aValue: TTime): Integer; inline;

    
    function IncHour( AHours: Integer=1 ): TTime                    ; inline ;
    
    function IncMinute( AMinutes: Integer=1 ): TTime                ; inline ;
    
    function IncSecond( ASeconds: Integer=1 ): TTime                ; inline ;
    
    function IncMiliSecond( AMilliSeconds: Integer=1 ): TTime       ; inline ;

    //-------- utilities ----------------------------

    class function Now: TTime ; inline ; static ;
    class function FistTimeOfTheDay: TTime; inline; static;
    class function LastTimeOfTheDay: TTime; inline; static;
  end;


  TDateTimeHelper = record helper for TDateTime
  private
  {$REGION 'Property Accessors'}
      function GetDate: TDate; inline ;
      function GetTime: TTime; inline ;
      procedure SetDate(const Value: TDate); inline;
      procedure SetTime(const Value: TTime); inline;
  {$ENDREGION}
  public
    const NullDateTime: TDateTime = 0.0;

    //-------- conversion methods -----------------------------------


    function ToString: string                      ; inline ;

    function ToStringUTC: string                   ; inline ;

    function ToStringISO: string                   ; inline ;

    function ToStringFormat(const aFormat: string): string                                      ; overload ; inline ;
    function ToStringFormat(const aFormat: string; aDateSeparator: Char): string                ; overload ; inline ;
    function ToStringFormat(const aFormat: string; aDateSeparator, aTimeSeparator: Char): string; overload ; inline ;
    function ToStringFormat(const aFormat: string; AFormatSettings: TFormatSettings): string    ; overload ; inline ;

    //-------- query methods -------------------------------------------


    function IsNull: Boolean                      ; inline ;
    function IsNotNull: Boolean                   ; inline ;


    property Date: TDate read GetDate write SetDate;
    property Time: TTime read GetTime write SetTime;

    //-------- utilities ----------------------------

    /// <summary> Torna la data e l'ora attuale (ora di sistema) </summary>
    class function NowToday: TDateTime ; inline ; static ;
  end;


  TTimeDynArray     = array of TTime;
  TDateTimeDynArray = array of TDateTime;
  TTDateDynArray    = array of TDate;


  /// <summary> Helper to use dynamic string array like a TStringList </summary>
  TStringDynArrayHelper = record helper for TStringDynArray
  public
    function IsEmpty: Boolean; inline;
    function IsNotEmpty: Boolean; inline;
    function Contains(const aValue: string;
                      aCompareOption: TStringHelper.TCompareOption = coCaseSensitive ): Boolean ; inline;
    function IndexOf(const aValue: string; aCompareOption: TStringHelper.TCompareOption = coCaseSensitive ): Integer ; overload ; inline;
    function IndexOf(const aValue: string; aStartPosition: Integer; aCompareOption: TStringHelper.TCompareOption = coCaseSensitive ): Integer ; overload ;
    function Count: Integer; inline;
    function First: string ; inline;
    function Last: string  ; inline;
    procedure Clear ; inline;
    procedure Resize(aCount: Integer); inline;
    procedure Add(const aValue: string); overload ; inline;
    procedure Add(aValues: TStringDynArray; aStartItem: Integer = 0; aItemCount: Integer = -1); overload ;
    procedure Add(aValues: TStrings       ; aStartItem: Integer = 0; aItemCount: Integer = -1); overload ; inline ;
    procedure Delete(aIndex: Integer);
    function Get(aIndex: Integer; const aDefault: string = ''): string;
    function ToString(const aLineSep: string = LF): string;
  end;


  TObjectHelper = class helper for TObject
  private
    function IsClass(aClass: TClass): Boolean; inline;
  public
    function CastAs<T: class>: T;
    function IsNull: Boolean; inline;
    function IsNotNull: Boolean; inline;
  end;

function _StrNumPadLeft(const aValue: string; aLength: Integer; aLeadingChar: Char): string;

implementation

var
  FRandomInit: Boolean;

function _StrNumPadLeft(const aValue: string; aLength: Integer; aLeadingChar: Char): string;
var
  idx: Integer;
begin
  if aLength < 1 then
    Exit('');

  if (Length(aValue) > aLength) then
    Result := StringOfChar( '*', aLength )
  else
    Result := StringOfChar( aLeadingChar, aLength-Length(aValue) ) + aValue ;

  if (aLeadingChar = '0') then
  begin
    idx := Pos('-',Result);
    if (idx > Low(string)) then
    begin
      Result[Low(string)] := '-';
      Result[idx] := '0';
    end;
  end;
end;

{$REGION 'TIntegerHelper'}

function TIntegerHelper.Abs: Integer;
begin
  Result := System.Abs(Self);
end;

function TIntegerHelper.Dec: Integer;
begin
  System.Dec(Self, 1);
  Result := Self;
end;

function TIntegerHelper.DecBy(aDecBy: Integer): Integer;
begin
  System.Dec(Self, aDecBy);
  Result := Self;
end;

function TIntegerHelper.Inc: Integer;
begin
  System.Inc(Self) ;
  Result := Self;
end;

function TIntegerHelper.IncBy(aIncBy: Integer): Integer;
begin
  System.Inc(Self, aIncBy) ;
  Result := Self;
end;

class function TIntegerHelper.Random(aTotValues: Integer): Integer;
begin
  if (not FRandomInit)  then
  begin
    System.Randomize;
    FRandomInit := True;
  end;

  if (ATotValues < 1) then
    Result := System.Random(System.MaxInt)
  else
    Result := System.Random(aTotValues) ;
end;

class procedure TIntegerHelper.Swap(var aValue1, aValue2: Integer);
var
  tmp: Integer;
begin
  tmp := aValue1 ;
  aValue1 := aValue2;
  aValue2 := tmp;
end;

function TIntegerHelper.ToDate: TDate;
var
  y: word;
  resDate: TDateTime;
begin
  y := Self div 10000;
  if y < 100 then
    y := 1900 + y;

  if (Self = 0) or
     not TryEncodeDate(   y,
                        ( Self div 100 ) mod 100,
                        ( Self mod 100 ),
                          resDate )
  then
    Result := TDate.NullDate
  else
    Result := resDate;
end;

function TIntegerHelper.ToTime(aFormat: TTimeConvFormat): TTime;
var
  resTime: TDateTime;
  hh, mm, ss, ms: word;
begin
  Result := TTime.NullTime;

  if (Self > 0) then
  begin
     if aFormat = HHMM then
     begin
       hh := Self div 100;
       mm := Self mod 100;
       ss := 0 ;
       ms := 0 ;
     end
     else
     if aFormat = HHMMSS then
     begin
       hh := ( Self div 10000 );
       mm := ( Self div   100 ) mod 100;
       ss := ( Self mod   100 );
       ms := 0 ;
     end
     else
     begin
       hh :=  ( Self div 10000000 );
       mm :=  ( Self div   100000 ) mod 100;
       ss :=  ( Self div     1000 ) mod 100;
       ms :=  ( Self mod     1000 );
     end;

     if TryEncodeTime(hh, mm, ss, ms, resTime) then
       Result := resTime;
  end;
end;

function TIntegerHelper.ToFloatWithDecimals(aDecimalDigits: Integer): Double;
begin
  Result := Double.RoundTo(Self / Power(10, aDecimalDigits), aDecimalDigits);
end;

function TIntegerHelper.ToString: string;
begin
  FmtStr(Result, '%d', [Self]);
end;

function TIntegerHelper.ToString(aLength: Integer; aLeadingChar: Char): string;
begin
  FmtStr(Result, '%d', [Self]);
  Result := _StrNumPadLeft(Result, aLength, aLeadingChar) ;
end;

function TIntegerHelper.ToStringFormat(const aFormat: string): string;
begin
  Result := FormatFloat(aFormat,Self)
end;

function TIntegerHelper.ToStringFormat(const aFormat: string; const aFormatSettings: TFormatSettings): string;
begin
  Result := FormatFloat(aFormat, Self, aFormatSettings);
end;

function TIntegerHelper.ToStringHex: string;
begin
   FmtStr(Result, '%.*x', [2, Self]);
end;

function TIntegerHelper.ToStringZero(aLength: Integer): string;
begin
  FmtStr(Result, '%d', [Self]);
  Result := _StrNumPadLeft(Result, aLength, '0') ;
end;

function TIntegerHelper.ToStringRoman: string;
const
  vals_count = 13;
  vals: array [1..vals_count] of word =
    (1, 4, 5, 9, 10, 40, 50, 90, 100, 400, 500, 900, 1000);
  roms: array [1..vals_count] of string =
    ('I', 'IV', 'V', 'IX', 'X', 'XL', 'L', 'XC', 'C',
    'CD', 'D', 'CM', 'M');
var
  b, value: Integer;
begin
  Result := '';
  value  := Self;
  b := vals_count;
  while value > 0 do
  begin
    while vals[b] > value do
      System.Dec(b);
    System.Dec(value, vals[b]);
    Result := Result + roms[b]
  end;
end;

{$ENDREGION}

{$REGION 'TInt64Helper'}

function TInt64Helper.Abs: Int64;
begin
  Result := System.Abs(Self);
end;

function TInt64Helper.Inc: Int64;
begin
  System.Inc(Self);
  Result := Self;
end;

function TInt64Helper.IncBy(aIncBy: Integer): Int64;
begin
  System.Inc(Self, aIncBy);
  Result := Self;
end;

function TInt64Helper.ToString: string;
begin
  FmtStr(Result, '%d', [Self]);
end;

function TInt64Helper.ToString(aLength: Integer; aLeadingChar: Char): string;
begin
  FmtStr(Result, '%d', [Self]);
  Result := _StrNumPadLeft(Result, aLength, aLeadingChar) ;
end;

function TInt64Helper.ToStringFormat(const aFormat: string; const aFormatSettings: TFormatSettings): string;
begin
  Result := FormatFloat(aFormat, Self, aFormatSettings);
end;

function TInt64Helper.ToStringFormat(const aFormat: string): string;
begin
  Result := FormatFloat(aFormat, Self);
end;

function TInt64Helper.ToStringZero(aLength: Integer): string;
begin
  FmtStr(Result, '%d', [Self]);
  Result := _StrNumPadLeft(Result, aLength, '0') ;
end;

{$ENDREGION}

{$REGION 'TFloatHelper' }

function TFloatHelper.Abs: Double;
begin
  Result := System.Abs(Self);
end;

function TFloatHelper.Frac: Double;
begin
  Result := System.Frac(Self);
end;

function TFloatHelper.ToRoundInt: Int64;
begin
  Result := System.Round(Self);
end;

function TFloatHelper.Int: Double;
begin
  Result := System.Int(Self);
end;

function TFloatHelper.ToInt: Int64;
begin
  Result := System.Trunc(Self);
end;

function TFloatHelper.ToIntWithDecimals(aDecimalDigits: Integer): Int64;
begin
  Result := Double.RoundTo(Self * Power(10, aDecimalDigits), 0).ToInt;
end;

function TFloatHelper.ToString: string;
begin
  Result := FloatToStr(Self) ;
end;

function TFloatHelper.ToString(aDecimalSeparator: Char): string;
var
  fmt: TFormatSettings;
begin
  fmt := TFormatSettings.Create;
  fmt.DecimalSeparator := aDecimalSeparator;
  Result := FloatToStr(Self, fmt);
end;

function TFloatHelper.ToString(aLength: Integer; aLeadingChar: Char): string;
begin
  Result := _StrNumPadLeft(ToString, aLength, aLeadingChar) ;
end;

function TFloatHelper.ToString(aLength: Integer; aLeadingChar, aDecimalSeparator: Char): string;
begin
  Result := _StrNumPadLeft(ToString(aDecimalSeparator), aLength, aLeadingChar) ;
end;

function TFloatHelper.ToStringZero(aLength: Integer): string;
begin
  Result := _StrNumPadLeft(ToString, aLength, '0') ;
end;

function TFloatHelper.ToStringZero(aLength: Integer; aDecimalSeparator: Char): string;
begin
  Result := _StrNumPadLeft(ToString(aDecimalSeparator), aLength, '0') ;
end;

function TFloatHelper.ToStringFormat(const aFormat: string): string;
begin
  Result := FormatFloat(aFormat, Self);
end;

function TFloatHelper.ToStringFormat(const aFormat: string; const aFormatSettings: TFormatSettings): string;
begin
  Result := FormatFloat(aFormat, Self, aFormatSettings);
end;

class function TFloatHelper.RoundTo(aValue: Double; aDecimalDigits: Integer): Double;
var
  m, i: Integer;
begin
  if (aDecimalDigits < 1) then
    Result := System.Round(aValue)
  else
  begin
    m := 1;
    for i := 1 to aDecimalDigits do
      m :=  m * 10 ;
    Result := System.Trunc(aValue*m + IfThen(aValue > 0, 0.5, -0.5))/m;
  end;
end;

function TFloatHelper.RoundTo(aDecimalDigits: Integer): Double;
begin
  Result := Double.RoundTo(Self,aDecimalDigits) ;
end;

{$ENDREGION}

{$REGION 'TCurrencyHelper'}

class function TCurrencyHelper.RoundTo(aValue: Currency; aDecimalDigits: Integer): Currency;
var
  m,i: Integer;
begin
  if (aDecimalDigits < 1) then
    Result := System.Round(aValue)
  else
  begin
    m := 1;
    for i := 1 to Max(aDecimalDigits,4) do
      m :=  m * 10 ;
    Result := System.Trunc(aValue*m + IfThen(aValue > 0, 0.5, -0.5))/m;
  end;
end;

function TCurrencyHelper.RoundTo(aDecimalDigits: Integer): Currency;
begin
  Result := Currency.RoundTo(Self,aDecimalDigits);
end;

function TCurrencyHelper.Abs: Currency;
begin
  Result := System.Abs(Self);
end;

function TCurrencyHelper.ToString: string;
begin
  Result := CurrToStr(Self);
end;

function TCurrencyHelper.ToString(aDecimalSeparator: Char): string;
var
  fmt: TFormatSettings;
begin
  fmt := TFormatSettings.Create;
  fmt.DecimalSeparator := aDecimalSeparator;
  Result := CurrToStr(Self, fmt);
end;

function TCurrencyHelper.ToString(aLength: Integer; aLeadingChar: Char): string;
begin
  Result := _StrNumPadLeft(ToString, aLength, aLeadingChar) ;
end;

function TCurrencyHelper.ToString(aLength: Integer; aLeadingChar, aDecimalSeparator: Char): string;
begin
  Result := _StrNumPadLeft(ToString(aDecimalSeparator), aLength, aLeadingChar) ;
end;

function TCurrencyHelper.ToStringFormat(const aFormat: string): string;
begin
  Result := FormatCurr(aFormat, Self);
end;

function TCurrencyHelper.ToStringFormat(const aFormat: string; const aFormatSettings: TFormatSettings): string;
begin
  Result := FormatCurr(aFormat, Self, aFormatSettings);
end;

function TCurrencyHelper.ToStringZero(aLength: Integer; aDecimalSeparator: Char): string;
begin
  Result := _StrNumPadLeft(ToString(aDecimalSeparator), aLength, '0') ;
end;

function TCurrencyHelper.ToStringZero(aLength: Integer): string;
begin
  Result := _StrNumPadLeft(ToString, aLength, '0') ;
end;

function TCurrencyHelper.ToInt: Int64;
begin
  Result := System.Trunc(Self);
end;

function TCurrencyHelper.ToIntWithDecimals(aDecimalDigits: Integer): Int64;
begin
  Result := Currency.RoundTo(Self * Power(10, aDecimalDigits), 0).ToInt;
end;

{$ENDREGION}

{$REGION 'TStringHelper'}

function TStringHelper.Len: Integer;
begin
  Result := System.Length(Self);
end;

function TStringHelper.GetChars(aIndex: Integer): Char;
begin
  if aIndex < 0 then
    Result := Self[Len+aIndex+Low(string)]
  else
    Result := Self[aIndex+Low(string)-1];
end;

function TStringHelper.GetFirstChar: Char;
begin
  if Self <> '' then
    Result := GetChars(1)
  else
    Result := #0;
end;

function TStringHelper.GetLastChar: Char;
begin
  if Self <> '' then
    Result := GetChars(-1)
  else
    Result := #0;
end;

function TStringHelper.IfEmpty(const aDefault: string): string;
begin
  if System.SysUtils.Trim(Self) = NullString then
    Result := aDefault
  else
    Result := Self;
end;

function TStringHelper.IfNull(const aDefault: string): string;
begin
  if Self = NullString then
    Result := aDefault
  else
    Result := Self;
end;

function TStringHelper.IsEmpty: Boolean;
begin
  Result := System.SysUtils.Trim(Self) = '';
end;

function TStringHelper.IsNotEmpty: Boolean;
begin
  Result := System.SysUtils.Trim(Self) <> '';
end;

function TStringHelper.IsNotNull: Boolean;
begin
  Result := (Self <> NullString);
end;

function TStringHelper.IsNull: Boolean;
begin
  Result := (Self = NullString);
end;

function TStringHelper.IfNotEmpty(aFunc: TFunc<string,string>; aDefault: string): string;
begin
  if IsNotEmpty then
    Result := aFunc(Self)
  else
    Result := aDefault;
end;

procedure TStringHelper.IfNotEmpty(aProc: TProc<string>);
begin
  if IsNotEmpty then
    aProc(Self);
end;

function TStringHelper.ToInt(aDefault: Integer): Integer;
begin
  Result := StrToIntDef(System.SysUtils.Trim(Self), aDefault);
end;

function TStringHelper.ToCurrency(aDefault: Currency; aDecimalSeparator: Char): Currency;
var
  fmt: TFormatSettings;
begin
  fmt := TFormatSettings.Create;
  if aDecimalSeparator <> #0 then
    fmt.DecimalSeparator := aDecimalSeparator;
  Result := StrToCurrDef(System.SysUtils.Trim(Self), aDefault, fmt);
end;

function TStringHelper.ToDate(aDefault: TDateTime; aDateSeparator: Char; aDateFormat: string): TDate;
var
  fmt: TFormatSettings;
begin
  fmt := TFormatSettings.Create;
  if aDateSeparator <> #0 then
    fmt.DateSeparator := aDateSeparator;
  if aDateFormat <> '' then
    fmt.ShortDateFormat := aDateFormat;
  Result := StrToDateDef(Self, aDefault, fmt);
end;

function TStringHelper.ToTime(aDefault: TDateTime; aTimeSeparator: Char): TTime;
var
  fmt: TFormatSettings;
begin
  fmt := TFormatSettings.Create;
  if aTimeSeparator <> #0 then
    fmt.TimeSeparator := aTimeSeparator;
  Result := StrToTimeDef(Self, aDefault, fmt);
end;

function TStringHelper.ToDateTime(aDefault: TDateTime; aDateSeparator, aTimeSeparator: Char): TDateTime;
var
  fmt: TFormatSettings;
begin
  fmt := TFormatSettings.Create;
  if aDateSeparator <> #0 then
    fmt.DateSeparator := aDateSeparator;
  if aTimeSeparator <> #0 then
    fmt.TimeSeparator := aTimeSeparator;

  Result := StrToDateTimeDef(Self, aDefault, fmt);
end;

function TStringHelper.ToDateTimeISO(aDefault: TDateTime): TDateTime;
begin
  if not TryISO8601ToDate(Self, Result, False) then
    Result := aDefault;
end;

function TStringHelper.ToDateTimeUTC(aDefault: TDateTime): TDateTime;
begin
  if not TryISO8601ToDate(Self, Result, True) then
    Result := aDefault;
end;

function TStringHelper.ToUpper: string;
begin
  Result := AnsiUpperCase(Self);
end;

function TStringHelper.ToLower: string;
begin
  Result := AnsiLowerCase(Self);
end;

function TStringHelper.ToMD5: string;
begin
  Result := THashMD5.GetHashString(Self);
end;

function TStringHelper.ToRomanInt(aDefault: Integer): Integer;
const
   romanChars = 'IVXLCDMvxlcdm?!#';
   decades : array [0..8] of integer = (0, 1, 10, 100, 1000, 10000, 100000, 1000000, 10000000) ;
   OneFive : array [boolean] of byte = (1, 5) ;
var
   newValue: integer ;
   cIdx, id: integer ;
begin
   Result := 0;
   for cIdx := High(Self) downto Low(Self) do
   begin
     id := System.Pos(Self[cIdx], romanChars)+1 ;
     newValue := OneFive[Odd(id)] * decades[id div 2] ;
     if newValue = 0 then
       Exit(-1);

     System.Inc(Result, newValue) ;
   end ;
end;

procedure TStringHelper.ToFile(const aFileName: string; aEncoding: TEncoding; aOptionBOM: TOptionBOM);
var
  fs: TFileStream;
  Buffer, Preamble: TBytes;
begin
  if aEncoding = nil then
    aEncoding := TEncoding.Default;

  fs := TFileStream.Create(aFileName, fmCreate);
  try
    Buffer := aEncoding.GetBytes(Self);
    if aOptionBOM = obIncludeBOM then
    begin
      Preamble := aEncoding.GetPreamble;
      if System.Length(Preamble) > 0 then
        fs.WriteBuffer(Preamble, System.Length(Preamble));
    end;
    fs.WriteBuffer(Buffer, System.Length(Buffer));
  finally
    fs.Free;
  end;
end;

function TStringHelper.ToFloat(aDefault: Double; aDecimalSeparator: Char): Double;
var
  fmt: TFormatSettings;
begin
  fmt := TFormatSettings.Create;
  if aDecimalSeparator <> #0 then
    fmt.DecimalSeparator := aDecimalSeparator;
  Result := StrToFloatDef(System.SysUtils.Trim(Self), aDefault, fmt) ;
end;

function TStringHelper.ToHexInt(aDefault: Integer): Integer;
begin
  Result := StrToIntDef('$'+System.SysUtils.Trim(Self), aDefault);
end;

function TStringHelper.ToInt64(aDefault: Int64): Int64;
begin
  Result := StrToInt64Def(System.SysUtils.Trim(Self), aDefault);
end;

function TStringHelper.ToHTML: string;
begin
  Result := TNetEncoding.HTML.Encode(Self);
end;

function TStringHelper.ToURL: string;
begin
  Result := TNetEncoding.URL.EncodeQuery(Self);
end;

function TStringHelper.ToBase64: string;
begin
  Result := TNetEncoding.Base64.Encode(Self).RemoveChars([#13,#10]);
end;

function TStringHelper.ToBase64(aCharsPerLine: Integer; const aSeparator: string): string;
var
  idx: Integer;
  str: string;
begin
  Result := '';
  str    := ToBase64;
  idx    := 1 ;
  while idx < Length(str)  do
  begin
    if Result <> '' then
      Result := Result + aSeparator;
    Result := Result + System.Copy(str, idx, aCharsPerLine);
    idx := idx + aCharsPerLine;
  end;
end;

function TStringHelper.FromBase64(const aSeparator: string): string;
begin
  Result := TNetEncoding.Base64.Decode(Replace(aSeparator, ''));
end;

function TStringHelper.FromBase64: string;
begin
  Result := TNetEncoding.Base64.Decode(RemoveChars([CR, LF]));
end;

function TStringHelper.Copy(aStart, aCount: Integer): string;
var
  lenStr: Integer ;
begin
  Result := '';
  lenStr := System.Length(Self);
  if (lenStr > 0) then
  begin
    if (aCount < 0) then
      aCount := lenStr-aStart+1;

    if (aStart > 0) and (aCount > 0) then
      Result := System.Copy(Self, aStart, aCount ) ;
  end;
end;

function TStringHelper.CopyFrom(aStart: Integer): string;
begin
  Result := System.Copy(Self, aStart, System.Length(Self)-aStart+1);
end;

function TStringHelper.Left(aCount: Integer): string;
begin
  Result := System.Copy(Self, 1, aCount) ;
end;

function TStringHelper.Right(aCount: Integer): string;
begin
  Result := System.Copy(Self, System.Length(Self) + 1 - aCount, aCount);
end;

function TStringHelper.MatchesMask(const aMask: string): Boolean;
begin
  if aMask = '' then
    Result := True
  else
    Result := System.Masks.MatchesMask(Self, aMask);
end;

function TStringHelper.PadCenter(aLength: Integer; aLeadingChar: char): string;
var
  tempS: string;
  lenStr: Integer;
begin
  lenStr := System.Length(Self);
  if (lenStr >= aLength) then
    Result := System.Copy(Self, 1, aLength)
  else
  begin
    tempS  := StringOfChar(aLeadingChar, (aLength - lenStr) div 2) + Self ;
    Result := tempS + StringOfChar(aLeadingChar, aLength - System.Length(tempS)) ;
  end;
end;

function TStringHelper.PadLeft(aLength: Integer; aLeadingChar: char): string;
begin
  if (System.Length(Self) >= aLength) then
    Result := System.Copy( Self, 1, aLength )
  else
    Result := StringOfChar(aLeadingChar, aLength - System.Length(Self)) + Self ;
end;

function TStringHelper.PadRight(aLength: Integer; aLeadingChar: char): string;
begin
  if (System.Length(Self) >= aLength) then
    Result := System.Copy( Self, 1, aLength )
  else
    Result := Self + StringOfChar(aLeadingChar, aLength - System.Length(Self) ) ;
end;

function TStringHelper.IndexInArray(const aValues: TStringDynArray; aCompareOption: TCompareOption): Integer;
begin
  for Result := 0 to High(aValues) do
    if ((aCompareOption = coCaseInsensitive) and (AnsiCompareText(Self, aValues[Result]) = 0)) or
       ((aCompareOption = coCaseSensitive  ) and (Self = aValues[Result]))                     then
      Exit;

  Result := -1;
end;

function TStringHelper.IndexInArray(const aValues: TStringDynArray): Integer;
begin
  for Result := 0 to High(aValues) do
    if (Self = aValues[Result]) then
       Exit;

  Result := -1;
end;

function TStringHelper.IsInArray(const aValues: TStringDynArray; aCompareOption: TCompareOption): Boolean;
begin
  Result := IndexInArray(aValues,aCompareOption) > -1;
end;

function TStringHelper.IsInArray(const aValues: TStringDynArray): Boolean;
var
  s: string;
begin
  for s in aValues do
    if (Self = s) then
       Exit(True);

  Result := False;
end;

function TStringHelper.IsInt64: Boolean;
var
  i: Int64;
begin
  Result := TryStrToInt64(Self, i);
end;

function TStringHelper.IsInteger: Boolean;
var
  i: Integer;
begin
  Result := TryStrToInt(Self, i);
end;

function TStringHelper.IsFloat: Boolean;
var
  i: Double;
begin
  Result := TryStrToFloat(Self, i);
end;

function TStringHelper.IsFloat(aDecimalSeparator: Char): Boolean;
var
  i: Double;
  fmt: TFormatSettings;
begin
  fmt := TFormatSettings.Create;
  fmt.DecimalSeparator := aDecimalSeparator;
  Result := TryStrToFloat(Self, i, fmt);
end;

function TStringHelper.IsDate(aDateSeparator: Char; const aDateFormat: string): Boolean;
begin
  if Self.IsEmpty then
    Result := False
  else
    Result := ToDate(TDate.NullDate, aDateSeparator, aDateFormat).IsNotNull;
end;

function TStringHelper.IsTime(aTimeSeparator: Char): Boolean;
begin
  if Self.IsEmpty then
    Result := False
  else
    Result := ToTime(TTime.NullTime, aTimeSeparator).IsNotNull;
end;

function TStringHelper.PosRight(const aSubStr: string; aStartChar: Integer): Integer;
var
  idx, lPos, lenSubStr, offs: Integer ;
begin
  if (aStartChar = 0) then
    aStartChar := System.Length(Self) ;

  Result    := 0 ;
  offs      := 1;
  lenSubStr := System.Length(aSubStr) ;

  for idx := aStartChar downto offs do
  begin
    lPos := idx - lenSubStr + offs ;
    if (lPos < 1) then
      Exit ;

    if (System.Copy(Self, lPos, lenSubStr) = aSubStr) then
      Exit(lPos);
  end;
end;

function TStringHelper.Pos(const aSubStr: string; aStartChar: Integer): Integer;
begin
  if aStartChar < 1 then
    aStartChar := 1;
  Result := System.Pos(aSubStr, Self, aStartChar);
end;

function TStringHelper.QuotedString(const aQuoteChar: Char): string;
begin
  Result := AnsiQuotedStr(Self, aQuoteChar);
end;

function TStringHelper.QuotedString: string;
begin
  Result := AnsiQuotedStr(Self, QUOTE_SINGLE);
end;

function TStringHelper.DeQuotedString(const aQuoteChar: Char): string;
begin
  Result := AnsiDeQuotedStr(self,aQuoteChar);
end;

function TStringHelper.DeQuotedString: string;
begin
  Result := AnsiDequotedStr(Self, QUOTE_SINGLE);
end;

function TStringHelper.Replace(const ASearchStr, aReplaceStr: String; aCompareOption: TCompareOption): string;
begin
  if (aCompareOption = coCaseSensitive) then
    Result := StringReplace( Self, ASearchStr, aReplaceStr, [rfReplaceAll] )
  else
    Result := StringReplace( Self, ASearchStr, aReplaceStr, [rfIgnoreCase,rfReplaceAll]);
end;

function TStringHelper.Replace(const ASearchStr, aReplaceStr: string): string;
begin
  Result := StringReplace( Self, ASearchStr, aReplaceStr, [rfReplaceAll] )
end;

function TStringHelper.RemoveChars(aRemoveChars: TSysCharSet): string;
var
  count, delta: Integer;
  ch: Char;
begin
  count  := 0 ;
  delta  := Low(string)-1;
  SetLength(Result, Length(Self));
  for ch in Self do
    if not CharInSet(ch, aRemoveChars) then
    begin
      Inc(count);
      Result[count+delta] := ch;
    end;
  SetLength(Result, count);
end;

function TStringHelper.ReplaceInvalidChars(aValidStrChars: TSysCharSet; const aReplaceStr: string): string;
var
  ch: Char;
begin
  Result := '';
  for ch in Self do
    if CharInSet(ch, aValidStrChars) then
      Result := Result + ch
    else
      Result := Result + aReplaceStr;
end;

function TStringHelper.ReplaceInvalidChars(const aValidStrChars, aReplaceStr: string): string;
var
  ch: Char;
begin
  Result := '';
  for ch in Self do
    if System.Pos(ch, aValidStrChars) > 0 then
      Result := Result + ch
    else
      Result := Result + aReplaceStr;
end;

function TStringHelper.Split(aSeparator, aQuote: Char): TStringDynArray;
begin
  Result := TTokenString.Create(Self, aSeparator, aQuote).ToArray;
end;

class function TStringHelper.Join(aValues: TStringDynArray; aSeparator, aQuote: Char): string;
var
  item: string;
begin
  Result := '';
  for item in aValues do
    Result := Result.Concat(aSeparator, IfThen(System.Pos(aSeparator,item) > 0, aQuote + item + aQuote, item));
end;

function TStringHelper.SameAs(const aValue: string): Boolean;
begin
  Result := AnsiCompareText( Self, aValue ) = 0 ;
end;

function TStringHelper.Equals(const aValue: string): Boolean;
begin
  Result := Self = aValue ;
end;

function TStringHelper.StartsWith(const aSubStr: string; aCompareOption: TCompareOption): Boolean;
begin
  if aCompareOption = coCaseInsensitive then
    Result := AnsiCompareText(System.Copy(Self, 1, System.Length(aSubStr)), aSubStr ) = 0
  else
    Result := System.Copy(Self, 1, System.Length(aSubStr)) = aSubStr ;
end;

function TStringHelper.StartsWith(const aSubStr: string): Boolean;
begin
  Result := System.Copy(Self, 1, System.Length(aSubStr)) = aSubStr ;
end;

function TStringHelper.EndsWith(const aSubStr: string; aCompareOption: TCompareOption): Boolean;
begin
  if aCompareOption = coCaseInsensitive then
    Result := AnsiCompareText(Right(System.Length(aSubStr) ), aSubStr ) = 0
  else
    Result := Right(System.Length(aSubStr)) = aSubStr ;
end;

function TStringHelper.EndsWith(const aSubStr: string): Boolean;
begin
  Result := Right(System.Length(aSubStr)) = aSubStr ;
end;

function TStringHelper.Contains(const aSubStr: string; aCompareOption: TCompareOption): Boolean;
begin
  if aCompareOption = coCaseInsensitive then
    Result := System.Pos(System.SysUtils.Lowercase(aSubStr), System.SysUtils.Lowercase(Self)) > 0
  else
    Result := System.Pos(aSubStr, Self) > 0;
end;

function TStringHelper.Contains(const aSubStr: string): Boolean;
begin
  Result := System.Pos(aSubStr, Self) > 0;
end;

function TStringHelper.EnsurePrefix(const aPrefix: string): string;
begin
  if System.Copy(Self, 1, System.Length(aPrefix)) <> aPrefix then
    Result := aPrefix + Self
  else
    Result := Self;
end;

function TStringHelper.EnsureSuffix(const aSuffix: string): string;
begin
  if (Right(System.Length(aSuffix)) <> aSuffix) then
    Result := Self + aSuffix
  else
    Result := Self;
end;

function TStringHelper.Trim: string;
begin
  Result := System.SysUtils.Trim(Self);
end;

function TStringHelper.TrimLeft: string;
begin
  Result := System.SysUtils.TrimLeft(Self);
end;

function TStringHelper.TrimRight: string;
begin
  Result := System.SysUtils.TrimRight(Self);
end;

function TStringHelper.UppercaseLetter: string;
begin
  Result := AnsiLowerCase(Self);
  if Result <> '' then
    Result[Low(string)] := AnsiUpperCase(Result)[Low(string)] ;
end;

function TStringHelper.Extract(aStart, aCount: Integer): string;
var
  len: Integer;
begin
  len := System.Length(Self);
  if (aCount < 0) then
    aCount := len - aStart ;

  Result := System.Copy( Self, aStart  , aCount ) ;
  Self   := System.Copy( Self, 1       , aStart-1 ) +
            System.Copy( Self, aStart+aCount, len ) ;
end;

function TStringHelper.Concat(const aSeparator, aConcatValue: string): string;
begin
  if Self.IsNotNull then
    Result := Self + aSeparator + aConcatValue
  else
    Result := aConcatValue;
end;

function TStringHelper.ConcatIfNotNull(const aSeparator, aConcatValue: string): string;
begin
  if aConcatValue.IsNotNull then
    Result := Concat(aSeparator, aConcatValue)
  else
    Result := Self;
end;

function TStringHelper.ConcatIfNotEmpty(const aSeparator, aConcatValue: string): string;
begin
  if aConcatValue.IsNotEmpty then
    Result := Concat(aSeparator, aConcatValue)
  else
    Result := Self;
end;

class function TStringHelper.Duplicate(aChar: Char; aCount: Integer): string;
begin
  Result := StringOfChar(aChar,aCount);
end;

class function TStringHelper.Duplicate(const aValue: string;
  aCount: Integer): string;
var
  idx: Integer;
begin
  Result := '';
  for idx := 1 to aCount do
    Result := Result + aValue;
end;

function TStringHelper.IsWordPresent(const aWord: string; aWordSeparators: TSysCharSet): Boolean;
var
  count, idx: Integer;
begin
  if aWordSeparators = [] then
    aWordSeparators := TBaseCharSet.WordSeparatorsSet ;

  Result := False;
  count  := WordCount(aWordSeparators);

  for idx := 0 to count-1 do
    if AnsiCompareText( WordAt(idx, aWordSeparators), aWord ) = 0 then
    begin
      Result := True;
      Exit;
    end;
end;

function TStringHelper.WordCount(aWordSeparators: TSysCharSet): Integer;
var
  len, idx: Cardinal;
begin
  if aWordSeparators = [] then
    aWordSeparators := TBaseCharSet.WordSeparatorsSet ;

  Result := 0;
  idx := Low(Self);
  len := High(Self);

  while idx <= len do
  begin
    while (idx <= len) and CharInSet(Self[idx], aWordSeparators) do
      Inc(idx);
    if idx <= len then
      Inc(Result);
    while (idx <= len) and not CharInSet(Self[idx], aWordSeparators) do
      Inc(idx);
  end;
end;

function TStringHelper.WordPos(aWordNum: Integer; aWordSeparators: TSysCharSet): Integer;
var
  count, idx, len: Integer;
begin
  if aWordSeparators = [] then
    aWordSeparators := TBaseCharSet.WordSeparatorsSet ;

  Result := 0;
  count  := -1;
  idx    := Low(string);
  len    := High(Self);

  while (idx <= len) and (count <> aWordNum) do
  begin
    while (idx <= len) and CharInSet(Self[idx], aWordSeparators) do
      Inc(idx);
    if idx <= len then
      Inc(count);
    if count <> aWordNum then
      while (idx <= len) and not CharInSet(Self[idx], aWordSeparators) do
        Inc(idx)
    else
      Result := idx;
  end;
end;

function TStringHelper.WordAt(aWordNum: Integer; aWordSeparators: TSysCharSet): string;
var
  idx: Integer;
begin
  if aWordSeparators = [] then
    aWordSeparators := TBaseCharSet.WordSeparatorsSet ;

  Result := '' ;
  idx := WordPos(aWordNum, aWordSeparators);
  if idx >= Low(string) then
    while (idx <= High(Self)) and not CharInSet(Self[idx], aWordSeparators) do
    begin
      Result := Result + Self[idx];
      Inc(idx);
    end;
end;

function TStringHelper.UppercaseWordLetter(aWordSeparators: TSysCharSet): string;
var
  len, idx, offs: Integer;
begin
  Result := Self;
  if Result <> '' then
  begin
    if aWordSeparators = [] then
      aWordSeparators := TBaseCharSet.WordSeparatorsSet ;

    Result := AnsiLowerCase(Result);
    offs   := Low(Result);
    idx    := offs;
    len    := High(Result);
    while (idx <= len) do
    begin
      while (idx <= len) and CharInSet(Result[idx], aWordSeparators) do
        Inc(idx);
      if (idx <= len) then
        Result[idx] := AnsiUpperCase(Result[idx])[offs];
      while (idx <= len) and not CharInSet(Result[idx], aWordSeparators) do
        Inc(idx);
    end;
  end;
end;

{$ENDREGION}

{$REGION 'TTokenString'}

constructor TTokenString.Create(const aValue: string);
begin
  FValue     := aValue;
  FSepChar   := ';';
  FQuoteChar := '"';
end;

constructor TTokenString.Create(const aValue: string; aSepChar, aQuoteChar: Char);
begin
  FValue     := aValue;
  FSepChar   := aSepChar;
  FQuoteChar := aQuoteChar;
end;

class operator TTokenString.Implicit(a: string): TTokenString;
begin
  Result := TTokenString.Create(a);
end;

class operator TTokenString.Implicit(a: TTokenString): string;
begin
  Result := a.FValue;
end;

function TTokenString.Quote(aQuoteChar: Char): TTokenString;
begin
  FQuoteChar := aQuoteChar;
  Result := Self;
end;

function TTokenString.Sep(aSepChar: Char): TTokenString;
begin
  FSepChar := aSepChar;
  Result := Self;
end;

function TTokenString.GetEnumerator: TEnumerator<string>;
begin
  Result := TTokenStringEnumerator.Create(Self);
end;

function TTokenString.TokenAt(aTokenNum: Integer): string;
var
  j, idx, len: Integer;
  inQuote    : Boolean;
begin
  Result  := ''    ;
  inQuote := False ;
  idx     := Low(string) ;
  j       := 0     ;
  len     := High(FValue);

  while (j <= aTokenNum) and (idx <= len) do
  begin
    if FValue[idx] = FQuoteChar then
      inQuote := not inQuote
    else
    if not inQuote and (FValue[idx] = FSepChar) then
      Inc(j)
    else
    if j = aTokenNum then
       Result := Result + FValue[idx];
    Inc(idx);
  end;
end;

function TTokenString.TokenCount: Integer;
var
  len, idx: Cardinal;
  inQuote: Boolean ;
begin
  Result  := 0     ;
  inQuote := False ;
  idx     := Low(string) ;
  len     := High(FValue);

  while idx <= len do
  begin
    if (idx <= len) and (FValue[idx] = FSepChar) then
      Inc(idx);

    if not inQuote and (idx <= len) then
      Inc(Result);

    if (idx <= len) and (FValue[idx] = FQuoteChar) then
    begin
      Inc(idx);
      inQuote := not inQuote;
    end;

    if inQuote then
      while (idx <= len) and (FValue[idx] <> FQuoteChar) do
        Inc(idx)
    else
      while (idx <= len) and (FValue[idx] <> FSepChar) do
        Inc(idx);
  end;
end;

function TTokenString.TokenFromList(aSourceList: TStrings): TTokenString;
var
  idx: Integer ;
begin
  FValue := '' ;
  for idx := 0 to aSourceList.Count-1 do
    FValue := FValue + FQuoteChar + aSourceList[idx] + FQuoteChar + FSepChar;

  Result := Self;
end;

procedure TTokenString.TokenToList(aDestList: TStrings);
var
  token  : string;
  tokens : TStringDynArray;
begin
  aDestList.BeginUpdate;
  try
    aDestList.Clear ;
    tokens := ToArray;
    for token in tokens do
      aDestList.Add(token);
  finally
    aDestList.EndUpdate;
  end;
end;

function TTokenString.ToArray: TStringDynArray;
var
  idx, len : Integer;
  inQuote  : Boolean;
  token    : string;
begin
  Result.Clear;

  token   := '';
  inQuote := False ;
  idx     := Low(string) ;
  len     := High(FValue);

  while (idx <= len) do
  begin
    if FValue[idx] = FQuoteChar then
      inQuote := not inQuote
    else
    if not inQuote and (FValue[idx] = FSepChar) then
    begin
      Result.Add(token);
      token := '';
    end
    else
      token := token + FValue[idx];

    Inc(idx);
  end;

  if token <> '' then
    Result.Add(token);
end;

{$ENDREGION}

{$REGION 'TTokenString.TTokenStringEnumerator' }

constructor TTokenString.TTokenStringEnumerator.Create(aTokenString: TTokenString);
begin
  FCurrent := -1 ;
  FList    := aTokenString.ToArray;
end;

function TTokenString.TTokenStringEnumerator.DoGetCurrent: string;
begin
  Result := Flist[FCurrent];
end;

function TTokenString.TTokenStringEnumerator.DoMoveNext: Boolean;
begin
  Inc(FCurrent);
  Result := FCurrent < Length(FList);
end;

{$ENDREGION}

{$REGION 'TDateHelper'}

class function TDateHelper.Today: TDate;
begin
  Result := System.SysUtils.Date;
end;

class function TDateHelper.Tomorrow: TDate;
begin
  Result := System.SysUtils.Date + 1;
end;

class function TDateHelper.Yesterday: TDate;
begin
  Result := System.SysUtils.Date - 1;
end;

function TDateHelper.IsNull: Boolean;
begin
  Result := (Self = NullDate);
end;

function TDateHelper.IsNotNull: Boolean;
begin
  Result := (Self <> NullDate);
end;

function TDateHelper.IsToday: Boolean;
begin
  Result := SameDate(Self, System.SysUtils.Date);
end;

function TDateHelper.IsNotToday: Boolean;
begin
  Result := not SameDate(Self, System.SysUtils.Date);
end;

function TDateHelper.IsInLeapYear: Boolean;
begin
  Result := IsLeapYear(YearOf(Self));
end;

function TDateHelper.IsInRange(aFromDate, aEndDate: TDate): Boolean;
begin
  Result := DateInRange(Self, aFromDate, aEndDate, True);
end;

function TDateHelper.LastDayOfMonth: TDate;
var
  m, d, y: Word ;
begin
  DecodeDate(Self, y, m, d);
  Result := EncodeDate(y, m, DaysInMonth(y, m)) ;
end;

function TDateHelper.FirstDayOfMonth: TDate;
var
  m, d, y: Word ;
begin
  DecodeDate(Self, y, m, d);
  Result := EncodeDate(y, m, 1) ;
end;

function TDateHelper.DaysBetween(aValue: TDate): Integer;
begin
  Result := System.DateUtils.DaysBetween(Self, aValue);
end;

function TDateHelper.MonthsBetween(aValue: TDate): Integer;
begin
  Result := System.DateUtils.MonthsBetween(Self, aValue);
end;

function TDateHelper.YearsBetween(aValue: TDate): Integer;
begin
  Result := System.DateUtils.YearsBetween(Self, aValue);
end;

class function TDateHelper.DaysInMonth(aYear, aMonth: Word): Integer;
begin
  Result := MonthDays[(aMonth = 2) and IsLeapYear(aYear), aMonth];
end;

function TDateHelper.DaysInMonth: Integer;
var
  m, d, y: Word ;
begin
  if IsNull then
    Result := 0
  else
  begin
    DecodeDate(Self, y, m, d);
    Result := DaysInMonth(y, m);
  end;
end;

procedure TDateHelper.Decode(out aYear, aMonth, aDay: Word);
begin
  if IsNull then
  begin
    aYear := 0;
    aMonth:= 0;
    aDay  := 0;
  end
  else
    DecodeDate(Self, aYear, aMonth, ADay);
end;

class function TDateHelper.Encode(aYear, aMonth, ADay: Word): TDate;
begin
  Result := EncodeDate(aYear, aMonth, ADay);
end;

class function TDateHelper.Create(aYear, aMonth, ADay: Word): TDate;
begin
  Result := EncodeDate(aYear, aMonth, ADay);
end;

function TDateHelper.Equals(aValue: TDate): Boolean;
begin
  Result := SameDate(Self,aValue);
end;

function TDateHelper.GetDay: Word;
begin
  if IsNull then
    Result := 0
  else
    Result := DayOf(Self);
end;

function TDateHelper.GetDayOfWeek: Integer;
begin
  if IsNull then
    Result := 0
  else
    Result := DayOfTheWeek(Self) ;
end;

function TDateHelper.GetDayOfYear: Integer;
begin
  if IsNull then
    Result := 0
  else
    Result := DayOfTheYear(Self);
end;

function TDateHelper.GetMonth: Word;
begin
  if IsNull then
    Result := 0
  else
    Result := MonthOf(Self);
end;

function TDateHelper.GetWeek: Word;
begin
  if IsNull then
    Result := 0
  else
    Result := WeekOf(Self);
end;

function TDateHelper.GetYear: Word;
begin
  if IsNull then
    Result := 0
  else
    Result := YearOf(Self);
end;

procedure TDateHelper.IfNotEmpty(aProc: TProc<TDate>);
begin
  if IsNotNull then
    aProc(Self);
end;

function TDateHelper.IfNull(aDefault: TDate): TDate;
begin
  if IsNull then
    Result := aDefault
  else
    Result := Self;
end;

function TDateHelper.IncDay(aDays: Integer): TDate;
begin
  Self := System.DateUtils.IncDay(Self,aDays);
  Result := Self;
end;

function TDateHelper.IncMonth(aMonths: Integer): TDate;
begin
  Self := System.SysUtils.IncMonth(Self,aMonths);
  Result := Self;
end;

function TDateHelper.IncYear(aYears: Integer): TDate;
begin
  Self := System.DateUtils.IncYear(Self,aYears);
  Result := Self;
end;

function TDateHelper.ToInt: Integer;
var
  yy, mm, dd: Word ;
begin
  if IsNull then
    Result := 0
  else
  begin
    DecodeDate( Self, yy, mm, dd ) ;
    Result := ( LongInt(yy) * 10000 ) + ( LongInt(mm) * 100 ) + LongInt(dd) ;
  end;
end;

function TDateHelper.ToString: string;
begin
  if IsNull then
    Result := ''
  else
    Result := DateToStr(Self);
end;

function TDateHelper.ToStringFormat(const aFormat: string; aDateSeparator: Char): string;
var
  fmt: TFormatSettings;
begin
  if IsNull then
    Result := ''
  else
  begin
    fmt := TFormatSettings.Create;
    fmt.DateSeparator := aDateSeparator;
    Result := FormatDateTime(aFormat, Self, fmt);
  end;
end;

function TDateHelper.ToStringFormat(const aFormat: string; aFormatSettings: TFormatSettings): string;
begin
  if IsNull then
    Result := ''
  else
    Result := FormatDateTime(aFormat,Self,aFormatSettings);
end;

function TDateHelper.ToStringFormat(const aFormat: string): string;
begin
  if IsNull then
    Result := ''
  else
    Result := FormatDateTime(aFormat,Self);
end;

function TDateHelper.ToStringUTC: string;
begin
  if IsNull then
    Result := ''
  else
    Result := FormatDateTime('yyyy"-"mm"-"dd', Self);
end;

class function TDateHelper.Max(const aDateA, aDateB: TDate): TDate;
begin
  if aDateA > aDateB then
    Result := aDateA
  else
    Result := aDateB;
end;

{$ENDREGION}

{$REGION 'TTimeHelper'}

function TTimeHelper.IsNotNull: Boolean;
begin
  Result := Self <> NullTime;
end;

function TTimeHelper.IsNull: Boolean;
begin
  Result := Self = NullTime;
end;

function TTimeHelper.IsPM: Boolean;
begin
  Result := System.DateUtils.IsPM(Self);
end;

function TTimeHelper.IsAM: Boolean;
begin
  Result := System.DateUtils.IsAM(Self);
end;

procedure TTimeHelper.Decode(out aHour, aMin, aSec, aMilliSec: Word);
begin
  DecodeTime( Self, aHour, aMin, aSec, aMilliSec ) ;
end;

procedure TTimeHelper.Decode(out aHour, aMin, aSec: Word);
var
  aMilliSec: Word;
begin
  DecodeTime( Self, aHour, aMin, aSec, aMilliSec ) ;
end;

procedure TTimeHelper.Decode(out aHour, aMin: Word);
var
  aSec, aMilliSec: Word;
begin
  DecodeTime( Self, aHour, aMin, aSec, aMilliSec ) ;
end;

class function TTimeHelper.Encode(aHour, aMin, aSec, aMilliSec: Word): TTime;
begin
  Result := EncodeTime(aHour, aMin, aSec, aMilliSec);
end;

class function TTimeHelper.Create(aHour, aMin, aSec, aMilliSec: Word): TTime;
begin
  Result := EncodeTime(aHour, aMin, aSec, aMilliSec);
end;

function TTimeHelper.Equals(aValue: TTime): Boolean;
begin
  Result := SameTime(Self, aValue);
end;

function TTimeHelper.GetHour: Word;
begin
  Result := HourOf(Self);
end;

function TTimeHelper.GetMilliSecond: Word;
begin
  Result := MilliSecondOf(Self);
end;

function TTimeHelper.GetMilliSecondOfDay: Integer;
begin
  Result := MilliSecondOfTheDay(Self)
end;

function TTimeHelper.GetMinute: Word;
begin
  Result := MinuteOf(Self);
end;

function TTimeHelper.GetMinuteOfDay: Integer;
begin
  Result := MinuteOfTheDay(Self);
end;

function TTimeHelper.GetSecond: Word;
begin
  Result := SecondOf(Self);
end;

function TTimeHelper.GetSecondOfDay: Integer;
begin
  Result := SecondOfTheDay(Self);
end;

function TTimeHelper.IncHour(aHours: Integer): TTime;
begin
  Self  := System.DateUtils.IncHour(Self,aHours) ;
  Result:= Self;
end;

function TTimeHelper.IncMinute(aMinutes: Integer): TTime;
begin
  Self   := System.DateUtils.IncMinute(Self,aMinutes);
  Result := Self;
end;

function TTimeHelper.IncMiliSecond(aMilliSeconds: Integer): TTime;
begin
  Self   := System.DateUtils.IncMilliSecond(Self,aMilliSeconds);
  Result := Self;
end;

function TTimeHelper.IncSecond(aSeconds: Integer): TTime;
begin
  Self := System.DateUtils.IncSecond(Self,aSeconds);
  Result := Self;
end;

class function TTimeHelper.FistTimeOfTheDay: TTime;
begin
  Result := EncodeTime(0,0,0,0) ;
end;

class function TTimeHelper.LastTimeOfTheDay: TTime;
begin
  Result := EncodeTime(23,59,59,999);
end;

class function TTimeHelper.Now: TTime;
begin
  Result := System.SysUtils.Time;
end;

function TTimeHelper.HoursBetween(aValue: TTime): Integer;
begin
  Result := System.DateUtils.HoursBetween(Self,aValue);
end;

function TTimeHelper.MinutesBetween(aValue: TTime): Integer;
begin
  Result := System.DateUtils.MinutesBetween(Self,aValue);
end;

function TTimeHelper.SecondsBetween(aValue: TTime): Integer;
begin
  Result := System.DateUtils.SecondsBetween(Self,aValue);
end;

function TTimeHelper.MillisecondsBetween(aValue: TTime): Integer;
begin
  Result := System.DateUtils.MilliSecondsBetween(Self,aValue);
end;

function TTimeHelper.ToInt(aFormat: TTimeConvFormat): Integer;
var
  hh, mm, ss, ms:word ;
begin
  if IsNull then
    Result := 0
  else
  begin
    DecodeTime( Self, hh, mm, ss, ms ) ;
    case aFormat of
      HHMM  : Result := (LongInt(hh)*  100) + LongInt(mm) ;
      HHMMSS: Result := (LongInt(hh)*10000) + LongInt(mm*100) + LongInt(ss) ;
    else
      Result := ( LongInt(hh) * 10000000 ) + ( LongInt(mm) * 100000 ) +
                ( LongInt(ss) * 1000     ) + LongInt(ms) ;
    end;
  end;
end;

function TTimeHelper.ToString: string;
begin
  Result := TimeToStr(Self);
end;

function TTimeHelper.ToStringFormat(const aFormat: string; aTimeSeparator: Char): string;
var
  fmt: TFormatSettings;
begin
  fmt := TFormatSettings.Create;
  fmt.TimeSeparator := aTimeSeparator;
  Result := FormatDateTime(aFormat, Self, fmt);
end;

function TTimeHelper.ToStringFormat(const aFormat: string; aFormatSettings: TFormatSettings): string;
begin
  Result := FormatDateTime(aFormat, Self, aFormatSettings);
end;

function TTimeHelper.ToStringFormat(const aFormat: string): string;
begin
  Result := FormatDateTime(aFormat, Self);
end;

{$ENDREGION}

{$REGION 'TDateTimeHelper'}

function TDateTimeHelper.GetDate: TDate;
begin
  Result := DateOf(Self);
end;

function TDateTimeHelper.GetTime: TTime;
begin
  Result := TimeOf(Self);
end;

function TDateTimeHelper.IsNotNull: Boolean;
begin
  Result := Self <> NullDateTime;
end;

function TDateTimeHelper.IsNull: Boolean;
begin
  Result := Self = NullDateTime;
end;

class function TDateTimeHelper.NowToday: TDateTime;
begin
  Result := System.SysUtils.Now;
end;

procedure TDateTimeHelper.SetDate(const Value: TDate);
begin
  Self := Trunc(Value) + Frac(Self);
end;

procedure TDateTimeHelper.SetTime(const Value: TTime);
begin
  Self := Trunc(Self) + Frac(Value);
end;

function TDateTimeHelper.ToString: string;
begin
  if IsNull then
    Result := ''
  else
    Result := DateTimeToStr(Self);
end;

function TDateTimeHelper.ToStringFormat(const aFormat: string; aDateSeparator, aTimeSeparator: Char): string;
var
  fmt: TFormatSettings;
begin
  if IsNull then
    Result := ''
  else
  begin
    fmt := TFormatSettings.Create;
    fmt.DateSeparator := aDateSeparator;
    fmt.TimeSeparator := aTimeSeparator;
    Result := FormatDateTime(aFormat, Self, fmt);
  end;
end;

function TDateTimeHelper.ToStringFormat(const aFormat: string; aDateSeparator: Char): string;
var
  fmt: TFormatSettings;
begin
  if IsNull then
    Result := ''
  else
  begin
    fmt := TFormatSettings.Create;
    fmt.DateSeparator := aDateSeparator;
    Result := FormatDateTime(aFormat, Self, fmt);
  end;
end;

function TDateTimeHelper.ToStringFormat(const aFormat: string): string;
begin
  if IsNull then
    Result := ''
  else
    Result := FormatDateTime(aFormat, Self);
end;

function TDateTimeHelper.ToStringFormat(const aFormat: string; aFormatSettings: TFormatSettings): string;
begin
  if IsNull then
    Result := ''
  else
    Result := FormatDateTime(aFormat, Self, aFormatSettings);
end;

function TDateTimeHelper.ToStringISO: string;
begin
  if IsNull then
    Result := ''
  else
    Result := System.DateUtils.DateToISO8601(Self,False);
end;

function TDateTimeHelper.ToStringUTC: string;
begin
  if IsNull then
    Result := ''
  else
    Result := System.DateUtils.DateToISO8601(Self,True);
end;

{$ENDREGION}

{$REGION 'TStringDynArrayHelper' }

function TStringDynArrayHelper.IsEmpty: Boolean;
begin
  Result := Length(Self) = 0;
end;

function TStringDynArrayHelper.IsNotEmpty: Boolean;
begin
  Result := Length(Self) > 0;
end;

function TStringDynArrayHelper.Count: Integer;
begin
  Result := Length(Self);
end;

procedure TStringDynArrayHelper.Clear;
begin
  SetLength(Self,0);
end;

procedure TStringDynArrayHelper.Resize(aCount: Integer);
begin
  SetLength(Self,aCount);
end;

function TStringDynArrayHelper.ToString(const aLineSep: string): string;
var
  s: string;
begin
  Result := '';
  for s in self do
    Result := Result.Concat(aLineSep, s);
end;

procedure TStringDynArrayHelper.Add(const aValue: string);
begin
  SetLength(Self,Length(Self)+1);
  Self[High(Self)] := aValue;
end;

procedure TStringDynArrayHelper.Add(aValues: TStringDynArray; aStartItem: Integer; aItemCount: Integer);
var
  idx, idxStart, idxAdd: Integer;
begin
  if Length(aValues) = 0 then
    Exit;

  if (aItemCount = -1) or (aStartItem+aItemCount > Length(aValues)) then
    aItemCount := Length(aValues)-aStartItem;

  idxAdd   := 0 ;
  idxStart := Length(Self);
  SetLength(Self, idxStart+aItemCount);
  for idx := aStartItem to aStartItem+aItemCount-1 do
  begin
    Self[idxStart+idxAdd] := aValues[idx];
    Inc(idxAdd);
  end;
end;

procedure TStringDynArrayHelper.Add(aValues: TStrings; aStartItem: Integer; aItemCount: Integer);
begin
  Add(aValues.ToStringArray, aStartItem, aItemCount);
end;

procedure TStringDynArrayHelper.Delete(aIndex: Integer);
var
  idx: Integer;
begin
  if (aIndex > High(Self)) or (aIndex < 0) then
    Exit;

  for idx := aIndex to High(Self)-1 do
    Self[idx] := Self[idx+1];

  SetLength(Self,Length(Self)-1);
end;

function TStringDynArrayHelper.Get(aIndex: Integer; const aDefault: string): string;
begin
  if (aIndex > High(Self)) or (aIndex < 0) then
    Result := aDefault
  else
    Result := Self[aIndex];
end;

function TStringDynArrayHelper.IndexOf(const aValue: string; aStartPosition: Integer; aCompareOption: TStringHelper.TCompareOption): Integer;
begin
  for Result := AStartPosition to High(Self) do
    if ((aCompareOption = coCaseInsensitive) and (AnsiCompareText(aValue, Self[Result]) = 0)) or
       ((aCompareOption = coCaseSensitive  ) and (aValue = Self[Result]))                     then
       Exit;

  Result := -1;
end;

function TStringDynArrayHelper.IndexOf(const aValue: string; aCompareOption: TStringHelper.TCompareOption): Integer;
begin
  Result := IndexOf(aValue,0,aCompareOption);
end;

function TStringDynArrayHelper.Contains(const aValue: string; aCompareOption: TStringHelper.TCompareOption): Boolean;
begin
  Result := (IndexOf(aValue,0,aCompareOption) > -1);
end;

function TStringDynArrayHelper.First: string;
begin
  if Length(Self) > 0 then
    Result := Self[0]
  else
    Result := '';
end;

function TStringDynArrayHelper.Last: string;
begin
  if Length(Self) > 0 then
    Result := Self[High(Self)]
  else
    Result := '';
end;

{$ENDREGION}

{$REGION 'TObjectHelper' }

function TObjectHelper.IsClass(aClass: TClass): Boolean;
begin
  Result := Assigned(Self) and (Self is aClass) ;
end;

function TObjectHelper.CastAs<T>: T;
begin
  if IsClass(T) then
    Result := T(Self)
  else
    Result := nil;
end;

function TObjectHelper.IsNotNull: Boolean;
begin
  Result := Self <> nil;
end;

function TObjectHelper.IsNull: Boolean;
begin
  Result := Self = nil;
end;

{$ENDREGION}

end.
