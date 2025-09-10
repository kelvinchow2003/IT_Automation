# Define adapter name
$adapterName = "Ethernet"

# Disable IPv6
Disable-NetAdapterBinding -Name $adapterName -ComponentID ms_tcpip6

# Set static IP address
New-NetIPAddress -InterfaceAlias $adapterName -IPAddress "192.168.99.220" -PrefixLength 24 -DefaultGateway "192.168.99.1"

# Set DNS servers
Set-DnsClientServerAddress -InterfaceAlias $adapterName -ServerAddresses ("192.168.80.19", "192.168.80.29")


# Confirm changes
Get-NetIPAddress -InterfaceAlias $adapterName
Get-DnsClientServerAddress -InterfaceAlias $adapterName