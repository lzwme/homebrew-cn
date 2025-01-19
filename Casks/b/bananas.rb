cask "bananas" do
  version "0.0.20"
  sha256 "cd9532d3e077849271e4a86bf680749f1e707ed63fb08933e31daad312187472"

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