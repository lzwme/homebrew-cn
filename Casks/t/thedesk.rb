cask "thedesk" do
  version "25.0.14"
  sha256 "42c753c18a788aead76059b30a70730de36d4f1408abf2703d0e9aa58ff30891"

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