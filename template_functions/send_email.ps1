function Send-Email {
	[CmdletBinding()]
	param (
		[Parameter(Mandatory = $true)]
		[string[]]$Destination,

		[Parameter(Mandatory = $true)]
		[string]$Subject,

		[Parameter(Mandatory = $true)]
		[string]$HTMLBody,

		[string[]]$CC,
		[string[]]$BCC,
		[string]$TextBody,
		[string[]]$AttachmentList,
		[PSCredential]$Credential
	)

	# Ensure Send-MailKitMessage module is available
	if (-not (Get-Module -ListAvailable -Name Send-MailKitMessage)) {
		Install-Module -Name Send-MailKitMessage -Force
	}

	# Important if the certificate is self-signed or causing problems.
	if ($false -eq [System.Convert]::ToBoolean($Env:SMTP_VALIDATE_CERTIFICATE)) {
		[System.Net.ServicePointManager]::ServerCertificateValidationCallback = { $true }
	}

	Send-MailKitMessage -SMTPServer ([string]$Env:SMTP_SERVER) `
		-Port ([int]$Env:SMTP_PORT) `
		-From ([string]$Env:SMTP_FROM) `
		-RecipientList $Destination `
		-CCList $CC `
		-BCCList $BCC `
		-Subject $Subject `
		-TextBody $TextBody `
		-HTMLBody $HTMLBody `
		-AttachmentList $AttachmentList `
		-Credential $Credential `
		-UseSecureConnectionIfAvailable
}
