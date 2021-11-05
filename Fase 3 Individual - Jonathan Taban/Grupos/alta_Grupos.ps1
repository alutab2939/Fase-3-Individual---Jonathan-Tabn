$gruposCsv=Read-Host "Introduce el fichero csv de Grupos:"
$fichero = import-csv -Path $gruposCsv -delimiter :
foreach($linea in $fichero)

{
	New-ADGroup -Name:$linea.Name -Description:$linea.Description -GroupCategory:$linea.Category -GroupScope:$linea.Scope -Path:$linea.Path
}