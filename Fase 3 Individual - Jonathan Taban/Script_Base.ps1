function Crear_UOs
{ 
                $ficheroCsvUO=Read-Host "Introduce el fichero csv de UO's:"
 $fichero = import-csv -Path $ficheroCsvUO -delimiter :
 foreach($line in $fichero)
{
   New-ADOrganizationalUnit -Description:$line.Descripcion -Name:$line.Nombre -Path:$line.Path -ProtectedFromAccidentalDeletion:$true
}
}

function Crear_Grupos
{
$gruposCsv=Read-Host "Introduce el fichero csv de Grupos:"
$fichero = import-csv -Path $gruposCsv -delimiter :
foreach($linea in $fichero)

{
	New-ADGroup -Name:$linea.Name -Description:$linea.Description -GroupCategory:$linea.Category -GroupScope:$linea.Scope -Path:$linea.Path
}
}

function Crear_Usuarios
{
$fichero_csv=Read-Host "Introduce el fichero csv de los usuarios:"
                $fichero_csv_importado = import-csv -Path $fichero_csv -Delimiter : 			     
                foreach($line in $fichero_csv_importado)
{
		    $path="DC=vera,DC=upv,DC=es"
  	            $containerPath=$line.Path
  	            $passAccount=ConvertTo-SecureString $line.Dni -AsPlainText -force
	            $name=$line.Name
	            $nameShort=$line.Name
	            $Surnames=$line.Surname
	            $nameLarge=$line.Name+'.'+$line.Surname1+'.'+$line.Surname2
	            $computerAccount=$line.Computer
	            $email=$line.email
                
	  
	            if (Get-ADUser -filter { name -eq $nameShort })
                {
                        $nameShort=$line.Surname
                }
	
	            [boolean]$Habilitado=$true
  	            If($line.Hability -Match 'false') {$Habilitado=$false}
  	            $ExpirationAccount = $line.DaysAccountExpire
 	            $timeExp = (get-date).AddDays($ExpirationAccount)
	
	            New-ADUser `
    		        -SamAccountName $nameShort `
   	 	            -UserPrincipalName $nameShort `
    		        -Name $nameShort `
		            -Surname $Surnames `
    		        -DisplayName $nameShort `
    		        -GivenName $line.Name `
    		        -LogonWorkstations:$line.Computer `
		            -Description "Cuenta de $nameLarge" `
    		        -EmailAddress $email `
		            -AccountPassword $passAccount `
    		        -Enabled $Habilitado `
		            -CannotChangePassword $false `
    		        -ChangePasswordAtLogon $true `
		            -PasswordNotRequired $false `
    		        -Path $containerPath `
    		        -AccountExpirationDate $timeExp
		    
		        Add-ADGroupMember -Identity $line.Departament -Members $nameShort
}
}

function Crear_Equipos
{
$equiposCsv=Read-Host "Introduce el fichero csv de Equipos:"
$fichero= import-csv -Path $equiposCsv -delimiter ":"

foreach($line in $fichero)
	{
		New-ADComputer -Enabled:$true -Name:$line.Computer -Path:$line.Path -SamAccountName:$line.Computer
	}

write-Host ""
write-Host "Se han creado los equipos" -Fore green
write-Host "" 
}
#----------------Funcion Submenu  -------------#
function mostrar_Submenu
{
     param (
           [string]$Titulo = 'Submenu.....'
     )
     Clear-Host 
     Write-Host "================ $Titulo ================"
    
     Write-Host "1: Opción 1."
     Write-Host "2: Opción 2."
     Write-Host "s: Volver al menu principal."
do
{
     $input = Read-Host "Por favor, pulse una opcion"
     switch ($input)
     {
           '1' {
                'Opcion 1'
                return
           } '2' {
                'Opcion 2'
                return
           } 
     }
}
until ($input -eq 'q')
}



#Función que nos muestra un menú por pantalla con 3 opciones, donde una de ellas es para acceder
# a un submenú) y una última para salir del mismo.

function mostrarMenu 
{ 
     param ( 
           [string]$Titulo = 'Selección de opciones' 
     ) 
     Clear-Host 
     Write-Host "================ $Titulo================" 
      
     
     Write-Host "1. Crear estructura logica" 
     Write-Host "2. Eliminar estructura lógica" 
     Write-Host "3. Submneu" 
     Write-Host "s. Presiona 's' para salir" 
}

do 
{ 
     mostrarMenu 
     $input = Read-Host "Elegir una Opción" 
     switch ($input) 
     { 
           '1' { 
		Clear-Host  
                Crear_UOs
		Crear_Grupos
		Crear_Usuarios
		Crear_Equipos
                pause
               
           } '2' { 
                Clear-Host  
                Set-ADOrganizationalUnit -Identity "OU=DepartamentosVERA,DC=vera,DC=upv,DC=es" -ProtectedFromAccidentalDeletion $false
		Remove-ADOrganizationalUnit -Identity "OU=DepartamentosVERA,DC=vera,DC=upv,DC=es" -Recursive
                pause
           } '3' {  
                mostrar_Submenu      
           } 's' {
                'Saliendo del script...'
                return 
           }  
     } 
     pause 
} 
until ($input -eq 's')
