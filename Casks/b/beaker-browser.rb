cask "beaker-browser" do
  version "1.1.0"
  sha256 "c88718c6ec1f7cbb70f33e3ac04f0d2117ab5b7907d9fa0529cd8b70f13df0e2"

  url "https://ghfast.top/https://github.com/beakerbrowser/beaker/releases/download/#{version}/beaker-browser-#{version}.dmg",
      verified: "github.com/beakerbrowser/beaker/"
  name "Beaker Browser"
  name "Beaker"
  desc "Experimental peer-to-peer web browser"
  homepage "https://beakerbrowser.com/"

  no_autobump! because: :requires_manual_review

  disable! date: "2024-12-16", because: :discontinued

  auto_updates true

  app "Beaker Browser.app"

  zap trash: [
    "~/Library/Application Support/Beaker Browser",
    "~/Library/Application Support/Caches/beaker-browser-updater",
    "~/Library/Caches/com.pfrazee.beaker-browser",
    "~/Library/Caches/com.pfrazee.beaker-browser.ShipIt",
    "~/Library/Preferences/com.pfrazee.beaker-browser.plist",
    "~/Library/Saved Application State/com.pfrazee.beaker-browser.savedState",
  ]
end