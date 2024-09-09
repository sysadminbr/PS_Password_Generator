<#
# CITRA IT - EXCELÊNCIA EM TI
# SCRIPT PARA GERAR SENHA SEGURA.
# AUTOR: luciano@citrait.com.br
# DATA: 20/03/2021
# Homologado para executar no Windows 10 ou Server 2012R2+
# EXAMPLO DE USO: Powershell -ExecutionPolicy ByPass -File C:\scripts\PS_Password_Generator.ps1


#>


Function GeneratePassword
{
	Param([Int32] $length=16)
	$ALLOWED_CHARS = @()

	45      | %{ $ALLOWED_CHARS += $_ }  # -
	48..57  | %{ $ALLOWED_CHARS += $_ }  # 0-9
	63..90  | %{ $ALLOWED_CHARS += $_ }  # @?A-Z
	95      | %{ $ALLOWED_CHARS += $_ }  # _
	97..122 | %{ $ALLOWED_CHARS += $_ } # a-z

	$password_bytes = Get-Random -InputObject $ALLOWED_CHARS -Count $length
	$password = [System.Text.Encoding]::Ascii.GetString($password_bytes)
	Return $password
}



#
# Detecting where (path) this script is being invocated
#
$ME_PATH = Split-Path -Parent $MyInvocation.MyCommand.Path



#
# Adding windows gui forms assembly
#
Add-Type -AssemblyName System.Windows.Forms
[System.Windows.Forms.Application]::EnableVisualStyles()


#
# Creating the main form 
#
$form = new-object system.windows.forms.form
$form.Size = New-Object System.Drawing.Size @(400,200)
$form.Text = "Script Gerador de Senhas"
$form.Icon = New-Object System.Drawing.Icon "$ME_PATH\citra.ico"



# Layout
$layout = New-Object System.Windows.Forms.FlowLayoutPanel
$layout.Anchor = [System.Windows.Forms.AnchorStyles]::Top -bor [System.Windows.Forms.AnchorStyles]::Left
$layout.AutoScroll = $False
$layout.AutoSize = $True
$layout.AutoSizeMode = [System.Windows.Forms.AutoSizeMode]::GrowOnly
$layout.BorderStyle = [System.Windows.Forms.BorderStyle]::None
$layout.Dock = [System.Windows.Forms.DockStyle]::Top
$layout.FlowDirection = [System.Windows.Forms.FlowDirection]::LeftToRight
$layout.Location = New-Object System.Drawing.Point @(0,0)
$layout.Margin = New-Object System.Windows.Forms.Padding @(3,3,3,3)
$layout.MaximumSize = New-Object System.Drawing.Size @(0,0)
$layout.MinimumSize = New-Object System.Drawing.Size @(0,0)
$layout.Padding = New-Object System.Windows.Forms.Padding @(10)
$layout.WrapContents = $True


# Label password size
$label_password_size = New-Object System.Windows.Forms.Label
$label_password_size.AutoSize = $True
$label_password_size.Padding = [System.Windows.Forms.Padding] 7
$label_password_size.Text = "Password Size: "



# Password Length input box
$length_box = New-Object System.Windows.Forms.TextBox
$length_box.Size = New-Object System.Drawing.Size @(30,500)
$length_box.Text = 16


# Generate Password Button
$btnGenPassword = New-Object System.Windows.Forms.Button
$btnGenPassword.Text = "Gerar"
$btnGenPassword.Add_Click({
	$output_txtbox.Text = GeneratePassword $length_box.Text
})


# Copy to clipboard button
$btnCopy = New-Object System.Windows.Forms.Button
$btnCopy.Text = "Copiar"
$btnCopy.Add_Click({
	[System.Windows.Forms.Clipboard]::SetText($output_txtbox.Text)
})


# Output textbox
$output_txtbox = New-Object System.Windows.Forms.TextBox
$output_txtbox.ReadOnly = $True
$output_txtbox.WordWrap = $False
$output_txtbox.Width = 300
$output_txtbox.Text = "Generated Password goes here"


#
# Controls adding
#
$layout.Controls.Add($label_password_size)
$layout.Controls.Add($length_box)
$layout.Controls.Add($btnGenPassword)
$layout.Controls.Add($btnCopy)
$layout.Controls.Add($output_txtbox)
$form.Controls.Add($layout)

$form.show()
$btnGenPassword.PerformClick()
While($form.Visible)
{
	[System.Windows.Forms.Application]::DoEvents()
}
# $form.ShowDialog()


