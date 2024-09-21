cask "thedesk" do
  version "25.0.15"
  sha256 "6acd958ea4a1ea496bd1b7069a231170c8be5ded50964b712d715dd548bf82b4"

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