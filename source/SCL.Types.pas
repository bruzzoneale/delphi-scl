{
  SCL.Types
  author(bruzzoneale@gmail.com)

  Definition of the base classes for managing native data types
  encapsulated in dedicated classes with related conversion and
  manipulation routines.

  All methods that return their own type always return a reference to themselves
  and are typically methods that alter the stored value.
}
unit SCL.Types;

interface

uses
  System.Character,
  System.StrUtils,
  System.SysUtils,
  System.Classes,
  System.Types,
  System.Rtti,
  System.Math,
  System.DateUtils,
  System.Masks,
  System.Hash,
  System.NetEncoding,
  System.Generics.Collections;

const
  DEFAULT_FORMATFLOAT = '#,##0.00';
  DEFAULT_FORMATINT   = '#,##0';
  CRLF = #13#10;
  CR   = #13;
  LF   = #10;
  QUOTE_SINGLE = #39;
  QUOTE_DOUBLE = #34;
  STRING_BASE_INDEX = Low(string);

  NullDateTime = 0.0;
  NullDate     = 0.0;
  NullTime     = 0.0;
  NullString   = '';

type
  /// <summary>
  /// Base for specific exceptions raised by SCL.Types
  /// </summary>
  ECommonTypesException = class(Exception)
  end;
  /// <summary>
  /// Errors caused by incorrect parameters
  /// </summary>
  EInvalidArgument = class(ECommonTypesException)
  end;

