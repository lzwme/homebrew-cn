cask "ontime" do
  arch arm: "arm64", intel: "x64"

  version "3.11.1"
  sha256 arm:   "4ca6ad7e6300731bf11e5ab9f1dcd6d7502422c909a2eb1ddf51eae38590151e",
         intel: "eee8e8726d785a6981f5694b17ef4ca9a6267b9ec5b0d57b7ae5703ad5c61253"

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