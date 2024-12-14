cask "ontime" do
  arch arm: "arm64", intel: "x64"

  version "3.9.5"
  sha256 arm:   "cbdb6286badb1159de5d7ce70f82b701037c8c919adc73f1d1f45e8fdcccf7c1",
         intel: "229e2e48696ce846ebbf406ddd77c3d68c9421948f7e70de9fd3d5fea9a66ef9"

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