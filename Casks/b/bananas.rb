cask "bananas" do
  version "0.0.16"
  sha256 "1c320527dd0fc915afbb54714dce92013ea79347b50dd4a859fe74348a006d75"

  url "https:github.commistweavercobananasreleasesdownloadv#{version}bananas_universal.dmg",
      verified: "github.commistweavercobananas"
  name "Bananas Screen Sharing"
  desc "Cross-platform screen sharing tool"
  homepage "https:getbananas.net"

  depends_on macos: ">= :catalina"

  app "bananas.app"

  zap trash: [
    "~LibraryApplication Supportbananas",
    "~LibraryPreferencesnet.getbananas.app.plist",
    "~LibrarySaved Application Statenet.getbananas.app.savedState",
  ]
end