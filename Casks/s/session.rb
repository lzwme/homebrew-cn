cask "session" do
  arch arm: "arm64", intel: "x64"

  version "1.16.2"
  sha256 arm:
                "d11a80d19c138ae8dda12d87ce8352c4716d27b6cdd9301bf56dc242fe77055c",
         intel: "ae069d7aa5c56a3e255066b6a75ccf09f5fae7aadb68580dae45096ca2b1fb88"

  url "https:github.comsession-foundationsession-desktopreleasesdownloadv#{version}session-desktop-mac-#{arch}-#{version}.dmg",
      verified: "github.comsession-foundationsession-desktop"
  name "Session"
  desc "Onion routing based messenger"
  homepage "https:getsession.org"

  livecheck do
    url :url
    strategy :github_latest
  end

  auto_updates true
  depends_on macos: ">= :ventura"

  app "Session.app"

  zap trash: [
    "~LibraryApplication SupportSession",
    "~LibraryCachesSession",
    "~LibraryPreferencescom.loki-project.messenger-desktop.plist",
    "~LibrarySaved Application Statecom.loki-project.messenger-desktop.savedState",
  ]
end