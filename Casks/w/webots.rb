cask "webots" do
  version "R2025a"
  sha256 "484f6cc84ca794dd33e410b0bfc030132cc5b163a882c350c1d293d06d87584f"

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

  no_autobump! because: :requires_manual_review

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