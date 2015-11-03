#Create Variables for total automation
$rootUser = "root"
$rootPWord = ConvertTo-SecureString –String "root" –AsPlainText -Force
$rootCredential = New-Object –TypeName System.Management.Automation.PSCredential –ArgumentList $rootUser, $rootPWord

#Start VM
start-VMX -Path "C:\Users\thomanat\Documents\Virtual Machines\ESD_Node\ESD_Node.vmx"

#Wait for VM to start
start-sleep -s 60

#Pass command to start daemon
New-SSHSession -ComputerName '192.168.253.128' -Credential (Get-Credential $rootCredential)
Invoke-SSHCommand -Index 0 -command "esd"

#Start remaining VMs
Start-VMX -Path "C:\Users\thomanat\Documents\Virtual Machines\Sim_Node_0\Sim_Node_0.vmx"
Start-VMX -Path "C:\Users\thomanat\Documents\Virtual Machines\Sim_Node_1\Sim_Node_1.vmx"
