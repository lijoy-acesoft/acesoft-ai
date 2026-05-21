$ErrorActionPreference = 'Stop'

$root = Split-Path -Parent $PSScriptRoot
$sourceDir = Join-Path $root 'images\clientele'
$targetDir = Join-Path $sourceDir 'home'

if (-not (Test-Path $sourceDir)) {
  throw "Missing source directory: $sourceDir"
}

if (-not (Test-Path $targetDir)) {
  New-Item -ItemType Directory -Path $targetDir | Out-Null
}

Add-Type -AssemblyName System.Drawing

function Save-JpegWithQuality {
  param(
    [Parameter(Mandatory = $true)][System.Drawing.Bitmap]$Bitmap,
    [Parameter(Mandatory = $true)][string]$Path,
    [Parameter(Mandatory = $true)][int]$Quality
  )
  $encoder = [System.Drawing.Imaging.ImageCodecInfo]::GetImageEncoders() | Where-Object { $_.MimeType -eq 'image/jpeg' }
  if (-not $encoder) {
    $Bitmap.Save($Path, [System.Drawing.Imaging.ImageFormat]::Jpeg)
    return
  }
  $params = New-Object System.Drawing.Imaging.EncoderParameters(1)
  $params.Param[0] = New-Object System.Drawing.Imaging.EncoderParameter([System.Drawing.Imaging.Encoder]::Quality, [long]$Quality)
  $Bitmap.Save($Path, $encoder, $params)
  $params.Dispose()
}

$maxWidth = 280
$maxHeight = 90
$processed = 0

Get-ChildItem $sourceDir -File | Where-Object { $_.Name -match '^logo-\d+\.(png|jpg|jpeg|webp)$' } | ForEach-Object {
  $src = $_.FullName
  $outName = $_.Name.ToLowerInvariant()
  $dst = Join-Path $targetDir $outName
  $ext = $_.Extension.ToLowerInvariant()

  # Keep existing WebP logo as-is (already efficient and tooling may not decode WebP).
  if ($ext -eq '.webp') {
    Copy-Item $src $dst -Force
    $processed++
    return
  }

  $img = $null
  $bmp = $null
  $g = $null
  try {
    $img = [System.Drawing.Image]::FromFile($src)
    $scale = [Math]::Min([Math]::Min($maxWidth / $img.Width, $maxHeight / $img.Height), 1.0)
    $newW = [Math]::Max([int][Math]::Round($img.Width * $scale), 1)
    $newH = [Math]::Max([int][Math]::Round($img.Height * $scale), 1)

    $bmp = New-Object System.Drawing.Bitmap($newW, $newH)
    $g = [System.Drawing.Graphics]::FromImage($bmp)
    $g.InterpolationMode = [System.Drawing.Drawing2D.InterpolationMode]::HighQualityBicubic
    $g.SmoothingMode = [System.Drawing.Drawing2D.SmoothingMode]::HighQuality
    $g.PixelOffsetMode = [System.Drawing.Drawing2D.PixelOffsetMode]::HighQuality
    $g.CompositingQuality = [System.Drawing.Drawing2D.CompositingQuality]::HighQuality
    $g.DrawImage($img, 0, 0, $newW, $newH)

    if ($ext -eq '.jpg' -or $ext -eq '.jpeg') {
      Save-JpegWithQuality -Bitmap $bmp -Path $dst -Quality 82
    }
    else {
      $bmp.Save($dst, [System.Drawing.Imaging.ImageFormat]::Png)
    }
    $processed++
  }
  finally {
    if ($g) { $g.Dispose() }
    if ($bmp) { $bmp.Dispose() }
    if ($img) { $img.Dispose() }
  }
}

Write-Host "Built $processed home logo variants in images/clientele/home"
