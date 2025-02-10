cask "deadbolt" do
  arch arm: "-arm64"

  version "2.0.0"
  sha256 arm:   "ad2d7780f7032018cb40241781f445c5fb1b4cf6adc481917735472ba9f2a8da",
         intel: "3584529c35711c56d6f118ce06e76e7c14dafe8b71608aa25ee42ccf6e5dd633"

  url "https:github.comalichtmandeadboltreleasesdownloadv#{version}Deadbolt-#{version}#{arch}.dmg"
  name "Deadbolt"
  desc "File encryption tool"
  homepage "https:github.comalichtmandeadbolt"

  livecheck do
    url :url
    strategy :github_latest
  end

  app "Deadbolt.app"

  zap trash: [
    "~LibraryApplication Supportdeadbolt",
    "~LibraryPreferencesorg.alichtman.deadbolt.plist",
    "~LibrarySaved Application Stateorg.alichtman.deadbolt.savedState",
  ]
end