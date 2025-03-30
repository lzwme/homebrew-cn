cask "readest" do
  version "0.9.28"
  sha256 "8bc1ebee2b15efcfb674637c4b9ded1d9eeaef0e292b83e9678c84eaca10a63a"

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