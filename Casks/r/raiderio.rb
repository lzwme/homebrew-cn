cask "raiderio" do
  version "4.7.4"
  sha256 "e69685830dfa00d37dbbddb7b0a05f96b83f93bf8d7b73ea2b7789d075446c78"

  url "https:github.comRaiderIOraiderio-client-buildsreleasesdownloadv#{version}RaiderIO_Client.dmg",
      verified: "github.comRaiderIOraiderio-client-builds"
  name "Raider.io Client"
  desc "World of Warcraft client to track Mythic+ and Raid Progression"
  homepage "https:raider.io"

  livecheck do
    url :url
    strategy :github_latest
  end

  depends_on macos: ">= :big_sur"

  app "RaiderIO.app"

  zap trash: [
    "~LibraryApplication SupportRaiderIO",
    "~LibraryLogsRaiderIO",
  ]
end