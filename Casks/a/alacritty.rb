cask "alacritty" do
  version "0.15.1"
  sha256 "abaf240980cf3378031d1bfb3473d3b36abac15d679e2f780d5c0f09aa218459"

  url "https:github.comalacrittyalacrittyreleasesdownloadv#{version}Alacritty-v#{version}.dmg"
  name "Alacritty"
  desc "GPU-accelerated terminal emulator"
  homepage "https:github.comalacrittyalacritty"

  livecheck do
    url :url
    strategy :github_latest
  end

  app "Alacritty.app"
  binary "#{appdir}Alacritty.appContentsMacOSalacritty"
  binary "#{appdir}Alacritty.appContentsResources61alacritty",
         target: "#{ENV.fetch("TERMINFO", "~.terminfo")}61alacritty"
  binary "#{appdir}Alacritty.appContentsResources61alacritty-direct",
         target: "#{ENV.fetch("TERMINFO", "~.terminfo")}61alacritty-direct"
  manpage "#{appdir}Alacritty.appContentsResourcesalacritty.1.gz"
  manpage "#{appdir}Alacritty.appContentsResourcesalacritty.5.gz"
  manpage "#{appdir}Alacritty.appContentsResourcesalacritty-msg.1.gz"
  manpage "#{appdir}Alacritty.appContentsResourcesalacritty-bindings.5.gz"
  bash_completion "#{appdir}Alacritty.appContentsResourcescompletionsalacritty.bash"
  fish_completion "#{appdir}Alacritty.appContentsResourcescompletionsalacritty.fish"
  zsh_completion "#{appdir}Alacritty.appContentsResourcescompletions_alacritty"

  zap trash: [
    "~LibraryPreferencesorg.alacritty.plist",
    "~LibrarySaved Application Stateorg.alacritty.savedState",
  ]
end