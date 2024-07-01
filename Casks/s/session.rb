cask "session" do
  version "1.12.4"
  sha256 "64f38022612af6d6d287b15904b3528fb1a34a21616fb12caf0b05e0e4679f3e"

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