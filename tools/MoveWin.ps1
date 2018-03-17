*************************************************************************************************************** 
# MoveWin.ps1
# -------------------------------------------------------------------------------------------------------------
#  Generates a set of ANSI adverts for display when logging off a BBS.
# -----------------------------------------------------------
# Usage > .\MoveWin.ps1 -BBSType 1 -OutputDir D:\MyBBSFolder\Art -NumAds 5 -Overwrite
# -------------------------------------------------------------------------------------------------------------
# --------- OPTIONS --------------------------
# BBSType 1:EngimaBBS, 2:Mystic, 3:Other"
# OutputDir Full Path - Use Quotes if there is a space
# NumAds (Optional) - Number of randomly selected ads. 0 or larger then the ads will just get all of them.
# Overwrite - Overwrite existing files. Default $false. Can set $true or just -Overwrite
#*************************************************************************************************************** 

param (
   
    [parameter(Mandatory = $true)]
    [ValidateRange(1, 3)] #Only allow 1-3 for now. 
    [int] $BBSType,

    [Parameter(Mandatory = $true)][string]$OutputDir,
    [Int]$NumAds = "0", # Default All files
    [switch]$Overwrite = $false # Overwrite existing files
   
)

if (-not($BBSType)) { Throw "You must supply a value for -BBSType. 1:EngimaBBS, 2:Mystic, 3:Other" }
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
        2 { $filename = "logoff.an$ADN"   } #Mystic
        3 { $filename = "bbsad$ADN.ans"   } #Other
     
    }
    write-host "$($Ad.Name) => $filename"
    $FilePath = "$OutputDir\$filename"
    $Ad.CopyTo($FilePath, $Overwrite)
}