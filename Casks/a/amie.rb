cask "amie" do
  arch arm: "-arm64"

  version "240402.0.5"
  sha256 arm:   "1689d7d768b41c2287647be605f3e1222e27b11b540ca2926daaee9d63a41609",
         intel: "91ccdcf1dcd954ad014c84e934806b0db379c84ab6eaaf5f5a046a952599508b"

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