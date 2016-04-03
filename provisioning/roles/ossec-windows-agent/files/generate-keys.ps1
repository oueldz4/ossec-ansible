#File to generate keys 

$i = nb_agents

for ($i=1; $i -le 10; $i++)
{
	$str = Get-Random
	$md5 = New-Object -TypeName System.Security.Cryptography.MD5CryptoServiceProvider
	$utf8 = New-Object -TypeName System.Text.UTF8Encoding
	$hash = [System.BitConverter]::ToString($md5.ComputeHash($utf8.GetBytes($str)))
	$hash = $hash -replace "-",''
	Write-Host "$i linux_agent$i any $hash$hash" | Out-File clients$i.key
}