{$REGION 'Aliases'}
  /// <summary>
  /// Alias for standard data types
  /// </summary>
  TNetEncoding = System.NetEncoding.TNetEncoding;
  TStringDynArray = System.Types.TStringDynArray;
{$ENDREGION}

  /// <summary>
  /// Dynamic arrays
  /// </summary>
  TTimeDynArray     = array of TTime;
  TDateTimeDynArray = array of TDateTime;
  TTDateDynArray    = array of TDate;
  TIntegerDynArray  = array of Integer;

  TTimeConvFormat = ( HHMM, HHMMSS, HHMMSSMSS );

  /// <summary>
  ///   Set of general utility mathematical routines
  /// </summary>
  TMath = record
  public
    /// <summary> Rounds a number to the indicated decimal places using mathematical rounding </summary>
    class function RoundTo( AValue: Double; ADecimalDigits: Integer ): Double; overload ; static ;
    class function RoundTo( AValue: Double; ADecimalDigits: Integer; AType: Integer ): Double; overload ; static ;
  end;

  /// <summary>
  /// Helper for the 32-bit signed integer data type (Integer)
  /// </summary>
  TIntegerHelper = record helper for Integer
  public
    const  MaxValue = 2147483647;
    const  MinValue = -2147483648;

    //-------- Value modification methods -----------------------------------

    /// <summary> Increments the integer by 1 </summary>
    function Inc: Integer                    ; overload; inline ;
    /// <summary> Increments the integer by the indicated value </summary>
    function IncBy( aIncBy: Integer ): Integer ; overload; inline ;
    /// <summary> Decrements the integer by 1 </summary>
    function Dec: Integer                    ; overload; inline ;
    /// <summary> Decrements the integer by the indicated value </summary>
    function DecBy( aDecBy: Integer ): Integer ; overload; inline ;

    //-------- Query methods ---------------------------------------

    /// <summary> Returns the absolute value of the integer </summary>
    function Abs: Integer ; overload ; inline ;

    function IsZero: Boolean; inline;

    //-------- Conversion methods -------------------------------------------

    /// <summary> Converts the integer to a string </summary>
    function ToString: string ; overload ; inline ;
    /// <summary> Converts the integer to a fixed-length string, right-aligning it and specifying the padding character </summary>
    function ToString( aLength: Integer; aLeadingChar: Char=' ' ): string ; overload ; inline ;
    /// <summary> Converts the integer to a fixed-length string, right-aligning it and using zero as padding </summary>
    function ToStringZero( aLength: Integer ): string ; inline;
    /// <summary> Converts the integer to a string representing it as a hexadecimal value </summary>
    function ToStringHex: string                      ; inline ;
    /// <summary> Converts the integer to a string representing it with Roman numerals </summary>
    function ToStringRoman: string;
    /// <summary> Converts the integer to a string with formatting </summary>
    function ToStringFormat( const aFormat: string ): string ; overload ; inline ;
    /// <summary> Converts the integer to a string with formatting (Thread-Safe) </summary>
    function ToStringFormat( const aFormat: string; const aFormatSettings: TFormatSettings ): string ; overload ; inline ;
    /// <summary> Converts the integer to a date: the integer is assumed to be in YYYYMMDD format </summary>
    function ToDate: TDate ;
    /// <summary> Converts the integer to a time: the integer is assumed to be in HHMMSSMSS or HHMMSS or HHMM format </summary>
    function ToTime(aFormat: TTimeConvFormat = HHMMSSMSS): TTime ; inline ;
    /// <summary> Converts the integer to a Double assuming that decimals are also present (fixed number of digits) </summary>
    function ToFloatWithDecimals(aDecimalDigits: Integer): Double; inline ;

    //-------- Generic methods ----------------------------

    /// <summary>
    /// Generates a uniform random integer (same probability for each possible value)
    /// ATotValues represents the total number of possible values that the method can return
    /// (e.g., if 100, then Random returns a random number between 0 and 99)
    /// If not specified, any number within the Integer range is returned
    /// </summary>
    class function Random( aTotValues: Integer=0): Integer ; static ;
    /// <summary> Swaps the value of the two variables </summary>
    class procedure Swap(var aValue1, aValue2: Integer)  ; static ; inline ;
  end;

  /// <summary>
  /// Helper for the 64-bit signed integer data type (Int64)
  /// </summary>
  TInt64Helper = record helper for Int64
  public
    const  MaxValue = 9223372036854775807;
    const  MinValue = -9223372036854775808;

    //-------- Value modification methods -----------------------------------

    /// <summary> Increments the integer by 1 </summary>
    function Inc: Int64     ; overload ; inline ;
    /// <summary> Increments the integer by the indicated value </summary>
    function IncBy( aIncBy: Integer ): Int64 ; overload; inline ;

    //-------- Query methods ---------------------------------------

    /// <summary> Returns the absolute value of the integer </summary>
    function Abs: Int64                ; overload ; inline ;

    function IsZero: Boolean; inline;

    //-------- Conversion methods -------------------------------------------

    /// <summary> Converts the integer to a string </summary>
    function ToString: string ; overload ; inline ;
    /// <summary> Converts the integer to a fixed-length string, right-aligning it and specifying the padding character </summary>
    function ToString( aLength: Integer; aLeadingChar: Char=' ' ): string ; overload ; inline;
    /// <summary> Converts the integer to a fixed-length string, right-aligning it and using zero as padding </summary>
    function ToStringZero( aLength: Integer ): string ; inline ;
    /// <summary> Converts the integer to a string with formatting </summary>
    function ToStringFormat( const aFormat: string ): string            ; overload ; inline ;
    /// <summary> Converts the number to a string with formatting (Thread-Safe)</summary>
    function ToStringFormat( const aFormat: string; const aFormatSettings: TFormatSettings ): string ; overload ; inline ;
  end;


  /// <summary>
  /// Helper for floating-point numbers (Double)
  /// </summary>
  TFloatHelper = record helper for Double
  public
    const  MaxValue:Double =  1.7976931348623157081e+308;
    const  MinValue:Double = -1.7976931348623157081e+308;

    //-------- Query methods ---------------------------------------

    /// <summary> Returns the absolute value of the number </summary>
    function Abs : Double ; inline ;
    /// <summary> Returns the integer part of a number </summary>
    function Int : Double ; inline ;
    /// <summary> Returns the fractional part of a number </summary>
    function Frac: Double ; inline ;

    /// <summary> Determines if the value is to be considered zero </summary>
    function IsZero: Boolean; inline;

    //-------- Conversion methods -------------------------------------------

    /// <summary> Converts the number to an integer by truncating the decimal part </summary>
    function ToInt: Int64  ; inline ;
    /// <summary> Converts to an integer keeping the indicated number of decimal places at the end of the integer part (e.g., 128.88 => 12888) </summary>
    function ToIntWithDecimals(aDecimalDigits: Integer): Int64 ; inline ;
    /// <summary> Converts the number as an integer with mathematical rounding </summary>
    function ToRoundInt: Int64                  ; inline ;
    /// <summary> Converts the number to a string </summary>
    function ToString: string                                       ; overload ; inline ;
    /// <summary> Converts the number to a string specifying a character as the decimal separator</summary>
    function ToString(aDecimalSeparator: Char): string              ; overload ; inline ;
    /// <summary> Converts the number to a string specifying a character as the decimal separator and using a fixed number of digits for the decimals</summary>
    function ToString(aDecimalSeparator: Char; aDecimalDigits: Integer): string ; overload ; inline ;
    /// <summary> Converts the number to a fixed-length string, right-aligning it and specifying the padding character</summary>
    function ToString( aLength: Integer; aLeadingChar: Char=' ' ): string ; overload ; inline ;
    /// <summary> Converts the number to a fixed-length string, right-aligning it and specifying the padding character and decimal separator</summary>
    function ToString( aLength: Integer; aLeadingChar: Char; aDecimalSeparator: Char): string ; overload ; inline ;
    /// <summary> Converts the number to a fixed-length string, right-aligning it and using zero as padding </summary>
    function ToStringZero( aLength: Integer ): string                  ; overload ; inline ;
    /// <summary> Converts the number to a fixed-length string, right-aligning it and using zero as padding and specifying the decimal separator </summary>
    function ToStringZero( aLength: Integer; aDecimalSeparator: Char): string ; overload ; inline ;
    /// <summary> Converts the number to a string with formatting </summary>
    function ToStringFormat( const aFormat: string=DEFAULT_FORMATFLOAT ): string; overload ; inline ;
    /// <summary> Converts the number to a string with Thread-Safe formatting</summary>
    function ToStringFormat(const aFormat: string; const aFormatSettings: TFormatSettings ): string; overload ; inline ;

    //-------- Generic methods ----------------------------

    /// <summary> Rounds the number to the indicated decimal places using mathematical rounding </summary>
    function RoundTo( aDecimalDigits: Integer ): Double ; overload; inline ;
    /// <summary> Rounds the number to the indicated decimal places using selectable rounding </summary>
    function RoundTo( aDecimalDigits: Integer; aType: Integer ): Double ; overload; inline ;
  end;

  /// <summary>
  /// Helper for fixed-point numbers with 4 decimal places (Currency)
  /// </summary>
  TCurrencyHelper = record helper for Currency
  public
    const MinValue: Currency = -922337203685477.5807 {$IFDEF LINUX} + 1 {$ENDIF};
    const MaxValue: Currency =  922337203685477.5807 {$IFDEF LINUX} - 1 {$ENDIF};

    //-------- Query methods ---------------------------------------

    /// <summary> Returns the absolute value of the number </summary>
    function Abs : Currency ; overload ;

    /// <summary> Determines if the value is to be considered zero </summary>
    function IsZero: Boolean; inline;

    //-------- Conversion methods -------------------------------------------

    /// <summary> Converts the number to an integer by truncating the decimal part </summary>
    function ToInt: Int64                ; inline ;
    /// <summary> Converts to an integer keeping the indicated number of decimal places at the end of the integer part (e.g., 128.88 => 12888) </summary>
    function ToIntWithDecimals(aDecimalDigits: Integer): Int64 ; inline ;
    /// <summary> Converts the number to a string </summary>
    function ToString: string                                       ; overload ; inline ;
    /// <summary> Converts the number to a string specifying a character as the decimal separator</summary>
    function ToString(aDecimalSeparator: Char): string              ; overload ; inline ;
    /// <summary> Converts the number to a string specifying a character as the decimal separator and using a fixed number of digits for the decimals</summary>
    function ToString(aDecimalSeparator: Char; aDecimalDigits: Integer): string ; overload ; inline ;
    /// <summary> Converts the number to a fixed-length string, right-aligning it and specifying the padding character </summary>
    function ToString( aLength: Integer; aLeadingChar: Char=' ' ): string ; overload ; inline;
    /// <summary> Converts the number to a fixed-length string, right-aligning it and specifying the padding character and decimal separator</summary>
    function ToString( aLength: Integer; aLeadingChar: Char; aDecimalSeparator: Char): string ; overload ; inline ;
    /// <summary> Converts the number to a fixed-length string, right-aligning it and using zero as padding </summary>
    function ToStringZero(aLength: Integer ): string                  ; overload ;inline ;
    /// <summary> Converts the number to a fixed-length string, right-aligning it and using zero as padding and specifying the decimal separator </summary>
    function ToStringZero( aLength: Integer; aDecimalSeparator: Char): string ; overload ; inline ;
    /// <summary> Converts the number to a string with formatting </summary>
    function ToStringFormat( const aFormat: string=DEFAULT_FORMATFLOAT ): string  ; overload ; inline ;
    /// <summary> Converts the number to a string with formatting </summary>
    function ToStringFormat( const aFormat: string; const aFormatSettings: TFormatSettings ): string; overload ; inline ;

    //-------- Generic methods ----------------------------

    /// <summary> Rounds the number to the indicated decimal places using mathematical rounding (max 4 decimal places) </summary>
    function RoundTo( aDecimalDigits: Integer ): Currency ; overload; inline ;
    /// <summary> Rounds the number to the indicated decimal places using selectable rounding (max 4 decimal places) </summary>
    function RoundTo( aDecimalDigits: Integer; aType: Integer ): Currency ; overload; inline ;
  end;

  /// <summary>
  /// Collection of commonly used character sets
  /// </summary>
  TBaseCharSet = class
  public
    const
    /// <summary> Standard ASCII visual character set </summary>
    VisualRangeSet: TSysCharSet = ['\','$','%','&','@','*','+','/','A'..'Z',
                                   'a'..'z','{','}','(',')','>','<','?',
                                   '0'..'9','[',']'] ;

    /// <summary> Standard ASCII alphabetic character set </summary>
    AlphabeticCharSet: TSysCharSet =  ['A'..'Z','a'..'z'] ;
    /// <summary> Commonly used characters as word separators </summary>
    WordSeparatorsSet: TSysCharSet = [' ',',','.',';','/','\',':','''','"','`','(',')','[',']','{','}'] ;
    /// <summary> Valid characters for real numbers </summary>
    NumericSet     : TSysCharSet = ['0','1','2','3','4','5','6','7','8','9',',','.','-','+'] ;
    /// <summary> Valid characters for integers </summary>
    IntegerSet     : TSysCharSet = ['0','1','2','3','4','5','6','7','8','9','-','+'] ;
    /// <summary> Valid characters for hexadecimal numbers </summary>
    HexIntegerSet: TSysCharSet = ['0','1','2','3','4','5','6','7','8','9','A','B','C','D','E','F','a','b','c','d','e','f','-','+'] ;
    /// <summary> Valid characters for numbers in scientific notation </summary>
    ScientificSet: TSysCharSet = ['0','1','2','3','4','5','6','7','8','9',',','.','-','+','E','e'] ;
    /// <summary> Valid characters for Boolean values </summary>
    BooleanTrueSet: TSysCharSet = ['1','T','t','Y','y','S','s'] ;
    /// <summary> Characters used for parentheses </summary>
    BracketsSet    : TSysCharSet = ['(',')','[',']','{','}'] ;

  const
   /// <summary> Valid characters for MIME base 64 encoding </summary>
    b64_MIMEBase64 = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/';
   /// <summary> Valid characters for ASCII base 64 encoding </summary>
    b64_UUEncode   = ' !"#$%&''()*+,-./0123456789:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ[\]^_';
   /// <summary> Valid characters for base 64 encoding </summary>
    b64_XXEncode   = '+-0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz';
   /// <summary> Valid characters for standard ASCII symbols and characters </summary>
    ASCII_Standard = ' !"#$%&''()*+,-./0123456789:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ[\]^_`abcdefghijklmnopqrstuvwxyz{|}';
    /// <summary> Valid characters for MIME base 36 encoding </summary>
    b36_MIMEBase36 = '0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ';
  end;

  /// <summary>
  /// Alternative helper implementation for the string data type
  /// ALL functions ALWAYS use 1-based string indexing even on mobile platforms
  /// however, be careful if you want to access individual characters of a string as an array,
  /// in that case, using Chars[] of this StringHelper the access will always be 1-based
  /// </summary>
  /// <remarks>
  /// Be aware of System.SysUtils.TStringHelper as this helper instead works in the opposite way,
  /// always managing strings as 0-based regardless of the platform, so it is
  /// recommended NOT to mix helpers in the same application but choose to adopt a UNIQUE
  /// method otherwise there is a risk of great confusion
  /// </remarks>
  TStringHelper = record helper for String
  private
    function GetChars(AIndex: Integer): Char; inline;
    function GetLastChar : Char; inline;
    function GetFirstChar: Char; inline;
  public
    type  TCompareOption = ( coCaseInsensitive, coCaseSensitive ) ;
    type  TOptionBOM = (obWithoutBOM, obIncludeBOM);

    //-------- Conversion methods -------------------------------------------

    /// <summary> Converts the string to Integer (returns 0 if not possible) </summary>
    function ToInt: Integer                                           ; overload; inline ;
    /// <summary> Converts the string to Integer (returns ADefault if not possible) </summary>
    function ToInt(aDefault: Integer): Integer                      ; overload; inline ;
    /// <summary> Converts the string containing a hexadecimal number to a decimal integer with default </summary>
    function ToHexInt(aDefault: Integer = 0): Integer                ; inline ;
    /// <summary> Converts the string containing a Roman numeral to an integer with default </summary>
    function ToRomanInt(aDefault:Integer = 0): Integer                ;
    /// <summary> Converts the string to 64-bit Integer (returns ADefault if not possible) </summary>
    function ToInt64(aDefault: Int64 = 0): Int64                      ; inline ;
    /// <summary> Converts the string to a real number (returns ADefault if not possible) </summary>
    function ToFloat(aDefault: Double = 0; aDecimalSeparator: Char = #0): Double                  ; inline ;
    /// <summary> Converts the string to a fixed-point number (returns ADefault if not possible) </summary>
    function ToCurrency(aDefault: Currency = 0; aDecimalSeparator: Char = #0): Currency              ; inline ;
    /// <summary> Converts the string to a date (returns ADefault if not possible) </summary>
    function ToDate(aDefault: TDateTime = NullDateTime; aDateSeparator: Char = #0; aDateFormat: string=''):TDate; inline ;
    /// <summary> Converts the string to a time (returns ADefault if not possible). A separator different from the system default can be defined </summary>
    function ToTime(aDefault: TDateTime = NullDateTime; aTimeSeparator: Char = #0):TTime                  ; inline ;
    /// <summary> Converts the string to a date/time (returns ADefault if not possible). A separator different from the system default can be defined </summary>
    function ToDateTime(aDefault: TDateTime = NullDateTime; aDateSeparator: Char = #0; aTimeSeparator: Char = #0):TDateTime; inline ;
    /// <summary> Converts the string in ISO8601 format to date/time (returns ADefault if not possible) taking into account the local time zone </summary>
    function ToDateTimeISO(aDefault: TDateTime = NullDateTime):TDateTime; inline ;
    /// <summary> Converts the string in ISO8601 date/time format (returns ADefault if not possible) without modifying the time (intended as absolute) </summary>
    function ToDateTimeUTC(aDefault: TDateTime = NullDateTime):TDateTime; inline ;
    /// <summary> Converts the string to uppercase (Unicode)</summary>
    function ToUpper: string                                         ; inline ;
    /// <summary> Converts the entire string to lowercase (Unicode)</summary>
    function ToLower: string                                         ; inline ;
    /// <summary> Converts any special characters in the string to the format compatible with HTML/XML </summay>
    function ToHTML: string                                          ; inline ;
    /// <summary> Converts any special characters in the string to be used as a URL (typically adapts GET parameters) </summay>
    function ToURL: string                                           ; inline ;
    /// <summary> Encodes the string in BASE64 (without any formatting) </summay>
    function ToBase64: string                                        ; overload ; inline ;
    /// <summary> Encodes the string in BASE64 and formats it by adding a separator every ACharsPerLine characters (default CRLF) </summay>
    function ToBase64(aCharsPerLine: Integer; const aSeparator: string = CRLF): string ; overload ;
    /// <summary> Assuming the string is BASE64 encoded, returns the decoded string without considering any formatting </summary>
    function FromBase64: string                                       ; overload ; inline ;
    function FromBase64(const aSeparator: string): string            ; overload ; inline ;

    /// <summary> Writes the entire content of the string to a file (overwriting it if it exists)
    /// <param>aEncoding</param> you can specify an encoding for Unicode (by default treats the file as ANSI in the current codepage)
    /// <param>aOptionBOM</param> determines whether to write the BOM to the file (which will be used for reading)
    /// </summary>
    procedure ToFile(const aFileName: string; aEncoding: TEncoding = nil; aOptionBOM: TOptionBOM = obWithoutBOM);

    /// <summary> Returns the MD5 of the string </summary>
    function ToMD5: string; inline;

    //-------- Query methods --------------------------------

    /// <summary> Indicates whether the string is null </summary>
    function IsNull: Boolean                                      ; inline ;
    /// <summary> Indicates whether the string is not null </summary>
    function IsNotNull: Boolean                                   ; inline ;
    /// <summary> Indicates whether the string is empty or consists only of spaces </summary>
    function IsEmpty: Boolean                                     ; inline ;
    /// <summary> Indicates whether the string is not empty and does not consist only of spaces </summary>
    function IsNotEmpty: Boolean                                  ; inline ;
    /// <summary> If the string is null, returns the alternative string indicated as ADefault, otherwise returns the value of the string </summary>
    function IfNull(const aDefault: string): string               ; inline ;
    /// <summary> If the string is empty (null or only spaces), returns the alternative string indicated as ADefault, otherwise returns the value of the string </summary>
    function IfEmpty(const aDefault: string): string              ; inline ;
    /// <summary> Executes an anonymous procedure if the string is not empty (the string is passed as a parameter) </summary>
    procedure IfNotEmpty(aProc: TProc<string>)                    ; overload ; inline ;
    /// <summary> Executes an anonymous function if the string is not empty and returns its result, otherwise returns an optional default value </summary>
    function IfNotEmpty(aFunc: TFunc<string,string>; aDefault: string=''): string; overload ; inline ;
    /// <summary> Returns the number of characters in the string </summery>
    function Len: Integer                                        ; inline;
    function Length: Integer                                     ; inline;
    /// <summary> Returns the first ACount characters of the string </summary>
    function Left( aCount: Integer ): string                     ; inline ;
    /// <summary> Returns the last ACount characters of the string </summary>
    function Right( aCount: Integer ): string                    ; inline ;
    /// <summary> Returns a substring from character AStart (always 1-based index) with ACount characters </summary>
    function Copy ( aStart: Integer; aCount: Integer ): string    ; inline ;
    /// <summary> Returns a substring from character AStart to the end </summary>
    function CopyFrom ( aStart: Integer): string                  ; inline ;
    /// <summary> Searches for a substring within the string starting from the left at character AStartChar (default is the first character), always case-sensitive </summary>
    function Pos(const aSubStr: string ; aStartChar: Integer = 0): Integer    ; inline ;
    /// <summary> Searches for a substring within the string starting from the right at character AOffSet, always case-sensitive </summary>
    function PosRight(const aSubStr: string ; aStartChar: Integer = 0): Integer; inline ;

    /// <summary>
    /// Searches for the string within the indicated array and returns its position. Returns -1 if not present.
    /// Can be used to leverage: case IndexInArray() of ... even with strings (case-sensitive by default)
    /// </summary>
    function IndexInArray(const aValues: TStringDynArray; aCompareOption: TCompareOption): Integer; overload ; inline ;
    function IndexInArray(const aValues: TStringDynArray): Integer                                   ; overload ; inline ;
    /// <summary> Checks if the string is present within the indicated array (case-sensitive by default) </summary>
    function IsInArray(const aValues: TStringDynArray; aCompareOption: TCompareOption): Boolean; overload ; inline ;
    function IsInArray(const aValues: TStringDynArray): Boolean                                    ; overload ; inline ;
    /// <summary> Indicates whether the string is equal to the indicated string (case-insensitive) </summary>
    function SameAs(const aValue: string): Boolean                ; inline ;
    /// <summary> Indicates whether the string is equal to the indicated string (case-sensitive) </summary>
    function Equals(const aValue: string): Boolean                ; inline ;
    /// <summary> Indicates whether the string has the initial characters equal to aSubStr (case-sensitive by default) </summary>
    function StartsWith(const aSubStr: string): Boolean                                             ; overload ; inline ;
    function StartsWith(const aSubStr: string; aCompareOption: TCompareOption): Boolean           ; overload ; inline ;
    /// <summary> Indicates whether the string has the final characters equal to aSubStr (case-sensitive by default) </summary>
    function EndsWith(const aSubStr: string): Boolean                                               ; overload ; inline ;
    function EndsWith(const aSubStr: string; aCompareOption: TCompareOption): Boolean             ; overload ; inline ;
    /// <summary> Indicates whether a substring is present within the string (case-sensitive by default)</summary>
    function Contains( const aSubStr: string): Boolean                                             ; overload ; inline ;
    function Contains( const aSubStr: string; aCompareOption: TCompareOption): Boolean           ; overload ; inline ;
    /// <summay> Checks if the string meets the criteria of a mask containing wildcards (*,?), always Case-Insensitive </summay>
    function MatchesMask( const aMask: string): Boolean          ; inline ;

    /// <summary> Returns the total number of words contained in the string </summary>
    function WordCount(aWordSeparators: TSysCharSet = [] ): Integer                              ; inline ;
    /// <summary> Returns the starting character position of the word number aWordNum (starting from zero) in the string </summary>
    function WordPos(aWordNum: Integer; aWordSeparators: TSysCharSet = []): Integer              ; inline ;
    /// <summary> Returns the word number aWordNum (starting from zero) in the string </summary>
    function WordAt(aWordNum: Integer; aWordSeparators: TSysCharSet = []): string                ; inline ;
    /// <summary> Returns True if the indicated word is present in the string (case-insensitive) </summary>
    function IsWordPresent(const aWord: string; aWordSeparators: TSysCharSet = []): Boolean; inline ;

    /// <summary> Query on the type of content of the string </summary>
    function IsInteger: Boolean   ; inline;
    function IsInt64  : Boolean   ; inline;
    function IsFloat  : Boolean   ; overload; inline;
    function IsFloat(aDecimalSeparator: Char): Boolean ; overload; inline;
    function IsDate(aDateSeparator: Char = #0; const aDateFormat: string = ''): Boolean; inline;
    function IsTime(aTimeSeparator: Char = #0): Boolean                                           ; inline;

    //-------- String manipulation methods ----------------------------

    /// <summary> Returns the string right-aligned to the length aLength with ALeadingChar as the left padding character </summary>
    function PadLeft  ( aLength: Integer; ALeadingChar: char =' ' ): string  ;
    /// <summary> Returns the string left-aligned to the length aLength with ALeadingChar as the right padding character </summary>
    function PadRight ( aLength: Integer; ALeadingChar: char =' ' ): string  ;
    /// <summary> Returns the string center-aligned to the length aLength with ALeadingChar as the side padding character </summary>
    function PadCenter( aLength: Integer; ALeadingChar: char =' ' ): string  ;
    /// <summary> Returns the string without leading spaces </summary>
    function TrimLeft: string                                       ; inline;
    /// <summary> Returns the string without trailing spaces </summary>
    function TrimRight: string; overload                           ; inline;
    /// <summary> Returns the string without leading and trailing spaces </summary>
    function Trim: string                                          ; inline;
    /// <summary> Returns the string enclosed in quotes using the indicated character as the quote (' by default) </summary>
    function QuotedString: string                                                   ; overload; inline ;
    function QuotedString(const aQuoteChar: Char): string                          ; overload; inline ;
    /// <summary> Returns the string without the quotes that enclose it (' by default) </summary>
    function DeQuotedString: string                                                 ; overload; inline ;
    function DeQuotedString(const aQuoteChar: Char): string                        ; overload; inline ;
    /// <summary> Returns the string in lowercase with the first letter uppercase </summary>
    function UppercaseLetter: string ; inline ;
    /// <summary> Returns the string with all words in lowercase and the initial letter uppercase </summary>
    function UppercaseWordLetter(aWordSeparators: TSysCharSet = [] ): string;
     /// <summary> Returns the string with the indicated prefix (if already present, it is not modified), always case-sensitive </summary>
    function EnsurePrefix(const aPrefix: string): string                ; inline;
    /// <summary> Returns the string with the indicated suffix (if already present, it is not modified), always case-sensitive </summary>
    function EnsureSuffix(const aSuffix: string): string                ; inline ;
    /// <summary> Replaces all occurrences of aSearchStr with aReplaceStr in the string (case-sensitive by default) </summary>
    function Replace( const aSearchStr, aReplaceStr: string): string                              ; overload ; inline ;
    function Replace( const aSearchStr, aReplaceStr: string; aCompareOption: TCompareOption): string ; overload ; inline ;
    /// <summary> Removes a set of characters from the string (much more performant than performing a replacement with a null character) </summary>
    function RemoveChars(aRemoveChars: TSysCharSet): string            ;
    /// <summary> Checks that the string contains only the characters indicated in aValidStrChars, otherwise for each character not found in AValidChars, it is replaced with the entire string AReplaceStr </summary>
    function ReplaceInvalidChars(aValidStrChars: TSysCharSet; const aReplaceStr: string): string                ; overload ;
    function ReplaceInvalidChars(const aValidStrChars, aReplaceStr: string): string                                 ; overload ;
    /// <summary> Appends another string to the string, inserting a separator only if the starting string is not null </summary>
    function Concat(const aSeparator, aConcatValue: string): string    ; overload ; inline;
    /// <summary> Appends another string to the string without separators and without conditions </summary>
    function Concat(const aConcatValue: string): string                ; overload ; inline;
    /// <summary> Appends all strings of an array to the string without separators and without conditions </summary>
    function Concat(const aConcatValues: TStringDynArray): string      ; overload ; inline;
    /// <summary> Like Concat() but only if the string to be appended is not empty, otherwise returns the original string unchanged </summary>
    function ConcatIfNotEmpty(const aSeparator, aConcatValue: string): string; inline;
    /// <summary> Like Concat() but only if the string to be appended is not Null, otherwise returns the original string unchanged </summary>
    function ConcatIfNotNull(const aSeparator, aConcatValue: string): string ; inline;
    /// <summary> Like Concat() but appending two different strings depending on the value of the indicated condition </summary>
    function ConcatIf(aIfCondition: Boolean; const aTrueConcatValue: string; const aFalseConcatValue: string=''): string ; inline;

    /// <summary> Returns the string without leading zeros </summary>
    function TrimLeftZero: string ;

    //-------- Methods that alter the content of a string ----------------------------

    /// <summary> Returns a substring by removing it from the string (same rules as Copy) </summary>
    function Extract( AStart: Integer; aCount: Integer = -1 ): string ;

    //-------- Generic methods ----------------------------

    /// <summary> Returns a sequence of characters </summary>
    class function Duplicate(aChar: Char; aCount: Integer): string; overload ; static ; inline ;
    /// <summary> Appends the string aCount times </summary>
    class function Duplicate(const aValue: string; aCount: Integer): string; overload ; static ; inline ;
    /// <summary> Appends the string aCount times </summary>
            function Duplicate(aCount: Integer): string; overload; inline;
    /// <summary> If the string contains tokens, it splits them into an array based on the indicated separator (implements @link(TTokenString)) </summary>
    function Split(aSeparator: Char; aQuote: Char ='"'): TStringDynArray; inline;
    /// <summary> Given an array of strings, the content is joined into a single string composed of tokens </string>
    class function Join(aValues: TStringDynArray; aSeparator: Char; aQuote: Char ='"'): string; static;

    /// <summary> Access to the characters of the string ALWAYS with 1-based index </summary>
    /// <remarks> Indicating a NEGATIVE number then the indicated position is from the end of the string </remarks>
    property Chars[AIndex: Integer]: Char read GetChars;
    /// <summary> Returns the first character of the string, if empty returns #0 without raising errors </summary>
    property FirstChar: Char read GetFirstChar;
    /// <summary> Returns the last character of the string, if empty returns #0 without raising errors </summary>
    property LastChar : Char read GetLastChar;
  end;


  /// <summary>
  /// Implementation of a string composed of multiple values with a delimiter (token)
  /// Default SepChar separator = ;
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
    /// <summary>
    /// Returns the total number of tokens contained in the string. Any token separator characters (SepChar)
    /// present within a pair of quotes (QuoteChar) are not considered as token separators.
    ///</summary>
    function TokenCount: Integer;
    /// <summary>
    /// Returns the token at the position number aTokenNum (starting from zero). Any token separator characters (SepChar)
    /// present within a pair of quotes (QuoteChar) are not considered as token separators.
    /// <para> The QuoteChar characters of a token are not returned (the token is only the content) </para>
    /// </summary>
    function TokenAt(aTokenNum: Integer): string ;
    /// <summary> Returns the position of the first character in the original string relative to the indicated token </summary>
    function TokenPos(aTokenNum: Integer): Integer ;
    /// <summary> Fills a list with all the tokens contained in the string. The content of the list is cleared first </summary>
    procedure TokenToList(ADestList: TStrings);
    /// <summary> Joins all the elements of the list into a single string, delimiting the elements with the SepChar separator </summary>
    function TokenFromList(ASourceList: TStrings): TTokenString ;
    /// <summary> Enumerator to iterate over all tokens </summary>
    function GetEnumerator: TEnumerator<string>;
    /// <summary> Returns all tokens within an array </summary>
    function ToArray: TStringDynArray;
    /// <summary> Token separator setting </summary>
    function Sep(aSepChar: Char): TTokenString;
    /// <summary> Quote character setting </summary>
    function Quote(aQuoteChar: Char): TTokenString;

    property SepChar  : Char read FSepChar   write FSepChar ;
    property QuoteChar: Char read FQuoteChar write FQuoteChar;
  end;


  /// <summary>
  /// Helper for TDate for date management
  /// </summary>
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
    //-------- Conversion methods -------------------------------------------

    /// <summary> Converts the date to a string with default formatting </summary>
    function ToString: string                  ; inline ;
    /// <summary> Converts the date to a string in standard ISO8601 format (without time) </summary>
    function ToStringUTC: string               ; inline ;
    /// <summary> Converts the date to a string with the specified formatting </summary>
    function ToStringFormat(const aFormat: string): string                                  ; overload ; inline ;
    function ToStringFormat(const aFormat: string; aDateSeparator: Char): string            ; overload ; inline ;
    function ToStringFormat(const aFormat: string; AFormatSettings: TFormatSettings): string; overload ; inline ;
    /// <summary> Converts the date to an integer in YYYYMMDD format </summary>
    function ToInt: Integer               ; inline ;
    /// <summary> Decomposes the date into its individual elements (day, month, year) </summary>
    procedure Decode( out aYear, aMonth, aDay: Word )         ; inline ;
    /// <summary> Encode a date from its individual elements (day, month, year) </summary>
    class function Encode( aYear, aMonth, aDay: Word ): TDate ; inline ; static ;
    class function Create( aYear, aMonth, aDay: Word ): TDate ; inline ; static ;

    //-------- Query methods -------------------------------------------

    /// <summary> Indicates whether the date is null </summary>
    function IsNull: Boolean                  ; inline ;
    /// <summary> Indicates whether the date is not null </summary>
    function IsNotNull: Boolean               ; inline ;
    /// <summary> Indicates whether it is a leap year </summary>
    function IsInLeapYear: Boolean            ; inline ;
    /// <summary> Checks if the date is within the specified range </summary>
    function IsInRange(aFromDate, aEndDate: TDate): Boolean; inline;
    /// <summary> Indicates whether the dates are equal </summary>
    function Equals( aValue: TDate ): Boolean ; inline ;
    /// <summary> If the date is null, returns the alternative date indicated as aDefault, otherwise returns the stored date </summary>
    function IfNull(aDefault: TDate): TDate   ; inline ;
    /// <summary> Executes an anonymous procedure if the date is not null (the date is passed as a parameter) </summary>
    procedure IfNotEmpty(aProc: TProc<TDate>) ; inline ;

    /// <summary> Indicates whether the date coincides with the current day </summary>
    function IsToday: Boolean; inline;
    /// <summary> Indicates whether the date is different from the current day </summary>
    function IsNotToday: Boolean; inline;

    /// <summary> Extracts the day from the date </summary>
    property Day  : Word read GetDay;
    /// <summary> Extracts the month from the date </summary>
    property Month: Word read GetMonth;
    /// <summary> Extracts the year from the date </summary>
    property Year : Word read GetYear;
    /// <summary> Extracts the week of the year from the date </summary>
    property Week : Word read GetWeek;
    /// <summary> Extracts the day of the week from the date (1 Monday, 7 Sunday) </summary>
    property DayOfWeek: Integer read GetDayOfWeek;
    /// <summary> Extracts the day of the year from the date </summary>
    property DayOfYear: Integer read GetDayOfYear;

    /// <summary> Returns the total number of days in the month of the indicated or stored date </summary>
          function DaysInMonth: Integer                        ; overload ;
    class function DaysInMonth( aYear, aMonth: Word ): Integer ; overload ; static ; inline ;
    /// <summary> Returns the date containing the first day of the current month </summary>
    function FirstDayOfMonth: TDate               ; inline ;
    /// <summary> Returns the date containing the last day of the month of the indicated date </summary>
    function LastDayOfMonth: TDate                ; inline ;
    /// <summary> Returns the number of days of difference from the indicated date </summary>
    function DaysBetween(aValue: TDate)  : Integer; inline;
    /// <summary> Returns the number of months of difference from the indicated date </summary>
    function MonthsBetween(aValue: TDate): Integer; inline;
    /// <summary> Returns the number of years of difference from the indicated date </summary>
    function YearsBetween(aValue: TDate) : Integer; inline;

    //-------- Methods that alter the content of a date ----------------------------

    /// <summary> Increments the date by the indicated number of days </summary>
    function IncDay( aDays: Integer = 1 ): TDate                     ; inline ;
    /// <summary> Increments the date by the indicated number of months </summary>
    function IncMonth( aMonths: Integer = 1 ): TDate                 ; inline ;
    /// <summary> Increments the date by the indicated number of years </summary>
    function IncYear( aYears: Integer = 1 ): TDate                   ; inline ;

    //-------- Generic methods ----------------------------

    /// <summary> Queries on the system date </summary>
    class function Today    : TDate ; inline ; static ;
    class function Tomorrow : TDate ; inline ; static ;
    class function Yesterday: TDate ; inline ; static ;

    /// <summary> Returns the greater of the two indicated dates </summary>
    class function Max(const aDateA, aDateB: TDate): TDate; inline ; static ;
  end;


  /// <summary>
  /// Helper for TTime for time management
  /// </summary>
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
    //-------- Conversion methods -------------------------------------------

    /// <summary> Converts the time to a string with default formatting </summary>
    function ToString: string                  ; inline ;
    /// <summary> Converts the time to a string with the specified formatting </summary>
    function ToStringFormat(const aFormat: string): string                                  ; overload ; inline ;
    function ToStringFormat(const aFormat: string; aTimeSeparator: Char): string            ; overload ; inline ;
    function ToStringFormat(const aFormat: string; aFormatSettings: TFormatSettings): string; overload ; inline ;
    /// <summary> Converts the time to integer in the given format </summary>
    function ToInt(aFormat: TTimeConvFormat = HHMMSSMSS): Integer                          ; inline ;
    /// <summary> Encode a time from its individual elements hours and minutes (optional seconds and milliseconds) </summary>
    class function Create( aHour, aMin: Word; aSec: Word = 0; aMilliSec: Word = 0 ): TTime ; inline ; static ;
    class function Encode( aHour, aMin: Word; aSec: Word = 0; aMilliSec: Word = 0 ): TTime ; inline ; static ;
    /// <summary> Decomposes the time into its individual elements (hours and minutes) </summary>
    procedure Decode(out aHour, aMin: Word )                     ; overload ; inline ;
    /// <summary> Decomposes the time into its individual elements (hours, minutes and seconds) </summary>
    procedure Decode(out aHour, aMin, aSec: Word )               ; overload ; inline ;
    /// <summary> Decomposes the time into its individual elements (hours, minutes, seconds and milliseconds) </summary>
    procedure Decode(out aHour, aMin, aSec, aMilliSec: Word )    ; overload ; inline ;

    //-------- Query methods -------------------------------------------

    /// <summary> Indicates whether the time is null </summary>
    function IsNull: Boolean                     ; inline ;
    /// <summary> Indicates whether the time is not null </summary>
    function IsNotNull: Boolean                  ; inline ;
    /// <summary> Indicates whether the times are equal </summary>
    function Equals( aValue: TTime ): Boolean    ; inline ;
    /// <summary> Indicates whether the time is afternoon </summary>
    function IsPM: Boolean; inline ;
    /// <summary> Indicates whether the time is morning </summary>
    function IsAM: Boolean; inline ;

    /// <summary> Extracts the hour from the time </summary>
    property Hour   : Word read GetHour;
    /// <summary> Extracts the minute from the time </summary>
    property Minute : Word read GetMinute;
    /// <summary> Extracts the second from the time </summary>
    property Second : Word read GetSecond;
    /// <summary> Extracts the millisecond from the time </summary>
    property MilliSecond : Word read GetMilliSecond;

    /// <summary> Returns the minute of the day (minutes passed since midnight) </summary>
    property MinuteOfDay: Integer read GetMinuteOfDay;
    /// <summary> The second of the day returns (seconds elapsed since midnight) </summary>
    property SecondOfDay: Integer read GetSecondOfDay;
    /// <summary> The millisecond of the day returns (milliseconds elapsed since midnight) </summary>
    property MilliSecondOfDay: Integer read GetMilliSecondOfDay;

    /// <summary> Returns the hours difference compared to another time </summary>
    function HoursBetween(aValue: TTime)       : Integer; inline;
    /// <summary> Returns the minutes difference compared to another time </summary>
    function MinutesBetween(aValue: TTime)     : Integer; inline;
    /// <summary> Returns the seconds difference compared to another time </summary>
    function SecondsBetween(aValue: TTime)     : Integer; inline;
    /// <summary> Returns the milliseconds difference compared to another time </summary>
    function MillisecondsBetween(aValue: TTime): Integer; inline;

   //-------- Methods that alter the content of a time ----------------------------

    /// <summary> Increments the time by the indicated number of hours </summary>
    function IncHour( AHours: Integer=1 ): TTime                    ; inline ;
    /// <summary> Increments the time by the indicated number of minutes </summary>
    function IncMinute( AMinutes: Integer=1 ): TTime                ; inline ;
    /// <summary> Increments the time by the indicated number of seconds </summary>
    function IncSecond( ASeconds: Integer=1 ): TTime                ; inline ;
    /// <summary> Increments the time by the indicated number of milliseconds </summary>
    function IncMiliSecond( AMilliSeconds: Integer=1 ): TTime       ; inline ;

    //-------- Generic methods ----------------------------

    /// <summary> Queries on the system time </summary>
    class function Now: TTime ; inline ; static ;

    // <summary> Return the start time of the day (00:00) </summary>
    class function FistTimeOfTheDay: TTime; inline; static;
    // <summary> Return the last time of the day  (23:59) </summary>
    class function LastTimeOfTheDay: TTime; inline; static;
  end;


  /// <summary>
  /// Helper for TDateTime for timestamp management
  /// </summary>
  TDateTimeHelper = record helper for TDateTime
  private
  {$REGION 'Property Accessors'}
      function GetDate: TDate; inline ;
      function GetTime: TTime; inline ;
      procedure SetDate(const Value: TDate); inline;
      procedure SetTime(const Value: TTime); inline;
  {$ENDREGION}
  public
    //-------- Conversion methods -------------------------------------------

    /// <summary> Converts the date and time to a string with default formatting </summary>
    function ToString: string                      ; inline ;
    /// <summary> Converts the date to a string in standard ISO8601 format with Z time </summary>
    function ToStringUTC: string                   ; inline ;
    /// <summary> Converts the date to a string in standard ISO8601 format with current zone time </summary>
    function ToStringISO: string                   ; inline ;
    /// <summary> Converts the date and time to a string with the specified formatting </summary>
    function ToStringFormat(const aFormat: string): string                                      ; overload ; inline ;
    function ToStringFormat(const aFormat: string; aDateSeparator: Char): string                ; overload ; inline ;
    function ToStringFormat(const aFormat: string; aDateSeparator, aTimeSeparator: Char): string; overload ; inline ;
    function ToStringFormat(const aFormat: string; AFormatSettings: TFormatSettings): string    ; overload ; inline ;

    //-------- Query methods -------------------------------------------

    /// <summary> Returns the number of days of difference from the indicated date </summary>
    function DaysBetween(aValue: TDateTime)        : Integer; inline;
    /// <summary> Returns the number of months of difference from the indicated date </summary>
    function MonthsBetween(aValue: TDateTime)      : Integer; inline;
    /// <summary> Returns the number of years of difference from the indicated date </summary>
    function YearsBetween(aValue: TDateTime)       : Integer; inline;
    /// <summary> Returns the hours difference compared to another date </summary>
    function HoursBetween(aValue: TDateTime)       : Integer; inline;
    /// <summary> Returns the minutes difference compared to another time </summary>
    function MinutesBetween(aValue: TDateTime)     : Integer; inline;
    /// <summary> Returns the seconds difference compared to another time </summary>
    function SecondsBetween(aValue: TDateTime)     : Integer; inline;
    /// <summary> Returns the milliseconds difference compared to another time </summary>
    function MillisecondsBetween(aValue: TDateTime): Integer; inline;

    function IsNull: Boolean                      ; inline ;
    function IsNotNull: Boolean                   ; inline ;

    /// <summary> Get or Set only the date part  </summary>
    property Date: TDate read GetDate write SetDate;
    /// <summary> Get or Set only the time part  </summary>
    property Time: TTime read GetTime write SetTime;

    //-------- Generic methods ----------------------------

    /// <summary> Queries on the system date and time </summary>
    class function NowToday: TDateTime ; inline ; static ;
  end;


  /// <sumary>
  ///  Helper per gli array di stringhe
  /// </summary>
  TStringDynArrayHelper = record helper for TStringDynArray
  public
    /// <summary> Indica se l'array è vuoto </summary>
    function IsEmpty: Boolean; inline;
    /// <summary> Indica se l'array contiene almeno un elemento </summary>
    function IsNotEmpty: Boolean; inline;
    /// <summary> Indica se una stringa è contenuta nell'array </summary>
    function Contains(const aValue: string;
                      aCompareOption: TStringHelper.TCompareOption = coCaseSensitive ): Boolean ; inline;
    // <summary> Torna l'indice della prima occorrenza della stringa indicata </summary>
    function IndexOf(const aValue: string; aCompareOption: TStringHelper.TCompareOption = coCaseSensitive ): Integer ; overload ; inline;
    // <summary> Torna l'indice della prima occorrenza della stringa a partire dalla posizione indicata</summary>
    function IndexOf(const aValue: string; aStartPosition: Integer; aCompareOption: TStringHelper.TCompareOption = coCaseSensitive ): Integer ; overload ;
    /// <summary> Torna il numero totale di elementi dell'array </summary>
    function Count: Integer; inline;
    /// <summary> Torna il primo elemento dell'array o una stringa nulla se l'array è vuoto </summary>
    function First: string ; inline;
    /// <summary> Torna il primo elemento dell'array rimuovendolo (se l'array è vuoto torna una stringa nulla) </summary>
    function ExtractFirst: string ; inline;
    /// <summary> Torna l'ultimo elemento dell'array o una stringa nulla se l'array è vuoto </summary>
    function Last: string  ; inline;
    /// <summary> Torna l'ultimo elemento dell'array rimuovendolo (se l'array è vuoto torna una stringa nulla) </summary>
    function ExtractLast: string ; inline;
    /// <summary> Azzera il contenuto dell'array (zero elementi) </summary>
    procedure Clear ; inline;
    /// <summary>
    ///  Ridimensiona l'array al numero di elementi indicato.
    ///  Se la dimensione si riduce si perdono gli ultimi elementi,
    ///  Se la dimensione aumenta i nuovi elementi vengono inizializzati con una stringa nulla
    /// </summary>
    procedure Resize(aCount: Integer); inline;
    /// <summary> Accoda una stringa all'array </summary>
    procedure Add(const aValue: string); overload ; inline;
    /// <summary> Aggiunge elementi presenti in liste dove si può anche specificare il range di elementi (per default aggiunge tutto) </summary>
    procedure Add(aValues: TStringDynArray; aStartItem: Integer = 0; aItemCount: Integer = -1); overload ;
    procedure Add(aValues: TStrings       ; aStartItem: Integer = 0; aItemCount: Integer = -1); overload ; inline ;
    /// <summary> Accoda una stringa all'array solo se non è già presente</summary>
    procedure AddIfNotExists(const aValue: string; aCompareOption: TStringHelper.TCompareOption = coCaseSensitive); overload ;
    /// <summary> Rimozione di un elemento dall'array con scorrimento degli elementi successivi verso l'alto (come una lista) </summary>
    procedure Delete(aIndex: Integer); inline;
    /// <summary> Torna il valore dell'elemento indicato; se l'indice è fuori dai limiti torna una stringa nulla o il valore di default indicato </summary>
    function Get(aIndex: Integer; const aDefault: string = ''): string;
    /// <summary> Concatena il contenuto dell'array in un unica stringa usando il separatore indicato </summary>
    function ToString(const aLineSep: string = LF): string;
  end;

  /// <sumary>
  ///  Helper for integer array
  /// </summary>
  TIntegerDynArrayHelper = record helper for TIntegerDynArray
  public
    /// <summary> Clears the content of the array (zero elements) </summary>
    procedure Clear ; inline;
    /// <summary> Indicates whether the array is empty </summary>
    function IsEmpty: Boolean; inline;
    /// <summary> Indicates whether the array contains at least one element </summary>
    function IsNotEmpty: Boolean; inline;
    /// <summary> Indicates whether a number is contained in the array </summary>
    function Contains(const aValue: Integer): Boolean; inline;
    // <summary> Returns the index of the first occurrence of the indicated number </summary>
    function IndexOf(const aValue: Integer): Integer ; inline;
    /// <summary> Returns the total number of elements in the array </summary>
    function Count: Integer; inline;
    /// <summary> Returns the first element of the array or 0 if the array is empty </summary>
    function First: Integer ; inline;
    /// <summary> Returns the last element of the array or 0 if the array is empty </summary>
    function Last: Integer  ; inline;
    /// <summary>
    ///  Resizes the array to the indicated number of elements.
    ///  If the size is reduced, the last elements are lost.
    ///  If the size is increased, the new elements are initialized to 0.
    /// </summary>
    procedure Resize(aCount: Integer);
    /// <summary> Adds a new value to the array </summary>
    procedure Add(const aValue: Integer); overload ; inline;
    /// <summary> Returns the value of the indicated element; if the index is out of bounds, returns the indicated default value </summary>
    function Get(aIndex: Integer; aDefault: Integer = 0): Integer;
    /// <summary> Removes an element from the array by shifting subsequent elements upwards (like a list) </summary>
    procedure Delete(aIndex: Integer); inline;
  end;

  /// <summary>
  ///  Helper for TMonitor
  /// </summary>
  TMonitorHelper = record helper for TMonitor
  public
     /// <summary> Executes the <i>aAction</i> procedure only after locking <i>aObject</i> </summary>
     class procedure DoWithLock(const aObject: TObject; const aAction: TProc); static;
     /// <summary>
     /// Executes the <i>aAction</i> procedure only after locking <i>aObject</i>
     /// within the specified timeout (in milliseconds), otherwise it exits returning <b>False</b>
     /// </summary>
     class function DoWithLockTimeout(const aObject: TObject; const aAction: TProc; const aTimeOut: Cardinal): Boolean; static;
  end;

  /// <summary>
  ///  Helper for TObject
  /// </summary>
  TObjectHelper = class helper for TObject
  private
    function IsClass(aClass: TClass): Boolean;
  public
    /// <summary> Cast the object to the given class. If it fails, no exception is raised, but nil is returned </summary>
    function CastAs<T: class>: T;
    /// <summary> determine whether the pointer of an object is not assigned (nil) </summary>
    function IsNotAssigned: Boolean; inline;
    /// <summary> determine whether the pointer of an object is assigned </summary>
    function IsAssigned: Boolean   ; inline;
    /// <summary> Return a class by name using RTTI (even partial, the last characters are considered significant) </summary>
    class function FindAnyClass(const aPartialRightName: string): TClass; static;
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
    if (idx > STRING_BASE_INDEX) then
    begin
      Result[STRING_BASE_INDEX] := '-';
      Result[idx] := '0';
    end;
  end;
end;

{$REGION 'TMath' }

class function TMath.RoundTo(aValue: Double; aDecimalDigits: Integer): Double;
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

class function TMath.RoundTo( AValue: Double; ADecimalDigits: Integer; AType: Integer ): Double;
var
   TpM  : integer;
   idx  : integer;
   Res  : double;
   Fraz : double;
   xSgn : integer;
begin
   Result := RoundTo(AValue, -ADecimalDigits);
   if (CompareValue(Result, AValue) <> 0) then
   begin
     TpM := 10;
     for idx := 1 to ADecimalDigits - 1 do
        TpM := TpM * 10;
     if ADecimalDigits = 0 then TpM := 1;

     xSgn := 1;
     if AValue < 0 then xSgn := -1;
     AValue := abs(AValue);
     Res  := RoundTo(AValue * TpM,-10);
     Fraz := Frac(Res);
     Res  := Trunc(Res);
     if AType = 1 then
     begin
        // rounding up
        if Fraz <> 0 then Result := xSgn * ( ( Res + 1 ) / TpM )
                     else Result := xSgn * ( Res / TpM );
     end
     else  if AType = 2 then
     begin
        // rounding down
        Result := xSgn * ( Res / TpM );
     end
     else
     begin
        // Mathematical Rounding
        if Fraz < 0.5 then Result := xSgn * ( Res / TpM )
                      else Result := xSgn * ( ( Res + 1 ) / TpM );
     end;
   end;
end;

{$ENDREGION}

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

function TIntegerHelper.IsZero: Boolean;
begin
  Result := Self = 0;
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
    Result := NullDate
  else
    Result := resDate;
end;

function TIntegerHelper.ToTime(aFormat: TTimeConvFormat): TTime;
var
  resTime: TDateTime;
  hh, mm, ss, ms: word;
begin
  Result := NullTime;

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
  Result := TMath.RoundTo(Self / Power(10, aDecimalDigits), aDecimalDigits);
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

function TInt64Helper.IsZero: Boolean;
begin
  Result := Self = 0;
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

function TFloatHelper.IsZero: Boolean;
begin
  Result := System.Math.IsZero(Self);
end;

function TFloatHelper.ToInt: Int64;
begin
  Result := System.Trunc(Self);
end;

function TFloatHelper.ToIntWithDecimals(aDecimalDigits: Integer): Int64;
begin
  Result := TMath.RoundTo(Self * Power(10, aDecimalDigits), 0).ToInt;
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

function TFloatHelper.ToString(aDecimalSeparator: Char; aDecimalDigits: Integer): string;
var
  fmt: TFormatSettings;
begin
  fmt := TFormatSettings.Create;
  fmt.DecimalSeparator := aDecimalSeparator;
  Result := FormatFloat('0.'+StringOfChar('0', aDecimalDigits), Self, fmt);
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

function TFloatHelper.RoundTo(aDecimalDigits: Integer): Double;
begin
  Result := TMath.RoundTo(Self,aDecimalDigits) ;
end;

function TFloatHelper.RoundTo(aDecimalDigits: Integer; aType: Integer): Double ;
begin
  Result := TMath.RoundTo(Self,aDecimalDigits,aType) ;
end;

{$ENDREGION}

{$REGION 'TCurrencyHelper'}

function TCurrencyHelper.RoundTo(aDecimalDigits: Integer): Currency;
begin
  Result := TMath.RoundTo(Self,aDecimalDigits);
end;

function TCurrencyHelper.IsZero: Boolean;
begin
  Result := (Self = 0);
end;

function TCurrencyHelper.RoundTo(aDecimalDigits: Integer; aType: Integer): Currency ;
begin
  Result := TMath.RoundTo(Self,aDecimalDigits,aType) ;
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

function TCurrencyHelper.ToString(aDecimalSeparator: Char; aDecimalDigits: Integer): string;
var
  fmt: TFormatSettings;
begin
  fmt := TFormatSettings.Create;
  fmt.DecimalSeparator := aDecimalSeparator;
  Result := FormatFloat('0.'+StringOfChar('0', aDecimalDigits), Self, fmt);
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
  Result := TMath.RoundTo(Self * Power(10, aDecimalDigits), 0).ToInt;
end;

{$ENDREGION}

{$REGION 'TStringHelper'}

function TStringHelper.Len: Integer;
begin
  Result := System.Length(Self);
end;

function TStringHelper.Length: Integer;
begin
  Result := System.Length(Self);
end;

function TStringHelper.GetChars(aIndex: Integer): Char;
var
  idx: Integer;
begin
  if aIndex < 0 then
    idx := Len+aIndex+STRING_BASE_INDEX
  else
    idx := aIndex+STRING_BASE_INDEX-1;

  if (idx >= STRING_BASE_INDEX) and (idx <= High(Self)) then
    Result := Self[idx]
  else
    Result := #0;
end;

function TStringHelper.GetFirstChar: Char;
begin
  if Self <> NullString then
    Result := Self[STRING_BASE_INDEX]
  else
    Result := #0;
end;

function TStringHelper.GetLastChar: Char;
begin
  if Self <> NullString then
    Result := Self[High(Self)]
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
  Result := System.SysUtils.Trim(Self) = NullString;
end;

function TStringHelper.IsNotEmpty: Boolean;
begin
  Result := System.SysUtils.Trim(Self) <> NullString;
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

function TStringHelper.ToInt: Integer;
begin
  Result := StrToIntDef(System.SysUtils.Trim(Self), 0);
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
  if (Self = NullString) or not TryISO8601ToDate(Self, Result, False) then
    Result := aDefault;
end;

function TStringHelper.ToDateTimeUTC(aDefault: TDateTime): TDateTime;
begin
  if (Self = NullString) or not TryISO8601ToDate(Self, Result, True) then
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
  while idx < System.Length(Self) do
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
    Result := ToDate(NullDate, aDateSeparator, aDateFormat).IsNotNull;
end;

function TStringHelper.IsTime(aTimeSeparator: Char): Boolean;
begin
  if Self.IsEmpty then
    Result := False
  else
    Result := ToTime(NullTime, aTimeSeparator).IsNotNull;
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
  delta  := STRING_BASE_INDEX-1;
  SetLength(Result, System.Length(Self));
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

function TStringHelper.TrimLeftZero: string;
var
  idx: integer;
begin
  idx  := STRING_BASE_INDEX;
  Self := System.SysUtils.TrimLeft(Self);

  while ((Self[idx] = '0') and (idx < High(Self))) do
  begin
    Self[idx] := ' ';
    inc(idx);
  end;
  Result := System.SysUtils.TrimLeft(Self);
end;

function TStringHelper.UppercaseLetter: string;
begin
  Result := AnsiLowerCase(Self);
  if Result <> '' then
    Result[STRING_BASE_INDEX] := AnsiUpperCase(Result)[STRING_BASE_INDEX] ;
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

function TStringHelper.Concat(const aConcatValue: string): string;
begin
  Result := Self + aConcatValue;
end;

function TStringHelper.Concat(const aConcatValues: TStringDynArray): string;
var
  s: string;
begin
  Result := Self;
  for s in aConcatValues do
    Result := Result + s;
end;

function TStringHelper.ConcatIf(aIfCondition: Boolean; const aTrueConcatValue, aFalseConcatValue: string): string;
begin
  if aIfCondition then
    Result := Self + aTrueConcatValue
  else
    Result := Self + aFalseConcatValue;
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

class function TStringHelper.Duplicate(const aValue: string; aCount: Integer): string;
var
  idx: Integer;
begin
  Result := '';
  for idx := 1 to aCount do
    Result := Result + aValue;
end;

function TStringHelper.Duplicate(aCount: Integer): string;
begin
  Result := string.Duplicate(Self,aCount);
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
  idx    := STRING_BASE_INDEX;
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
  if idx >= STRING_BASE_INDEX then
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
  idx     := STRING_BASE_INDEX ;
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

function TTokenString.TokenPos(aTokenNum: Integer): Integer;
var
  j, idx, len: Integer;
  inQuote    : Boolean;
begin
  Result  := STRING_BASE_INDEX-1 ;
  inQuote := False ;
  idx     := STRING_BASE_INDEX ;
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
    begin
       Result := idx + (1 - STRING_BASE_INDEX);
       Exit;
    end;
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
  idx     := STRING_BASE_INDEX ;
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
  idx     := STRING_BASE_INDEX ;
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

class function TDateTimeHelper.NowToday: TDateTime;
begin
  Result := System.SysUtils.Now;
end;

function TDateTimeHelper.GetDate: TDate;
begin
  Result := DateOf(Self);
end;

function TDateTimeHelper.GetTime: TTime;
begin
  Result := TimeOf(Self);
end;

function TDateTimeHelper.HoursBetween(aValue: TDateTime): Integer;
begin
  Result := System.DateUtils.HoursBetween(Self, aValue);
end;

function TDateTimeHelper.IsNotNull: Boolean;
begin
  Result := Self <> NullDateTime;
end;

function TDateTimeHelper.IsNull: Boolean;
begin
  Result := Self = NullDateTime;
end;

function TDateTimeHelper.MillisecondsBetween(aValue: TDateTime): Integer;
begin
  Result := System.DateUtils.MilliSecondsBetween(Self, aValue);
end;

function TDateTimeHelper.MinutesBetween(aValue: TDateTime): Integer;
begin
  Result := System.DateUtils.MinutesBetween(Self, aValue);
end;

function TDateTimeHelper.DaysBetween(aValue: TDateTime): Integer;
begin
  Result := System.DateUtils.DaysBetween(Self, aValue);
end;

function TDateTimeHelper.MonthsBetween(aValue: TDateTime): Integer;
begin
  Result := System.DateUtils.MonthsBetween(Self, aValue);
end;

function TDateTimeHelper.YearsBetween(aValue: TDateTime): Integer;
begin
  Result := System.DateUtils.YearsBetween(Self, aValue);
end;

function TDateTimeHelper.SecondsBetween(aValue: TDateTime): Integer;
begin
  Result := System.DateUtils.SecondsBetween(Self, aValue);
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

procedure TStringDynArrayHelper.AddIfNotExists(const aValue: string; aCompareOption: TStringHelper.TCompareOption);
begin
  if not Contains(aValue, aCompareOption) then
    Add(aValue);
end;

procedure TStringDynArrayHelper.Delete(aIndex: Integer);
begin
  if (aIndex <= High(Self)) and (aIndex >= 0) then
    System.Delete(Self,aIndex,1);
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

function TStringDynArrayHelper.ExtractFirst: string;
begin
  if Length(Self) > 0 then
  begin
    Result := Self[0];
    Delete(0);
  end
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

function TStringDynArrayHelper.ExtractLast: string;
begin
  if Length(Self) > 0 then
  begin
    Result := Self[High(Self)];
    Delete(High(Self));
  end
  else
    Result := '';
end;

{$ENDREGION}

{$REGION 'TMonitorHelper'}

class procedure TMonitorHelper.DoWithLock(const aObject: TObject; const AAction: TProc);
begin
  TMonitor.Enter(aObject);
  try
    AAction();
  finally
    TMonitor.Exit(aObject);
  end;
end;

class function TMonitorHelper.DoWithLockTimeout(const aObject: TObject;
  const AAction: TProc; const ATimeOut: Cardinal): Boolean;
begin
  Result := TMonitor.Enter(aObject, ATimeOut);
  if Result then
    try
      AAction();
    finally
      TMonitor.Exit(aObject);
    end;
end;

{$ENDREGION}

{$REGION 'TObjectHelper' }

function TObjectHelper.CastAs<T>: T;
begin
  if IsClass(T) then
    Result := T(Self)
  else
    Result := nil;
end;

function TObjectHelper.IsClass(aClass: TClass): Boolean;
begin
  if not Assigned(Self) or (NativeInt(Self) < $10000) then
    Result := False
  else
  if Self is aClass then
    Result := True
  else
    Result := False;
end;

function TObjectHelper.IsNotAssigned: Boolean;
begin
  Result := not Assigned(Self);
end;

function TObjectHelper.IsAssigned: Boolean;
begin
  Result := Assigned(Self);
end;

class function TObjectHelper.FindAnyClass(const aPartialRightName: string): TClass;
var
  ctx: TRttiContext;
  typ: TRttiType;
  list: TArray<TRttiType>;
begin
  Result := nil;
  ctx := TRttiContext.Create;
  try
    list := ctx.GetTypes;
    for typ in list do
    begin
      if typ.IsInstance and (EndsText(aPartialRightName, typ.Name)) then
      begin
        Result := typ.AsInstance.MetaClassType;
        Exit;
      end;
    end;
  finally
    ctx.Free;
  end;
end;


{$ENDREGION}

{$REGION 'TIntegerDynArrayHelper' }

procedure TIntegerDynArrayHelper.Clear;
begin
  SetLength(Self,0);
end;

function TIntegerDynArrayHelper.IsEmpty: Boolean;
begin
  Result := (Length(Self) = 0);
end;

function TIntegerDynArrayHelper.IsNotEmpty: Boolean;
begin
  Result := (Length(Self) > 0);
end;

function TIntegerDynArrayHelper.Count: Integer;
begin
  Result := Length(Self);
end;

function TIntegerDynArrayHelper.First: Integer;
begin
  if Length(Self) = 0 then
    Result := 0
  else
    Result := Self[0];
end;

function TIntegerDynArrayHelper.Last: Integer;
begin
  if Length(Self) = 0 then
    Result := 0
  else
    Result := Self[High(Self)];
end;

function TIntegerDynArrayHelper.Get(aIndex, aDefault: Integer): Integer;
begin
  if (aIndex > -1) and (aIndex <= High(Self)) then
    Result := Self[aIndex]
  else
    Result := aDefault;
end;

procedure TIntegerDynArrayHelper.Resize(aCount: Integer);
begin
  SetLength(Self, aCount);
end;

function TIntegerDynArrayHelper.IndexOf(const aValue: Integer): Integer;
begin
  for Result := 0 to High(Self) do
     if Self[Result] = aValue then
       Exit;

  Result := -1;
end;

function TIntegerDynArrayHelper.Contains(const aValue: Integer): Boolean;
begin
  Result := (IndexOf(aValue) > -1);
end;

procedure TIntegerDynArrayHelper.Add(const aValue: Integer);
begin
  SetLength(Self, Length(Self)+1);
  Self[High(Self)] := aValue;
end;

procedure TIntegerDynArrayHelper.Delete(aIndex: Integer);
begin
  if (aIndex <= High(Self)) and (aIndex >= 0) then
    System.Delete(Self,aIndex,1);
end;

{$ENDREGION}

end.
