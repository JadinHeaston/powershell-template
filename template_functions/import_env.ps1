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
			$value = $matches[2].Trim()

			# Remove surrounding quotes if present
			if ($value -match '^"(.*)"$' -or $value -match "^'(.*)'$") {
				$value = $matches[1]
			}

			# Attempt to convert to appropriate type
			switch -Regex ($value) {
				'^true$' { $typedValue = $true; break }
				'^false$' { $typedValue = $false; break }
				'^-?\d+$' { $typedValue = [int]$value; break }
				'^-?\d+\.\d+$' { $typedValue = [double]$value; break }
				default { $typedValue = $value }
			}

			# Store the string representation in the environment variable
			[System.Environment]::SetEnvironmentVariable($key, "$typedValue", 'Process')

			Write-Verbose "Set $key = $typedValue"
		}
		else {
			if ($Debug) {
				Write-Warning "Skipping invalid line: $line"
			}
		}
	}
}
