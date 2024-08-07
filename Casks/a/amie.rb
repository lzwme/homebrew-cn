cask "amie" do
  arch arm: "-arm64"

  version "240806.0.0"
  sha256 arm:   "108a2234373c9fb6106549dbbb400f3905b3a8258ae11e45452b73cf14ef3e34",
         intel: "fe56a741048bc1a4b3f9c9b734ff57539c9e8933ba770eac0c92854addbd157b"

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