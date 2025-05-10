cask "amie" do
  arch arm: "-arm64"

  version "250509.0.0"
  sha256 arm:   "d0b3f75c38f7af02f4221bd19f2479865c8303a8ed0bd87cafb0301276247e6e",
         intel: "724728b8326b50dbf653e2464adb12f9bb1159fdeb1f6c2dbe6af702e8be89b1"

  url "https:github.comamiesoelectron-releasesreleasesdownloadv#{version}Amie-#{version}#{arch}-mac.zip",
      verified: "github.comamiesoelectron-releases"
  name "Amie"
  desc "Calendar and task manager"
  homepage "https:amie.so"

  auto_updates true
  depends_on macos: ">= :big_sur"

  app "Amie.app"

  zap trash: [
    "~LibraryApplication Supportamie-desktop",
    "~LibraryCachesamie-desktop",
    "~LibraryLogsamie-desktop",
    "~LibraryPreferencesso.amie.electron-app.plist",
    "~LibrarySaved Application Stateso.amie.electron-app.savedState",
  ]
end