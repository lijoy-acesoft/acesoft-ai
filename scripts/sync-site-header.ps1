# Sync page reveal + sticky header across all HTML pages
$ErrorActionPreference = 'Stop'
$root = Split-Path -Parent $PSScriptRoot
$utf8 = New-Object System.Text.UTF8Encoding $false

$oldPreloaderBlock = @'
    window.addEventListener("load", function () {
      var preloader = document.getElementById("preloader");
      var container = document.getElementById("container-preloader");
      if (!preloader || !container) return;
      container.classList.add("loaded");
      window.setTimeout(function () { preloader.style.display = "none"; }, 1100);
    });
'@

$oldPreloaderBlockTabs = $oldPreloaderBlock -replace '    ', "`t"

$oldIndexBlock = @'
		window.addEventListener("load", function () {
			var preloader = document.getElementById("preloader");
			var container = document.getElementById("container-preloader");
			if (!preloader || !container) return;
			document.documentElement.classList.add("loaded");
			container.classList.add("loaded");
			window.setTimeout(function () {
				preloader.style.display = "none";
			}, 1100);
		});
'@

$pageReadyTag = '  <script defer src="js/page-ready.js"></script>'
$visibilityOld = 'html:not(.loaded) .page-wrapper{visibility:hidden}'
$visibilityNew = 'html:has(#preloader):not(.loaded) .page-wrapper{visibility:hidden}'

$skip = @('footer.html')
$count = 0

Get-ChildItem $root -Filter '*.html' -File | ForEach-Object {
  if ($skip -contains $_.Name) { return }
  $c = [System.IO.File]::ReadAllText($_.FullName, $utf8)
  $orig = $c

  $c = $c.Replace($visibilityOld, $visibilityNew)

  if ($c.Contains($oldPreloaderBlock)) {
    $c = $c.Replace($oldPreloaderBlock, '')
  }
  if ($c.Contains($oldPreloaderBlockTabs)) {
    $c = $c.Replace($oldPreloaderBlockTabs, '')
  }
  if ($c.Contains($oldIndexBlock)) {
    $c = $c.Replace($oldIndexBlock, '')
  }

  if ($c -notmatch 'js/page-ready\.js') {
    if ($c -match '(<script[^>]+src="js/jquery\.js"[^>]*>)') {
      $c = $c -replace '(<script[^>]+src="js/jquery\.js"[^>]*>)', "$pageReadyTag`n`$1"
    }
    elseif ($c -match '(</body>)') {
      $c = $c -replace '(</body>)', "$pageReadyTag`n`$1"
    }
  }

  if ($c -ne $orig) {
    [System.IO.File]::WriteAllText($_.FullName, $c, $utf8)
    $count++
    Write-Host "Synced: $($_.Name)"
  }
}

Write-Host "Updated $count HTML file(s). Run: npm run perf:css"
