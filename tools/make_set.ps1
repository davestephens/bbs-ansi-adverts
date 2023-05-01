#*************************************************************************************************************** 
# MoveWin.ps1
# -------------------------------------------------------------------------------------------------------------
#  Generates a set of ANSI adverts for display when logging off a BBS.
# -----------------------------------------------------------
# Usage > .\MoveWin.ps1 -BBSType 1 -OutputDir D:\MyBBSFolder\Art -NumAds 5 -Overwrite
# -------------------------------------------------------------------------------------------------------------
# ---------- OPTIONS ------------------------------------------------------------------------------------------
# BBSType   (Optional)  - BBSType for Naming Conventions 1:EngimaBBS, 2:Mystic, 3:Other" Default Engima
# OutputDir (Mandatory) - Full Path - Use Quotes if there is a space
# NumAds    (Optional)  - Number of randomly selected ads. 0 or larger then the ads will just get all of them.
# Overwrite (Optional)  - Overwrite existing files. Default $false. Can set $true or just -Overwrite
#*************************************************************************************************************** 

param (
    [ValidateRange(1, 3)][Int]$BBSType = 1, #Only allow input 1-3 Default 3
    [Parameter(Mandatory = $true)][string]$OutputDir,
    [Int]$NumAds = 0, # Default All files
    [switch]$Overwrite = $false # Overwrite existing files
)

$Ads = Get-ChildItem -File -Filter '*.ans' -Path '..\adverts\' -Recurse
$MaxIndex = $Ads.Count - 1
$SelectedAds = @()

If ($NumAds -gt 0 -and $NumAds -le $Ads.Count) {
    # Get Random Ads based on the amount
    while ($SelectedAds.Count -lt $NumAds) {
        $RndIndex = 0..$MaxIndex  | Get-Random
        if ($SelectedAds -notcontains $Ads[$RndIndex]) {
            $SelectedAds += $Ads[$RndIndex]
        }
    }
    $SelectedAds | ft -AutoSize
}
else {
    $SelectedAds = $Ads #All Ads
}
$ADN = 0
foreach ($Ad in $SelectedAds) {
    $ADN++
    $filename = "default.ans"
    switch ( $BBSType ) {
        1 { $filename = "othrbbs$ADN.ans" } #Enigma
        2 { $filename = "logoff.$ADN.ans"   } #Mystic
        3 { $filename = "bbsad$ADN.ans"   } #Other
     
    }
    write-host "$($Ad.Name) => $filename"
    $FilePath = "$OutputDir\$filename"
    $Ad.CopyTo($FilePath, $Overwrite)
}
