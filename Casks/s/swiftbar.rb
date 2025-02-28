cask "swiftbar" do
  version "2.0.1"
  sha256 "ac70a9cbdde20d58dae27d360764aa42c3698f6e1bc4618c4b03297a2cee67fa"

  url "https:github.comswiftbarSwiftBarreleasesdownloadv#{version}SwiftBar.v#{version}.zip",
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