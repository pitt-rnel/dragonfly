;Product Info
Name "Dragonfly" ;Define your own software name here
!define PRODUCT "Dragonfly" ;Define your own software name here
!define VERSION "1.0.0" ;Define your own software version here


!include "MUI.nsh"
!include "winmessages.nsh"
!include "EnvVarUpdate.nsh"
!include "LogicLib.nsh"

;--------------------------------
;Configuration

  OutFile "dragonfly_windows_setup.exe"

  !define MUI_ICON "dragonfly.ico"

  ;Folder selection page
  InstallDir "$PROGRAMFILES\${PRODUCT}"

  ;Remember install folder
  InstallDirRegKey HKCU "Software\${PRODUCT}" ""

;--------------------------------
;Pages
  !insertmacro MUI_PAGE_WELCOME
  !insertmacro MUI_PAGE_LICENSE "../LICENSE"
  !insertmacro MUI_PAGE_COMPONENTS
  !insertmacro MUI_PAGE_DIRECTORY
  !insertmacro MUI_PAGE_INSTFILES
  !insertmacro MUI_PAGE_FINISH
  !insertmacro MUI_UNPAGE_CONFIRM
  !insertmacro MUI_UNPAGE_INSTFILES

  !define MUI_ABORTWARNING

  !define MUI_HEADERBITMAP "${NSISDIR}\Contrib\Icons\modern-header.bmp"
  !define MUI_SPECIALBITMAP "${NSISDIR}\Contrib\Icons\modern-wizard.bmp"
 ;!define MUI_UI "${NSISDIR}\Contrib\UIs\default.exe" -- Generated by the gui, but causes errors
 
;--------------------------------
  ;Language
 
  !insertmacro MUI_LANGUAGE "English"
;--------------------------------
  ;Language Strings
 
  ;Descriptions
  LangString DESC_Section_Core   ${LANG_English} "Dragonfly Core executables and C++ interface"
  LangString DESC_Section_Matlab ${LANG_English} "Dragonfly Matlab interface"
  LangString DESC_Section_Java   ${LANG_English} "Dragonfly Java interface"
  LangString DESC_Section_dotNET ${LANG_English} "Dragonfly .NET interface"
  LangString DESC_Section_python ${LANG_English} "Dragonfly Python interface"
  LangString DESC_Section_Shortcuts ${LANG_English} "Shortcuts to Dragonfly in the Start Menu and on the Desktop"
  LangString DESC_Section_Uninstaller ${LANG_English} "Dragonfly Uninstaller"

     
Section "Dragonfly Core" section_Core
  SectionIn RO

  ;${EnvVarUpdate} $0 "DRAGONFLY" "A" "HKLM" "$INSTDIR" 
  !define env_hklm 'HKLM "SYSTEM\CurrentControlSet\Control\Session Manager\Environment"'
  ; set variable
  WriteRegExpandStr ${env_hklm} DRAGONFLY "$INSTDIR"

  ReadEnvStr $R0 "PYTHONPATH" 
  ${If} $R0 == ''
      WriteRegExpandStr ${env_hklm} PYTHONPATH "$INSTDIR\lang\python"

      ; make sure windows knows about the change
      SendMessage ${HWND_BROADCAST} ${WM_WININICHANGE} 0 "STR:Environment" /TIMEOUT=5000
  ${Else}
      ; make sure windows knows about the change
      SendMessage ${HWND_BROADCAST} ${WM_WININICHANGE} 0 "STR:Environment" /TIMEOUT=5000

      ${EnvVarUpdate} $0 "PYTHONPATH" "A" "HKLM" "$INSTDIR\lang\python"
  ${EndIf}
  
  SetOutPath "$INSTDIR"
  FILE "..\README.md"
  FILE "..\LICENSE"
  FILE "..\AUTHORS"
  FILE "..\VERSION"
  
  SetOutPath "$INSTDIR\bin"
  FILE "..\bin\MessageManager.exe"
  FILE "..\bin\QuickLogger.exe"

  SetOutPath "$INSTDIR\examples"
  FILE "..\examples\*.txt"
  
  SetOutPath "$INSTDIR\examples\cpp"
  FILE /r /x *.pdb /x *.ncb /x *.user /x *.suo /x Release /x Debug /x obj "..\examples\cpp\"
    
  SetOutPath "$INSTDIR\include"
  FILE "..\include\*.h"

  SetOutPath "$INSTDIR\include\internal"
  FILE "..\include\internal\*.h"
  
  SetOutPath "$INSTDIR\lib"
  FILE "..\lib\*.lib"
  
  SetOutPath "$INSTDIR\src\utils"
  FILE /r "..\src\utils\*"
  
  SetOutPath "$INSTDIR\tools"
  FILE "*.m"
  FILE "*.py"
  
  ;SetOutPath "$INSTDIR\PipeLib\PipeLib"
  ;FILE "..\PipeLib\PipeLib\UPipe.h"
  ;SetOutPath "$INSTDIR\PipeLib"
  ;FILE "..\PipeLib\PipeLib.lib"
SectionEnd

Section "Matlab Interface" section_Matlab
  SetOutPath "$INSTDIR\lang\matlab"
  FILE "..\lang\matlab\*.m"
  FILE "..\lang\matlab\*.mex*"
  FILE "..\lang\matlab\*.h"
  
  SetOutPath "$INSTDIR\examples\matlab"
  FILE /r "..\examples\matlab\"
