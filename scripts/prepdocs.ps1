Write-Host "Environment variables set."



rustc --version

python.exe -m pip install --upgrade pip

$pythonCmd = Get-Command python -ErrorAction SilentlyContinue
if (-not $pythonCmd) {
  # fallback to python3 if python not found
  $pythonCmd = Get-Command python3 -ErrorAction SilentlyContinue
}
refreshenv
Write-Host 'Creating python virtual environment "scripts/.venv"'
Start-Process -FilePath ($pythonCmd).Source -ArgumentList "-m venv ./scripts/.venv" -Wait -NoNewWindow

$venvPythonPath = "./scripts/.venv/scripts/python.exe"
if (Test-Path -Path "/usr") {
  # fallback to Linux venv path
  $venvPythonPath = "./scripts/.venv/bin/python"
}

$rgname = Read-host "Enter your resource group name where your terraform infra is deployed"
$rgname
$location = Read-Host "Enter your activate genai resource group location"
$subid = Read-Host "Enter your SubID"

cd C:\Users\demouser\activate-genai\scripts
mkdir genai
cd genai



azd init -t https://github.com/Azure-Samples/azure-search-openai-demo -e activate-genai -s $subid -l $location

$envContent = "AZURE_RESOURCE_GROUP=`"$rgname`""
$envContent1 = "AZURE_LOCATION=`"$location`""
$envContent2 = "AZURE_SUBSCRIPTION_ID=`"$subid`""





# Specify the path to the .env file
$envFilePath = "C:\azure-search-openai-demo\.azure\activegenai\.env"

# Add content to the file
Add-Content -Path $envFilePath -Value $envContent
Add-Content -Path $envFilePath -Value $envContent1
Add-Content -Path $envFilePath -Value $envContent2
Add-Content -Path $envFilePath -Value $envContent3

azd auth login

azd up -e activate-genai


