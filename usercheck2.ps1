cls
$domains = @("corp", "csgiutil", "prod")

$allcreds = foreach ($Domain in $domains)
{
    $cred = Get-Credential $Domain

    $obj = New-Object PSObject
    Add-Member -InputObject $obj -MemberType NoteProperty -Name Domain -Value $Domain
    $obj | Add-Member -MemberType NoteProperty -Name Cred -Value $cred

    $Obj
}

$list = Get-Content 'C:\Sujin Data\Powershell\scripts\test.txt'

$check = {
    try {
        $bldusr = {get-localuser | where-object { $_.name -like "*test1*"}}
        if ($bldusr)
        {
            Return $true
        }
        else
        {
            Return $false
        }
    }
    catch
    {
        Return $false
    }
}

$out = Invoke-Command -ComputerName localhost -ScriptBlock $check

if ($out -eq $true)
{

foreach ($computer in $list)
{
    $dname = $computer.Split(".")[1]
    $mycred = ($allcreds | Where-Object {$_.Domain -eq $dname}).cred

    Invoke-Command -ScriptBlock $check -Credential $mycred -ComputerName $computer
}
}