cask "blood-on-the-clocktower-online" do
  arch arm: "aarch64", intel: "x64"

  version "3.42.0"
  sha256 arm:   "25a46a96c35b08f0ae60572a3ceac175a478fb48ce85a061726a56613bcea2a3",
         intel: "230d2931ed431e310ff2e406d338302183378f0137970889f568bd329f452a2c"

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