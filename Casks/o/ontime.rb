cask "ontime" do
  arch arm: "arm64", intel: "x64"

  version "3.15.1"
  sha256 arm:   "7b2995f6703f59381f203cba7aa11345b179991d9ec02e6e634c7faa4bfdb57e",
         intel: "b6b75b4bc77094ffe4fb965797f1db5f7c8380b5eb5e7c8276214f3b7cf9d8e5"

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