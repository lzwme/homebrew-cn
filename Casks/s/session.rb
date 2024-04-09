cask "session" do
  version "1.12.1"
  sha256 "6526a732f79d77720bc3af8957d2a5fbfec93afdc8723ee571157c537d20167b"

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
end