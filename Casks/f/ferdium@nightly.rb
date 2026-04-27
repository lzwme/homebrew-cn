cask "ferdium@nightly" do
  arch arm: "arm64", intel: "x64"

  version "7.1.3-nightly.2"
  sha256 arm:   "39034c2e030a54148329792f34f114754e893efb1393ecbb61d68cf36262f9cd",
         intel: "9fe112a017c500a27898300ce6698751067dbbdaed386328d5b23699c8fb2391"

  url "https://ghfast.top/https://github.com/ferdium/ferdium-app/releases/download/v#{version}/Ferdium-mac-#{version}-#{arch}.dmg",
      verified: "github.com/ferdium/ferdium-app/"
  name "Ferdium Nightly"
  desc "Multi-platform multi-messaging app"
  homepage "https://ferdium.org/"

  livecheck do
    url :url
    regex(/v?(\d+(?:\.\d+)+-nightly\.\d+)/i)
  end

  auto_updates true
  conflicts_with cask: "ferdium"
  depends_on macos: ">= :big_sur"

  app "Ferdium.app"

  uninstall quit:   "com.ferdium.ferdium-app",
            delete: "/Library/Logs/DiagnosticReports/Ferdium Helper_.*wakeups_resource.diag"

  zap trash: [
    "~/Library/Application Support/Caches/ferdium-updater",
    "~/Library/Application Support/Ferdium",
    "~/Library/Caches/com.ferdium.ferdium-app",
    "~/Library/Caches/com.ferdium.ferdium-app.ShipIt",
    "~/Library/Logs/Ferdium",
    "~/Library/Preferences/ByHost/com.ferdium.ferdium-app.ShipIt.*.plist",
    "~/Library/Preferences/com.electron.ferdium.helper.plist",
    "~/Library/Preferences/com.electron.ferdium.plist",
    "~/Library/Preferences/com.ferdium.ferdium-app.plist",
    "~/Library/Saved Application State/com.ferdium.ferdium-app.savedState",
  ]
end