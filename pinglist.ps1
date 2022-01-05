Param(
  [Parameter(Mandatory=$true, position=0)][string]$csvfile
)
$WarningPreference = "SilentlyContinue"
$ColumnHeader = "IP Address"
$ipaddresses = import-csv $csvfile | select-object $ColumnHeader
$output_filename = ("output_" + $(get-date -f yyyyMMddHHmmss) + ".csv")

Write-Host "Reading file" $csvfile
Write-Host "Started Pinging.."

function check_connectivity {
    foreach( $ip in $ipaddresses) {

        if (test-connection $ip.("IP Address") -count 1 -quiet) {

            $status = Write-output "Active"

        } else {

            $status = Write-output "Inactive"
        }

        [pscustomobject][ordered]@{
        Endpoint_IP  = $ip.("IP Address")
        Status  = $status
        }
    }
}

check_connectivity | Tee-Object -Variable info
Write-Host "Pinging Completed."

$info | export-csv $output_filename -NoTypeInformation