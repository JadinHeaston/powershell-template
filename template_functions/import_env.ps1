# Template Functions
function Import-Env {
	# Print Environment Variables: Get-ChildItem env:
		
	[CmdletBinding()]
	param (
		[string]$Path = "$PSScriptRoot\.env"
	)

	if (-Not (Test-Path $Path)) {
		Write-Warning "The .env file was not found at path: $Path"
		return
	}
	else {
		Write-Verbose "Loading .env: $Path"
	}

	$lines = Get-Content -Path $Path

	foreach ($line in $lines) {
		$trimmed = $line.Trim()

		# Skip empty lines and comments
		if ([string]::IsNullOrWhiteSpace($trimmed) -or $trimmed.StartsWith('#')) {
			continue
		}

		# Match KEY=VALUE format
		if ($trimmed -match '^\s*([^=]+?)\s*=\s*(.*)$') {
			$key = $matches[1].Trim()
			$value = $matches[2].Trim(' "')

			# Set environment variable for current session
			[System.Environment]::SetEnvironmentVariable($key, $value, 'Process')
			Write-Verbose "Set $key"
		}
		else {
			if ($Debug) {
				Write-Warning "Skipping invalid line: $line"
			}
		}
	}
}
