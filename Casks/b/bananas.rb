cask "bananas" do
  version "0.0.13"
  sha256 "b2d51a7a1f6e203909f398e1ce4195477a8bfefc77e0e86bff336ccb496bfd05"

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