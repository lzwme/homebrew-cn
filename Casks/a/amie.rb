cask "amie" do
  arch arm: "-arm64"

  version "240710.0.0"
  sha256 arm:   "e887a7666df79a5ccf6679be9a94bd924dfb061dda3fbf582ff63ebf1767ab52",
         intel: "961eb6ae5eab70da5ac93e6e8b8c8034823908f84ada049593f3470295819015"

  url "https:github.comamiesoelectron-releasesreleasesdownloadv#{version}Amie-#{version}#{arch}-mac.zip",
      verified: "github.comamiesoelectron-releases"
  name "Amie"
  desc "Calendar and task manager"
  homepage "https:amie.so"

  auto_updates true
  depends_on macos: ">= :high_sierra"

  app "Amie.app"

  zap trash: [
    "~LibraryApplication Supportamie-desktop",
    "~LibraryCachesamie-desktop",
    "~LibraryLogsamie-desktop",
    "~LibraryPreferencesso.amie.electron-app.plist",
    "~LibrarySaved Application Stateso.amie.electron-app.savedState",
  ]
end