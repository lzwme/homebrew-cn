cask "swiftbar" do
  version "2.0.0"
  sha256 "626dacd22126dd3d9821892277ec7fdaf0390953344dc1d8ab5caa1abf6762b6"

  url "https:github.comswiftbarSwiftBarreleasesdownloadv#{version}SwiftBar.v#{version}.b520.zip",
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