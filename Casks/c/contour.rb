cask "contour" do
  version "0.5.0.7168"
  sha256 "903354e43f30404f591fda60df8e2c43e74781078e8f7dcd877a1473c8acff9c"

  url "https:github.comcontour-terminalcontourreleasesdownloadv#{version}contour-#{version}-osx.dmg"
  name "contour"
  desc "Terminal emulator"
  homepage "https:github.comcontour-terminalcontour"

  app "contour.app"
  binary "contour.appContentsMacOScontour"
  binary "contour.appContentsResourcesshell-integrationshell-integration.zsh",
         target: "#{HOMEBREW_PREFIX}sharezshsite-functions_contour"
  binary "contour.appContentsResourcesterminfo63contour",
         target: "#{ENV.fetch("TERMINFO", "~.terminfo")}63contour"

  zap trash: "~.configcontour"
end