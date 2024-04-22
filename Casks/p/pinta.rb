cask "pinta" do
  version "2.1.2"
  sha256 "ab31c1bd274ce7d13e6ca8d5b243e1251dd69356f466d39d3ff1127616129b33"

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