$ficheroCsvUO=Read-Host "Introduce el fichero csv de UO's:"
 $fichero = import-csv -Path $ficheroCsvUO -delimiter :
 foreach($line in $fichero)
{
   New-ADOrganizationalUnit -Description:$line.Descripcion -Name:$line.Nombre -Path:$line.Path -ProtectedFromAccidentalDeletion:$true
}