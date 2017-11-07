#gCS
#gCS.tcl
##===================================================================
#	Copyright (c) 2017 Yuji SODE <yuji.sode@gmail.com>
#
#	This software is released under the MIT License.
#	See LICENSE or http://opensource.org/licenses/mit-license.php
##===================================================================
#Interpreter that reads source code and outputs geological columnar section as HTML file in the current directory.
#=== Synopsis ===
#**Tcl**
#::gCS::_Run filePath ?encoding?;
#**Shell**
#tclsh gCS.tcl filePath ?encoding?;
#=== Parameters ===
# - $filePath: file path of a file to load
# - $encoding: encoding name
##===================================================================
namespace eval ::gCS {
	#=== gCS.js (Yuji SODE,2017): the MIT License; https://gist.github.com/YujiSODE/a8d3ba4f02567533124a6fd05563f125 ===
	#These functions ("gCS_color" and "gCS_pattern") generate a stratum for geological columnar section on a given canvas tag. "gCS_scale" generates scale bar.
	#base64 encoded dataurl version on Mon_Nov_06_14:28:14_GMT_2017
	set _gCS_js {data:image/js;base64,LypnQ1MuanMKKgoqICAgIENvcHlyaWdodCAoYykgMjAxNyBZdWppIFNPREUgPHl1amkuc29kZUBnbWFpbC5jb20+CioKKiAgICBUaGlzIHNvZnR3YXJlIGlzIHJlbGVhc2VkIHVuZGVyIHRoZSBNSVQgTGljZW5zZS4KKi8KLy9UaGVzZSBmdW5jdGlvbnMgKCJnQ1NfY29sb3IiIGFuZCAiZ0NTX3BhdHRlcm4iKSBnZW5lcmF0ZSBhIHN0cmF0dW0gZm9yIGdlb2xvZ2ljYWwgY29sdW1uYXIgc2VjdGlvbiBvbiBhIGdpdmVuIGNhbnZhcyB0YWcuCi8vImdDU19zY2FsZSIgZ2VuZXJhdGVzIHNjYWxlIGJhci4KdmFyIGdDU19jb2xvcj1mdW5jdGlvbihjdnMseDAseTAsZHgxLGR4MixkeSxjb2xvcix0ZXh0KXsKICAgIC8qY3ZzIGlzIGEgY2FudmFzIGVsZW1lbnQKICAgICogeDAsIHkwLCBkeDEsIGR4MiBhbmQgZHkgYXJlIGxlbmd0aHMgaW4gcGl4ZWxzCiAgICAqIGR4MSBhbmQgZHgyIGFyZSBsb3dlciBhbmQgdXBwZXIgd2lkdGhzCiAgICAqIGNvbG9yIGlzIENTUyA8Y29sb3I+IHZhbHVlCiAgICAqIHRleHQgaXMgc2hvcnQgdGV4dAogICAgKi8KICAgIC8qCiAgICAqIHgwLCB5MCwgZHgxLCBkeDIgYW5kIGR5IGFyZSBzaG93biBhcyBmb2xsb3dzOgogICAgKiAoeDAseTApCiAgICAqICstLS0tLS0tKyAoeDArZHgyLHkwKQogICAgKiB8ICAgICAgICBcCiAgICAqICstLS0tLS0tLS0rICh4MCtkeDEseTArZHkpCiAgICAqICh4MCx5MCtkeSkKICAgICovCiAgICAvL2N0eCBpcyAyZCBjb250ZXh0IG9mIGNhbnZhcyB0YWcKICAgIC8vdyBhbmQgaCBhcmUgbWF4IHdpZHRoIGFuZCBtZWRpdW0gaGVpZ2h0IG9mIGEgc3RyYXR1bQogICAgdmFyIGN0eD1jdnMuZ2V0Q29udGV4dCgnMmQnKSx3PU1hdGgubWF4KGR4MSxkeDIpLGg9KGR5LzIpPDE/MTpNYXRoLmZsb29yKGR5LzIpOwogICAgLy9hIHN0cmF0dW0KICAgIGN0eC5maWxsU3R5bGU9Y29sb3I7CiAgICBjdHguYmVnaW5QYXRoKCksY3R4Lm1vdmVUbyh4MCx5MCk7CiAgICBjdHgubGluZVRvKHgwLHkwK2R5KSxjdHgubGluZVRvKHgwK2R4MSx5MCtkeSksY3R4LmxpbmVUbyh4MCtkeDIseTApOwogICAgY3R4LmNsb3NlUGF0aCgpLGN0eC5maWxsKCk7CiAgICAvL2EgdGV4dAogICAgY3R4LmZpbGxTdHlsZT0iIzAwMCI7CiAgICB0ZXh0PSF0ZXh0PyIiOnRleHQ7CiAgICBjdHguZmlsbFRleHQodGV4dCx4MCt3LHkwK2gpOwogICAgY3R4PW51bGw7CiAgICAvL3JldHVybmVkIHZhbHVlIGlzIHRvIGJlIHRoZSBuZXh0IHgwIGFuZCB5MCBhcyBhbiBhcnJheTogW3gwLHkwXQogICAgcmV0dXJuIFt4MCx5MCtkeV07Cn07CnZhciBnQ1NfcGF0dGVybj1mdW5jdGlvbihjdnMseDAseTAsZHgxLGR4MixkeSxzcmMsdGV4dCl7CiAgICAvKmN2cyBpcyBhIGNhbnZhcyBlbGVtZW50CiAgICAqIHgwLCB5MCwgZHgxLCBkeDIgYW5kIGR5IGFyZSBsZW5ndGhzIGluIHBpeGVscwogICAgKiBkeDEgYW5kIGR4MiBhcmUgbG93ZXIgYW5kIHVwcGVyIHdpZHRocwogICAgKiBzcmMgaXMgZmlsZXBhdGggdG8gaW1hZ2VmaWxlIG9yIGRhdGF1cmwgb2YgaW1hZ2Ugd2hpY2ggaXMgdXNlZCBhcyBwYXR0ZXJuCiAgICAqIHRleHQgaXMgc2hvcnQgdGV4dAogICAgKi8KICAgIC8qCiAgICAqIHgwLCB5MCwgZHgxLCBkeDIgYW5kIGR5IGFyZSBzaG93biBhcyBmb2xsb3dzOgogICAgKiAoeDAseTApCiAgICAqICstLS0tLS0tKyAoeDArZHgyLHkwKQogICAgKiB8ICAgICAgICBcCiAgICAqICstLS0tLS0tLS0rICh4MCtkeDEseTArZHkpCiAgICAqICh4MCx5MCtkeSkKICAgICovCiAgICAvL2N0eCBpcyAyZCBjb250ZXh0IG9mIGNhbnZhcyB0YWcKICAgIC8vdyBhbmQgaCBhcmUgbWF4IHdpZHRoIGFuZCBtZWRpdW0gaGVpZ2h0IG9mIGEgc3RyYXR1bQogICAgLy9JbWcgaXMgaW1hZ2Ugb2JqZWN0CiAgICB2YXIgY3R4PWN2cy5nZXRDb250ZXh0KCcyZCcpLHc9TWF0aC5tYXgoZHgxLGR4MiksaD0oZHkvMik8MT8xOk1hdGguZmxvb3IoZHkvMiksSW1nPW5ldyBJbWFnZSgpOwogICAgSW1nLnNyYz1zcmM7CiAgICBJbWcuYWRkRXZlbnRMaXN0ZW5lcignbG9hZCcsZnVuY3Rpb24oKXsKICAgICAgICAvL2Egc3RyYXR1bQogICAgICAgIGN0eC5maWxsU3R5bGU9Y3R4LmNyZWF0ZVBhdHRlcm4oSW1nLCdyZXBlYXQnKTsKICAgICAgICBjdHguYmVnaW5QYXRoKCksY3R4Lm1vdmVUbyh4MCx5MCk7CiAgICAgICAgY3R4LmxpbmVUbyh4MCx5MCtkeSksY3R4LmxpbmVUbyh4MCtkeDEseTArZHkpLGN0eC5saW5lVG8oeDArZHgyLHkwKTsKICAgICAgICBjdHguY2xvc2VQYXRoKCksY3R4LmZpbGwoKTsKICAgICAgICAvL2EgdGV4dAogICAgICAgIGN0eC5maWxsU3R5bGU9IiMwMDAiOwogICAgICAgIHRleHQ9IXRleHQ/IiI6dGV4dDsKICAgICAgICBjdHguZmlsbFRleHQodGV4dCx4MCt3LHkwK2gpOwogICAgICAgIGN0eD1JbWc9bnVsbDsKICAgIH0sZmFsc2UpOwogICAgLy9yZXR1cm5lZCB2YWx1ZSBpcyB0byBiZSB0aGUgbmV4dCB4MCBhbmQgeTAgYXMgYW4gYXJyYXk6IFt4MCx5MF0KICAgIHJldHVybiBbeDAseTArZHldOwp9Owp2YXIgZ0NTX3NjYWxlPWZ1bmN0aW9uKGN2cyxsYWJlbCx3LGgpewogICAgLypjdnMgaXMgYSBjYW52YXMgZWxlbWVudAogICAgKiBsYWJlbCBpcyBsYWJlbCBvZiBzY2FsZQogICAgKiB3IGFuZCBoIGFyZSB3aWR0aCBhbmQgaGVpZ2h0IG9mIHNjYWxlIGluIHBpeGVscwogICAgKi8KICAgIC8vY3R4IGlzIDJkIGNvbnRleHQgb2YgY2FudmFzIHRhZwogICAgLy9jVyBhbmQgY0ggYXJlIHdpZHRoIGFuZCBoZWlnaHQgb2YgY2FudmFzIGVsZW1lbnQKICAgIC8vTCBpcyBsYWJlbCBzaXplIGluIHBpeGVscwogICAgdmFyIGN0eD1jdnMuZ2V0Q29udGV4dCgnMmQnKSxjVz1jdnMud2lkdGgsY0g9Y3ZzLmhlaWdodCxMPTA7CiAgICBjdHguZmlsbFN0eWxlPSIjMDAwIjsKICAgIGN0eC5zdHJva2VTdHlsZT0iIzAwMCI7CiAgICBjdHgubGluZVdpZHRoPXc7CiAgICBMPWN0eC5tZWFzdXJlVGV4dChsYWJlbCkud2lkdGg7CiAgICBjdHguYmVnaW5QYXRoKCksY3R4Lm1vdmVUbyhNYXRoLmZsb29yKGNXLShMLzIpKSxjSC1oKTsKICAgIGN0eC5saW5lVG8oTWF0aC5mbG9vcihjVy0oTC8yKSksY0gpLGN0eC5zdHJva2UoKTsKICAgIGN0eC5maWxsVGV4dChsYWJlbCxjVy1MLGNILWgpOwogICAgY3R4PW51bGw7Cn07Ci8qCiogICAgICAgICAgTUlUIExpY2Vuc2UKKgoqIENvcHlyaWdodCAoYykgMjAxNyBZdWppIFNvZGUKKgoqIFBlcm1pc3Npb24gaXMgaGVyZWJ5IGdyYW50ZWQsIGZyZWUgb2YgY2hhcmdlLCB0byBhbnkgcGVyc29uIG9idGFpbmluZyBhIGNvcHkKKiBvZiB0aGlzIHNvZnR3YXJlIGFuZCBhc3NvY2lhdGVkIGRvY3VtZW50YXRpb24gZmlsZXMgKHRoZSAiU29mdHdhcmUiKSwgdG8gZGVhbAoqIGluIHRoZSBTb2Z0d2FyZSB3aXRob3V0IHJlc3RyaWN0aW9uLCBpbmNsdWRpbmcgd2l0aG91dCBsaW1pdGF0aW9uIHRoZSByaWdodHMKKiB0byB1c2UsIGNvcHksIG1vZGlmeSwgbWVyZ2UsIHB1Ymxpc2gsIGRpc3RyaWJ1dGUsIHN1YmxpY2Vuc2UsIGFuZC9vciBzZWxsCiogY29waWVzIG9mIHRoZSBTb2Z0d2FyZSwgYW5kIHRvIHBlcm1pdCBwZXJzb25zIHRvIHdob20gdGhlIFNvZnR3YXJlIGlzCiogZnVybmlzaGVkIHRvIGRvIHNvLCBzdWJqZWN0IHRvIHRoZSBmb2xsb3dpbmcgY29uZGl0aW9uczoKKiBUaGUgYWJvdmUgY29weXJpZ2h0IG5vdGljZSBhbmQgdGhpcyBwZXJtaXNzaW9uIG5vdGljZSBzaGFsbCBiZSBpbmNsdWRlZCBpbiBhbGwKKiBjb3BpZXMgb3Igc3Vic3RhbnRpYWwgcG9ydGlvbnMgb2YgdGhlIFNvZnR3YXJlLgoqCiogVEhFIFNPRlRXQVJFIElTIFBST1ZJREVEICJBUyBJUyIsIFdJVEhPVVQgV0FSUkFOVFkgT0YgQU5ZIEtJTkQsIEVYUFJFU1MgT1IKKiBJTVBMSUVELCBJTkNMVURJTkcgQlVUIE5PVCBMSU1JVEVEIFRPIFRIRSBXQVJSQU5USUVTIE9GIE1FUkNIQU5UQUJJTElUWSwKKiBGSVRORVNTIEZPUiBBIFBBUlRJQ1VMQVIgUFVSUE9TRSBBTkQgTk9OSU5GUklOR0VNRU5ULiBJTiBOTyBFVkVOVCBTSEFMTCBUSEUKKiBBVVRIT1JTIE9SIENPUFlSSUdIVCBIT0xERVJTIEJFIExJQUJMRSBGT1IgQU5ZIENMQUlNLCBEQU1BR0VTIE9SIE9USEVSCiogTElBQklMSVRZLCBXSEVUSEVSIElOIEFOIEFDVElPTiBPRiBDT05UUkFDVCwgVE9SVCBPUiBPVEhFUldJU0UsIEFSSVNJTkcgRlJPTSwKKiBPVVQgT0YgT1IgSU4gQ09OTkVDVElPTiBXSVRIIFRIRSBTT0ZUV0FSRSBPUiBUSEUgVVNFIE9SIE9USEVSIERFQUxJTkdTIElOIFRIRQoqIFNPRlRXQVJFLgoqLwo=};
	#*** Variables ***
	# - $_SIZE: size of canvas element in a html file; {width height}
	# - $_FONT: CSS font value
	# - $_TITLE: data title
	# - $_SCALE: scale bar; {label width height}
	variable _SIZE {};
	variable _FONT {};
	variable _TITLE {};
	variable _SCALE {};
	#*** Regular expressions ***
	#Regular expressions that match @VAR block, @FIG block and @TXT block
	variable _reVAR {\#@VAR\n(.+)\#@VAR};
	variable _reFIG {\#@FIG\n(.+)\#@FIG};
	variable _reTXT {\#@TXT\n(.+)\#@TXT};
	#Regular expression that matches filename of image file
	variable _reImg {(?:^.+\.gif$)|(?:^.+\.png$)|(?:^.+\.jpeg$)|(?:^.+\.bmp$)|(?:^.+\.svg$)};
	#*** Procedures ***
	#it reads a file as text
	proc _Load {filePath {encoding {}}} {
		# - $filePath: file path of a file to load
		# - $encoding: encoding name
		set c [open $filePath r];
		if {[llength $encoding]} {fconfigure $c -encoding $encoding;};
		set r [read -nonewline $c];
		close $c;unset c;
		return $r;
	};
	#it outputs data as given filename
	proc _Output {filePath data {encoding {}}} {
		# - $filePath: file path of file to output
		# - $data: data to output
		# - $encoding: encoding name
		set c [open $filePath w];
		if {[llength $encoding]} {fconfigure $c -encoding $encoding;};
		puts -nonewline $c $data;
		close $c;unset c;
		return $data;
	};
	#Main procedure to run this system
	proc _Run {filePath {encoding {}}} {
		# - $filePath: file path of a file to load
		# - $encoding: encoding name
		#Regular expressions that match VAR block, FIG block and TXT block
		variable _reVAR;variable _reFIG;variable _reTXT;
		#cH is cumulative height
		set cH 0;
		#Regular expression that matches filename of image file
		variable _reImg;
		# - $_SIZE: size of canvas element in a html file; {width height}
		# - $_FONT: CSS font value
		# - $_TITLE: data title
		# - $_SCALE: scale bar; {label width height}
		# - $_gCS_js: base64 encoded dataurl version of gCS.js (Yuji SODE,2017); the MIT License
		variable _gCS_js;
		variable _SIZE;variable _FONT;variable _TITLE;variable _SCALE;
		#** Encoding **
		set encoding [expr {[llength $encoding]>0?$encoding:[encoding system]}];
		#** it reads given file as a Tcl code **
		if {[llength $encoding]} {
			source -encoding $encoding $filePath;
		} else {
			source $filePath;
		};
		#** Html fragments: html_0 to html_2 **
		#+++++++++++++++ html_0 +++++++++++++++
		set html_0 "<!DOCTYPE html><html lang=\"en\"><head><meta charset=\"$encoding\"><meta name=\"generator\" content=\"gCS.tcl\"><title>$_TITLE</title>\n<script type=\"text/javascript\" src=\"${_gCS_js}\"></script>\n";
		append html_0 "<script type=\"text/javascript\">window.addEventListener\(\'load\',function\(\)\{var slf=window,c=slf.document.getElementById\(\'gCS_cvs\'\),a=slf.document.getElementById\(\'gCS_dl\'\),xy=\[0,0\]\;";
		if {[llength $_FONT]} {append html_0 "c.getContext\(\'2d\'\).font=\"$_FONT\"\;";};
		#+++++++++++++++ html_1 +++++++++++++++
		set html_1 "slf.setTimeout\(function(\)\{a.href=c.toDataURL\(\'image/png\'\)\;\},1000\)\;\},false\)\;</script></head>\n";
		#+++++++++++++++ html_2 +++++++++++++++
		set html_2 "<body><canvas id=\"gCS_cvs\" width=[lindex $_SIZE 0] height=[lindex $_SIZE 1]></canvas>\n";
		append html_2 "<p><a id=\"gCS_dl\" href=\"*\" download=\"[regsub -all {[^0-9a-zA-Z]} $_TITLE _]\.png\">Download columnar section</a></p>";
		#_reElem is regular expression that matches variables in the current namespace
		set i 0;
		set _reElem {};
		foreach e [info vars ::gCS::*] {
			append _reElem "[expr {$i>0?{|}:{}}]\(?:\^[namespace tail $e]\$\)";
			incr i 1;
		};
		#** it reads given file as a text **
		#doc is text data of given file
		set doc [::gCS::_Load $filePath $encoding];
		#varV is @VAR block value
		#figV is @FIG block value
		#txtV is @TXT block value
		set varV [lindex [regexp -inline $_reVAR $doc] 1];
		set figV [lindex [regexp -inline $_reFIG $doc] 1];
		set txtV [lindex [regexp -inline $_reTXT $doc] 1];
		#** Columnar section **
		foreach elm [split $figV \;] {
			if {[llength $elm]} {
				set v0 [regsub {^(?:\n)?\#} $elm {}];
				#v0 is details of the current stratum: {stratumName:dy dx1 dx2:shortText}
				set v [split $v0 \:];
				set v_0 [lindex $v 0];
				set v_1 [lindex $v 1];
				set v_2 [lindex $v 2];
				#** Generating JavaScript code: columnar section **
				#cf. javascript: var c=<canvas element>
				#cf. javascript: var xy=[0,0]
				#To check if the current stratum name is declared
				if {[regexp $_reElem $v_0]} {
					#++ when the current stratum name is declared ++
					#std is standard value of the current stratum: {standardWidth color|image}
					variable $v_0;
					set std [subst $[subst $v_0]];
					set std_0 [lindex $std 0];
					set std_1 [lindex $std 1];
					if {[regexp $_reImg $std_1]} {
						#when source image is image file
						set js_dx1 [expr {double(${std_0})+double([lindex $v_1 1])}];
						set js_dx2 [expr {double(${std_0})+double([lindex $v_1 2])}];
						set js_dy [lindex $v_1 0];
						#cf. javascript: gCS_pattern(cvs,x0,y0,dx1,dx2,dy,src,text)->[x,y]
						append html_0 "xy=gCS_pattern\(c,xy\[0\],xy\[1\],${js_dx1},${js_dx2},${js_dy},\"${std_1}\"[expr {[llength $v_2]>0?",\"$v_2\"":{}}]\)\;";
						incr cH $js_dy;
					} else {
						#when source image is CSS <color> value
						set js_dx1 [expr {double(${std_0})+double([lindex $v_1 1])}];
						set js_dx2 [expr {double(${std_0})+double([lindex $v_1 2])}];
						set js_dy [lindex $v_1 0];
						#cf. javascript: gCS_color(cvs,x0,y0,dx1,dx2,dy,color,text)->[x,y]
						append html_0 "xy=gCS_color\(c,xy\[0\],xy\[1\],${js_dx1},${js_dx2},${js_dy},\"${std_1}\"[expr {[llength $v_2]>0?",\"$v_2\"":{}}]\)\;";
						incr cH $js_dy;
					};
				} else {
					#++ when the current stratum name is not declared ++
					set js_dy [lindex $v_1 0];
					append html_0 "xy=gCS_color\(c,xy\[0\],xy\[1\],[expr floor([lindex $_SIZE 0]/4)],0,${js_dy},\"\#0000\"[expr {[llength $v_2]>0?",\"$v_2\"":{}}]\)\;";
						incr cH $js_dy;
				};
			};
		};
		#** Generating JavaScript code: scale **
		#cf. javascript: gCS_scale(cvs,label,w,h)
		append html_0 "gCS_scale\(c,\"[lindex $_SCALE 0]\",[lindex $_SCALE 1],[lindex $_SCALE 2]\)\;";
		append html_2 "<p>[string map {\# {} \n <br>} $txtV]</p>";
		#** Building HTML source **
		append html_0 $html_1;
		append html_0 $html_2;
		append html_0 "<footer>[clock format [clock seconds] -gmt 1]</footer></body></html>";
		::gCS::_Output "[regsub -all {[^0-9a-zA-Z]} $_TITLE _].html" $html_0 $encoding;
		puts stdout {=== Sizes ===};
		puts stdout "Canvas height:[lindex $_SIZE 1] px\nSection height:$cH px";
		puts stdout {=== Variables ===};
		puts stdout $varV;
		unset html_0 html_1 html_2 varV figV txtV;
		exit;
	};
};
if {$argc} {::gCS::_Run [lindex $argv 0] [lindex $argv 1];};
