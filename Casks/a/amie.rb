cask "amie" do
  arch arm: "-arm64"

  version "241014.0.0"
  sha256 arm:   "9eb258c21b4b6fb83e8da4feb2d825309cc0fe3611014fe504ae744b996012a9",
         intel: "a67386cc7141088f06df6c6b57f53fa32b904ce7053c6ce0cd1a8f098ff31780"

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