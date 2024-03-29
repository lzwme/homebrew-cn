cask "webots" do
  version "R2023b"
  sha256 "6fe4638f28bd5ca9fc0c4c910dbe4bae835497a3186df11c42f0665f802f82e4"

  url "https:github.comcyberboticswebotsreleasesdownload#{version}webots-#{version}.dmg",
      verified: "github.comcyberboticswebots"
  name "Cyberbotics Webots Robot Simulator"
  name "Webots"
  desc "Open source desktop application used to simulate robots"
  homepage "https:www.cyberbotics.com"

  livecheck do
    url :url
    regex(([\w._-]+)i)
    strategy :github_latest
  end

  auto_updates true
  depends_on macos: ">= :mojave"

  app "Webots.app"

  uninstall quit: "com.cyberbotics.webots"

  zap trash: [
    "~LibraryApplication SupportCyberboticsWebots",
    "~LibraryCachesCyberboticsWebots",
    "~LibraryPreferencescom.cyberbotics.Webots-#{version}.plist",
  ]
end