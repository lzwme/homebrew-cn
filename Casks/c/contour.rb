cask "contour" do
  version "0.3.12.262"
  sha256 "45487d423767a20c2d55a712392cebea6b3d2d259c68fbce8f11c6f7e155cc76"

  url "https:github.comcontour-terminalcontourreleasesdownloadv#{version}contour-#{version}-osx.dmg"
  name "Contour"
  desc "Terminal emulator"
  homepage "https:github.comcontour-terminalcontour"

  app "Contour.app"
  binary "Contour.appContentsMacOScontour"
  binary "Contour.appContentsResourcesshell-integrationshell-integration.zsh",
         target: "#{HOMEBREW_PREFIX}sharezshsite-functions_contour"
  binary "Contour.appContentsResourcesterminfo63contour",
         target: "#{ENV.fetch("TERMINFO", "~.terminfo")}63contour"
  binary "Contour.appContentsResourcesterminfo63contour-latest",
         target: "#{ENV.fetch("TERMINFO", "~.terminfo")}63contour-latest"

  zap trash: "~.configcontour"
end