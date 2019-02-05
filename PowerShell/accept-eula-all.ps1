<#
.SYNOPSIS
  Auto accepts all of the EULAs for the Sysinternals utilities.

.DESCRIPTION
  Each of the tools from the Sysinternals suite raises a Microsoft License Agreement window that the user must accept in order
  to continue. Especially when using these tools across multiple hosts, this can be quite annoying and tedious. There are a few
  workarounds for this.

  > Workaround 1:  Via the registry – using the REG ADD command in the custom script to ensure that the EULA was flagged as 
                   being accepted. Below are the registry entries:
                       - [HKEY_CURRENT_USER\Software\Sysinternals\PsService]”EulaAccepted”=dword:00000001
                       - [HKEY_CURRENT_USER\Software\Sysinternals\PsList]”EulaAccepted”=dword:00000001

                   By using the REG ADD command, the entries are added for whichever user or service account runs the
                   script on the fly. However, this is a little inelegant – leading us to …

  > Workaround 2:  Use the –accepteula switch when running the tools so that the EULA acceptance is not displayed when
                   the script is launched via Task Scheduler.
  
  However, these can be just as much of a headache in some cases (i.e. if the user forgets to pass the 'accepteula' flag when 
  launching one of the utilities or having to *manually* add/set registry keys for each tool, for each user, across each host).
  
  When executed from the same directory where the Sysinternals apps reside, this script will enumerate all of the utilities 
  present and then create and set the appropriate registry keys for each. Effectively, this 'auto accepts' the EULA for all of 
  the Sysinternals tools for the current user.
  
  Note: Some (not all) of the Sysinternals tools will honor a 'global key' for the Eula:
        - reg.exe ADD HKCU\Software\Sysinternals /v EulaAccepted /t REG_DWORD /d 1 /f
        - reg.exe ADD HKU\.DEFAULT\Software\Sysinternals /v EulaAccepted /t REG_DWORD /d 1 /f
  
  While this can be useful, it does not work for every Sysinternals application. In order to ensure that the Eula is accepted 
  across all of the tools and that the prompt never occurs when launching any of the utilities, it is best not to rely solely on 
  this 'global key'.
  
  Reference Links:
        - https://peter.hahndorf.eu/blog/post/2010/03/07/WorkAroundSysinternalsLicensePopups
        - https://clintboessen.blogspot.com/2013/08/scripting-with-sysinternals-tools.html
        - https://blogs.technet.microsoft.com/askperf/2008/12/16/batch-files-task-scheduler-and-pstools-and-a-eula/

.NOTES
  Version:        1.0
  Author:         Brian Etchieson
  Creation Date:  AUG/27/2018
  Purpose/Change: Initial script development

.EXAMPLE
  .\accept-eula-all.ps1
#>

# Temporary file
$file = "$env:TEMP\sysint-exe-files.txt"

if(Test-Path $file)
{
    Remove-Item "$file" -Force -ErrorAction 0
}


# Enumerate
gci *.exe | % {$_.BaseName} > $file


# Set 'global key'
Write-Host "`nAccepting EULA globally"
reg.exe ADD "HKCU\Software\Sysinternals" /v EulaAccepted /t REG_DWORD /d 1 /f


# Set reg keys for each Sysinternals tool
ForEach ($line in Get-Content $file)
{
    Write-Host "`nAccepting EULA for $line"
    reg.exe ADD "HKCU\Software\Sysinternals\$line" /v EulaAccepted /t REG_DWORD /d 1 /f
}

Write-Host "`nAll set :)`n"

# Cleanup
Remove-Item -path $file

#EOF
