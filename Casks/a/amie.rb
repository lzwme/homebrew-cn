cask "amie" do
  arch arm: "-arm64"

  version "240130.0.0"
  sha256 arm:   "41c0006ba47ae7e25766b332324adbcb8299ac16e1d3e0a63fedf03de2781484",
         intel: "639c16ce35cb376ce7d276fe64735eaa62538e99599ca1841e6c3ded08c01b00"

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