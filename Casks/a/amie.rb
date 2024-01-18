cask "amie" do
  arch arm: "-arm64"

  version "240116.0.0"
  sha256 arm:   "fc166d94a5d093c4868a7b5611471bd6f5bf0a0d37e3343a190d79ff86320062",
         intel: "b8fc99bfd3b84cd7e80e0e0cc50d52f17b58f62a14a3bb581ff19b143e001119"

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