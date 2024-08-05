param(
    [parameter(Mandatory=$true)]
    [String]$awsaccesssecret,
    [parameter(Mandatory=$true)]
    [String]$awsaccesskeyid
    [bool]$isCleanup = $false
)

#This is supposed to push the credentials into the build host
$homeDir="$HOME/.aws"
$credentialfileName = "credentials"
$credentialfilebackup ="credentials_bckp"
$credentialfile ="$HOME/.aws/$credentialfileName"
$credentialbckpfile ="$HOME/.aws/$credentialfilebackup"


if($isCleanup)
{
    if(Test-Path -Path $credentialbckpfile -PathType Leaf)
    {
        Remove-Item -Path $credentialfile -Force

        Rename-Item -Path $credentialbckpfile -NewName $credentialfileName
    }
}
else
{
    if(Test-Path -Path $credentialfile -PathType Leaf)
    {
        if(Test-Path -Path $credentialfile -PathType Container)
        {
            Remove-Item -LiteralPath $credentialfilebackup -Force -Recurse
        }
        Rename-Item -Path $credentialfile -NewName $credentialfilebackup
    }

    if(-Not(Test-Path -Path $homeDir -PathType Container))
    {
        New-Item $homeDir -ItemType Directory
    }

    New-Item $credentialfile

    $credentialfilecontent="[$env:TF_VAR_profilename]" + [Environment]::NewLine + "aws_access_key_id = $awsaccesskeyid" + [Environment]::NewLine + "aws_secret_access_key = $awsaccesssecret"

    Set-Content $credentialfile $credentialfilecontent
}
