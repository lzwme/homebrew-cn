cask "ontime" do
  arch arm: "arm64", intel: "x64"

  version "3.14.2"
  sha256 arm:   "4037ec2cf99e55f1410b263438841fe994f08c7b26f774fcf00fd0ce1933a2c5",
         intel: "cac6c2c1cdd5d4c594cd34c97a61c5b91e6a12660e721d99f4bb6f086d95818d"

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