$StatDir='H:\SteamLibrary\steamapps\common\FPSAimTrainer\FPSAimTrainer\stats'
$ArchiveDir=$StatDir + '\Archive'
if(!(test-path $ArchiveDir))
{
    new-item -path $ArchiveDir -ItemType Directory -Force
}
$GameMode='Close Long Strafes Invincible - Challenge - '
$BotName='Close Long Strafes Invincible'
$OutputDir='H:\temp\AimTrakingInfo\'
$OuputFileName='Close Long Strafes Invincible.csv'
$outputFile=$OutputDir+$OuputFileName
$csvStatSheets=Get-ChildItem -Path $StatDir |where-object {$_.Name -like "*$GameMode*"}
$StatData=@()
foreach($csv in $csvStatSheets)
{
    $CSVImport=import-csv $csv.FullName
    $DateParse=($csv.name.split('-'))[2].trim()
    $dataImport=$CSVImport|Where-Object {$_.'Kill #' -match 'LG'}

    foreach($DI in $dataImport)
    {
        $misses=($DI.Timestamp) - ($DI.Bot)
        $Accuracy=$DI.Bot/$DI.Timestamp
        $Accuracy=[math]::Round($Accuracy, 3)
        $dEntry= New-Object psobject
        $dEntry | add-member -MemberType NoteProperty -name 'Weapon' -value $DI.'Kill #'
        $dEntry | add-member -MemberType NoteProperty -name 'Shots' -value $DI.Timestamp
        $dEntry | add-member -MemberType NoteProperty -name 'Hits' -value $DI.Bot
        $dEntry | add-member -MemberType NoteProperty -name 'Misses' -value $Misses
        $dEntry | add-member -MemberType NoteProperty -name 'Accuracy' -value $Accuracy
        $dEntry | add-member -MemberType NoteProperty -name 'Damage Done' -value $DI.Weapon
        $dEntry | add-member -MemberType NoteProperty -name 'Damage Possible' -value $DI.TTK
        $dEntry | add-member -MemberType NoteProperty -name 'Date' -value $DateParse
        $StatData+=$dEntry
    }
    move-Item  -path $csv.FullName -Destination $ArchiveDir
}
$StatData|Export-Csv -NoTypeInformation -Force $outputFile -append


