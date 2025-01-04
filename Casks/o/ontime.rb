cask "ontime" do
  arch arm: "arm64", intel: "x64"

  version "3.9.10"
  sha256 arm:   "a5900380f10f7fb13f29371e832f0cc3be9eaf68ef373f9e44af4dfc447467bb",
         intel: "fecd4822f61acbeab8a0ffacb73126013d90cf82a30e22234711a7ab5027e86b"

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