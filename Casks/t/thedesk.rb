cask "thedesk" do
  version "25.0.11"
  sha256 "75d5484c1ad7cbc5d461c104563f3c0dc34a01b9cfc8309653fe178891d6aeab"

  url "https:github.comcutlsthedesk-nextreleasesdownloadv#{version}TheDesk-#{version}-universal.dmg",
      verified: "github.comcutlsthedesk-next"
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