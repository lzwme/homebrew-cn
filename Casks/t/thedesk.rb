cask "thedesk" do
  version "24.2.1"
  sha256 "5499ed955ad4131ef925cae04923ec58b3a550187a8289945d67ce22634c6639"

  url "https:github.comcutlsTheDeskreleasesdownloadv#{version}TheDesk-#{version}-universal.dmg",
      verified: "github.comcutlsTheDesk"
  name "TheDesk"
  desc "MastodonMisskey Client for PC"
  homepage "https:thedesk.top"

  livecheck do
    url :url
    strategy :github_latest
  end

  app "TheDesk.app"

  zap trash: [
    "~LibraryApplication Supportthedesk",
    "~LibraryPreferencestop.thedesk.plist",
    "~LibrarySaved Application Statetop.thedesk.savedState",
  ]
end