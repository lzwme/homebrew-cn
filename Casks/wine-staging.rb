cask "wine-staging" do
  version "8.3"
  sha256 "f4d89d45c78436460d03df6774e0a80086b6552678caf0de67b08063b3b839d8"

  # Current winehq packages are deprecated and these are packages from
  # the new maintainers that will eventually be pushed to Winehq.
  # See https://www.winehq.org/pipermail/wine-devel/2021-July/191504.html
  url "https://ghproxy.com/https://github.com/Gcenx/macOS_Wine_builds/releases/download/#{version}/wine-staging-#{version}-osx64.tar.xz",
      verified: "github.com/Gcenx/macOS_Wine_builds/"
  name "WineHQ-staging"
  desc "Compatibility layer to run Windows applications"
  homepage "https://wiki.winehq.org/MacOS"

  livecheck do
    url :url
    strategy :github_latest
  end

  conflicts_with cask: [
    "wine-stable",
    "wine-devel",
  ]

  app "Wine Staging.app"
  binary "#{appdir}/Wine Staging.app/Contents/Resources/start/bin/appdb"
  binary "#{appdir}/Wine Staging.app/Contents/Resources/start/bin/winehelp"
  binary "#{appdir}/Wine Staging.app/Contents/Resources/wine/bin/msiexec"
  binary "#{appdir}/Wine Staging.app/Contents/Resources/wine/bin/notepad"
  binary "#{appdir}/Wine Staging.app/Contents/Resources/wine/bin/regedit"
  binary "#{appdir}/Wine Staging.app/Contents/Resources/wine/bin/regsvr32"
  binary "#{appdir}/Wine Staging.app/Contents/Resources/wine/bin/wine"
  binary "#{appdir}/Wine Staging.app/Contents/Resources/wine/bin/wine64"
  binary "#{appdir}/Wine Staging.app/Contents/Resources/wine/bin/wineboot"
  binary "#{appdir}/Wine Staging.app/Contents/Resources/wine/bin/winecfg"
  binary "#{appdir}/Wine Staging.app/Contents/Resources/wine/bin/wineconsole"
  binary "#{appdir}/Wine Staging.app/Contents/Resources/wine/bin/winedbg"
  binary "#{appdir}/Wine Staging.app/Contents/Resources/wine/bin/winefile"
  binary "#{appdir}/Wine Staging.app/Contents/Resources/wine/bin/winemine"
  binary "#{appdir}/Wine Staging.app/Contents/Resources/wine/bin/winepath"
  binary "#{appdir}/Wine Staging.app/Contents/Resources/wine/bin/wineserver"

  caveats <<~EOS
    #{token} supports both 32-bit and 64-bit. It is compatible with an existing
    32-bit wine prefix, but it will now default to 64-bit when you create a new
    wine prefix. The architecture can be selected using the WINEARCH environment
    variable which can be set to either win32 or win64.

    To create a new pure 32-bit prefix, you can run:
      $ WINEARCH=win32 WINEPREFIX=~/.wine32 winecfg

    See the Wine FAQ for details: https://wiki.winehq.org/FAQ#Wineprefixes
  EOS
end