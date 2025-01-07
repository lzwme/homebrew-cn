cask "ontime" do
  arch arm: "arm64", intel: "x64"

  version "3.10.2"
  sha256 arm:   "d51fe5f97082c14510377c5cfe3fefb2728335930f7aa1adfe7f90a821897dbd",
         intel: "523370e5186016ad8e0ca463727ab9c31413eddcdce8c4bfba6b3f5d4d3749ff"

  url "https:github.comcpvalenteontimereleasesdownloadv#{version}ontime-macOS-#{arch}.dmg",
      verified: "github.comcpvalenteontime"
  name "Ontime"
  desc "Time keeping for live events"
  homepage "https:getontime.no"

  livecheck do
    url :url
    strategy :github_latest
  end

  auto_updates true
  depends_on macos: ">= :catalina"

  app "ontime.app"

  zap trash: [
    "~LibraryApplication Supportontime",
    "~LibraryPreferencesno.lightdev.ontime.plist",
    "~LibrarySaved Application Stateno.lightdev.ontime.savedState",
  ]
end