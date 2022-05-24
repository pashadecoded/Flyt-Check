$logfile = "$env:USERPROFILE\Desktop\Flyt-Check.log"
if (Test-Path -Path $logfile) {
    rm $logfile
}

function WriteLog {
    Param ([string]$LogString)
    $LogMessage = "$LogString"
    Add-content $logfile -value $LogMessage
}

write-host "lllllllll lllllllll Flyt-Check"
write-host "lllllllll lllllllll"
write-host "lllllllll lllllllll"
write-host "lllllllll lllllllll"
write-host "lllllllll lllllllll"
write-host "`nlllllllll lllllllll"
write-host "lllllllll lllllllll"
write-host "lllllllll lllllllll"
write-host "lllllllll lllllllll"
write-host "lllllllll lllllllll"
Write-host "`nGathering Info, Please Wait."


WriteLog "-------------------------------------------"
WriteLog "## System Resources ##"
WriteLog "-------------------------------------------`n"

function Out-Default {}
$ErrorActionPreference = "SilentlyContinue"
$ProgressPreference = "SilentlyContinue" 
$host.UI.RawUI.WindowTitle = “Pre-Flyt_Check”
$OGPATH = Get-Location   
$USRPRL = $env:USERPROFILE
$JAVAENV = $env:JAVA_HOME
$NODEPATH = "$env:USERPROFILE\AppData\Roaming\npm\node_modules"
$NODEPATH2 = "C:\ProgramData\npm\node_modules"

$cpu = (Get-CimInstance -ClassName Win32_Processor | Select-Object -Property Name, NumberOfCores)
$osnram = (Get-CimInstance -ClassName Win32_OperatingSystem | Select-Object -Property Caption, Version, OsArchitecture, TotalVisibleMemorySize, FreePhysicalMemory)
$processor = $cpu.Name
$corecount = $cpu.NumberOfCores

$os = $osnram.Caption
$osver = $osnram.Version
$ostype = $osnram.OsArchitecture
$totalram = $osnram.TotalVisibleMemorySize / 1mb
$ram = [math]::ceiling(($totalram)) 

WriteLog "Processor : $processor"
WriteLog "Cores     : $corecount"
WriteLog "Ram       : $ram GB"
WriteLog "OS        : $os"
WriteLog "Build     : $osver"
WriteLog "Type      : $ostype"

if ($JAVAENV) {
    write-host "`n## Checking Env_Variable ##"
    WriteLog "`n-------------------------------------------"
    WriteLog "## Env_Variables ##"
    WriteLog "-------------------------------------------`n"
    
   
        WriteLog "Java_Home: $JAVAENV`n"
        

}


### nodejs version check 

WriteLog "`n-------------------------------------------"
WriteLog "## Node.js ##"
WriteLog "-------------------------------------------`n"
$nodejs = "Node.js"
$nodever = "12.0.0"
$node = (Get-ItemProperty HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall\* | Where { $_.DisplayName -match $nodejs } | Select-Object -Property DisplayName, DisplayVersion)
$nodeversion = $node.DisplayVersion


$npm_version = (npm -v)
     
$angular = ($npm_trim | Out-String -Stream | Select-String -Pattern "@angular/cli").ToString().Trim()
$rimraf = ($npm_trim | Out-String -Stream | Select-String -Pattern "rimraf").ToString().Trim()
$host.UI.RawUI.WindowTitle = “Pre-Flyt_Check”

if ($nodeversion) {

    if ($nodeversion -like "12.0.0") {
        WriteLog "node.js v$nodeversion is installed"
    }
    else {
        WriteLog "node.js v$nodeversion is not Supported, Please install nodejs v12.0.0"
    }
    
    WriteLog "`n-------------------------------------------"
    WriteLog "## Npm ##"
    WriteLog "-------------------------------------------`n"

    if (Test-Path -Path $NODEPATH2) {
                cd $NODEPATH2
                $npm_command = (npm ls --depth=0 -s) | where { $_ -ne "" }
                $npm_trim = $npm_command.replace('+--', '').replace('`--', '')
            }
            else {
                $npm_g_command = (npm -g ls --depth=0 -s) | where { $_ -ne "" }
                $npm_trim = $npm_g_command.replace('+--', '').replace('`--', '') 
            }

    if ($nodeversion) {

        
        if ($npm_version) {
            if ($npm_version -like "6.9.0") {
                WriteLog "npm v$npm_version is installed"
            }
            else {
                WriteLog "npm v$npm_version is not Supported, Please install npm v6.9.0"
            }
        }
        else {
            WriteLog "npm is not installed"
        }


    }

    ### node modules version check
   
    WriteLog "`n-------------------------------------------"
    WriteLog "## Node Modules ##"
    WriteLog "-------------------------------------------`n"
    
    if ($angular) {
        
        if ($angular -like "@angular/cli@8.0.0") {

            WriteLog "$angular is installed`n"
        }
        else {
            WriteLog "$angular is not Supported, Please Install @angular/cli@8.0.0`n"
        }
    }
    else {
        WriteLog "@angular/cli is not installed`n"
    }
    

    if ($rimraf) {
      

        if ($rimraf -like "rimraf@3.0.0") {
            WriteLog "$rimraf is installed"
        }
        else {
            WriteLog "$rimraf is not supported, Please Install rimraf@3.0.0"
        }
    }
    else {
        WriteLog "rimraf is not installed"
    }



}
else {
    WriteLog "node.js is not installed"
}



