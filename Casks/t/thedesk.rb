cask "thedesk" do
  version "25.0.10"
  sha256 "62312a6825d56aa5937f6055b6a24959c7105c56e535eaed1acfa8d28a9247dd"

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