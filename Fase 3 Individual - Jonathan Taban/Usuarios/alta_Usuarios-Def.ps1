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