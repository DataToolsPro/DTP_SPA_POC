# PowerShell Script to Create All 13 Jira Tickets for DTP_APP_V3 Setup
# 
# Prerequisites:
# 1. Get your Jira API token: https://id.atlassian.com/manage-api-tokens
# 2. Run this script and enter your credentials when prompted
#
# Usage:
#   .\scripts\create-jira-tickets.ps1

param(
    [string]$JiraEmail = "",
    [string]$JiraApiToken = ""
)

$JiraBaseUrl = "https://goodmangroup.atlassian.net"
$ProjectKey = "MBT"
$IssueType = "Task"
$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$TicketsFile = Join-Path $ScriptDir "tickets.json"

# If credentials not provided, prompt for them
if ([string]::IsNullOrEmpty($JiraEmail)) {
    $JiraEmail = Read-Host "Enter your Jira email (e.g. your@email.com)"
}

if ([string]::IsNullOrEmpty($JiraApiToken)) {
    Write-Host "`nGet your API token from: https://id.atlassian.com/manage-api-tokens" -ForegroundColor Cyan
    $SecureToken = Read-Host "Enter your Jira API token" -AsSecureString
    $JiraApiToken = [Runtime.InteropServices.Marshal]::PtrToStringAuto(
        [Runtime.InteropServices.Marshal]::SecureStringToBSTR($SecureToken)
    )
}

# Base64 encode credentials for Basic Auth
$base64AuthInfo = [Convert]::ToBase64String([Text.Encoding]::ASCII.GetBytes("${JiraEmail}:${JiraApiToken}"))
$headers = @{
    "Authorization" = "Basic $base64AuthInfo"
    "Content-Type" = "application/json"
    "Accept" = "application/json"
}

# Function to create a Jira issue
function Create-JiraIssue {
    param(
        [string]$Summary,
        [string]$Description,
        [string]$Label = ""
    )
    
    # Jira API v3 expects description in ADF (Atlassian Document Format) or plain text
    # Using ADF format for better formatting support
    $descriptionLines = $Description -split "`n"
    $paragraphs = @()
    
    foreach ($line in $descriptionLines) {
        if ($line.Trim() -ne "") {
            $paragraphs += @{
                type = "paragraph"
                content = @(
                    @{
                        type = "text"
                        text = $line
                    }
                )
            }
        }
    }
    
    if ($paragraphs.Count -eq 0) {
        $paragraphs = @(@{
            type = "paragraph"
            content = @(@{
                type = "text"
                text = $Description
            })
        })
    }
    
    $body = @{
        fields = @{
            project = @{
                key = $ProjectKey
            }
            summary = $Summary
            description = @{
                type = "doc"
                version = 1
                content = $paragraphs
            }
            issuetype = @{
                name = $IssueType
            }
        }
    }
    
    if ($Label) {
        $body.fields.labels = @($Label)
    }
    
    $jsonBody = $body | ConvertTo-Json -Depth 10
    
    try {
        $response = Invoke-RestMethod -Uri "${JiraBaseUrl}/rest/api/3/issue" `
            -Method Post `
            -Headers $headers `
            -Body $jsonBody `
            -ErrorAction Stop
        
        Write-Host "✅ Created: $($response.key) - $Summary" -ForegroundColor Green
        return $response.key
    }
    catch {
        Write-Host "❌ Failed to create: $Summary" -ForegroundColor Red
        Write-Host "   Error: $($_.Exception.Message)" -ForegroundColor Red
        if ($_.ErrorDetails.Message) {
            Write-Host "   Details: $($_.ErrorDetails.Message)" -ForegroundColor Red
        }
        return $null
    }
}

# Load tickets from JSON
if (-not (Test-Path $TicketsFile)) {
    Write-Host "❌ Tickets file not found: $TicketsFile" -ForegroundColor Red
    exit 1
}

$ticketsData = Get-Content $TicketsFile | ConvertFrom-Json
$createdTickets = @()

Write-Host "`n🚀 Creating $($ticketsData.tickets.Count) Jira tickets in project MBT...`n" -ForegroundColor Cyan

foreach ($ticket in $ticketsData.tickets) {
    $key = Create-JiraIssue -Summary $ticket.summary -Description $ticket.description -Label $ticket.label
    if ($key) {
        $createdTickets += $key
    }
    Start-Sleep -Milliseconds 500  # Rate limiting
}

# Summary
Write-Host "`n✅ Ticket creation complete!`n" -ForegroundColor Green
Write-Host "View your tickets at: ${JiraBaseUrl}/jira/software/projects/${ProjectKey}/boards/2" -ForegroundColor Cyan
Write-Host "`nCreated $($createdTickets.Count) tickets:" -ForegroundColor Yellow
Write-Host ($createdTickets -join ", ") -ForegroundColor White
