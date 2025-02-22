Function Set-TimeZoneFromIP {
    if (Test-WebConnection -Uri "https://timezoneapi.io/api/ip/?token=aZuNiKeSCzxosgrJGmCK"){
        Function Get-TimeZoneFromIP {
            $URIRequest = "https://timezoneapi.io/api/ip/?token=aZuNiKeSCzxosgrJGmCK"
            $TimeZoneAPI =  (Invoke-WebRequest -Uri $URIRequest -UseBasicParsing).Content
            $TimeZoneInfo = $TimeZoneAPI  | ConvertFrom-Json
            $TimeZoneOffSet = $TimeZoneInfo.data.datetime.offset_tzfull
            if ($TimeZoneOffSet -match "Daylight"){$TimeZoneOffSet = $TimeZoneOffSet.Replace("Daylight","Standard")}
            return $TimeZoneOffSet
        }

        $TimeZone= Get-TimeZoneFromIP

        if ($env:SystemDrive -eq 'X:') {
            $WindowsPhase = 'WinPE'
        }
        if ($WindowsPhase -eq 'WinPE'){    
            Write-Host "Setting Timezone to $TimeZone - Offline Mode in WinPE"
            DISM.EXE /image:C:\ /Set-TimeZone:"$TimeZone"
        }
        else{
            Write-Host "Setting Timezone to $TimeZone - Online Mode in Full OS"
            Set-TimeZone -Name $TimeZone
        }
    }
    else {Return "Unable to connect to TimeZone API"}
}