cask "thedesk" do
  version "25.0.13"
  sha256 "71e902ec2da54bffdde583b6b5c11f714f264d930c7573e152525f110f753ed1"

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