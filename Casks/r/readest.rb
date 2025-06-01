cask "readest" do
  version "0.9.51"
  sha256 "fb1c51c42cb9ac0253db080fe3301b727df44b65c8c242fc959a396d5d6f075e"

  url "https:github.comreadestreadestreleasesdownloadv#{version}Readest_#{version}_universal.dmg",
      verified: "github.comreadestreadest"
  name "Readest"
  desc "Ebook reader"
  homepage "https:readest.com"

  livecheck do
    url :url
    strategy :github_latest
  end

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