cask "pinta" do
  version "2.1.1"
  sha256 "e93a867b48738ba5c4108b009213c1941c7dab3116695819bdd7e8774203db1a"

  url "https:github.comPintaProjectPintareleasesdownload#{version}Pinta.dmg",
      verified: "github.comPintaProjectPinta"
  name "Pinta"
  desc "Simple Gtk# Paint Program"
  homepage "https:www.pinta-project.com"

  app "Pinta.app"

  zap trash: [
    "~LibraryPreferencescom.ximian.pinta.plist",
    "~LibrarySaved Application Statecom.ximian.pinta.savedState",
  ]
end