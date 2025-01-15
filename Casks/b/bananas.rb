cask "bananas" do
  version "0.0.19"
  sha256 "41626250a3c7684288fbef201ecfa742ac6353b45f31aea4169ea757fecdfa3e"

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