cask "swiftbar" do
  version "2.0.1,536"
  sha256 "ac70a9cbdde20d58dae27d360764aa42c3698f6e1bc4618c4b03297a2cee67fa"

  url "https:github.comswiftbarSwiftBarreleasesdownloadv#{version.csv.first}SwiftBar.v#{version.csv.first}.b#{version.csv.second}.zip",
      verified: "github.comswiftbarSwiftBar"
  name "SwiftBar"
  desc "Menu bar customization tool"
  homepage "https:swiftbar.app"

  livecheck do
    url "https:swiftbar.github.ioSwiftBarappcast.xml"
    strategy :sparkle
  end

  no_autobump! because: :requires_manual_review

  auto_updates true
  depends_on macos: ">= :big_sur"

  app "SwiftBar.app"

  zap trash: [
    "~LibraryApplication Scriptscom.ameba.SwiftBar-LaunchAtLoginHelper",
    "~LibraryCachescom.ameba.SwiftBar",
    "~LibraryContainerscom.ameba.SwiftBar-LaunchAtLoginHelper",
    "~LibraryPreferencescom.ameba.SwiftBar.plist",
  ]
end