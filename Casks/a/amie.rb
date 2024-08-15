cask "amie" do
  arch arm: "-arm64"

  version "240814.0.0"
  sha256 arm:   "c5538b529d199f90af67eebd4e917fcfb8191abad234f9ba141a33742d9be9e1",
         intel: "aba609568c2a37fc65cdb2b17fa22a9283f758f7dec1a1c71d2a866db56e307b"

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