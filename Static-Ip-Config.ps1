# Define adapter name
$adapterName = "Ethernet"

# Disable IPv6
Disable-NetAdapterBinding -Name $adapterName -ComponentID ms_tcpip6

# Set static IP address
New-NetIPAddress -InterfaceAlias $adapterName -IPAddress "123.123.123.123" -PrefixLength 24 -DefaultGateway "123.123.123.123"

# Set DNS servers
Set-DnsClientServerAddress -InterfaceAlias $adapterName -ServerAddresses ("123.123.123.123", "123.123.123.123")



# Confirm changes
Get-NetIPAddress -InterfaceAlias $adapterName
Get-DnsClientServerAddress -InterfaceAlias $adapterName
