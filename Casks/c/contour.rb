cask "contour" do
  version "0.5.1.7247"
  sha256 "70484619b15eab2af562a2b11cc8bd44e67e514992ad1bb615ac2a0180708fae"

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