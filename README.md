INSTALLING FLUTTER:
https://docs.flutter.dev/install/manual

WITH ZIP FILE DOWNLOADED, RUN:
Expand-Archive (in Powershell)
FOR PATH: <Path_of_ZIP> 
FOR DESTINATION: <Dest_Path> (Dest path is where you want sdk to be extracted into)

ONCE EXTRACTED, HOW TO ADD TO PATH VARIABLES:
https://www.wikihow.com/Change-the-PATH-Environment-Variable-on-Windows
(once downloaded, in vscode should now have sdk inside of the vscode and be able to "create flutter proj") (don't actually create flutter project, this is just a litmus test)

In the bottom righthand corner of vs code, there should be a small box to click to "Select Device"
If you are not running the webapp in chrome, run manually in a terminal opened through VSCode with: 
flutter run -d web-server 

This should give you a link that was opened to connect to the application for debugging purposes, otherwise, connect through the open container to run without developing/debugging.
