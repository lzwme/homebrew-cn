cask "ontime" do
  arch arm: "arm64", intel: "x64"

  version "3.15.2"
  sha256 arm:   "cdab79d7a0ddb1c62e47ecd4d8730f1fc42f97dfa99e934a401c6348c496a349",
         intel: "f0e50dbd18947b09361def8be15e05d49b01ebacff569cd40c52fa2cd81b85b4"

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