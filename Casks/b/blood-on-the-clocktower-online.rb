cask "blood-on-the-clocktower-online" do
  arch arm: "aarch64", intel: "x64"

  version "3.33.1"
  sha256 arm:   "1cbf4f7d4b72d5ef43eb28ed273b38acd59d91176e28ed51ba636ec25f63d8d9",
         intel: "5cfc19a891a587b24be48dad2d4c4386e5676f912d52ccd36c390f0d6d1814d5"

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