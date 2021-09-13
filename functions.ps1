$global:started = $FALSE
$global:startingStep = $Step

function Should-Run-Step([string] $prospectStep) 
{
    if ($global:startingStep -eq $prospectStep -or $global:started) {
        $global:started = $TRUE
    }
    return $global:started
}

$global:RegRunKey ="HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Run"
function Restart-And-Run([string] $key, [string] $run) 
{
    Set-Key $global:RegRunKey $key $run
    Restart-Computer
    exit
}

$global:restartKey = "Restart-And-Resume"
function Clear-Any-Restart([string] $key=$global:restartKey) 
{
    if (Test-Key $global:RegRunKey $key) {
        Remove-Key $global:RegRunKey $key
    }
}

$global:powershell = (Join-Path $env:windir "system32\WindowsPowerShell\v1.0\powershell.exe")
function Restart-And-Resume([string] $script, [string] $step) 
{
    Restart-And-Run $global:restartKey "$global:powershell $script -Step $step"
}

function Test-Key([string] $path, [string] $key)
{
    return ((Test-Path $path) -and ((Get-Key $path $key) -ne $null))   
}

function Remove-Key([string] $path, [string] $key)
{
    Remove-ItemProperty -path $path -name $key
}

function Set-Key([string] $path, [string] $key, [string] $value) 
{
    Set-ItemProperty -path $path -name $key -value $value
}

function Get-Key([string] $path, [string] $key) 
{
    return (Get-ItemProperty $path).$key
}
