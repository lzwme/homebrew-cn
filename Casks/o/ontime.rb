cask "ontime" do
  arch arm: "arm64", intel: "x64"

  version "3.10.4"
  sha256 arm:   "60d9b27d5c15c6b7785a68a148986a7d03a9ee30ef0ca34d0d9ae672cac14ebe",
         intel: "b48c545ba094239a3d51ddf4b6d1556f78b7f5aa299156f275688ac252d8472d"

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