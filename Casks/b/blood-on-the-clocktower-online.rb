cask "blood-on-the-clocktower-online" do
  arch arm: "aarch64", intel: "x64"

  version "3.32.1"
  sha256 arm:   "8f15e34a1a8aac45b0492b9c1022495d3ba1e0d191617e27d597a7400b92313a",
         intel: "67d879c1f06bf4737deb4cf587532a2408787e5449c46a613b1f28463d0cfc08"

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