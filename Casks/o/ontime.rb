cask "ontime" do
  arch arm: "arm64", intel: "x64"

  version "3.14.4"
  sha256 arm:   "6f5e47bdf90a666dacf696758c959e46022126024a34b858434037144e861661",
         intel: "1fe1d81cc75f10dce22f193914f4f38064fc4b07ae965b567164a2209c1fdf08"

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