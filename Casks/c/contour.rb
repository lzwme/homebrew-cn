cask "contour" do
  arch arm: "arm", intel: "x86"

  version "0.6.1.7494"
  sha256 arm:   "71c91a97a1adb1969750a4842295ab4fd9d91f25cc84161fa89670472261793b",
         intel: "fd560a5e58f55ac20cd0d440b136365428126ba6fac8edde69b4d36d98467c7e"

  url "https:github.comcontour-terminalcontourreleasesdownloadv#{version}contour-#{version}-macOS-#{arch}.dmg"
  name "Contour"
  desc "Terminal emulator"
  homepage "https:github.comcontour-terminalcontour"

  app "contour.app"
  binary "#{appdir}contour.appContentsMacOScontour"
  binary "#{appdir}contour.appContentsResourcesterminfo63contour",
         target: "#{ENV.fetch("TERMINFO", "~.terminfo")}63contour"
  bash_completion "#{appdir}contour.appContentsResourcesshell-integrationshell-integration.bash",
                  target: "contour"
  fish_completion "#{appdir}contour.appContentsResourcesshell-integrationshell-integration.fish",
                  target: "contour.fish"
  zsh_completion "#{appdir}contour.appContentsResourcesshell-integrationshell-integration.zsh",
                 target: "_contour"

  zap trash: "~.configcontour"
end