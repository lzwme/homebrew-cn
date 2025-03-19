cask "readest" do
  version "0.9.23"
  sha256 "554e4c06a8098b1804775c558fab1e5199ed12e7deb7d0cf4e05ad477f6ee4c7"

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