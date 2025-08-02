cask "rave" do
  version "1.17.3"
  sha256 "534d28910e86251ecde4e838dc7117b23562725e3212f3bf7097af920f0af4a4"

  url "https://static.rave-web.com/rave-desktop/mac/x64/Rave-#{version}.dmg",
      verified: "static.rave-web.com/rave-desktop/mac/"
  name "Rave"
  desc "Social streaming app"
  homepage "https://rave.io/"

  livecheck do
    url "https://static.rave-web.com/rave-desktop/mac/x64/latest-mac.yml"
    strategy :electron_builder
  end

  auto_updates true
  depends_on macos: ">= :big_sur"

  app "Rave.app"

  zap trash: [
    "~/Library/Application Support/Rave",
    "~/Library/Caches/io.rave.desktop",
    "~/Library/Caches/io.rave.desktop.ShipIt",
    "~/Library/Caches/rave-desktop-updater",
    "~/Library/HTTPStorages/io.rave.desktop",
    "~/Library/Logs/Rave",
    "~/Library/Preferences/io.rave.desktop.plist",
    "~/Library/Saved Application State/io.rave.desktop.savedState",
  ]

  caveats do
    requires_rosetta
  end
end