cask "amie" do
  arch arm: "-arm64"

  version "241028.0.0"
  sha256 arm:   "12731bbaa01e06a5df607ff14659667382b1385d9006a3f3a892db2fba35aa78",
         intel: "673f024ee093288f275dc45504f5ad8879135f166b5668e666bdb6257e50a279"

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