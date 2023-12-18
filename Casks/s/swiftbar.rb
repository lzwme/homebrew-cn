cask "swiftbar" do
  version "1.4.4"
  sha256 "04f465abaabf7a06f8e75458824a551f5a2e85d60bdf73f95539825fee59d856"

  url "https:github.comswiftbarSwiftBarreleasesdownloadv#{version}SwiftBar.zip",
      verified: "github.comswiftbarSwiftBar"
  name "SwiftBar"
  desc "Menu bar customization tool"
  homepage "https:swiftbar.app"

  livecheck do
    url :url
    strategy :github_latest
  end

  depends_on macos: ">= :catalina"

  app "SwiftBar.app"

  zap trash: [
    "~LibraryApplication Scriptscom.ameba.SwiftBar-LaunchAtLoginHelper",
    "~LibraryCachescom.ameba.SwiftBar",
    "~LibraryContainerscom.ameba.SwiftBar-LaunchAtLoginHelper",
    "~LibraryPreferencescom.ameba.SwiftBar.plist",
  ]
end