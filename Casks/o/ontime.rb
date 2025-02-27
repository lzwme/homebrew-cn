cask "ontime" do
  arch arm: "arm64", intel: "x64"

  version "3.13.0"
  sha256 arm:   "fedea0f8e22cd29192f7d96402c839d9921376663e6e0adc583d00ce7c6208e0",
         intel: "4614f446d884bec49f3fc6bd750107c06c97c66b3702638ace07f3ec6f5f0b22"

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