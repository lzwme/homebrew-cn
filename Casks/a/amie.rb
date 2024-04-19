cask "amie" do
  arch arm: "-arm64"

  version "240418.0.0"
  sha256 arm:   "a1dc08b2bb6afaea04e2f1588b540aff38e52c3bc0219a264dad4bd9ed7ef45e",
         intel: "d5879fdf2ca7810ed5e1e0d7704d2e7dd4d29e5a90d122a09119531c64888a43"

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