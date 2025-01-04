cask "readest" do
  version "0.8.9"
  sha256 "305281f4f3850144065aa23475eb18c92ede3519f4dfbe0b5c9b1559c867b0d8"

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