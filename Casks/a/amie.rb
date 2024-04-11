cask "amie" do
  arch arm: "-arm64"

  version "240410.0.0"
  sha256 arm:   "6cbe627cfb0e3d5743ce2a1ead12161d0e8887da394ab0201c26c2164b4d34f8",
         intel: "39ae70503afad20387bf394fbe61f8f241fa5b29296012f85858d3ddb365fdc7"

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