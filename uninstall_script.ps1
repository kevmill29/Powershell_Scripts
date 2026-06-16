#Step 1: Definte the target registry paths
$regPaths = @(
    "HKLM:\Software]Microsoft\Windows\CurrentVersion\Uninstall\*",
    "HKLM:\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall\*"
)
#Step 2: Get all installed applications from the defined registry paths
$allInstalledApps = Get-ItemProperty -Path $regPaths -ErrorAction SilentlyContinue

#Step 3: Filter list to find only Java 8 or whatever application you want to find
$java8Apps = $allInstalledApps | Where-Object {$_.DisplayName -match "Java 8"}

#Step 4 : Error handling if no applications found
if($null -eq $java8Apps){
    Write-Host "No Java 8 applications found. Exiting Script."
    Exit
}

#Step 5 Loop through each java 8 installation found
foreach($app in $java8Apps){
    #Check if the uninstaller string contains an MSI product code (curly braces)
    if($app.UninstallString -match "{.*}"){
        $productCode = $Matches[0] # Matches[0] grabs the exact text found inside the braces
        Write-Host "Uninstalling $($app.DisplayName)..." -ForegroundColor Cyan
        
        #Trigger the silent uninstallation
        Start-Process -FilePath "msiexec.exe" -ArgumentList "/x $productCode /qn  /norestart" -Wait
    }
    }
}
