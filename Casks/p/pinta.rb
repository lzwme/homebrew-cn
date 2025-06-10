cask "pinta" do
  arch arm: "arm64", intel: "x86_64"

  version "3.0.1"
  sha256 arm:   "d2ab53ce4a0766d4d25b7ef5db6a0e9431d653c23e6daca11078cf68bf230ee3",
         intel: "dcd0fbc37b776df3c926619aedac4cc963931d8d586efebddbdbc2aa493def05"

  url "https:github.comPintaProjectPintareleasesdownload#{version}Pinta-macos-#{arch}.dmg",
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