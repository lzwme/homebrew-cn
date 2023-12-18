cask "swiftcord" do
  version "0.6.1"
  sha256 "6da79f88930ce384a58c3fd902f75ad64ef0b9e015aa547db6a85af7d46b2032"

  url "https:github.comSwiftcordAppSwiftcordreleasesdownloadv#{version}Swiftcord.#{version}.dmg"
  name "Swiftcord"
  desc "Native Discord client built in Swift"
  homepage "https:github.comSwiftcordAppSwiftcord"

  livecheck do
    url "https:raw.githubusercontent.comSwiftcordAppSwiftcordmainappcast.xml"
    strategy :sparkle, &:short_version
  end

  depends_on macos: ">= :monterey"

  app "Swiftcord.app"

  zap trash: [
    "~LibraryApplication Scriptsio.cryptoalgo.swiftcord",
    "~LibraryCachesio.cryptoalgo.swiftcord",
    "~LibraryContainersio.cryptoalgo.swiftcord",
    "~LibrarySaved Application Stateio.cryptoalgo.swiftcord.savedState",
  ]
end