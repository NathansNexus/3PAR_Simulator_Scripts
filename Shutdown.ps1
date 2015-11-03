#Set Root Variable
$rootUser = "root"
$rootPWord = ConvertTo-SecureString –String "root" –AsPlainText -Force
$rootCred = New-Object –TypeName System.Management.Automation.PSCredential –ArgumentList $rootUser, $rootPWord

#Set 3Par Variable
$3parUser = "3paradm"
$3parPWord = ConvertTo-SecureString –String "3pardata" –AsPlainText -Force
$3parCred = New-Object –TypeName System.Management.Automation.PSCredential –ArgumentList $3parUser, $3parPWord

#Pass Shutdown command to 3PAR Nodes
New-SSHSession -ComputerName '192.168.253.2' -Credential (Get-Credential $3parCred)
$session = Get-SSHSession -Index 0
$stream = $session.Session.CreateShellStream("dumb", 0, 0, 0, 0, 1000)
$stream.Write("shutdownsys halt")
$stream.Read()
$stream.Write("yes")

#Wait for them to shutdown
Start-Sleep -s 75

#Stop VMs
get-vmx -Path "C:\Users\thomanat\Documents\Virtual Machines\Sim_Node_0\Sim_Node_0.vmx"| stop-vmx
get-vmx -Path "C:\Users\thomanat\Documents\Virtual Machines\Sim_Node_1\Sim_Node_1.vmx"| stop-vmx

#SSH to Controller node and shutdown
New-SSHSession -ComputerName '192.168.253.128' -Credential (Get-Credential $rootCred)
Invoke-SSHCommand -Index 1 -command "esd stop; shutdown -h 0"
