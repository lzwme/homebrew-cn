cask "session" do
  version "1.14.2"
  sha256 "8aaac6764d02ce636938e2fa8da7fc750582a47a2a5fc2ae74ef9ac57f4b9d35"

  url "https:github.comoxen-iosession-desktopreleasesdownloadv#{version}session-desktop-mac-x64-#{version}.dmg",
      verified: "github.comoxen-iosession-desktop"
  name "Session"
  desc "Onion routing based messenger"
  homepage "https:getsession.org"

  livecheck do
    url :url
    strategy :github_latest
  end

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