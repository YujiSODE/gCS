# gCS
Interpreter that reads source code and outputs geological columnar section as HTML file in the current directory.  
GitHub: https://github.com/YujiSODE/gCS  
Wiki:
>Copyright (c) 2017 Yuji SODE \<yuji.sode@gmail.com\>  
>This software is released under the MIT License.  
>See LICENSE or http://opensource.org/licenses/mit-license.php
______
## 1. Synopsis
**Tcl**  
`::gCS::_Run filePath ?encoding?;`  
**Shell**  
`tclsh gCS.tcl filePath ?encoding?;`  

**Parameters**  
- `$filePath`: file path of a file to load
- `$encoding`: encoding name

## 2. Script
It requires Tcl/Tk 8.6+.
- `gCS.tcl`: Interpreter
- source code of geological columnar section as a tcl file; formatted with following syntaxes

## 3. Syntax
Source code of geological columnar section consits of three blocks: `@VAR`, `@FIG` and `@TXT`.  
All descriptions should be put between relating blocks. These blocks must be escaped with `#` as follows:

    #@VAR
    ...
    #@VAR
    #@FIG
    #...
    #@FIG
    #TXT
    #...
    #TXT

### 3-1. Block: `@VAR`
### 3-2. Block: `@FIG`
### 3-3. Block: `@TXT`

## 4. Library list
- gCS.js (Yuji SODE,2017): the MIT License; https://gist.github.com/YujiSODE/a8d3ba4f02567533124a6fd05563f125  
  \(base64 encoded dataurl version on Sat_Nov_04_05:05:13_GMT_2017\)
  
