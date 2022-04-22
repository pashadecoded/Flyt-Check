write-host "`n-------------------------------------------"
write-host "    ## Gathering System Resources ##"
write-host "-------------------------------------------`n"

$OGPATH = Get-Location   
$USRPRL = $env:USERPROFILE
$JAVAENV = $env:JAVA_HOME
$RPAENV = $env:ASGRPAInstallFolder

$NODEPATH = "$env:USERPROFILE\AppData\Roaming\npm\node_modulesa"
$NODEPATH2 = "C:\ProgramData\npm\node_modules"

if (GET-command $NODEPATH2 -errorAction SilentlyContinue) {
    cd $NODEPATH2
}
elseif (GET-command $NODEPATH -errorAction SilentlyContinue) {
    cd $NODEPATH
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



### nodejs version check ASG
write-host "`n-------------------------------------------"
write-host "    ## Checking nodejs ##"
write-host "-------------------------------------------`n"

if (Get-Command node -errorAction SilentlyContinue) {
    $node_version = (node -v)
    $npm_version = (npm -v)
    $npm_command = (npm ls -g --depth=0) | where { $_ -ne "" }
    $npm_trim = $npm_command.replace('+--', '').replace('`--', '')
    $angular = ($npm_trim | Out-String -Stream | Select-String -Pattern "@angular/cli@8.0.0").ToString().Trim()
    $rimraf = ($npm_trim | Out-String -Stream | Select-String -Pattern "rimraf@3.0.0").ToString().Trim()
        
}

if ($node_version) {

    if ($node_version -like "v12.0.0") {
        write-host "    nodejs $node_version Is Installed"
        
    }
    else {
        write-host "    nodejs $node_version Is Not Supported, Please Install nodejs v12.0.0"
    }
    
    write-host "`n-------------------------------------------"
    write-host "    ## Checking npm ##"
    write-host "-------------------------------------------`n"

    if ($node_version) {
        write-host "    npm v$npm_version Is Installed"
        
    }

    ### nodejs version check ASG
    write-host "`n-------------------------------------------"
    write-host "    ## Checking node modules ##"
    write-host "-------------------------------------------`n"
    
    if ($angular) {
        if ($angular -like "@angular/cli@8.0.0") {
            write-host "    $angular is Installed`n"
        }
        else {
            write-host "    $angular Is Not Supported, Please Install @angular/cli@8.0.0`n"
        }
    }
    else {
        write-host "    @angular/cli@8.0.0 not Installed in the System`n"
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
        write-host "    rimraf@3.0.0 Not Installed In the System"
    }



}
else {
    write-host "    Nodejs Is Not Installed In the System"
}




write-host "`n-------------------------------------------"
write-host "    ## Checking Other Pre-requisites ##"
write-host "-------------------------------------------`n"


$software = "Zulu JDK 8.44.0.9 (8u242), 64-bit";
$installed = (Get-ItemProperty HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall\* | Where { $_.DisplayName -eq $software }) -ne $null

If (-Not $installed) {
    Write-Host "    $software is not installed`n";
}
else {
    Write-Host "    $software is installed`n";
}

$software = "3.1.101"
#$installed1 = (Get-ItemProperty HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall\* | Where { $_.DisplayName -eq $software1 }) -ne $null
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
#Microsoft Access database engine 2010 (English)

#$installed = (Get-WmiObject -Class Win32_Product | where vendor -eq $software | select Name, Version

If ($installed) {

    $version = $installed.DisplayVersion
    Write-Host "    Microsoft Access database engine 2010 v $version is installed`n"
    
}
else {
    
                
    Write-Host "    Microsoft Access database engine 2010 is not installed`n"
}

$software = "Java 8"
$installed = (Get-ItemProperty HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall\* | Where { $_.DisplayName -match $software }) | select  DisplayName, DisplayVersion, InstallDate, Version
If ($installed) {

    $version = $installed.DisplayVersion
    Write-Host "    Java v$version is installed`n"
    
}
else {
    
                
    Write-Host "    Java is not installed`n"
}


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
    
