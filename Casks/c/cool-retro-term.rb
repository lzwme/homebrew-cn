cask "cool-retro-term" do
  version "1.2.0"
  sha256 "605610df37b6ed92fac14d5e34a83350148e989b10ad9550d3403187fb974e48"

  url "https:github.comSwordfish90cool-retro-termreleasesdownload#{version}Cool-Retro-Term-#{version}.dmg"
  name "Cool Retro Term"
  desc "Terminal emulator mimicking the old cathode display"
  homepage "https:github.comSwordfish90cool-retro-term"

  depends_on macos: ">= :high_sierra"

  app "cool-retro-term.app"

  zap trash: [
    "~LibraryApplication Supportcool-retro-term",
    "~LibraryCachescool-retro-term",
    "~LibraryPreferencescom.yourcompany.cool-retro-term.cool-retro-term.plist",
    "~LibraryPreferencescom.yourcompany.cool-retro-term.plist",
    "~LibrarySaved Application Statecom.yourcompany.cool-retro-term.savedState",
  ]
end