WriteLog "`n-------------------------------------------"
WriteLog "## Pre-requisites ##"
WriteLog "-------------------------------------------"

$software = "3.1.101"

$installed = (Get-ItemProperty HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall\* | Where { $_.DisplayName -match $software }) | select  DisplayName, DisplayVersion, InstallDate, Version
    
If (-Not $installed) {
    WriteLog "`nMicrosoft .NET Core 3.1.101 (x64) is not installed"
}
else {
    
    WriteLog "`nMicrosoft .NET Core 3.1.101 (x64) is installed"
    
}

$software = "4.8.04084";
$installed = ((gp HKLM:\SOFTWARE\Microsoft\'NET Framework Setup'\NDP\v4\Full\1033\*).Version -Match "4.8.04084").Length -gt 0

If (-Not $installed) {
    WriteLog "`nMicrosoft .Net Framework 4.8 Runtime is not installed";
}
else {
    WriteLog "`nMicrosoft .Net Framework 4.8 Runtime is installed";
}

$software = "`nMicrosoft Access database engine 2010 (English)"
$installed = (Get-ItemProperty HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall\* | Where { $_.DisplayName -eq $software }) | select  DisplayName, DisplayVersion, InstallDate, Version

If ($installed) {

    $version = $installed.DisplayVersion
    WriteLog "`nMicrosoft Access database engine 2010 is installed"
    
}
else {
    
                
    WriteLog "`nMicrosoft Access database engine 2010 is not installed"
}

 $software = "java"
 $jre = "jre"
 $jdk = "jdk"

 $JAVA32 = (Get-ItemProperty HKLM:\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall\* | Where { $_.Contact -match $software }) | select  DisplayName, DisplayVersion
 $JAVA64 = (Get-ItemProperty HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall\* | Where { $_.Contact -match $software }) | select  DisplayName, DisplayVersion
 $Jre32 = (Get-ItemProperty HKLM:\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall\* | Where { $_.InstallLocation -match $jre }) | select  DisplayName, DisplayVersion
 $Jre64 = (Get-ItemProperty HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\* | Where { $_.InstallLocation -match $jre }) | select  DisplayName, DisplayVersion
 $Jdk32 = (Get-ItemProperty HKLM:\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall\* | Where { $_.InstallLocation -match $jdk }) | select  DisplayName, DisplayVersion
 $Jdk64 = (Get-ItemProperty HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\* | Where { $_.InstallLocation -match $jdk }) | select  DisplayName, DisplayVersion

 If ($Jre32) {
     
     $j32 = $Jre32.DisplayName
     $j32v = $Jre32.DisplayVersion
     WriteLog "`n$j32 (32-bit) is installed"
       
 }

If ($Jdk32) {
     
     $j32 = $Jdk32.DisplayName
     $j32v = $Jdk32.DisplayVersion
     WriteLog "`n$j32 (32-bit) is installed"
       
 }

 If ($Jre64) {
     
     $j64 = $Jre64.DisplayName
     $j64v = $Jre64.DisplayVersion
     WriteLog "`n$j64 is installed"
       
 }

 If ($Jdk64) {
     
     $j64 = $Jdk64.DisplayName
     $j64v = $Jdk64.DisplayVersion
     WriteLog "`n$j64 is installed"
       
 }

$r = "java"
$f = (Get-NetFirewallRule | Where { $_.Name -match $r }) | select  DisplayName, Name, Enabled, PrimaryStatus, Profile, Direction, Action
$x = ($f | Where { $_.Name -match "TCP" }) | select  DisplayName, Enabled, PrimaryStatus, Profile, Direction, Action
$l = ($x | Out-String).ToString().Trim()
$c = ($f | Where { $_.Enabled -eq "False" })
$e = $x.DisplayName


WriteLog "`n-------------------------------------------"
WriteLog "## Related Firewall Entries ##  "
WriteLog "-------------------------------------------`n"


if ($f){
    if($c){

WriteLog "Related Firewall Rules are Disabled"
    }
    else{
        WriteLog "$l"
    }
    

}
else{
    WriteLog "No Related Firewall Entries Found" 
}


WriteLog "`n-------------------------------------------"
WriteLog "## Related Processes ##"
WriteLog "-------------------------------------------`n"

$f = Get-CimInstance Win32_Process | Select Name, CommandLine
$x1 = ($f.Name | Select-String -Pattern "java.exe")
$x2 = ($f.CommandLine | Select-String -Pattern "java.exe")


if ($x1){
       
        WriteLog "$x1 is running"
        #WriteLog "`nCommandLine: $x2"
        
}
else{
    WriteLog "No Related Services Running"

}

sleep 1
WriteLog "`n-------------------------------------------"
WriteLog "## Completed ##"
WriteLog "-------------------------------------------"
$completed = "completed"

cd $OGPATH

if ($completed) {
    write-host "`nGenerated Results Saved @ Desktop\Flyt-Check.log" 
    Write-Host "`nPress Any Key To Exit`n"
    $x = $host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
    invoke-item $logfile
}

#  ___ ___  ___
# | __/ _ \| __|
# | _| (_) | _|
# |___\___/|_|
#
    
