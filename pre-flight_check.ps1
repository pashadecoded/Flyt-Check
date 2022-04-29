write-host "-------------------------------------------"
write-host "    ## Gathering System Resources ##"
write-host "-------------------------------------------`n"
function Out-Default {}
$ErrorActionPreference = "SilentlyContinue"
$ProgressPreference = "SilentlyContinue" 
$host.UI.RawUI.WindowTitle = “Pre-Flyt_Check”


$OGPATH = Get-Location   
$USRPRL = $env:USERPROFILE
$JAVAENV = $env:JAVA_HOME
$RPAENV = $env:ASGRPAInstallFolder

# Add-MpPreference -ExclusionProcess "$Env:ProgramFiles\containerd\containerd.exe"

$NODEPATH = "$env:USERPROFILE\AppData\Roaming\npm\node_modules"
$NODEPATH2 = "C:\ProgramData\npm\node_modules"

if ($NODEPATH2) {
    cd $NODEPATH2
    $path = $NODEPATH2
}
else {
    cd $NODEPATH
    $path = $NODEPATH
}

$pcinfo = Get-ComputerInfo -Property CsProcessors, CsNumberOfLogicalProcessors, OsName, OsVersion, CsTotalPhysicalMemory

$cpu = ($pcinfo | Out-String -Stream | Select-String -Pattern "CsProcessors").ToString().Trim()
write-host "    $cpu"

$ncpu = ($pcinfo | Out-String -Stream | Select-String -Pattern "CsNumberOfLogicalProcessors").ToString().Trim()
write-host "    $ncpu"

$os = ($pcinfo | Out-String -Stream | Select-String -Pattern "OSName").ToString().Trim()
write-host "    $os"

$build = ($pcinfo | Out-String -Stream | Select-String -Pattern "OsVersion").ToString().Trim()
write-host "    $build"

$ram = (systeminfo | Select-String 'Total Physical Memory:').ToString().Split(':')[1].Trim()
write-host "    Total Physical Memory       : $ram"


if ($JAVAENV) {

    write-host "`n-------------------------------------------"
    write-host "    ## Checking Env_Variables ##"
    write-host "-------------------------------------------`n"
    write-host "    Java_Home: $JAVAENV`n" 
    write-host "    ASGRPAInstallFolder: $RPAENV"
}

### nodejs version check 
write-host "`n-------------------------------------------"
write-host "    ## Checking nodejs ##"
write-host "-------------------------------------------`n"

$node_version = (node -v)
$npm_version = (npm -v)
$npm_command = (npm ls --depth=0 -s) | where { $_ -ne "" }
$host.UI.RawUI.WindowTitle = “Pre-Flyt_Check”

$npm_trim = $npm_command.replace('+--', '').replace('`--', '')      
$angular = ($npm_trim | Out-String -Stream | Select-String -Pattern "@angular/cli").ToString().Trim()
$rimraf = ($npm_trim | Out-String -Stream | Select-String -Pattern "rimraf").ToString().Trim()


if ($node_version) {

    if ($node_version -like "v12.0.0") {
        write-host "    nodejs $node_version is installed"
        
    }
    else {
        write-host "    nodejs $node_version is not Supported, Please install nodejs v12.0.0"
    }
    
    write-host "`n-------------------------------------------"
    write-host "    ## Checking npm ##"
    write-host "-------------------------------------------`n"

    if ($node_version) {

        
        if ($npm_version) {
            if ($npm_version -like "6.9.0") {
                write-host "    npm v$npm_version is installed"
            }
            else {
                write-host "    npm v$npm_version is not Supported, Please install npm v6.9.0"
            }
        }
        else {
            write-host "    npm is not installed"
        }


    }

    ### nodejs version check
    write-host "`n-------------------------------------------"
    write-host "    ## Checking node modules ##"
    write-host "-------------------------------------------`n"
    
    if ($angular) {
        if ($angular -like "@angular/cli@8.0.0") {
            write-host "    $angular is installed`n"
        }
        else {
            write-host "    $angular is not Supported, Please Install @angular/cli@8.0.0`n"
        }
    }
    else {
        write-host "    @angular/cli is not installed`n"
    }
    

    if ($rimraf) {
        if ($rimraf -like "rimraf@3.0.0") {
            write-host "    $rimraf is installed"
        }
        else {
            write-host "    $rimraf is not supported, Please Install rimraf@3.0.0"
        }
    }
    else {
        write-host "    rimraf is not installed"
    }



}
else {
    write-host "    Nodejs is not installed"
}




write-host "`n-------------------------------------------"
write-host "    ## Checking Other Pre-requisites ##"
write-host "-------------------------------------------`n"




$software = "3.1.101"

$installed = (Get-ItemProperty HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall\* | Where { $_.DisplayName -match $software }) | select  DisplayName, DisplayVersion, InstallDate, Version
    
If (-Not $installed) {
    Write-Host "    Microsoft .NET Core 3.1.101 (x64) is not installed`n"
}
else {
    
    Write-Host "    Microsoft .NET Core 3.1.101 (x64) is installed`n"
    
}

$software = "4.8.04084";
$installed = ((gp HKLM:\SOFTWARE\Microsoft\'NET Framework Setup'\NDP\v4\Full\1033\*).Version -Match "4.8.04084").Length -gt 0

If (-Not $installed) {
    Write-Host "    Microsoft .Net Framework 4.8 Runtime is not installed`n";
}
else {
    Write-Host "    Microsoft .Net Framework 4.8 Runtime is installed`n";
}

$software = "Microsoft Access database engine 2010 (English)"
$installed = (Get-ItemProperty HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall\* | Where { $_.DisplayName -eq $software }) | select  DisplayName, DisplayVersion, InstallDate, Version
    
#$installed = (Get-ItemProperty HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall\* | Where { $_.DisplayName -eq $software }) -ne $null
#$installed = (Get-WmiObject -Class Win32_Product | where vendor -eq $software | select Name, Version

If ($installed) {

    $version = $installed.DisplayVersion
    Write-Host "    Microsoft Access database engine 2010 v $version is installed`n"
    
}
else {
    
                
    Write-Host "    Microsoft Access database engine 2010 is not installed`n"
}

$software = "Zulu JDK 8.44.0.9 (8u242), 64-bit";
$installed = (Get-ItemProperty HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall\* | Where { $_.DisplayName -eq $software }) -ne $null

If (-Not $installed) {
    Write-Host "    $software is not installed`n";
}
else {
    Write-Host "    $software is installed`n";
}

# $software = "Java 8"
# $installed = (Get-ItemProperty HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall\* | Where { $_.DisplayName -match $software }) | select  DisplayName, DisplayVersion, InstallDate, Version
# If ($installed) {

#     $version = $installed.DisplayVersion
#     Write-Host "    Java v$version is installed`n"
        
# }
# else {
        
                    
#     Write-Host "    Java is not installed`n"
# }


write-host "-------------------------------------------"
write-host "    ## Completed ##"
write-host "-------------------------------------------"
$completed = "completed"

cd $OGPATH

if ($completed) {
    Write-Host "Press Any Key To Exit"
    $x = $host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
    exit
}
    