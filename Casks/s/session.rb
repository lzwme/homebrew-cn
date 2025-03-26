cask "session" do
  version "1.15.1"
  sha256 "fa34e58b897e4f6471301b1b893af587f0fd5c98d10b6a2371fedbda35bb0a58"

  url "https:github.comsession-foundationsession-desktopreleasesdownloadv#{version}session-desktop-mac-x64-#{version}.dmg",
      verified: "github.comsession-foundationsession-desktop"
  name "Session"
  desc "Onion routing based messenger"
  homepage "https:getsession.org"

  livecheck do
    url :url
    strategy :github_latest
  end

  depends_on macos: ">= :ventura"

  app "Session.app"

  zap trash: [
    "~LibraryApplication SupportSession",
    "~LibraryCachesSession",
    "~LibraryPreferencescom.loki-project.messenger-desktop.plist",
    "~LibrarySaved Application Statecom.loki-project.messenger-desktop.savedState",
  ]

  caveats do
    requires_rosetta
  end
end