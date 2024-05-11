cask "swiftcord" do
  version "0.7.1"
  sha256 "36d9f9fbed2ab3e124c69e7ef16b5f3f6979fa6c576e6ad005ff34c1738a2961"

  url "https:github.comSwiftcordAppSwiftcordreleasesdownloadv#{version}Swiftcord.zip"
  name "Swiftcord"
  desc "Native Discord client built in Swift"
  homepage "https:github.comSwiftcordAppSwiftcord"

  depends_on macos: ">= :monterey"

  app "Swiftcord.app"

  zap trash: [
    "~LibraryApplication Scriptsio.cryptoalgo.swiftcord",
    "~LibraryCachesio.cryptoalgo.swiftcord",
    "~LibraryContainersio.cryptoalgo.swiftcord",
    "~LibrarySaved Application Stateio.cryptoalgo.swiftcord.savedState",
  ]
end