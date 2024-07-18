cask "amie" do
  arch arm: "-arm64"

  version "240717.1.0"
  sha256 arm:   "e2556de98f4c8c4b4af31e866d02fb8920d64b065f2ffabf919bebc7e8387152",
         intel: "8e876dda81cffaa7ac1fe1cd78cefe534afe194e2b6926c995a592f2574d9ed7"

  url "https:github.comamiesoelectron-releasesreleasesdownloadv#{version}Amie-#{version}#{arch}-mac.zip",
      verified: "github.comamiesoelectron-releases"
  name "Amie"
  desc "Calendar and task manager"
  homepage "https:amie.so"

  auto_updates true
  depends_on macos: ">= :catalina"

  app "Amie.app"

  zap trash: [
    "~LibraryApplication Supportamie-desktop",
    "~LibraryCachesamie-desktop",
    "~LibraryLogsamie-desktop",
    "~LibraryPreferencesso.amie.electron-app.plist",
    "~LibrarySaved Application Stateso.amie.electron-app.savedState",
  ]
end