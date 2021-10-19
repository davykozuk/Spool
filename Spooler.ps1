
Add-Type -AssemblyName PresentationCore, PresentationFramework
$Xaml = @"
<Window xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation" Title="SpoolerIMP" Height="300" Width="319">
    <Grid>
        <TextBox HorizontalAlignment="Left" Margin="10,18,0,0" Text="Poste" TextWrapping="Wrap" VerticalAlignment="Top" Width="120" Name="TPoste"/>
        <TextBlock HorizontalAlignment="Left" Margin="224,19,0,0" Text="Etat" TextWrapping="Wrap" VerticalAlignment="Top" Width="83" Name="TEtat"/>
        <Button Content="STOP" HorizontalAlignment="Left" Margin="20,61,0,0" VerticalAlignment="Top" Width="51" Name="BStop"/>
        <Button Content="START" HorizontalAlignment="Center" Margin="0,61,0,0" VerticalAlignment="Top" Width="51" Name="BStart"/>
        <Button Content="RESTART" HorizontalAlignment="Right" Margin="185,61,20,0" VerticalAlignment="Top" Name="BRestart"/>
        <Button Content="OK" HorizontalAlignment="Left" Margin="135,17,0,0" VerticalAlignment="Top" Name="BOk"/>
        <Rectangle HorizontalAlignment="Center" Height="198" Margin="0,86,0,0" Stroke="Black" VerticalAlignment="Top" Width="319">
        <Rectangle.Fill>
        <ImageBrush ImageSource="C:\Users\Davy\Documents\PowerShell\brother.jpg"/>
        </Rectangle.Fill>
</Rectangle>
</Grid>
</Window>
"@

#-------------------------------------------------------------#
#----Control Event Handlers-----------------------------------#
#-------------------------------------------------------------#

function FOk(){
$Poste=$TPoste.Text
$Service=Get-Service -ComputerName $Poste | where {$_.Name -like "*spooler*"}
if ($Service.Status -eq "Running")
{$TEtat.Background="#FF37C73D"
 $TEtat.Text="Démarré"}
else{
    $TEtat.Background="#FFCF2626"
    $TEtat.Text="Arreté"}
}
function FStart(){
$Poste=$TPoste.Text
Write-Host "Demarrage du service"
$Service=Get-Service -ComputerName $Poste | where {$_.Name -like "*spooler*"}
Start-Service $Service
if ($Service.Status -eq "Running")
{$TEtat.Background="#FF37C73D"
 $TEtat.Text="Démarré"}
else{
    $TEtat.Background="#FFCF2626"
    $TEtat.Text="Arreté"}
}
function FStop(){
$Poste=$TPoste.Text
Write-Host "Arret du service"
$Service=Get-Service -ComputerName $Poste | where {$_.Name -like "*spooler*"}
Stop-Service $Service
if ($Service.Status -eq "Running")
{$TEtat.Background="#FF37C73D"
 $TEtat.Text="Démarré"}
else{
    $TEtat.Background="#FFCF2626"
    $TEtat.Text="Arreté"}
    }
function FRestart(){
$Poste=$TPoste.Text
Write-Host "Redemarrage du service"
$Service=Get-Service -ComputerName $Poste | where {$_.Name -like "*spooler*"}
restart-Service $Service
if ($Service.Status -eq "Running")
{$TEtat.Background="#FF37C73D"
 $TEtat.Text="Démarré"}
else{
    $TEtat.Background="#FFCF2626"
    $TEtat.Text="Arreté"}
    }



#endregion

#-------------------------------------------------------------#
#----Script Execution-----------------------------------------#
#-------------------------------------------------------------#

$Window = [Windows.Markup.XamlReader]::Parse($Xaml)

[xml]$xml = $Xaml

$xml.SelectNodes("//*[@Name]") | ForEach-Object { Set-Variable -Name $_.Name -Value $Window.FindName($_.Name) }

#VERT
#$TEtat.Background="#FF37C73D"
#ROUGE
#$TEtat.Background="#FFCF2626"
$BStop.Add_Click({FStop $this $_})
$BStart.Add_Click({FStart $this $_})
$BRestart.Add_Click({FRestart $this $_})
$BOk.Add_Click({FOk $this $_})


[void]$Window.ShowDialog()

