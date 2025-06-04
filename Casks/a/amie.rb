cask "amie" do
  arch arm: "-arm64"

  version "250530.0.8"
  sha256 arm:   "d342743da41d7190ac52e8aeea3fba292d075d319d3b33b97334c2afeca392e0",
         intel: "776cc15604b6a1f1a5b62e68392286d07e96720f3a337973a3ebe1d46ef7c056"

  url "https:github.comamiesoelectron-releasesreleasesdownloadv#{version}Amie-#{version}#{arch}-mac.zip",
      verified: "github.comamiesoelectron-releases"
  name "Amie"
  desc "Calendar and task manager"
  homepage "https:amie.so"

  auto_updates true
  depends_on macos: ">= :big_sur"

  app "Amie.app"

  zap trash: [
    "~LibraryApplication Supportamie-desktop",
    "~LibraryCachesamie-desktop",
    "~LibraryLogsamie-desktop",
    "~LibraryPreferencesso.amie.electron-app.plist",
    "~LibrarySaved Application Stateso.amie.electron-app.savedState",
  ]
end