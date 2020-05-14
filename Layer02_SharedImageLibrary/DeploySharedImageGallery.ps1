$SigConfigs = Import-Csv -Path ..\Naming.csv | where-object {$_.Type -eq "sig"} | out-gridview -Title "Choose SIGs to Deploy:" -OutputMode Multiple
Set-Item Env:\SuppressAzurePowerShellBreakingChangeWarnings "true"

Foreach ($SigConfig in $SigConfigs) {
   $Params = $SigConfig.Params | ConvertFrom-Json
   $RGName = $SigConfig.ResourceGroupName
   $Location = $SigConfig.Location

   $resourceGroup = Get-AzResourceGroup -Name $RGName 

   $GalleryName = $SigConfig.Name # 'acmedevsig'

   New-AzGallery `
      -GalleryName $GalleryName `
      -ResourceGroupName $resourceGroup.ResourceGroupName `
      -Location $Location `
      -Description 'Shared Image Gallery'	

   $gallery = Get-AzGallery -Name $GalleryName

   $GallaryImageName = 'windows-server-2019-base' 

   New-AzGalleryImageDefinition `
      -GalleryName $gallery.Name `
      -ResourceGroupName $resourceGroup.ResourceGroupName `
      -Location $gallery.Location `
      -Name $GallaryImageName `
      -OsState generalized `
      -OsType Windows `
      -Publisher 'el' `
      -Offer 'baseoffer' `
      -Sku 'windowsserver2019'

   $galleryImage = Get-AzGalleryImageDefinition -Name $GallaryImageName -ResourceGroupName $resourceGroup.ResourceGroupName -GalleryName $gallery.Name

   $region1 = @{Name='usgovvirginia';ReplicaCount=1}
   $region2 = @{Name='usgovtexas';ReplicaCount=1}
   $region3 = @{Name='usgovarizona';ReplicaCount=1}
   #$targetRegions = @($region1,$region2)
   $targetRegions = @($region1,$region2,$region3)

   $GalleryImageVersionName = '1.0.1' 

   $managedImage = Get-AzImage `
      -ImageName $Params.ManagedImageName `
      -ResourceGroupName $Params.ManagedImageRG
   # Sample image name "windows-server-2019-base" 

   New-AzGalleryImageVersion `
      -GalleryImageDefinitionName $galleryImage.Name `
      -GalleryImageVersionName $GalleryImageVersionName `
      -GalleryName $gallery.Name `
      -ResourceGroupName $resourceGroup.ResourceGroupName `
      -Location $Location `
      -TargetRegion $targetRegions  `
      -Source $managedImage.Id.ToString() `
      -PublishingProfileEndOfLifeDate '2030-01-01' `
      
   $imageVersion = get-azGalleryImageVersion -Name $GalleryImageVersionName -ResourceGroupName $resourceGroup.ResourceGroupName -GalleryName $gallery.Name -GalleryImageDefinitionName $galleryImage.Name

} #SigConfigs
