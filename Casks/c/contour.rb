cask "contour" do
  version "0.4.2.6429"
  sha256 "cddf99817c73140413723e22eaed09f0e04c5de88a8778eb49ce454b6ae07c19"

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