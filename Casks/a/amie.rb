cask "amie" do
  arch arm: "-arm64"

  version "240508.0.0"
  sha256 arm:   "fcd99b0000ec7a3ba738520ce9b71420968139e3c842198f2963e56c76cafd27",
         intel: "c5c99aa74a8d6ac4558945c7bdc57f960ec8c68efe4555417ba7f0b52f7921ca"

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