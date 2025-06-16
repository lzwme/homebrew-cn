cask "v2rayu" do
  arch arm: "arm64", intel: "64"

  version "4.2.6"
  sha256 arm:   "f3d76886d7c2122f8911c314263c951051c52756b368e3b88545ebcd4075e474",
         intel: "4bd21d251e1e6f1d20ab6ea8cc52eedae69213170fc99c590e44451a180d9c18"

  url "https:github.comyanueV2rayUreleasesdownloadv#{version}V2rayU-#{arch}.dmg"
  name "V2rayU"
  desc "Collection of tools to build a dedicated basic communication network"
  homepage "https:github.comyanueV2rayU"

  # A tag using the stable version format is sometimes marked as "Pre-release"
  # on the GitHub releases page, so we have to use the `GithubLatest` strategy.
  livecheck do
    url :url
    strategy :github_latest
  end

  no_autobump! because: :requires_manual_review

  auto_updates true
  depends_on macos: ">= :big_sur"

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