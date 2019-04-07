$c = Get-Credential -UserName "Terraform" -Message "Please provide the ClientSecret"
$env:TF_VAR_client_secret = [Runtime.InteropServices.Marshal]::PtrToStringAuto(
    [Runtime.InteropServices.Marshal]::SecureStringToBSTR($c.Password))
