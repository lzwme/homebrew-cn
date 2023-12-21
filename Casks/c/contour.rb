cask "contour" do
  version "0.4.0.6245"
  sha256 "9aada387d7f213609707dd6c8f7730d4d23769b2c4a7f16bfe37bab92663337c"

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