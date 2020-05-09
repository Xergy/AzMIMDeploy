# Azure Shared Image Gallery Sampler (AzSharedImageGallerySampler)

## Overview

This repo contains steps and some simple scripts to get you through an "end to end" deployment of an Azure Shared Image Gallery.  Steps are also included to deploy an image from the SIG with both PowerShell and an ARM template.  **The entire scripted process, from bare metal, takes about 35 minutes - hopefully saving you some time!**

## Process Summary

- Use PowerShell to create a new VM 
- Create a standard image from that VM
- Deploy Shared Image Gallery (SIG)
- Upload standard image to Gallery
- Test deployment of Gallery image using PowerShell and ARM Template

## Detailed Steps

1. Login to Azure

1. Update environment details and execute ```DeployVMForImaging.ps1```. This script creates a simple VM with a new RG, vnet, nic, and nsg, which you will ultimately use to create your first standard VM image (i.e. a non-SIG image).  You need a standard VM image already created, to upload to a Shared Image Gallery (SIG).

   >  This image needs to be in the same region as the SIG!

1. Login to the newly created VM and execute ```sysprep``` from ```%windir%\system32\sysprep```

   > This link was very helpful:  
  https://docs.microsoft.com/en-us/azure/virtual-machines/windows/capture-image-resource

1. Select these options:

    - System Cleanup Action: Enter System Out-of-Box Experience (OOBE) 
    - Generalize: CHECKED!
    - Shutdown Options: Shutdown

1. Click OK, give the VM time to shutdown

   > VM will still show as running in the portal!

1. Update environment details and execute ```CaptureVMImage.ps1```.  Now are you ready to deploy a SIG!

1. Validate your new image looks good in the portal.

1. Update environment details and execute (step by step!) ```DeploySharedImageGallery.ps1```

   > Note, this script uses a slightly different RG name. In addition
   > here's some helpful guidance on ultimately naming your gallery from: https://docs.microsoft.com/en-us/azure/virtual-machines/windows/cli-ps-findimage
   > - **Publisher:** The organization that created the image. Examples: Canonical, MicrosoftWindowsServer  
   > - **Offer:** The name of a group of related images created by a publisher. Examples: UbuntuServer, WindowsServer  
   > - **SKU:** An instance of an offer, such as a major release of a distribution. Examples: 18.04-LTS, 2019-Datacenter  
   > - **Version:** The version number of an image SKU.  

1. Test deployment of a VM from the SIG with PowerShell.  Update environment details and execute ```DeployVMFromSIG.ps1```

   > You will need to update ```$imageVersionId``` from your environment!  It will look something like this:  
   ```/subscriptions/3ba3ebad-7974-4e80-XXXXXXXXX/resourceGroups/acme-dev-eus-sig-rg/providers/Microsoft.Compute/galleries/acmedevsig/images/windows-server-2019-base/versions/1.0.0```

   > **ProTip #56:** The VM deployment RG names contain "sigt" - different from the Gallery RG.  "t" is for VM deployment "testing". VM deployment RG names also include an instance number i.e. "02" or "03".  If you are testing your own variation of these scripts and templates, change the instance number and deploy a whole new RG every deployment test.  It's faster to deploy new, than delete and recreate.  Once you are done testing, clean up all the old RGs at once with ```NukeFromOrbit.ps1```.

1. Test deployment of a VM from the SIG with ARM Template.  Update environment details in ```azuredeploy.parameters.json``` and ```DeployVMFromSIGWithTemplate.ps1``` then execute ```DeployVMFromSIGWithTemplate.ps1```

   > You will need to update ```ImageReferenceId``` in ```azuredeploy.parameters.json```!

   > Be sure to change into the ```DeployVMFromSIGWithTemplate``` directory before running the script!

## Tips and Tricks

- Deploying from an SIG requires a newer api version in your own custom ARM templates.  If you run into the error below update the compute api version.

  This worked:
   ```json
   "type": "Microsoft.Compute/virtualMachines",
   "name": "[variables('vmName')]",
   "apiVersion": "2018-04-01",
   ```
   This failed:
   ```json
   "type": "Microsoft.Compute/virtualMachines",
   "apiVersion": "2016-04-30-preview",
   "name": "[variables('vmName')]",
   ```
   Sample error:

   ```PowerShell
   PS C:\GitRepos\Sandbox\ImageGalleryTesting\Multi-Disk-Deploy> New-AzResourceGroupDeployment -ResourceGroupName $RG -TemplateFile "azuredeploy_workingwithid_ps.json" -TemplateParameterFile "azuredeploy.parametrers.json"
   New-AzResourceGroupDeployment : 9:55:27 AM - Error: Code=InvalidTemplateDeployment; Message=The template deployment 'azuredeploy' is not valid according to the validation
   procedure. The tracking id is 'ef6f1cf2-5ba0-442d-a16a-d2f5eb804e34'. See inner errors for details.
   At line:1 char:1
   + New-AzResourceGroupDeployment -ResourceGroupName $RG -TemplateFile "a ...
   + ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
      + CategoryInfo          : NotSpecified: (:) [New-AzResourceGroupDeployment], Exception
      + FullyQualifiedErrorId : Microsoft.Azure.Commands.ResourceManager.Cmdlets.Implementation.NewAzureResourceGroupDeploymentCmdlet

   New-AzResourceGroupDeployment : 9:55:27 AM - Error: Code=InvalidParameter; Message=Resource 'MyWindowsVM' has invalid parameters. Details: The value of parameter imageReference.id is
   invalid.
   At line:1 char:1
   + New-AzResourceGroupDeployment -ResourceGroupName $RG -TemplateFile "a ...
   + ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
      + CategoryInfo          : NotSpecified: (:) [New-AzResourceGroupDeployment], Exception
      + FullyQualifiedErrorId : Microsoft.Azure.Commands.ResourceManager.Cmdlets.Implementation.NewAzureResourceGroupDeploymentCmdlet

   New-AzResourceGroupDeployment : The deployment validation failed
   At line:1 char:1
   + New-AzResourceGroupDeployment -ResourceGroupName $RG -TemplateFile "a ...
   + ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
      + CategoryInfo          : CloseError: (:) [New-AzResourceGroupDeployment], InvalidOperationException
      + FullyQualifiedErrorId : Microsoft.Azure.Commands.ResourceManager.Cmdlets.Implementation.NewAzureResourceGroupDeploymentCmdlet
    ```

## Known Issues and Update Ideas...

- It would be nice to be able to execute Sysprep via the Azure Script Extension
- Create new script to script to add additional regions

## Next Steps

- Add an additional replica in a new region for your image version.  Deploy a VM to that region. 






