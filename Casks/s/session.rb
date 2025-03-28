cask "session" do
  version "1.15.2"
  sha256 "1472c3a5be3b559eed16c1db18ec0139babcbac3621ac40bc88b64f97384a994"

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