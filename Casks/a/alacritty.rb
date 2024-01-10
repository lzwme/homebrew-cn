cask "alacritty" do
  version "0.13.1"
  sha256 "f6b9bcee5ff0e87ae80379c01c59dd4479670c3c628f6759909cb447f6dd5e98"

  url "https:github.comalacrittyalacrittyreleasesdownloadv#{version}Alacritty-v#{version}.dmg"
  name "Alacritty"
  desc "GPU-accelerated terminal emulator"
  homepage "https:github.comalacrittyalacritty"

  livecheck do
    url :url
    strategy :github_latest
  end

  app "Alacritty.app"
  binary "Alacritty.appContentsMacOSalacritty"
  binary "Alacritty.appContentsResourcescompletions_alacritty",
         target: "#{HOMEBREW_PREFIX}sharezshsite-functions_alacritty"
  binary "Alacritty.appContentsResourcescompletionsalacritty.bash",
         target: "#{HOMEBREW_PREFIX}etcbash_completion.dalacritty"
  binary "Alacritty.appContentsResourcescompletionsalacritty.fish",
         target: "#{HOMEBREW_PREFIX}sharefishvendor_completions.dalacritty.fish"
  binary "Alacritty.appContentsResources61alacritty",
         target: "#{ENV.fetch("TERMINFO", "~.terminfo")}61alacritty"
  binary "Alacritty.appContentsResources61alacritty-direct",
         target: "#{ENV.fetch("TERMINFO", "~.terminfo")}61alacritty-direct"
  manpage "Alacritty.appContentsResourcesalacritty.1.gz"
  manpage "Alacritty.appContentsResourcesalacritty.5.gz"
  manpage "Alacritty.appContentsResourcesalacritty-msg.1.gz"
  manpage "Alacritty.appContentsResourcesalacritty-bindings.5.gz"

  zap trash: [
    "~LibraryPreferencesio.alacritty.plist",
    "~LibrarySaved Application Stateio.alacritty.savedState",
  ]
end