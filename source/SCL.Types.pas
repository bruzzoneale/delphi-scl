{
  @SCL.Types(standard base class and helpers for standard data types)
  @author(bruzzoneale)
}
unit SCL.Types;

interface

uses
  System.Character,
  System.SysUtils,
  System.Classes,
  System.Types,
  System.Math,
  System.DateUtils,
  System.Masks,
  System.NetEncoding,
  System.Generics.Collections;

const
  DEFAULT_FORMATFLOAT = '#,##0.00';

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

    function Inc: Integer                      ; overload ; inline ;
    function IncBy( aIncBy: Integer ): Integer ; overload; inline ;
    function Dec: Integer                      ; overload ; inline ;
    function DecBy( aDecBy: Integer ): Integer ; overload; inline ;

    //-------- query methods  ---------------------------------------

    function Abs: Integer ; overload ; inline ;

    //-------- conversion methods -----------------------------------

          function ToString: string ; overload ; inline ;
          function ToString( aLength: Integer; aLeadingChar: Char=' ' ): string         ; overload ; inline;
    class function ToString( aValue, aLength: Integer; aLeadingChar: Char=' ' ): string ; overload ; static;

          function ToStringZero( aLength: Integer ): string       ; overload; inline;
    class function ToStringZero( aValue, aLength: Integer): string; overload; static;

          function ToStringHex: string                  ; overload ; inline ;
    class function ToStringHex(aValue: Integer): string ; overload ; static ; inline ;

          function ToStringRoman: string                  ; overload ; inline ;
    class function ToStringRoman(aValue: Integer): string ; overload ; static ;

          function ToStringFormat( const aFormat: string ): string                  ; overload ; inline ;
    class function ToStringFormat( aValue: Integer; const aFormat: string ): string ; overload ; static ; inline ;
          function ToStringFormat( const aFormat: string; const aFormatSettings: TFormatSettings ): string ; overload ; inline ;
    class function ToStringFormat( aValue: Integer; const aFormat: string; const aFormatSettings: TFormatSettings ): string ; overload ; static ; inline ;

    /// <summary> Converts integer value in the format YYYYMMDD to date </summary>
          function ToDate: TDate                  ; overload ; inline ;
    class function ToDate(aValue: Integer): TDate ; overload ; static ;

    /// <summary> Converts integer value in the format HHMMSSMMS, HHMMSS, HHMM to time </summary>
          function ToTime(aFormat: TTimeConvFormat = HHMMSSMSS): TTime                  ; overload ; inline ;
    class function ToTime(aValue: Integer; aFormat: TTimeConvFormat = HHMMSSMSS): TTime ; overload ; static ;

    /// <summary>
    ///   Converts integer value to double assuming fixed decimal digits
    ///   Example:  ToFloatWithDecimals(20099, 2) => 200.99
    /// </summary>
          function ToFloatWithDecimals(aDecimalDigits: Integer): Double        ; overload ; inline;
    class function ToFloatWithDecimals(aValue, aDecimalDigits: Integer): Double; overload ; static;

    //-------- utlities ----------------------------

    class procedure Swap(var aValue1, aValue2: Integer)   ; static ; inline ;
    /// <summary>
    ///  Simple random number generator: aTotValues assuming maximun values
    ///  Example: Random(100) => a random number between 0 and 99
    /// </summary>
    class function Random( aTotValues: Integer = MaxValue): Integer ; static ;
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
          function ToString( aLength: Integer; aLeadingChar: Char=' ' ): string                 ; overload ; inline;
    class function ToString( aValue: Int64; aLength: Integer; aLeadingChar: Char=' ' ): string  ; overload ; static ;
          function ToStringZero( aLength: Integer ): string                ; overload ; inline ;
    class function ToStringZero( aValue: Int64; aLength: Integer ): string ; overload ; static ;
          function ToStringFormat( const aFormat: string ): string                ; overload ; inline ;
    class function ToStringFormat( aValue: Int64; const aFormat: string ): string ; overload ; static ; inline ;
          function ToStringFormat( const aFormat: string; const aFormatSettings: TFormatSettings ): string ; overload ; inline ;
    class function ToStringFormat( aValue: Int64; const aFormat: string; const aFormatSettings: TFormatSettings ): string ; overload ; static ; inline ;
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

          function ToInt: Int64                 ; overload ; inline ;
    class function ToInt(aValue: Double): Int64 ; overload ; inline ; static ;
          function ToRoundInt: Int64                  ; overload ; inline ;
    class function ToRoundInt(aValue: Double): Int64  ; overload ; inline ; static ;
    /// <summary>
    ///   Converts to integer value including fixed decimal digits
    ///   Example:  ToIntWithDecimals(200.99, 2) => 20099
    /// </summary>
          function ToIntWithDecimals(aDecimalDigits: Integer): Int64                ; overload ; inline ;
    class function ToIntWithDecimals(aValue: Double; aDecimalDigits: Integer): Int64; overload ; inline ; static;

          function ToString: string                   ; overload ; inline ;
    class function ToString(aValue: Double): string   ; overload ; inline ; static ;
          function ToString( aLength: Integer; aLeadingChar: Char=' ' ): string                 ; overload ;
    class function ToString( aValue: Double; aLength: Integer; aLeadingChar: Char=' ' ): string ; overload ; static ;
          function ToStringZero( aLength: Integer ): string                ; overload ;
    class function ToStringZero(aValue: Double; aLength: Integer ): string ; overload ; static ;
          function ToStringFormat( const aFormat: string=DEFAULT_FORMATFLOAT ): string                ; overload ; inline ;
    class function ToStringFormat(aValue: Double; const aFormat: string=DEFAULT_FORMATFLOAT ): string ; overload ; inline ; static ;
          function ToStringFormat(const aFormat: string; const aFormatSettings: TFormatSettings ): string                 ; overload ; inline ;
    class function ToStringFormat(aValue: Double; const aFormat: string; const aFormatSettings: TFormatSettings ): string ; overload ; inline ; static ;

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

          function ToInt: Int64                 ; overload ; inline ;
    class function ToInt(aValue: Double): Int64 ; overload ; inline ; static ;

          function ToString: string                   ; overload ; inline ;
    class function ToString(aValue: Currency): string ; overload ; inline ; static ;
          function ToString( aLength: Integer; aLeadingChar: Char=' ' ): string                   ; overload ;
    class function ToString( aValue: Currency; aLength: Integer; ALeadingChar: Char=' ' ): string ; overload ; static ;
          function ToStringZero(aLength: Integer ): string                   ; overload ;
    class function ToStringZero(aValue: Currency; aLength: Integer ): string ; overload ; static ;
          function ToStringFormat( const aFormat: string=DEFAULT_FORMATFLOAT ): string                  ; overload ; inline ;
    class function ToStringFormat(aValue: Currency; const aFormat: string=DEFAULT_FORMATFLOAT ): string ; overload ; static ; inline ;
          function ToStringFormat( const aFormat: string; const aFormatSettings: TFormatSettings ): string                  ; overload ; inline ;
    class function ToStringFormat(aValue: Currency; const AFormat: string; const aFormatSettings: TFormatSettings ): string ; overload ; static ; inline ;

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

    //-------- conversion methods -----------------------------------

          function ToInt(aDefault: Integer = 0): Integer                          ; overload ; inline ;
    class function ToInt(const aValue: string; aDefault: Integer = 0 ): Integer   ; overload ; inline ; static ;
          function ToHexInt(aDefault: Integer = 0): Integer                       ; overload ; inline ;
    class function ToHexInt(const aValue: string; aDefault:Integer = 0): Integer  ; overload ; inline ; static ;
          function ToRomanInt(aDefault:Integer = 0): Integer                      ; overload ; inline ;
    class function ToRomanInt(const aValue: string; aDefault:Integer = 0): Integer; overload ; static ;
          function ToInt64(aDefault: Int64 = 0): Int64                            ; overload ; inline ;
    class function ToInt64(const aValue: string; aDefault: Int64 = 0): Int64      ; overload ; inline ; static ;
          function ToFloat(aDefault: Double = 0): Double                          ; overload ; inline ;
    class function ToFloat(const aValue: string; aDefault: Double = 0): Double    ; overload ; inline ; static ;
          function ToCurrency(aDefault: Currency = 0): Currency                       ; overload ; inline ;
    class function ToCurrency(const aValue: string; aDefault: Currency = 0): Currency ; overload ; inline ; static ;
          function ToDate(aDefault: TDateTime = 0.0; aDateSeparator: Char = #0; aDateFormat: string=''):TDate; overload ; inline ;
    class function ToDate(const aValue: string; aDefault: TDateTime = 0.0; aDateSeparator: Char = #0; aDateFormat: string=''):TDate ; overload ; static ;
          function ToTime(aDefault: TDateTime = 0.0; aTimeSeparator: Char = #0):TTime                      ; overload ; inline ;
    class function ToTime(const aValue: string; aDefault: TDateTime = 0.0; aTimeSeparator: Char = #0):TTime; overload ; static ;
          function ToDateTime(aDefault: TDateTime = 0.0; aDateSeparator: Char = #0; aTimeSeparator: Char = #0):TDateTime                      ; overload ; inline ;
    class function ToDateTime(const aValue: string; aDefault: TDateTime = 0.0; aDateSeparator: Char = #0; aTimeSeparator: Char = #0):TDateTime; overload ; static ;

          function ToHTML: string                        ; overload ; inline ;
    class function ToHTML(const aValue: string): string  ; overload ; inline ; static ;
          function ToURL: string                         ; overload ; inline ;
    class function ToURL(const aValue: string): string   ; overload ; inline ; static ;

          function ToBase64: string                      ; overload ; inline ;
    class function ToBase64(const aValue: string): string; overload ; inline ; static ;
          function ToBase64(aCharsPerLine: Integer; const aSeparator: string=#13#10): string                      ; overload ; inline ;
    class function ToBase64(const aValue: string; aCharsPerLine: Integer; const aSeparator: string=#13#10): string; overload ; static ;

          function FromBase64: string                                  ; overload ; inline ;
          function FromBase64(const aSeparator: string): string        ; overload ; inline ;
    class function FromBase64(const aValue, aSeparator: string): string; overload ; inline ; static ;

          procedure ToFile(const aFileName: string; aEncoding: TEncoding = nil)         ; overload ; inline ;
          procedure ToFileWithBOM(const aFileName: string; aEncoding: TEncoding = nil)  ; overload ; inline ;
    class procedure ToFile(const aValue, aFileName: string; aEncoding: TEncoding = nil; aWriteBOM: Boolean = false) ; overload ; static ;

    //-------- query methods  ---------------------------------------

          function IsNull: Boolean                       ; overload ; inline ;
    class function IsNull(const aValue: string): Boolean ; overload ; inline ; static ;
          function IsNotNull: Boolean                       ; overload ; inline ;
    class function IsNotNull(const aValue: string): Boolean ; overload ; inline ; static ;
          function IsEmpty: Boolean                         ; overload ; inline ;
    class function IsEmpty(const aValue: string): Boolean   ; overload ; inline ; static ;
          function IsNotEmpty: Boolean                      ; overload ; inline ;
    class function IsNotEmpty(const aValue: string): Boolean; overload ; inline ; static ;

          function IfNull(const aDefault: string): string         ; overload ; inline ;
    class function IfNull(const aValue, aDefault: string): string ; overload ; inline ; static ;
          function IfEmpty(const aDefault: string): string        ; overload ; inline ;
    class function IfEmpty(const aValue, aDefault: string): string; overload ; inline ; static ;
         procedure IfNotEmpty(aProc: TProc<string>)               ; overload ; inline ;
          function IfNotEmpty(aFunc: TFunc<string,string>; aDefault: string=''): string; overload ; inline ;

          function Len: Integer                      ; overload ; inline;
    class function Len(const aValue: string): Integer; overload ; inline ; static ;
          function Left( aCount: Integer ): string                     ; overload ; inline ;
    class function Left(const aValue: string; aCount: Integer): string ; overload ; inline ; static ;
          function Right( aCount: Integer ): string                       ; overload ; inline ;
    class function Right( const aValue: string; aCount: Integer ): string ; overload ; inline ; static ;
          function Copy ( aStart: Integer; aCount: Integer ): string                       ; overload ; inline ;
    class function Copy ( const aValue: string; aStart: Integer; aCount: Integer ): string ; overload ; static ;
          function CopyFrom ( aStart: Integer): string                       ; overload ; inline ;
    class function CopyFrom ( const aValue: string; aStart: Integer): string ; overload ; inline ; static ;

          function Pos(const aSubStr: string ; aStartChar: Integer = 0): Integer         ; overload ; inline ;
    class function Pos(const aValue, aSubStr: string ; aStartChar: Integer = 0): Integer ; overload ; inline ; static ;
          function PosRight(const aSubStr: string ; aStartChar: Integer = 0): Integer         ; overload ; inline ;
    class function PosRight(const aSubStr, aValue: string ; aStartChar: Integer = 0): Integer ; overload ; static ;

          function IndexInArray(const aValues: TStringDynArray; aCompareOption: TCompareOption): Integer; overload ; inline ;
          function IndexInArray(const aValues: TStringDynArray): Integer                                ; overload ; inline ;
    class function IndexInArray( const aValue: string; const aValues: TStringDynArray;
                                 aCompareOption: TCompareOption = coCaseSensitive): Integer             ; overload ; static ;

          function IsInArray(const aValues: TStringDynArray; aCompareOption: TCompareOption): Boolean; overload ; inline ;
          function IsInArray(const aValues: TStringDynArray): Boolean                                ; overload ; inline ;
    class function IsInArray(const aValue: string; const aValues: TStringDynArray;
                                   aCompareOption: TCompareOption = coCaseSensitive): Boolean        ; overload ; inline ; static ;

          function SameAs(const aValue: string): Boolean           ; overload ; inline ;
    class function SameAs(const aValue1, aValue2: string): Boolean ; overload ; inline ; static ;
          function Equals(const aValue: string): Boolean           ; overload ; inline ;
    class function Equals(const aValue1, aValue2: string): Boolean ; overload ; inline ; static ;

          function StartsWith(const aSubStr: string;
                            aCompareOption: TCompareOption): Boolean                    ; overload ; inline ;
          function StartsWith(const aSubStr: string): Boolean                           ; overload ; inline ;
    class function StartsWith(const aValue, aSubStr: string;
                            aCompareOption: TCompareOption = coCaseSensitive ): Boolean ; overload ; static ;

          function EndsWith(const aSubStr: string;
                            aCompareOption: TCompareOption): Boolean                    ; overload ; inline ;
          function EndsWith(const aSubStr: string): Boolean                             ; overload ; inline ;
    class function EndsWith(const aValue, aSubStr: string;
                            aCompareOption: TCompareOption = coCaseSensitive ): Boolean ; overload ; static ;

          function Contains( const aSubStr: string;
                            aCompareOption: TCompareOption): Boolean                    ; overload ; inline ;
          function Contains( const aSubStr: string): Boolean                            ; overload ; inline ;
    class function Contains( const aValue, aSubStr: string;
                            aCompareOption: TCompareOption = coCaseSensitive ): Boolean ; overload ; static ;

          function MatchesMask( const aMask: string): Boolean         ; overload ; inline ;
    class function MatchesMask( const aValue, aMask: string): Boolean ; overload ; inline ; static ;

          function WordCount(aWordSeparators: TSysCharSet = [] ): Integer                       ; overload ; inline ;
    class function WordCount(const aValue: string; aWordSeparators: TSysCharSet = [] ): Integer ; overload ; static ;
          function WordPos(aWordNum: Integer; aWordSeparators: TSysCharSet = []): Integer                      ; overload ; inline ;
    class function WordPos(const aValue: string; aWordNum: Integer; aWordSeparators: TSysCharSet = []): Integer; overload ; static ;
          function WordAt(aWordNum: Integer; aWordSeparators: TSysCharSet = []): string                        ; overload ; inline ;
    class function WordAt(const aValue: string; aWordNum: Integer; aWordSeparators: TSysCharSet = []): string  ; overload ; static ;
          function IsWordPresent(const aWord: string; aWordSeparators: TSysCharSet = []): Boolean         ; overload ; inline ;
    class function IsWordPresent(const aValue, aWord: string; aWordSeparators: TSysCharSet = []): Boolean ; overload ; static ;

          function IsInteger: Boolean   ; inline;
          function IsFloat  : Boolean   ; inline;
          function IsInt64  : Boolean   ; inline;
          function IsDate(aDateSeparator: Char = #0; const aDateFormat: string = ''): Boolean; inline;
          function IsTime(aTimeSeparator: Char = #0): Boolean                                ; inline;

    //-------- string manipulation methods ----------------------------

          function ToUpper: string                       ; overload ; inline ;
    class function ToUpper(const aValue: string): string ; overload ; inline ; static ;
          function ToLower: string                       ; overload ; inline ;
    class function ToLower(const aValue: string): string ; overload ; inline ; static ;

          function PadLeft( aLength: Integer; ALeadingChar: char =' ' ): string                        ; overload ; inline ;
    class function PadLeft( const aValue: string ; aLength: Integer; ALeadingChar: char =' ' ): string ; overload ; static ;
          function PadRight ( aLength: Integer; ALeadingChar: char =' ' ): string                       ; overload ; inline ;
    class function PadRight ( const aValue: string; aLength: Integer; ALeadingChar: char =' ' ): string ; overload ; static ;
          function PadCenter( aLength: Integer; ALeadingChar: char =' ' ): string                        ; overload ; inline ;
    class function PadCenter( const aValue: string ; aLength: Integer; ALeadingChar: char =' ' ): string ; overload ; static ;

          function TrimLeft: string                       ; overload ; inline;
    class function TrimLeft(const aValue: string): string ; overload ; inline ; static ;
          function TrimRight: string; overload ; inline;
    class function TrimRight(const aValue: string): string; overload ; inline ; static ;
          function Trim: string; inline;

          function QuotedString(const aQuoteChar: Char): string                             ; overload; inline ;
          function QuotedString: string                                                     ; overload; inline ;
    class function QuotedString(const aValue: string; const aQuoteChar: Char = ''''): string; overload; inline ; static ;

          function DeQuotedString(const aQuoteChar: Char): string                             ; overload; inline ;
          function DeQuotedString: string                                                     ; overload; inline ;
    class function DeQuotedString(const aValue: string; const aQuoteChar: Char = ''''): string; overload; inline ; static ;

          function UppercaseLetter: string                      ; overload ; inline ;
    class function UppercaseLetter(const aValue: string): string; overload ; inline ; static ;
          function UppercaseWordLetter(aWordSeparators: TSysCharSet = [] ): string                       ; overload ; inline ;
    class function UppercaseWordLetter(const aValue: string; aWordSeparators: TSysCharSet = [] ): string ; overload ; static ;

          function EnsurePrefix(const aPrefix: string): string        ; overload ; inline;
    class function EnsurePrefix(const aValue, aPrefix: string): string; overload ; inline; static;

          function EnsureSuffix(const aSuffix: string): string        ; overload ; inline ;
    class function EnsureSuffix(const aValue, aSuffix: string): string; overload ; inline ; static;

          function Replace( const aSearchStr, aReplaceStr: string; aCompareOption: TCompareOption): string         ; overload ; inline ;
          function Replace( const aSearchStr, aReplaceStr: string): string                                         ; overload ; inline ;
    class function Replace( const aValue, aSearchStr, aReplaceStr: string; aCompareOption: TCompareOption = coCaseSensitive ): string ; overload ; inline ; static;

          function RemoveChars(aRemoveChars: TSysCharSet): string                       ; overload; inline;
    class function RemoveChars( const aValue: string; aRemoveChars: TSysCharSet): string; overload; static;

          function ReplaceInvalidChars(aValidStrChars: TSysCharSet; const aReplaceStr: string): string       ; overload ; inline;
          function ReplaceInvalidChars(const aValidStrChars, aReplaceStr: string): string                    ; overload ; inline;
    class function ReplaceInvalidChars(const aValue: string; aValidStrChars: TSysCharSet; aReplaceStr: string): string; overload ; static; inline;
    class function ReplaceInvalidChars(const aValue, aValidStrChars, aReplaceStr: string): string            ; overload ; static; inline;

          function Concat(const aSeparator, aConcatValue: string): string; inline;
          function ConcatIfNotEmpty(const aSeparator, aConcatValue: string): string; inline;
          function ConcatIfNotNull(const aSeparator, aConcatValue: string): string; inline;

          function Split(aSeparator: Char; aQuote: Char ='"'): TStringDynArray; overload ; inline;
    class function Split(const aValue: string; aSeparator: Char; aQuote: Char ='"'): TStringDynArray; overload ; static ; inline;

          function Extract( AStart: Integer; aCount: Integer = -1 ): string                     ; overload ; inline ;
    class function Extract( var aValue: string; AStart: Integer; aCount: Integer = -1 ): string ; overload ; static ;

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
  end;


  TDateHelper = record helper for TDate
  private
  {$REGION 'Property Accessors'}
      function GetDay: Word; inline ;
      function GetMonth: Word; inline ;
      function GetYear: Word; inline ;
      function GetDayOfWeek: Word; inline;
      function GetDayOfYear: Word; inline;
      function GetWeek: Word; inline ;
  {$ENDREGION}
  public
    const NullDate: TDate = 0.0;

    //-------- conversion methods -----------------------------------

          function ToString: string                  ; overload ; inline ;
    class function ToString( aValue: TDate ): string ; overload ; inline ; static ;
          function ToStringFormat(const aFormat: string): string                  ; overload ; inline ;
          function ToStringFormat(const aFormat: string; AFormatSettings: TFormatSettings): string; overload ; inline ;
    class function ToStringFormat( aValue: TDate; const aFormat: string ): string ; overload ; inline ; static ;
    class function ToStringFormat( aValue: TDate; const aFormat: string; AFormatSettings: TFormatSettings): string ; overload ; inline ; static ;

    /// <summary> Converts a date to integer with format YYYYMMDD </summary>
          function ToInt: Integer               ; overload ; inline ;
    class function ToInt(aValue: TDate): Integer; overload ; static ;

    class function Encode( aYear, aMonth, aDay: Word ): TDate ; inline ; static ;
          procedure Decode( out aYear, aMonth, aDay: Word )               ; overload ; inline ;
    class procedure Decode( aValue: TDate; out aYear, aMonth, aDay: Word ); overload ;inline ; static ;

    //-------- query methods  ---------------------------------------

          function IsNull: Boolean                  ; overload ; inline ;
    class function IsNull( aValue: TDate ): Boolean ; overload ; inline ; static ;
          function IsNotNull: Boolean                  ; overload ; inline ;
    class function IsNotNull( aValue: TDate ): Boolean ; overload ; inline ; static ;
          function IsInLeapYear: Boolean                  ; overload ; inline ;
    class function IsInLeapYear( aValue: TDate ): Boolean ; overload ; inline ; static ;
          function Equals( aValue: TDate ): Boolean          ; overload ; inline ;
    class function Equals( AValue1, AValue2: TDate ): Boolean; overload ; inline ; static ;

          property Day  : Word read GetDay;
          property Month: Word read GetMonth;
          property Year : Word read GetYear;
          property Week : Word read GetWeek;
          property DayOfWeek: Word read GetDayOfWeek;
          property DayOfYear: Word read GetDayOfYear;

          function DaysInMonth: Integer                        ; overload ; inline ;
    class function DaysInMonth( aValue: TDate): Integer        ; overload ; static ; inline ;
    class function DaysInMonth( aYear, aMonth: Word ): Integer ; overload ; static ; inline ;
          function FirstDayOfMonth: TDate                      ; overload ; inline ;
    class function FirstDayOfMonth( aValue: TDate ): TDate     ; overload ; static ; inline ;
          function LastDayOfMonth: TDate                       ; overload ; inline ;
    class function LastDayOfMonth( aValue: TDateTime ): TDate  ; overload ; static ; inline ;

    //-------- alter value methods ----------------------------

          function IncDay( aDays: Integer = 1 ): TDate                      ; overload ; inline ;
    class function IncDay(var aValue: TDate; aDays: Integer = 1): TDate     ; overload ; inline ; static ;
          function IncMonth( aMonths: Integer = 1 ): TDate                  ; overload ; inline ;
    class function IncMonth(var aValue: TDate; aMonths: Integer = 1): TDate ; overload ; inline ; static ;
          function IncYear( aYears: Integer = 1 ): TDate                    ; overload ; inline ;
    class function IncYear(var aValue: TDate; AYears: Integer = 1): TDate   ; overload ; inline ; static ;

    class function Today: TDate ; inline ; static ;
    class function Max(const aDateA, aDateB: TDate): TDate; inline ; static ;
  end;



  TTimeHelper = record helper for TTime
  private
  {$REGION 'Property Accessors'}
    function GetHour: Word; inline;
    function GetMilliSecond: Word; inline;
    function GetMinute: Word; inline;
    function GetSecond: Word; inline;
  {$ENDREGION}
  public
    const NullTime: TTime = 0.0;

    //-------- conversion methods -----------------------------------

          function ToString: string                  ; overload ; inline ;
    class function ToString( aValue: TTime ): string ; overload ; inline ; static ;
          function ToStringFormat(const aFormat: string): string                                  ; overload ; inline ;
          function ToStringFormat(const aFormat: string; aFormatSettings: TFormatSettings): string; overload ; inline ;
    class function ToStringFormat( aValue: TTime; const aFormat: string; aFormatSettings: TFormatSettings): string ; overload ; inline ; static ;
    class function ToStringFormat( aValue: TTime; const aFormat: string ): string                 ; overload ; inline ; static ;

          function ToInt(aFormat: TTimeConvFormat = HHMMSSMSS): Integer               ; overload ; inline ;
    class function ToInt(aValue: TTime; aFormat: TTimeConvFormat = HHMMSSMSS): Integer; overload ; static ;

    class function Encode( aHour, aMin: Word; aSec: Word = 0; aMilliSec: Word = 0 ): TTime ; inline ; static ;
          procedure Decode(out aHour, aMin: Word )                 ; overload ; inline ;
    class procedure Decode( aValue: TTime; out aHour, aMin: Word ) ; overload ; inline ; static ;
          procedure Decode(out aHour, aMin, aSec: Word )                 ; overload ; inline ;
    class procedure Decode( aValue: TTime; out aHour, aMin, aSec: Word ) ; overload ; inline ; static ;
          procedure Decode(out aHour, aMin, aSec, aMilliSec: Word )                 ; overload ; inline ;
    class procedure Decode( aValue: TTime; out aHour, aMin, aSec, aMilliSec: Word ) ; overload ; inline ; static ;

    //-------- query methods  ---------------------------------------

          function IsNull: Boolean                  ; overload ; inline ;
    class function IsNull( aValue: TTime ): Boolean ; overload ; inline ; static ;
          function IsNotNull: Boolean                  ; overload ; inline ;
    class function IsNotNull( aValue: TTime ): Boolean ; overload ; inline ; static ;
          function Equals( aValue: TTime ): Boolean          ; overload ; inline ;
    class function Equals( aValue1, aValue2: TTime ): Boolean; overload ; inline ; static ;
          function IsPM: Boolean; inline ;
          function IsAM: Boolean; inline ;

          property Hour   : Word read GetHour;
          property Minute : Word read GetMinute;
          property Second : Word read GetSecond;
          property MilliSecond : Word read GetMilliSecond;

    //-------- alter value methods ----------------------------

          function IncHour( AHours: Integer=1 ): TTime                    ; overload ; inline ;
    class function IncHour( var aValue: TTime; AHours: Integer=1 ): TTime ; overload ; inline ; static ;
          function IncMinute( AMinutes: Integer=1 ): TTime                    ; overload ; inline ;
    class function IncMinute( var aValue: TTime; AMinutes: Integer=1 ): TTime ; overload ; inline ; static ;
          function IncSecond( ASeconds: Integer=1 ): TTime                    ; overload ; inline ;
    class function IncSecond( var aValue: TTime; ASeconds: Integer=1 ): TTime ; overload ; inline ; static ;
          function IncMiliSecond( AMilliSeconds: Integer=1 ): TTime                     ; overload ; inline ;
    class function IncMilliSecond( var aValue: TTime; AMilliSeconds: Integer=1 ): TTime ; overload ; inline ; static ;

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

          function ToString: string                      ; overload ; inline ;
    class function ToString( aValue: TDateTime ): string ; overload ; inline ; static ;
          function ToStringFormat(const aFormat: string): string                                  ; overload ; inline ;
          function ToStringFormat(const aFormat: string; AFormatSettings: TFormatSettings): string; overload ; inline ;
    class function ToStringFormat( aValue: TDateTime; const aFormat: string ): string ; overload ; inline ; static ;
    class function ToStringFormat( aValue: TDateTime; const aFormat: string; AFormatSettings: TFormatSettings): string ; overload ; inline ; static ;

    //-------- query methods  ---------------------------------------

          function IsNull: Boolean                      ; overload ; inline ;
    class function IsNull( aValue: TDateTime ): Boolean ; overload ; inline ; static ;

    property Date: TDate read GetDate write SetDate;
    property Time: TTime read GetTime write SetTime;

    //-------- utilities ----------------------------

    /// <summary> Torna la data e l'ora attuale (ora di sistema) </summary>
    class function TodayNow: TDateTime ; inline ; static ;
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
  end;


  TObjectHelper = class helper for TObject
  private
    function IsClass(aClass: TClass): Boolean; inline;
  public
    function CastAs<T: class>: T;
    function IsNull: Boolean; inline;
    function IsNotNull: Boolean; inline;
  end;


implementation

var
  FRandomInit: Boolean;

function NumStrPadLeft(const aValue: string; aLength: Integer; aLeadingChar: Char): string;
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
  System.Dec(Self,1);
  Result := Self;
end;

function TIntegerHelper.DecBy(aDecBy: Integer): Integer;
begin
  System.Dec(Self,aDecBy);
  Result := Self;
end;

function TIntegerHelper.Inc: Integer;
begin
  System.Inc(Self) ;
  Result := Self;
end;

function TIntegerHelper.IncBy(aIncBy: Integer): Integer;
begin
  System.Inc(Self,aIncBy) ;
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

class function TIntegerHelper.ToDate(aValue: Integer): TDate;
var
  y: word;
  resDate: TDateTime;
begin
  y := aValue div 10000;
  if y < 100 then
    y := 1900 + y;

  if (aValue = 0) or
     not TryEncodeDate(   y,
                        ( aValue div   100 ) mod 100,
                        ( aValue mod   100 ),
                          resDate ) then
    resDate := TDate.NullDate;

  Result := resDate;
end;

function TIntegerHelper.ToDate: TDate;
begin
  Result := ToDate(Self);
end;

class function TIntegerHelper.ToTime(aValue: Integer; aFormat: TTimeConvFormat): TTime;
var
  resTime: TDateTime;
  hh, mm, ss, ms: word;
begin
  Result := TTime.NullTime;

  if (aValue > 0) then
  begin
     if aFormat = HHMM then
     begin
       hh := aValue div 100;
       mm := aValue mod 100;
       ss := 0 ;
       ms := 0 ;
     end
     else
     if aFormat = HHMMSS then
     begin
       hh := ( aValue div 10000 );
       mm := ( aValue div   100 ) mod 100;
       ss := ( aValue mod   100 );
       ms := 0 ;
     end
     else
     begin
       hh :=  ( aValue div 10000000 );
       mm :=  ( aValue div   100000 ) mod 100;
       ss :=  ( aValue div     1000 ) mod 100;
       ms :=  ( aValue mod     1000 );
     end;

     if TryEncodeTime(hh, mm, ss, ms, resTime) then
       Result := resTime;
  end;
end;

function TIntegerHelper.ToTime(aFormat: TTimeConvFormat): TTime;
begin
  Result := ToTime(Self, aFormat);
end;

class function TIntegerHelper.ToFloatWithDecimals(aValue: Integer; aDecimalDigits: Integer): Double;
begin
  Result := Double.RoundTo(aValue / Power(10,aDecimalDigits), aDecimalDigits);
end;

function TIntegerHelper.ToFloatWithDecimals(aDecimalDigits: Integer): Double;
begin
  Result := ToFloatWithDecimals(Self, aDecimalDigits);
end;

function TIntegerHelper.ToString: string;
begin
  FmtStr(Result, '%d', [Self]);
end;

class function TIntegerHelper.ToString(aValue, aLength: Integer; aLeadingChar: Char): string;
begin
  FmtStr(Result, '%d', [aValue]);
  Result := NumStrPadLeft( Result, aLength, aLeadingChar ) ;
end;

function TIntegerHelper.ToString(aLength: Integer; aLeadingChar: Char): string;
begin
  Result := ToString(Self, aLength, aLeadingChar);
end;

class function TIntegerHelper.ToStringFormat(aValue: Integer; const aFormat: string): string;
begin
  Result := FormatFloat(aFormat,aValue);
end;

function TIntegerHelper.ToStringFormat(const aFormat: string): string;
begin
  Result := FormatFloat(aFormat,Self)
end;

class function TIntegerHelper.ToStringFormat(aValue: Integer; const aFormat: string; const aFormatSettings: TFormatSettings): string;
begin
  Result := FormatFloat(aFormat,aValue,aFormatSettings);
end;

function TIntegerHelper.ToStringFormat(const aFormat: string; const aFormatSettings: TFormatSettings): string;
begin
  Result := FormatFloat(aFormat,Self,aFormatSettings);
end;

class function TIntegerHelper.ToStringHex(aValue: Integer): string;
begin
   FmtStr(Result, '%.*x', [2, aValue]);
end;

function TIntegerHelper.ToStringHex: string;
begin
   FmtStr(Result, '%.*x', [2, Self]);
end;

class function TIntegerHelper.ToStringZero(aValue, aLength: Integer): string;
begin
  FmtStr(Result, '%d', [aValue]);
  Result := NumStrPadLeft( Result, aLength, '0' ) ;
end;

function TIntegerHelper.ToStringZero( aLength: Integer): string;
begin
  Result := ToStringZero(Self,aLength);
end;

class function TIntegerHelper.ToStringRoman(aValue: Integer): string;
const
  Nvals = 13;
  vals: array [1..Nvals] of word =
    (1, 4, 5, 9, 10, 40, 50, 90, 100, 400, 500, 900, 1000);
  roms: array [1..Nvals] of string =
    ('I', 'IV', 'V', 'IX', 'X', 'XL', 'L', 'XC', 'C',
    'CD', 'D', 'CM', 'M');
var
  b: Integer;
begin
  result := '';
  b := Nvals;
  while aValue > 0 do
  begin
    while vals[b] > aValue do
      System.Dec(b);
    System.Dec(aValue, vals[b]);
    result := result + roms[b]
  end;
end;

function TIntegerHelper.ToStringRoman: string;
begin
  Result := ToStringRoman(Self);
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
  System.Inc(Self,aIncBy);
  Result := Self;
end;

function TInt64Helper.ToString: string;
begin
  FmtStr(Result, '%d', [Self]);
end;

class function TInt64Helper.ToString(aValue: Int64; aLength: Integer; aLeadingChar: Char): string;
begin
  FmtStr(Result, '%d', [aValue]);
  Result := NumStrPadLeft( Result, aLength, aLeadingChar ) ;
end;

function TInt64Helper.ToString(aLength: Integer; aLeadingChar: Char): string;
begin
  Result := ToString( Self, aLength, aLeadingChar ) ;
end;

class function TInt64Helper.ToStringFormat(aValue: Int64; const aFormat: string; const aFormatSettings: TFormatSettings): string;
begin
  Result := FormatFloat(aFormat, aValue, aFormatSettings);
end;

function TInt64Helper.ToStringFormat(const aFormat: string; const aFormatSettings: TFormatSettings): string;
begin
  Result := FormatFloat(aFormat, Self, aFormatSettings);
end;

class function TInt64Helper.ToStringFormat(aValue: Int64; const aFormat: string): string;
begin
  Result := FormatFloat(aFormat, aValue);
end;

function TInt64Helper.ToStringFormat(const aFormat: string): string;
begin
  Result := FormatFloat(aFormat, Self);
end;

class function TInt64Helper.ToStringZero(aValue: Int64; aLength: Integer): string;
begin
  FmtStr(Result, '%d', [aValue]);
  Result := NumStrPadLeft(Result, aLength, '0') ;
end;

function TInt64Helper.ToStringZero(aLength: Integer): string;
begin
  Result := ToStringZero(Self, aLength) ;
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

class function TFloatHelper.ToRoundInt(aValue: Double): Int64;
begin
  Result := System.Round(aValue);
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

class function TFloatHelper.ToInt(aValue: Double): Int64;
begin
  Result := System.Trunc(aValue);
end;

class function TFloatHelper.ToIntWithDecimals(aValue: Double; aDecimalDigits: Integer): Int64;
begin
  Result := Double.RoundTo(aValue*Power(10,aDecimalDigits),0).ToInt;
end;

function TFloatHelper.ToIntWithDecimals(aDecimalDigits: Integer): Int64;
begin
  Result := ToIntWithDecimals(Self,aDecimalDigits);
end;

class function TFloatHelper.ToString(aValue: Double): string;
begin
  Result := FloatToStr(aValue) ;
end;

function TFloatHelper.ToString: string;
begin
  Result := FloatToStr(Self) ;
end;

function TFloatHelper.ToString(aLength: Integer; aLeadingChar: Char): string;
begin
  Result := NumStrPadLeft(FloatToStr(Self), aLength, aLeadingChar) ;
end;

class function TFloatHelper.ToString(aValue: Double; aLength: Integer; aLeadingChar: Char): string;
begin
  Result := NumStrPadLeft(FloatToStr(aValue), aLength, aLeadingChar) ;
end;

class function TFloatHelper.ToStringZero(aValue: Double; aLength: Integer): string;
begin
  Result := NumStrPadLeft(FloatToStr(aValue), aLength, '0') ;
end;

function TFloatHelper.ToStringZero(aLength: Integer): string;
begin
  Result := NumStrPadLeft(FloatToStr(Self), aLength, '0') ;
end;

class function TFloatHelper.ToStringFormat(aValue: Double; const aFormat: string): string;
begin
  Result := FormatFloat(aFormat, aValue);
end;

function TFloatHelper.ToStringFormat(const aFormat: string): string;
begin
  Result := FormatFloat(aFormat, Self);
end;

class function TFloatHelper.ToStringFormat(aValue: Double; const aFormat: string; const aFormatSettings: TFormatSettings): string;
begin
  Result := FormatFloat(aFormat, aValue, aFormatSettings);
end;

function TFloatHelper.ToStringFormat(const aFormat: string; const aFormatSettings: TFormatSettings): string;
begin
  Result := FormatFloat(aFormat, Self, aFormatSettings);
end;

class function TFloatHelper.RoundTo(aValue: Double; aDecimalDigits: Integer): Double;
var
  m,i: Integer;
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

class function TCurrencyHelper.ToString(aValue: Currency): string;
begin
  Result := CurrToStr(aValue);
end;

function TCurrencyHelper.ToString: string;
begin
  Result := CurrToStr(Self);
end;

function TCurrencyHelper.ToString(aLength: Integer; aLeadingChar: Char): string;
begin
  Result := NumStrPadLeft(CurrToStr(Self), aLength, aLeadingChar) ;
end;

class function TCurrencyHelper.ToInt(aValue: Double): Int64;
begin
  Result := System.Trunc(aValue);
end;

function TCurrencyHelper.ToInt: Int64;
begin
  Result := System.Trunc(Self);
end;

class function TCurrencyHelper.ToString(aValue: Currency; aLength: Integer; aLeadingChar: Char): string;
begin
  Result := NumStrPadLeft(CurrToStr(aValue), aLength, aLeadingChar) ;
end;

class function TCurrencyHelper.ToStringFormat(aValue: Currency; const aFormat: string): string;
begin
  Result := FormatCurr(aFormat, aValue);
end;

function TCurrencyHelper.ToStringFormat(const aFormat: string): string;
begin
  Result := FormatCurr(aFormat, Self);
end;

function TCurrencyHelper.ToStringFormat(const aFormat: string; const aFormatSettings: TFormatSettings): string;
begin
  Result := FormatCurr(aFormat, Self, aFormatSettings);
end;

class function TCurrencyHelper.ToStringFormat(aValue: Currency; const aFormat: string; const aFormatSettings: TFormatSettings): string;
begin
  Result := FormatCurr(aFormat, aValue, aFormatSettings);
end;

class function TCurrencyHelper.ToStringZero(aValue: Currency;
  aLength: Integer): string;
begin
  Result := NumStrPadLeft(CurrToStr(aValue), aLength, '0') ;
end;

function TCurrencyHelper.ToStringZero(aLength: Integer): string;
begin
  Result := NumStrPadLeft(CurrToStr(Self), aLength, '0') ;
end;

{$ENDREGION}

{$REGION 'TStringHelper'}

function TStringHelper.GetChars(aIndex: Integer): Char;
begin
  if aIndex < 0 then
    Result := Self[System.Length(Self)+aIndex+Low(string)]
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

class function TStringHelper.IfNull(const aValue, aDefault: string): string;
begin
  if aValue = NullString then
    Result := aDefault
  else
    Result := aValue;
end;

class function TStringHelper.IfEmpty(const aValue, aDefault: string): string;
begin
  if System.SysUtils.Trim(aValue) = NullString then
    Result := aDefault
  else
    Result := aValue;
end;

function TStringHelper.IfNull(const aDefault: string): string;
begin
  if Self = NullString then
    Result := aDefault
  else
    Result := Self;
end;

class function TStringHelper.IsEmpty(const aValue: string): Boolean;
begin
  Result := System.SysUtils.Trim(aValue) = '';
end;

function TStringHelper.IsEmpty: Boolean;
begin
  Result := System.SysUtils.Trim(Self) = '';
end;

class function TStringHelper.IsNotEmpty(const aValue: string): Boolean;
begin
  Result := System.SysUtils.Trim(aValue) <> '';
end;

function TStringHelper.IsNotEmpty: Boolean;
begin
  Result := System.SysUtils.Trim(Self) <> '';
end;

class function TStringHelper.IsNotNull(const aValue: string): Boolean;
begin
  Result := (aValue <> NullString);
end;

function TStringHelper.IsNotNull: Boolean;
begin
  Result := (Self <> NullString);
end;

class function TStringHelper.IsNull(const aValue: string): Boolean;
begin
  Result := (aValue = NullString);
end;

function TStringHelper.IsNull: Boolean;
begin
  Result := (Self = NullString);
end;

function TStringHelper.IfNotEmpty(aFunc: TFunc<string,string>; aDefault: string): string;
begin
  if Self.IsNotEmpty then
    Result := aFunc(Self)
  else
    Result := aDefault;
end;

procedure TStringHelper.IfNotEmpty(aProc: TProc<string>);
begin
  if Self.IsNotEmpty then
    aProc(Self);
end;

function TStringHelper.ToInt(aDefault: Integer): Integer;
begin
  Result := StrToIntDef(Self.Trim, aDefault);
end;

class function TStringHelper.ToInt(const aValue: string; aDefault: Integer): Integer;
begin
  Result := StrToIntDef(aValue.Trim, aDefault);
end;

function TStringHelper.ToCurrency(aDefault: Currency): Currency;
begin
  Result := StrToCurrDef(Self.Trim, aDefault);
end;

class function TStringHelper.ToCurrency(const aValue: string; aDefault: Currency): Currency;
begin
  Result := StrToCurrDef(aValue.Trim, aDefault);
end;

class function TStringHelper.ToDate(const aValue: string; aDefault: TDateTime; aDateSeparator: Char; aDateFormat: string): TDate;
var
  fmt: TFormatSettings;
begin
  fmt := TFormatSettings.Create;
  if aDateSeparator <> #0 then
    fmt.DateSeparator := aDateSeparator;
  if aDateFormat <> '' then
    fmt.ShortDateFormat := aDateFormat;
  Result := StrToDateDef(aValue,aDefault,fmt);
end;

function TStringHelper.ToDate(aDefault: TDateTime; aDateSeparator: Char; aDateFormat: string): TDate;
begin
  Result := ToDate(Self,aDefault,aDateSeparator,aDateFormat);
end;

class function TStringHelper.ToTime(const aValue: string; aDefault: TDateTime; aTimeSeparator: Char): TTime;
var
  fmt: TFormatSettings;
begin
  fmt := TFormatSettings.Create;
  if aTimeSeparator <> #0 then
    fmt.TimeSeparator := aTimeSeparator;
  Result := StrToTimeDef(aValue,aDefault,fmt);
end;

function TStringHelper.ToTime(aDefault: TDateTime; aTimeSeparator: Char): TTime;
begin
  Result := ToTime(Self,aDefault,aTimeSeparator);
end;

class function TStringHelper.ToDateTime(const aValue: string; aDefault: TDateTime; aDateSeparator, aTimeSeparator: Char): TDateTime;
var
  fmt: TFormatSettings;
begin
  fmt := TFormatSettings.Create;
  if aDateSeparator <> #0 then
    fmt.DateSeparator := aDateSeparator;
  if aTimeSeparator <> #0 then
    fmt.TimeSeparator := aTimeSeparator;

  Result := StrToDateTimeDef(aValue,aDefault,fmt);
end;

function TStringHelper.ToDateTime(aDefault: TDateTime; aDateSeparator, aTimeSeparator: Char): TDateTime;
begin
  Result := ToDateTime(Self,aDefault,aDateSeparator,aTimeSeparator);
end;

class function TStringHelper.ToUpper(const aValue: string): string;
begin
  Result := AnsiUpperCase(aValue);
end;

function TStringHelper.ToLower: string;
begin
  Result := AnsiLowerCase(Self);
end;

class function TStringHelper.ToLower(const aValue: string): string;
begin
  Result := AnsiLowerCase(aValue);
end;

class function TStringHelper.ToRomanInt(const aValue: string; aDefault: Integer): Integer;
const
   romanChars = 'IVXLCDMvxlcdm?!#';
   decades : array [0..8] of integer = (0, 1, 10, 100, 1000, 10000, 100000, 1000000, 10000000) ;
   OneFive : array [boolean] of byte = (1, 5) ;
var
   newValue: integer ;
   cIdx, id: integer ;
begin
   Result := 0;
   for cIdx := High(aValue) downto Low(aValue) do
   begin
     id := System.Pos(aValue[cIdx], romanChars)+1 ;
     newValue := OneFive[Odd(id)] * decades[id div 2] ;
     if newValue = 0 then
       Exit(-1);

     System.Inc(Result, newValue) ;
   end ;
end;

function TStringHelper.ToRomanInt(aDefault: Integer): Integer;
begin
  Result := ToRomanInt(Self,aDefault);
end;

function TStringHelper.ToUpper: string;
begin
  Result := AnsiUpperCase(Self);
end;

class procedure TStringHelper.ToFile(const aValue, aFileName: string; aEncoding: TEncoding; aWriteBOM: Boolean);
var
  fs: TFileStream;
  Buffer, Preamble: TBytes;
begin
  if aEncoding = nil then
    aEncoding := TEncoding.Default;

  fs := TFileStream.Create(aFileName, fmCreate);
  try
    Buffer := aEncoding.GetBytes(aValue);
    if aWriteBOM then
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

procedure TStringHelper.ToFile(const aFileName: string; aEncoding: TEncoding);
begin
  ToFile(Self,aFileName,aEncoding,False);
end;

procedure TStringHelper.ToFileWithBOM(const aFileName: string; aEncoding: TEncoding);
begin
  ToFile(Self,aFileName,aEncoding,True);
end;

class function TStringHelper.ToFloat(const aValue: string; aDefault: Double): Double;
begin
  Result := StrToFloatDef(aValue.Trim, aDefault) ;
end;

function TStringHelper.ToFloat(aDefault: Double): Double;
begin
  Result := StrToFloatDef(Self.Trim, aDefault) ;
end;

class function TStringHelper.ToHexInt(const aValue: string; aDefault: Integer): Integer;
begin
  Result := StrToIntDef('$'+aValue.Trim,aDefault);
end;

function TStringHelper.ToHexInt(aDefault: Integer): Integer;
begin
  Result := StrToIntDef('$'+Self.Trim,aDefault);
end;

function TStringHelper.ToInt64(aDefault: Int64): Int64;
begin
  Result := StrToInt64Def(Self.Trim, aDefault);
end;

class function TStringHelper.ToInt64(const aValue: string; aDefault: Int64): Int64;
begin
  Result := StrToInt64Def(aValue.Trim, aDefault);
end;

function TStringHelper.ToHTML: string;
begin
  Result := TNetEncoding.HTML.Encode(Self);
end;

class function TStringHelper.ToHTML(const aValue: string): string;
begin
  Result := TNetEncoding.HTML.Encode(aValue);
end;

class function TStringHelper.ToURL(const aValue: string): string;
begin
  Result := TNetEncoding.URL.EncodeQuery(aValue);
end;

function TStringHelper.ToURL: string;
begin
  Result := TNetEncoding.URL.EncodeQuery(Self);
end;

class function TStringHelper.ToBase64(const aValue: string): string;
begin
  Result := RemoveChars(TNetEncoding.Base64.Encode(aValue), [#13,#10]);
end;

function TStringHelper.ToBase64: string;
begin
  Result := RemoveChars(TNetEncoding.Base64.Encode(Self), [#13,#10]);
end;

class function TStringHelper.ToBase64(const aValue: string; aCharsPerLine: Integer; const aSeparator: string): string;
var
  idx: Integer;
  str: string;
begin
  Result := '';
  str    := ToBase64(aValue);
  idx    := 1 ;
  while idx < Length(str)  do
  begin
    if Result <> '' then
      Result := Result + aSeparator;
    Result := Result + System.Copy(str, idx, aCharsPerLine);
    idx := idx + aCharsPerLine;
  end;
end;

function TStringHelper.ToBase64(aCharsPerLine: Integer; const aSeparator: string): string;
begin
  Result := ToBase64(Self, aCharsPerLine, aSeparator);
end;

class function TStringHelper.FromBase64(const aValue, aSeparator: string): string;
begin
  Result := TNetEncoding.Base64.Decode(Replace(aValue, aSeparator, ''));
end;

function TStringHelper.FromBase64(const aSeparator: string): string;
begin
  Result := TNetEncoding.Base64.Decode(Replace(Self, aSeparator, ''));
end;

function TStringHelper.FromBase64: string;
begin
  Result := TNetEncoding.Base64.Decode(RemoveChars(Self, [#13, #10]));
end;

class function TStringHelper.Copy(const aValue: string; aStart, aCount: Integer): string;
var
  len: Integer ;
begin
  Result := '';
  len := System.Length(aValue);
  if (len > 0) then
  begin
    if (aCount < 0) then
      aCount := len-aStart+1 ;

    if (aStart > 0) and (aCount > 0) then
      Result := System.Copy( aValue, aStart, aCount ) ;
  end;
end;

function TStringHelper.Copy(aStart, aCount: Integer): string;
begin
  Result := String.Copy(Self, aStart, aCount);
end;

class function TStringHelper.CopyFrom(const aValue: string; aStart: Integer): string;
begin
  Result := System.Copy(aValue, aStart, System.Length(aValue)-aStart+1);
end;

function TStringHelper.CopyFrom(aStart: Integer): string;
begin
  Result := System.Copy(Self, aStart, System.Length(Self)-aStart+1);
end;

function TStringHelper.Left(aCount: Integer): string;
begin
  Result := System.Copy(Self, 1, aCount) ;
end;

class function TStringHelper.Left(const aValue: string; aCount: Integer): string;
begin
  Result := System.Copy(aValue, 1, aCount) ;
end;

class function TStringHelper.Right(const aValue: string; aCount: Integer): string;
begin
  Result := System.Copy(aValue, System.Length(aValue) + 1 - aCount, aCount);
end;

function TStringHelper.Right(aCount: Integer): string;
begin
  Result := System.Copy(Self, System.Length(Self) + 1 - aCount, aCount);
end;

class function TStringHelper.Len(const aValue: string): Integer;
begin
  Result := System.Length(aValue);
end;

function TStringHelper.Len: Integer;
begin
  Result := System.Length(Self);
end;

class function TStringHelper.MatchesMask(const aValue, aMask: string): Boolean;
begin
  if aMask = '' then
    Result := True
  else
    Result := System.Masks.MatchesMask(aValue,aMask);
end;

function TStringHelper.MatchesMask(const aMask: string): Boolean;
begin
  if aMask = '' then
    Result := True
  else
    Result := System.Masks.MatchesMask(Self,aMask);
end;

class function TStringHelper.PadCenter(const aValue: string; aLength: Integer; aLeadingChar: char): string;
var
  tempS: string;
  lenStr: Integer;
begin
  lenStr := System.Length(aValue);
  if (lenStr >= aLength) then
    Result := System.Copy( aValue, 1, aLength )
  else
  begin
    tempS  := StringOfChar(aLeadingChar, (aLength - lenStr) div 2) + aValue ;
    Result := tempS + StringOfChar(aLeadingChar, aLength - System.Length(tempS)) ;
  end;
end;

function TStringHelper.PadCenter(aLength: Integer; aLeadingChar: char): string;
begin
  Result := PadCenter(Self,aLength,aLeadingChar);
end;

class function TStringHelper.PadLeft(const aValue: string; aLength: Integer; aLeadingChar: char): string;
begin
  if (System.Length(aValue) >= aLength) then
    Result := System.Copy( aValue, 1, aLength )
  else
    Result := StringOfChar(aLeadingChar, aLength - System.Length(aValue) ) + aValue ;
end;

function TStringHelper.PadLeft(aLength: Integer; aLeadingChar: char): string;
begin
  Result := PadLeft(Self,aLength,aLeadingChar);
end;

class function TStringHelper.PadRight(const aValue: string; aLength: Integer; aLeadingChar: char): string;
begin
  if (System.Length(aValue) >= aLength) then
    Result := System.Copy( aValue, 1, aLength )
  else
    Result := aValue + StringOfChar(aLeadingChar, aLength - System.Length(aValue) ) ;
end;

function TStringHelper.PadRight(aLength: Integer; aLeadingChar: char): string;
begin
  Result := PadRight(Self,aLength,aLeadingChar);
end;

class function TStringHelper.IndexInArray(const aValue: string; const  aValues: TStringDynArray; aCompareOption: TCompareOption): Integer;
begin
  for Result := 0 to High(aValues) do
    if ((aCompareOption = coCaseInsensitive) and (AnsiCompareText(aValue, aValues[Result]) = 0)) or
       ((aCompareOption = coCaseSensitive  ) and (aValue = aValues[Result]))                     then
      Exit;

  Result := -1;
end;

function TStringHelper.IndexInArray(const aValues: TStringDynArray; aCompareOption: TCompareOption): Integer;
begin
  Result := IndexInArray(Self,aValues,aCompareOption);
end;

function TStringHelper.IndexInArray(const aValues: TStringDynArray): Integer;
begin
  for Result := 0 to High(aValues) do
    if (Self = aValues[Result]) then
       Exit;

  Result := -1;
end;

class function TStringHelper.IsInArray(const aValue: string; const aValues: TStringDynArray; aCompareOption: TCompareOption): Boolean;
begin
  Result := IndexInArray(aValue,aValues,aCompareOption) > -1;
end;

function TStringHelper.IsInArray(const aValues: TStringDynArray; aCompareOption: TCompareOption): Boolean;
begin
  Result := IndexInArray(Self,aValues,aCompareOption) > -1;
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

class function TStringHelper.PosRight(const aSubStr, aValue: string; aStartChar: Integer): Integer;
var
  idx, lPos, lenSubStr, offs: Integer ;
begin
  if (aStartChar = 0) then
    aStartChar := System.Length(aValue) ;

  Result    := 0 ;
  offs      := 1;
  lenSubStr := System.Length(aSubStr) ;

  for idx := aStartChar downto offs do
  begin
    lPos := idx - lenSubStr + offs ;
    if (lPos < 1) then
      Exit ;

    if (System.Copy(aValue, lPos, lenSubStr) = aSubStr) then
      Exit(lPos);
  end;
end;

function TStringHelper.PosRight(const aSubStr: string; aStartChar: Integer): Integer;
begin
  Result := PosRight(aSubStr,Self,aStartChar);
end;

function TStringHelper.Pos(const aSubStr: string; aStartChar: Integer): Integer;
begin
  if aStartChar < 1 then
    aStartChar := 1;
  Result := System.Pos(aSubStr, Self, aStartChar);
end;

class function TStringHelper.Pos(const aValue, aSubStr: string; aStartChar: Integer): Integer;
begin
  if aStartChar < 1 then
    aStartChar := 1;
  Result := System.Pos(aSubStr, aValue, aStartChar);
end;

class function TStringHelper.QuotedString(const aValue: string; const aQuoteChar: Char): string;
begin
  Result := AnsiQuotedStr(aValue, aQuoteChar);
end;

function TStringHelper.QuotedString(const aQuoteChar: Char): string;
begin
  Result := AnsiQuotedStr(Self, aQuoteChar);
end;

function TStringHelper.QuotedString: string;
begin
  Result := AnsiQuotedStr(Self,'''');
end;

class function TStringHelper.DeQuotedString(const aValue: string; const aQuoteChar: Char): string;
begin
  Result := AnsiDeQuotedStr(aValue, aQuoteChar);
end;

function TStringHelper.DeQuotedString: string;
begin
  Result := AnsiDequotedStr(Self,'''');
end;

function TStringHelper.DeQuotedString(const aQuoteChar: Char): string;
begin
  Result := AnsiDeQuotedStr(self,aQuoteChar);
end;

class function TStringHelper.Replace(const aValue, ASearchStr, aReplaceStr: String; aCompareOption: TCompareOption): string;
begin
  if (aCompareOption = coCaseSensitive) then
    Result := StringReplace( aValue, ASearchStr, aReplaceStr, [rfReplaceAll] )
  else
    Result := StringReplace( aValue, ASearchStr, aReplaceStr, [rfIgnoreCase,rfReplaceAll]);
end;

function TStringHelper.Replace(const ASearchStr, aReplaceStr: string; aCompareOption: TCompareOption): string;
begin
  Result := Replace(Self,ASearchStr,aReplaceStr,aCompareOption);
end;

function TStringHelper.Replace(const ASearchStr, aReplaceStr: string): string;
begin
  Result := StringReplace( Self, ASearchStr, aReplaceStr, [rfReplaceAll] )
end;

class function TStringHelper.RemoveChars(const aValue: string;  aRemoveChars: TSysCharSet): string;
var
  count, delta: Integer;
  ch: Char;
begin
  count  := 0 ;
  delta  := Low(string)-1;
  SetLength(Result, Length(aValue));
  for ch in aValue do
    if not CharInSet(ch, aRemoveChars) then
    begin
      Inc(count);
      Result[count+delta] := ch;
    end;
  SetLength(Result, count);
end;

function TStringHelper.RemoveChars(aRemoveChars: TSysCharSet): string;
begin
  Result := RemoveChars(Self, aRemoveChars);
end;

class function TStringHelper.ReplaceInvalidChars(const aValue: string; aValidStrChars: TSysCharSet; aReplaceStr: string): string;
var
  ch: Char;
begin
  Result := '';
  for ch in aValue do
    if CharInSet(ch, aValidStrChars) then
      Result := Result + ch
    else
      Result := Result + aReplaceStr;
end;

class function TStringHelper.ReplaceInvalidChars(const aValue, aValidStrChars, aReplaceStr: string): string;
var
  ch: Char;
begin
  Result := '';
  for ch in aValue do
    if System.Pos(ch, aValidStrChars) > 0 then
      Result := Result + ch
    else
      Result := Result + aReplaceStr;
end;

function TStringHelper.ReplaceInvalidChars(const aValidStrChars, aReplaceStr: string): string;
begin
  Result := ReplaceInvalidChars(Self, aValidStrChars, aReplaceStr);
end;

function TStringHelper.ReplaceInvalidChars(aValidStrChars: TSysCharSet; const aReplaceStr: string): string;
begin
  Result := ReplaceInvalidChars(Self, aValidStrChars, aReplaceStr);
end;

class function TStringHelper.SameAs(const AValue1, AValue2: string): Boolean;
begin
  Result := AnsiCompareText( AValue1, AValue2 ) = 0 ;
end;

class function TStringHelper.Split(const aValue: string; aSeparator, aQuote: Char): TStringDynArray;
begin
  Result := TTokenString.Create(aValue, aSeparator, aQuote).ToArray;
end;

function TStringHelper.Split(aSeparator, aQuote: Char): TStringDynArray;
begin
  Result := TTokenString.Create(Self, aSeparator, aQuote).ToArray;
end;

function TStringHelper.SameAs(const aValue: string): Boolean;
begin
  Result := AnsiCompareText( Self, aValue ) = 0 ;
end;

class function TStringHelper.Equals(const AValue1, AValue2: string): Boolean;
begin
  Result := AValue1 = AValue2 ;
end;

function TStringHelper.Equals(const aValue: string): Boolean;
begin
  Result := Self = aValue ;
end;

class function TStringHelper.StartsWith(const aValue, aSubStr: string; aCompareOption: TCompareOption): Boolean;
begin
  if aCompareOption = coCaseInsensitive then
    Result := AnsiCompareText(System.Copy(aValue, 1, System.Length(aSubStr)), aSubStr ) = 0
  else
    Result := System.Copy(aValue, 1, System.Length(aSubStr)) = aSubStr ;
end;

function TStringHelper.StartsWith(const aSubStr: string; aCompareOption: TCompareOption): Boolean;
begin
  Result := StartsWith(Self, aSubStr, aCompareOption);
end;

function TStringHelper.StartsWith(const aSubStr: string): Boolean;
begin
  Result := System.Copy(Self, 1, System.Length(aSubStr)) = aSubStr ;
end;

class function TStringHelper.EndsWith(const aValue, aSubStr: string; aCompareOption: TCompareOption): Boolean;
begin
  if aCompareOption = coCaseInsensitive then
    Result := AnsiCompareText(Right(aValue, System.Length(aSubStr) ), aSubStr ) = 0
  else
    Result := Right(aValue, System.Length(aSubStr)) = aSubStr ;
end;

function TStringHelper.EndsWith(const aSubStr: string; aCompareOption: TCompareOption): Boolean;
begin
  Result := EndsWith(Self,aSubStr,aCompareOption);
end;

function TStringHelper.EndsWith(const aSubStr: string): Boolean;
begin
  Result := Right(Self, System.Length(aSubStr)) = aSubStr ;
end;

class function TStringHelper.Contains(const aValue, aSubStr: string; aCompareOption: TCompareOption): Boolean;
begin
  if aCompareOption = coCaseInsensitive then
    Result := System.Pos(System.SysUtils.Lowercase(aSubStr), System.SysUtils.Lowercase(aValue)) > 0
  else
    Result := System.Pos(aSubStr, aValue) > 0;
end;

function TStringHelper.Contains(const aSubStr: string; aCompareOption: TCompareOption): Boolean;
begin
  Result := Contains(Self,aSubStr,aCompareOption);
end;

function TStringHelper.Contains(const aSubStr: string): Boolean;
begin
  Result := System.Pos(aSubStr, Self) > 0;
end;

class function TStringHelper.EnsurePrefix(const aValue, aPrefix: string): string;
begin
  if System.Copy(aValue,1,System.Length(aPrefix)) <> aPrefix then
    Result := aPrefix + aValue
  else
    Result := aValue;
end;

function TStringHelper.EnsurePrefix(const aPrefix: string): string;
begin
  if System.Copy(Self, 1, System.Length(aPrefix)) <> aPrefix then
    Result := aPrefix + Self
  else
    Result := Self;
end;

class function TStringHelper.EnsureSuffix(const aValue, aSuffix: string): string;
begin
  if Right(aValue, System.Length(aSuffix)) <> aSuffix then
    Result := aValue + aSuffix
  else
    Result := aValue;
end;

function TStringHelper.EnsureSuffix(const aSuffix: string): string;
begin
  if (Right(Self, System.Length(aSuffix)) <> aSuffix) then
    Result := Self + aSuffix
  else
    Result := Self;
end;

function TStringHelper.Trim: string;
begin
  Result := System.SysUtils.Trim(Self);
end;

class function TStringHelper.TrimLeft(const aValue: string): string;
begin
  Result := System.SysUtils.TrimLeft(aValue);
end;

function TStringHelper.TrimLeft: string;
begin
  Result := System.SysUtils.TrimLeft(Self);
end;

function TStringHelper.TrimRight: string;
begin
  Result := System.SysUtils.TrimRight(Self);
end;

class function TStringHelper.TrimRight(const aValue: string): string;
begin
  Result := System.SysUtils.TrimRight(aValue);
end;

class function TStringHelper.UppercaseLetter(const aValue: string): string;
begin
  Result := AnsiLowerCase(aValue);
  if Result <> '' then
    Result[Low(string)] := AnsiUpperCase(Result)[Low(string)] ;
end;

function TStringHelper.UppercaseLetter: string;
begin
  Result := UppercaseLetter(Self);
end;

class function TStringHelper.Extract(var aValue: string; aStart, aCount: Integer): string;
var
  len: Integer;
begin
  len := System.Length(aValue);
  if (aCount < 0) then
    aCount := len - aStart ;

  Result := System.Copy( aValue, aStart  , aCount ) ;
  aValue := System.Copy( aValue, 1       , aStart-1 ) +
            System.Copy( aValue, aStart+aCount, len ) ;
end;

function TStringHelper.Extract(aStart, aCount: Integer): string;
begin
  Result := Extract(string(Self),aStart,aCount);
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

class function TStringHelper.IsWordPresent(const aValue, aWord: string; aWordSeparators: TSysCharSet): Boolean;
var
  count, idx: Integer;
begin
  if aWordSeparators = [] then
    aWordSeparators := TBaseCharSet.WordSeparatorsSet ;

  Result := False;
  count  := WordCount(aValue, aWordSeparators);

  for idx := 0 to count-1 do
    if AnsiCompareText( WordAt(aValue, idx, aWordSeparators), aWord ) = 0 then
    begin
      Result := True;
      Exit;
    end;
end;

function TStringHelper.IsWordPresent(const aWord: string; aWordSeparators: TSysCharSet): Boolean;
begin
  Result := IsWordPresent(Self,aWord,aWordSeparators);
end;

class function TStringHelper.WordCount(const aValue: string; aWordSeparators: TSysCharSet): Integer;
var
  len, idx: Cardinal;
begin
  if aWordSeparators = [] then
    aWordSeparators := TBaseCharSet.WordSeparatorsSet ;

  Result := 0;
  idx := Low(aValue);
  len := High(aValue);

  while idx <= len do
  begin
    while (idx <= len) and CharInSet(aValue[idx], aWordSeparators) do
      Inc(idx);
    if idx <= len then
      Inc(Result);
    while (idx <= len) and not CharInSet(aValue[idx], aWordSeparators) do
      Inc(idx);
  end;
end;

function TStringHelper.WordCount(aWordSeparators: TSysCharSet): Integer;
begin
  Result := WordCount(Self,aWordSeparators);
end;

class function TStringHelper.WordPos(const aValue: string; aWordNum: Integer; aWordSeparators: TSysCharSet): Integer;
var
  count, idx, len: Integer;
begin
  if aWordSeparators = [] then
    aWordSeparators := TBaseCharSet.WordSeparatorsSet ;

  Result := 0;
  count  := -1;
  idx    := Low(string);
  len    := High(aValue);

  while (idx <= len) and (count <> aWordNum) do
  begin
    while (idx <= len) and CharInSet(aValue[idx], aWordSeparators) do
      Inc(idx);
    if idx <= len then
      Inc(count);
    if count <> aWordNum then
      while (idx <= len) and not CharInSet(aValue[idx], aWordSeparators) do
        Inc(idx)
    else
      Result := idx;
  end;
end;

function TStringHelper.WordPos(aWordNum: Integer; aWordSeparators: TSysCharSet): Integer;
begin
  Result := WordPos(Self,aWordNum,aWordSeparators);
end;

class function TStringHelper.WordAt(const aValue: string; aWordNum: Integer; aWordSeparators: TSysCharSet): string;
var
  idx: Integer;
begin
  if aWordSeparators = [] then
    aWordSeparators := TBaseCharSet.WordSeparatorsSet ;

  Result := '' ;
  idx := WordPos(aValue,aWordNum, aWordSeparators);
  if idx >= Low(string) then
    while (idx <= High(aValue)) and not CharInSet(aValue[idx], aWordSeparators) do
    begin
      Result := Result + aValue[idx];
      Inc(idx);
    end;
end;

function TStringHelper.WordAt(aWordNum: Integer; aWordSeparators: TSysCharSet): string;
begin
  Result := WordAt(Self,aWordNum,aWordSeparators);
end;

class function TStringHelper.UppercaseWordLetter(const aValue: string; aWordSeparators: TSysCharSet): string;
var
  len, idx, offs: Integer;
begin
  Result := aValue;
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

function TStringHelper.UppercaseWordLetter(aWordSeparators: TSysCharSet): string;
begin
  Result := UppercaseWordLetter(Self,aWordSeparators);
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

{$REGION 'TDateHelper'}

class function TDateHelper.IsNotNull(aValue: TDate): Boolean;
begin
  Result := aValue <> NullDate;
end;

class function TDateHelper.IsNull(aValue: TDate): Boolean;
begin
  Result := (aValue = NullDate);
end;

function TDateHelper.IsNull: Boolean;
begin
  Result := (Self = NullDate);
end;

function TDateHelper.IsNotNull: Boolean;
begin
  Result := Self <> NullDate;
end;

class function TDateHelper.DaysInMonth(aYear, aMonth: Word): Integer;
begin
  Result := MonthDays[(aMonth = 2) and IsLeapYear(aYear), aMonth];
end;

class function TDateHelper.DaysInMonth(aValue: TDate): Integer;
var
  YY, MM, DD: Word;
begin
  if IsNull(aValue) then
    Result := 0
  else
  begin
    DecodeDate(aValue, YY, MM, DD);
    Result := DaysInMonth(YY, MM);
  end;
end;

function TDateHelper.DaysInMonth: Integer;
begin
  Result := DaysInMonth(Self);
end;

class procedure TDateHelper.Decode(aValue: TDate; out aYear, aMonth, ADay: Word);
begin
  DecodeDate(aValue, aYear, aMonth, ADay);
end;

procedure TDateHelper.Decode(out aYear, aMonth, ADay: Word);
begin
  DecodeDate(Self, aYear, aMonth, ADay);
end;

class function TDateHelper.Encode(aYear, aMonth, ADay: Word): TDate;
begin
  Result := EncodeDate(aYear, aMonth, ADay);
end;

class function TDateHelper.Equals(aValue1, aValue2: TDate): Boolean;
begin
  Result := SameDate(aValue1,aValue2);
end;

function TDateHelper.Equals(aValue: TDate): Boolean;
begin
  Result := SameDate(Self,aValue);
end;

class function TDateHelper.FirstDayOfMonth(aValue: TDate): TDate;
var
  MM,DD,YY: Word ;
begin
  DecodeDate(aValue,YY,MM,DD);
  Result := EncodeDate(YY,MM,1) ;
end;

function TDateHelper.FirstDayOfMonth: TDate;
begin
  Result := FirstDayOfMonth(Self);
end;

function TDateHelper.GetDay: Word;
begin
  if IsNull then
    Result := 0
  else
    Result := DayOf(Self);
end;

function TDateHelper.GetDayOfWeek: Word;
begin
  if IsNull then
    Result := 0
  else
    Result := DayOfTheWeek(Self) ;
end;

function TDateHelper.GetDayOfYear: Word;
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

class function TDateHelper.IncDay(var aValue: TDate; aDays: Integer): TDate;
begin
  aValue := System.DateUtils.IncDay(aValue,aDays);
  Result := aValue;
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

class function TDateHelper.IncMonth(var aValue: TDate; aMonths: Integer): TDate;
begin
  aValue := System.SysUtils.IncMonth(aValue,aMonths);
  Result := aValue;
end;

class function TDateHelper.IncYear(var aValue: TDate; aYears: Integer): TDate;
begin
  aValue := System.DateUtils.IncYear(aValue,aYears);
  Result := aValue;
end;

function TDateHelper.IncYear(aYears: Integer): TDate;
begin
  Self := System.DateUtils.IncYear(Self,aYears);
  Result := Self;
end;

class function TDateHelper.IsInLeapYear(aValue: TDate): Boolean;
begin
  Result := IsLeapYear(YearOf(aValue)) ;
end;

function TDateHelper.IsInLeapYear: Boolean;
begin
  Result := IsLeapYear(YearOf(Self));
end;

class function TDateHelper.LastDayOfMonth(aValue: TDateTime): TDate;
var
  MM,DD,YY: Word ;
begin
  DecodeDate(aValue,YY,MM,DD);
  Result := EncodeDate(YY,MM,DaysInMonth(YY,MM)) ;
end;

function TDateHelper.LastDayOfMonth: TDate;
begin
  Result := LastDayOfMonth(Self);
end;

class function TDateHelper.Today: TDate;
begin
  Result := System.SysUtils.Date;
end;

class function TDateHelper.ToInt(aValue: TDate): Integer;
var
  yy, mm, dd: Word ;
begin
  if IsNull(aValue) then
    Result := 0
  else
  begin
    DecodeDate( aValue, yy, mm, dd ) ;
    Result := ( LongInt(yy) * 10000 ) + ( LongInt(mm) * 100 ) + LongInt(dd) ;
  end;
end;

function TDateHelper.ToInt: Integer;
begin
  Result := ToInt(Self);
end;

class function TDateHelper.ToString(aValue: TDate): string;
begin
  Result := DateToStr(aValue);
end;

function TDateHelper.ToString: string;
begin
  Result := DateToStr(Self);
end;

class function TDateHelper.ToStringFormat(aValue: TDate; const aFormat: string; aFormatSettings: TFormatSettings): string;
begin
  Result := FormatDateTime(aFormat,aValue,aFormatSettings);
end;

function TDateHelper.ToStringFormat(const aFormat: string; aFormatSettings: TFormatSettings): string;
begin
  Result := FormatDateTime(aFormat,Self,aFormatSettings);
end;

class function TDateHelper.ToStringFormat(aValue: TDate; const aFormat: string): string;
begin
  Result := FormatDateTime(aFormat,aValue);
end;

function TDateHelper.ToStringFormat(const aFormat: string): string;
begin
  Result := FormatDateTime(aFormat,Self);
end;

{$ENDREGION}

{$REGION 'TTimeHelper'}

class function TTimeHelper.IsNotNull(aValue: TTime): Boolean;
begin
  Result := aValue <> NullTime;
end;

function TTimeHelper.IsNotNull: Boolean;
begin
  Result := Self <> NullTime;
end;

class function TTimeHelper.IsNull(aValue: TTime): Boolean;
begin
  Result := aValue = NullTime;
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

class procedure TTimeHelper.Decode(aValue: TTime; out aHour, aMin: Word);
var
  aSec, aMilliSec: Word;
begin
  DecodeTime( aValue, aHour, aMin, aSec, aMilliSec ) ;
end;

procedure TTimeHelper.Decode(out aHour, aMin, aSec: Word);
var
  aMilliSec: Word;
begin
  DecodeTime( Self, aHour, aMin, aSec, aMilliSec ) ;
end;

class procedure TTimeHelper.Decode(aValue: TTime; out aHour, aMin, aSec, aMilliSec: Word);
begin
  DecodeTime( aValue, aHour, aMin, aSec, aMilliSec ) ;
end;

procedure TTimeHelper.Decode(out aHour, aMin: Word);
var
  aSec, aMilliSec: Word;
begin
  DecodeTime( Self, aHour, aMin, aSec, aMilliSec ) ;
end;

class procedure TTimeHelper.Decode(aValue: TTime; out aHour, aMin, aSec: Word);
var
  aMilliSec: Word;
begin
  DecodeTime( aValue, aHour, aMin, aSec, aMilliSec ) ;
end;

class function TTimeHelper.Encode(aHour, aMin, aSec, aMilliSec: Word): TTime;
begin
  Result := EncodeTime(aHour,aMin,aSec,aMilliSec);
end;

class function TTimeHelper.Equals(aValue1, aValue2: TTime): Boolean;
begin
  Result := SameTime(aValue1, aValue2);
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

function TTimeHelper.GetMinute: Word;
begin
  Result := MinuteOf(Self);
end;

function TTimeHelper.GetSecond: Word;
begin
  Result := SecondOf(Self);
end;

class function TTimeHelper.IncHour(var aValue: TTime; aHours: Integer): TTime;
begin
  aValue := System.DateUtils.IncHour(aValue,aHours) ;
  Result := aValue;
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

class function TTimeHelper.IncMinute(var aValue: TTime; aMinutes: Integer): TTime;
begin
  aValue := System.DateUtils.IncMinute(aValue,aMinutes);
  Result := aValue;
end;

function TTimeHelper.IncMiliSecond(aMilliSeconds: Integer): TTime;
begin
  Self   := System.DateUtils.IncMilliSecond(Self,aMilliSeconds);
  Result := Self;
end;

class function TTimeHelper.IncMilliSecond(var aValue: TTime; aMilliSeconds: Integer): TTime;
begin
  aValue := System.DateUtils.IncMilliSecond(aValue,aMilliSeconds);
  Result := aValue;
end;

class function TTimeHelper.IncSecond(var aValue: TTime; aSeconds: Integer): TTime;
begin
  aValue := System.DateUtils.IncSecond(aValue,aSeconds);
  Result := aValue;
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

class function TTimeHelper.ToInt(aValue: TTime; aFormat: TTimeConvFormat): Integer;
var
  hh, mm, ss, ms:word ;
begin
  if IsNull(aValue) then
    Result := 0
  else
  begin
    DecodeTime( aValue, hh, mm, ss, ms ) ;
    case aFormat of
      HHMM  : Result := (LongInt(hh)*  100) + LongInt(mm) ;
      HHMMSS: Result := (LongInt(hh)*10000) + LongInt(mm*100) + LongInt(ss) ;
    else
      Result := ( LongInt(hh) * 10000000 ) + ( LongInt(mm) * 100000 ) +
                ( LongInt(ss) * 1000     ) + LongInt(ms) ;
    end;
  end;
end;

function TTimeHelper.ToInt(aFormat: TTimeConvFormat): Integer;
begin
  Result := ToInt(Self, aFormat);
end;

class function TTimeHelper.ToString(aValue: TTime): string;
begin
  Result := TimeToStr(aValue);
end;

function TTimeHelper.ToString: string;
begin
  Result := TimeToStr(Self);
end;

function TTimeHelper.ToStringFormat(const aFormat: string; aFormatSettings: TFormatSettings): string;
begin
  Result := FormatDateTime(aFormat,Self,aFormatSettings);
end;

class function TTimeHelper.ToStringFormat(aValue: TTime; const aFormat: string; aFormatSettings: TFormatSettings): string;
begin
  Result := FormatDateTime(aFormat,aValue,aFormatSettings);
end;

function TTimeHelper.ToStringFormat(const aFormat: string): string;
begin
  Result := FormatDateTime(aFormat,Self);
end;

class function TTimeHelper.ToStringFormat(aValue: TTime;
  const aFormat: string): string;
begin
  Result := FormatDateTime(aFormat,aValue);
end;

class function TDateHelper.Max(const aDateA, aDateB: TDate): TDate;
begin
  if aDateA > aDateB then
    Result := aDateA
  else
    Result := aDateB;
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

function TDateTimeHelper.IsNull: Boolean;
begin
  Result := Self = NullDateTime;
end;

class function TDateTimeHelper.IsNull(aValue: TDateTime): Boolean;
begin
  Result := aValue = NullDateTime;
end;

class function TDateTimeHelper.TodayNow: TDateTime;
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

class function TDateTimeHelper.ToString(aValue: TDateTime): string;
begin
  Result := DateTimeToStr(aValue);
end;

function TDateTimeHelper.ToString: string;
begin
  Result := DateTimeToStr(Self);
end;

class function TDateTimeHelper.ToStringFormat(aValue: TDateTime; const aFormat: string; aFormatSettings: TFormatSettings): string;
begin
  Result := FormatDateTime(aFormat,aValue,aFormatSettings);
end;

class function TDateTimeHelper.ToStringFormat(aValue: TDateTime; const aFormat: string): string;
begin
  Result := FormatDateTime(aFormat,aValue);
end;

function TDateTimeHelper.ToStringFormat(const aFormat: string): string;
begin
  Result := FormatDateTime(aFormat,Self);
end;

function TDateTimeHelper.ToStringFormat(const aFormat: string; aFormatSettings: TFormatSettings): string;
begin
  Result := FormatDateTime(aFormat,Self,aFormatSettings);
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
