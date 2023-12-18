cask "alacritty" do
  version "0.12.3"
  sha256 "7fc3220a3ad93ab2e555d2a9724506fc314ca4beaa81ce16e43cb3e9c06f1a93"

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
  manpage "Alacritty.appContentsResourcesalacritty-msg.1.gz"

  zap trash: [
    "~LibraryPreferencesio.alacritty.plist",
    "~LibrarySaved Application Stateio.alacritty.savedState",
  ]
end