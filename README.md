# delphi-SCL

A general purpose library based on Delphi records and helpers

## SCL.Types

General purpose library for managing native data types encapsulated in dedicated record helper with related conversion and manipulation routines.

## Important Note about String Helper

ALL functions ALWAYS use 1-based string indexing on all platforms.
However, be careful if you want to access individual characters of a string as an array, in that case, using Chars[] of this StringHelper the access will always be 1-based.

Be aware of System.SysUtils.TStringHelper as this helper instead works in the opposite way, always managing strings as 0-based regardless of the platform, so it is recommended NOT to mix helpers in the same application but choose to adopt a UNIQUE method otherwise there is a risk of great confusion.
 
## Helper fort dynamic array

The helper for string dynamic array, let you to manage the array as a TStringList. For example:

```delphi
var str := 'red;yellow;black;white';
var strArray := str.Split(';');

writeln(strArray.Count); // output: 4
strArray.Add('green');
writeln(strArray.Count); // output: 5

writeln(strArray.First); // output: red
writeln(strArray.Last);  // output: green
writeln(strArray.Contains('red')); // output: TRUE
```


[![License](https://img.shields.io/badge/License-Apache%202.0-yellowgreen.svg)](https://opensource.org/licenses/Apache-2.0)
