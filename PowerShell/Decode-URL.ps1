<#
.SYNOPSIS
  Extract the original URL from a "Safe Links" link.

.DESCRIPTION
  Microsoft Safelink protection or 'Safe Links' (aka 'Office 365 ATP Safe Links' or 'ATP Safe Links') is a "security feature"
  offered as part of Microsoft's Adavanced Threat Protection (ATP) for enterprise organizations. It replaces the URLs in an
  incoming email with URLs that allow Microsoft to scan the original link for anything suspicious and redirect the user only
  after it is cleared.
  
    Example:
        www.google.com
              └─> would be replaced
                  with something that
                  looks like this ─┐
                                   ˅
        na01.safelinks.protection.outlook.com/?url=http%3a%2f%2fwww.google.com

  The problem is that often times the original URL is needed or the link does not properly redirect for certain URLs. Because
  of the way Safe Links formats the links, it can be difficult/annoying/time-consuming to derive the original intended URL from
  the one that Safe Links replaces it with. This "feature" is not only extremely annoying, it is also considered by many security
  professionals to be less safe.

    Example:
        4 Reasons "Safe Links" are Less Safe (from 'https://www.avanan.com/resources/microsoft-atp-safe-links'):
            1. Safe Links bypassed with IP traffic misdirection
            2. Safe Links bypassed using obfuscated URLs
            3. It makes it impossible to know where the link is going
            4. Users more likely to 'login' on a Fake O365 login page if the domain is outlook.com
  
  This script is intended to quickly and easily extract the original URL from a Safe Links replaced URL. Hopefully, feature 16401
  is implemented sooner rather than later... (https://products.office.com/en-us/business/office-365-roadmap?featureid=16401)
	
.NOTES
  Version:        1.0
  Author:         Brian Etchieson
  Creation Date:  AUG/23/2018
  Purpose/Change: Initial script development

.EXAMPLE
  .\Decode-URL.ps1
#>

#clear ;

Write-Host "`nExtract Original URL from Safelinks URL`n"

$safelinks_url = Read-Host "Enter Safelinks URL"

$trimmed_url = $safelinks_url.Replace("https://na01.safelinks.protection.outlook.com/?url=","")

$encoded_url = $trimmed_url.Substring(0, $trimmed_url.IndexOf('&data='))

Add-Type -AssemblyName System.Web
$decoded_url = [System.Web.HttpUtility]::UrlDecode("$encoded_url")

Write-Host "`n"
Write-Host "Original URL:"
Write-Host $decoded_url
Write-Host "`n"

#EOF
