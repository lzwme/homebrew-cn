cask "amie" do
  arch arm: "-arm64"

  version "240718.0.0"
  sha256 arm:   "8f8f6a48a09dba899237eba31fc5ade77a16285272819cd3978101e85306913b",
         intel: "7f0e0140b2c79cc41db8eeccd985c6cc74aa9d86da4d3319beaf0f280e648f1c"

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