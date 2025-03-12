cask "session" do
  version "1.15.0"
  sha256 "bf78a795e8ccbd5f2913368c7bd1a393c66d9f800e5ce7c3cdaaa1b3bff4eefc"

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