cask "v2rayu" do
  arch arm: "arm64", intel: "64"

  version "4.2.0"
  sha256 arm:   "d3280094d96f504dc730ca21be752d60a08cfcea5a015042ccec4eb734f3dd8f",
         intel: "d3280094d96f504dc730ca21be752d60a08cfcea5a015042ccec4eb734f3dd8f"

  url "https:github.comyanueV2rayUreleasesdownloadv#{version}V2rayU-#{arch}.dmg"
  name "V2rayU"
  desc "Collection of tools to build a dedicated basic communication network"
  homepage "https:github.comyanueV2rayU"

  auto_updates true
  depends_on macos: ">= :sierra"

  app "V2rayU.app"

  uninstall launchctl: [
    "yanue.v2rayu.http",
    "yanue.v2rayu.v2ray-core",
  ]

  zap trash: [
    "~.V2rayU",
    "~LibraryCachesnet.yanue.V2rayU",
    "~LibraryContainersnet.yanue.V2rayU.Launcher",
    "~LibraryHTTPStoragesnet.yanue.V2rayU",
    "~LibraryLaunchAgentsyanue.v2rayu.v2ray-core.plist",
    "~LibraryLogsV2rayU.log",
    "~LibraryPreferencesnet.yanue.V2rayU.plist",
  ]
end