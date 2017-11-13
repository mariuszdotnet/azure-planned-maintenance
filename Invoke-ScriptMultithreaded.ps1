Function Invoke-ScriptMultithreaded{ 
    [cmdletbinding()] 
    param(   
      [Parameter(Mandatory=$true,ValueFromPipeline=$false)] 
      [String]$Script, 
      [Parameter(Mandatory=$false,ValueFromPipeline=$false)] 
      [String[]]$Arguments, 
      [Parameter(Mandatory=$true,ValueFromPipeline=$true)] 
      [Object[]]$Array 
      ) 
      BEGIN{ 
      If($Arguments -eq $NULL){$Arguments = @()} 
      $a = $Arguments   # This is to make the script more readable 
       } # end BEGIN 
       
      PROCESS{ 
          Foreach($Element in $Array){ 
              try{ 
              Start-Job -name $Element -FilePath $Script -ArgumentList $Element, $a[0], $a[1], $a[2], $a[3], $a[4], $a[5], $a[6], $a[7], $a[8], $a[9], $a[10], $a[11], $a[12], $a[13], $a[14], $a[15], $a[16], $a[17], $a[18], $a[19], $a[20] 
              } #end try 
              catch{ 
              $Exception = $error[0] 
              $FunctionError =    "`r`n" + "Function:"  + "`t"   + "Invoke-ScriptMultithreaded " +  
                                  "`r`n" + "Script:"    + "`t`t" + $Script +  
                                  "`r`n" + "Element:"   + "`t`t" + $Element +  
                                  "`r`n" + "Arguments:" + "`t"   + $Arguments +  
                                  "`r`n" + "Error:"     + "`t`t" + $Exception 
              Write-EventLog -LogName "Windows PowerShell" -Source "PowerShell" -EventId 100 -Message $FunctionError -EntryType Error 
              }#end catch 
          }#end Foreach 
      } #end PROCESS 
       
      END { 
    } #end END 
}# end Function



$aVMsName = "" # "myvm1", "myvm2", "myvm3"
$rgName = "" # "test-rg"
Invoke-ScriptMultithreaded ".\runMaintenance.ps1"  -Array $aVMsName -Arguments $rgName