SectionEnd

Section ".NET Interface" section_dotNET
  SetOutPath "$INSTDIR\lang\dot_net"
  FILE "..\lang\dot_net\Dragonfly.NET.dll"
  FILE "..\lang\dot_net\*.m"
  
  SetOutPath "$INSTDIR\examples\cs"
  FILE /r /x *.pdb /x *.ncb /x *.user /x *.suo /x Release /x Debug /x obj "..\examples\cs\"
SectionEnd

Section "Python Interface" section_python
  SetOutPath "$INSTDIR\lang\python"
  FILE "..\lang\python\_PyDragonfly.pyd"
  FILE "..\lang\python\_PyDragonfly.lib"
  FILE "..\lang\python\PyDragonfly.py"
  FILE "..\lang\python\_Dragonfly_Definitions.pyd"
  FILE "..\lang\python\_Dragonfly_Definitions.lib"
  FILE "..\lang\python\Dragonfly_Definitions.py"
  
  SetOutPath "$INSTDIR\examples\python"
  FILE /r /x *.pyc "..\examples\python\"
SectionEnd

Section "Shortcuts" section_Shortcuts
  SetShellVarContext all
  CreateDirectory "$SMPROGRAMS\${PRODUCT}"
  CreateShortCut "$SMPROGRAMS\${PRODUCT}\examples.lnk" "$INSTDIR\examples"
  CreateShortCut "$SMPROGRAMS\${PRODUCT}\MessageManager.lnk" "$INSTDIR\bin\MessageManager.exe" "" "$INSTDIR\bin\MessageManager.exe" 0
  CreateShortCut "$DESKTOP\MessageManager.lnk" "$INSTDIR\bin\MessageManager.exe" "" "$INSTDIR\bin\MessageManager.exe" 0
SectionEnd

Section "Uninstaller" section_Uninstaller
  SetShellVarContext all
  
  CreateShortCut "$SMPROGRAMS\${PRODUCT}\Uninstall.lnk" "$INSTDIR\uninst.exe" "" "$INSTDIR\uninst.exe" 0
  WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${PRODUCT}" "DisplayName" "${PRODUCT} ${VERSION}"
  WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${PRODUCT}" "DisplayVersion" "${VERSION}"
  WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${PRODUCT}" "URLInfoAbout" ""
  WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${PRODUCT}" "Publisher" "MotorLab©"
  WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${PRODUCT}" "UninstallString" "$INSTDIR\Uninst.exe"
  WriteRegStr HKLM "Software\${PRODUCT}" "" $INSTDIR
  WriteUninstaller "$INSTDIR\Uninst.exe"
SectionEnd
 
!insertmacro MUI_FUNCTION_DESCRIPTION_BEGIN
  !insertmacro MUI_DESCRIPTION_TEXT ${section_Core} $(DESC_Section_Core)
  !insertmacro MUI_DESCRIPTION_TEXT ${section_Matlab} $(DESC_Section_Matlab)
 ;!insertmacro MUI_DESCRIPTION_TEXT ${section_Java} $(DESC_Section_Java)
  !insertmacro MUI_DESCRIPTION_TEXT ${section_dotNET} $(DESC_Section_dotNET)
  !insertmacro MUI_DESCRIPTION_TEXT ${section_python} $(DESC_Section_python)
  !insertmacro MUI_DESCRIPTION_TEXT ${section_Shortcuts} $(DESC_Section_Shortcuts)
  !insertmacro MUI_DESCRIPTION_TEXT ${section_Uninstaller} $(DESC_Section_Uninstaller)
!insertmacro MUI_FUNCTION_DESCRIPTION_END
 
Function un.onUninstSuccess
  HideWindow
  MessageBox MB_ICONINFORMATION|MB_OK "$(^Name) was successfully removed from your computer.."
FunctionEnd
  
Function un.onInit 
  MessageBox MB_ICONQUESTION|MB_YESNO|MB_DEFBUTTON2 "Are you sure you want to completely remove $(^Name) and all of its components?" IDYES +2
  Abort
FunctionEnd
 
Section "Uninstall" 
  SetShellVarContext all
  
  RMDir /r /REBOOTOK "$INSTDIR"
  RMDir /r "$SMPROGRAMS\${PRODUCT}"

  Delete "$DESKTOP\MessageManager.lnk"
  DeleteRegKey HKEY_LOCAL_MACHINE "SOFTWARE\${PRODUCT}"
  DeleteRegKey HKEY_LOCAL_MACHINE "SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\${PRODUCT}"
  
  ;${un.EnvVarUpdate} $0 "DRAGONFLY" "R" "HKLM" "$INSTDIR" 
  ; delete variable
  DeleteRegValue ${env_hklm} DRAGONFLY
  ; make sure windows knows about the change
  SendMessage ${HWND_BROADCAST} ${WM_WININICHANGE} 0 "STR:Environment" /TIMEOUT=5000  
  
  ; Remove from PYTHONPATH  
  ${un.EnvVarUpdate} $0 "PYTHONPATH" "R" "HKLM" "$INSTDIR\lang\python"
  
SectionEnd
               
;Function .onInstSuccess
;   MessageBox MB_ICONQUESTION|MB_YESNO|MB_DEFBUTTON2 "Would you like to start $(^Name) now?" IDYES true IDNO false
;   true:
;     ExecShell open "$INSTDIR\bin\MessageManager.exe"
;   false:
;FunctionEnd
   
;eof
