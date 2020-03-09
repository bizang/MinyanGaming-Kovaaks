$StatDir='H:\SteamLibrary\steamapps\common\FPSAimTrainer\FPSAimTrainer\stats'
$ArchiveDir=$StatDir + '\Archive'
if(!(test-path $ArchiveDir))
{
    new-item -path $ArchiveDir -ItemType Directory -Force
}
$GameMode='Cata IC Long Strafes - Challenge - '
$BotName='Quaker Bot Long Strafes'
$OutputDir='H:\temp\AimTrakingInfo\'
$OuputFileName='Cata IC Long Strafes.csv'
$outputFile=$OutputDir+$OuputFileName
$csvStatSheets=Get-ChildItem -Path $StatDir |where-object {$_.Name -like "*$GameMode*"}
$StatData=@()
foreach($csv in $csvStatSheets)
{
    $CSVImport=import-csv $csv.FullName
    $DateParse=($csv.name.split('-'))[2].trim()
    $dataImport=$CSVImport|Where-Object {$_.Bot -match $BotName}
    foreach($DI in $dataImport)
    {
        $dEntry= New-Object psobject
        $dEntry | add-member -MemberType NoteProperty -name 'Kill #' -value $DI.'Kill #'
        $dEntry | add-member -MemberType NoteProperty -name 'Timestamp' -value $DI.Timestamp
        $dEntry | add-member -MemberType NoteProperty -name 'Date' -value $DateParse
        $dEntry | add-member -MemberType NoteProperty -name 'Bot' -value $DI.Bot
        $dEntry | add-member -MemberType NoteProperty -name 'Weapon' -value $DI.Weapon
        $dEntry | add-member -MemberType NoteProperty -name 'TTK' -value ($DI.TTK).replace("s","")
        $dEntry | add-member -MemberType NoteProperty -name 'Shots' -value $DI.Shots
        $dEntry | add-member -MemberType NoteProperty -name 'Hits' -value $DI.Hits
        $dEntry | add-member -MemberType NoteProperty -name 'Accuracy' -value $DI.Accuracy
        $dEntry | add-member -MemberType NoteProperty -name 'Damage Done' -value $DI.'Damage Done'
        $dEntry | add-member -MemberType NoteProperty -name 'Damage Possible' -value $DI.'Damage Possible'
        $dEntry | add-member -MemberType NoteProperty -name 'Efficiency' -value $DI.Efficiency
        $dEntry | add-member -MemberType NoteProperty -name 'Cheated' -value $DI.Cheated
        $StatData+=$dEntry
    }
    move-Item  -path $csv.FullName -Destination $ArchiveDir
}
$StatData|Export-Csv -NoTypeInformation -Force $outputFile -Append


