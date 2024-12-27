cask "contour" do
  arch arm: "arm", intel: "x86"

  version "0.6.0.7452"
  sha256 arm:   "0bbde7becfd6f7ab5d11c5cfcd266db7f942e91dede8d2898e1f8adabe64aae5",
         intel: "f26f10883e1abc5b0099fcfee69831583058dab72f64f198ec3bbe08c608e916"

  url "https:github.comcontour-terminalcontourreleasesdownloadv#{version}contour-#{version}-macOS-#{arch}.dmg"
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