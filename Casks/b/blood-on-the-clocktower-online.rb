cask "blood-on-the-clocktower-online" do
  arch arm: "aarch64", intel: "x64"

  version "3.35.1"
  sha256 arm:   "55764da862d70be6761ba075778f40e9a61948788262afe30bf2470a4ddd2ab4",
         intel: "2fd1d083724879e6e3a5b7b4ce984cf48c8a3033b47bdcb5d5f5197b34cf64c4"

  url "https:github.comThePandemoniumInstitutebotc-releasereleasesdownloadv#{version}Blood.on.the.Clocktower.Online_#{version}_#{arch}.dmg",
      verified: "github.comThePandemoniumInstitutebotc-release"
  name "Blood on the Clocktower Online"
  desc "Client for the game Blood on the Clocktower"
  homepage "https:bloodontheclocktower.com"

  depends_on macos: ">= :high_sierra"

  app "Blood on the Clocktower Online.app"

  zap trash: [
    "~LibraryApplication Supportbotc-app",
    "~LibraryApplication Supportcom.thepandemoniuminstitute.botc.app",
    "~LibraryCachescom.thepandemoniuminstitute.botc.app",
    "~LibrarySaved Application Statecom.thepandemoniuminstitute.botc.app.savedState",
    "~LibraryWebKitcom.thepandemoniuminstitute.botc.app",
  ]
end