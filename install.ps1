$account = "airtonix"

$repo    = "dotfiles"

$branch  = "master"



$powerShellVersion = $PSVersionTable.PSVersion.Major

$dotNetFullVersion = [version](get-itemproperty -Path "HKLM:\Software\Microsoft\NET Framework Setup\NDP\v4\Full" -ErrorAction SilentlyContinue).Version

$dotNetClientVersion = [version](get-itemproperty -Path "HKLM:\Software\Microsoft\NET Framework Setup\NDP\v4\Client" -ErrorAction SilentlyContinue).Version



$hasSupportedPowershellVersion = (

  ($powerShellVersion -ge 3) -and 

  (

    $dotNetFullVersion -ge [version]"4.5" -or

    $dotNetClientVersion -ge [version]"4.5"

  )

)



if (!$hasSupportedPowershellVersion) {

  write-warning -Message @"

Insuffcient versions of powershell or dotnet available.



   powershell: $powerShellVersion (requires v3+) 

   dot net: $dotNetFullVersion (requires 4.5+)

   dot net client: $dotNetClientVersion (requires 4.5+)

"@

  

  return;

}



function Remove-Directory {

  param (

    [string]$dir

  )

  $exists = [System.IO.Directory]::Exists($dir)



    if ($exists) {

        [System.IO.Directory]::Delete($dir, $true)

    }

}



function Create-Directory {

  param (

    [string]$dir

  )

  $exists = [System.IO.Directory]::Exists($dir)

    if (!$exists) {

        [System.IO.Directory]::CreateDirectory($dir)

    }

}



function Reset-Directory {

  param (

    [string]$dir

  )

    Remove-Directory $dir

    Create-Directory $dir

}





function Download-File {

  param (

    [string]$url,

    [string]$file

  )

  write-host "Downloading $url"

  $filename = split-path $url -Leaf

  $output =  join-path $env:TEMP $repo

  

  Remove-Directory $output



  [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

  invoke-webrequest -UseBasicParsing -Uri $url -OutFile $output 



  $downloaded = join-path $output $filename

  write-host "Dowloaded $downloaded"



  return $downloaded

}



function Unzip-File {

    param (

        [string]$File,

        [string]$Destination = (get-location).Path

    )



    $filePath = resolve-path $File

    $fileHash = get-filehash $filePath

  

    $destinationPath = $ExecutionContext.SessionState.Path.GetUnresolvedProviderPathFromPSPath($Destination)

     

    Reset-Directory $destinationPath



    try {

        [System.Reflection.Assembly]::LoadWithPartialName("System.IO.Compression.FileSystem") | out-null

        [System.IO.Compression.ZipFile]::ExtractToDirectory("$filePath", "$destinationPath")

    } catch {

        write-warning -Message "Unexpected Error. Error details: $_.Exception.Message"

    }

    

    write-host "Moving to $destinationPath"



}



$installDir = join-path $HOME (join-path ".$repo" "$repo-$branch")

$archive = Download-File "https://github.com/$account/$repo/archive/$branch.zip"

Unzip-File $archive $installDir





push-location $installDir

& .\ps\provision\index.ps1

pop-location



