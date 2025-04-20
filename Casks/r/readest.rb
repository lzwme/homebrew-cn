cask "readest" do
  version "0.9.36"
  sha256 "4b59bc1397dffa7c78e8ffd5a4b124fe0ee00efa5dc446e24c62c0a74ef6a002"

  url "https:github.comreadestreadestreleasesdownloadv#{version}Readest_#{version}_universal.dmg",
      verified: "github.comreadestreadest"
  name "Readest"
  desc "Ebook reader"
  homepage "https:readest.com"

  depends_on macos: ">= :monterey"

  app "Readest.app"

  zap trash: [
    "~LibraryApplication Supportcom.bilingify.readest",
    "~LibraryCachescom.bilingify.readest",
    "~LibraryCachesreadest",
    "~LibraryPreferencescom.bilingify.readest.plist",
    "~LibraryWebKitcom.bilingify.readest",
    "~LibraryWebKitreadest",
  ]
end