cask "kmeet" do
  version "2.0.1"
  sha256 :no_check

  url "https://download.storage5.infomaniak.com/meet/kMeet.dmg"
  name "kMeet"
  desc "Client for the kMeet videoconferencing solution"
  homepage "https://kmeet.infomaniak.com/"

  livecheck do
    url "https://download.storage5.infomaniak.com/meet/latest-mac.yml"
    strategy :electron_builder
  end

  no_autobump! because: :requires_manual_review

  app "kMeet.app"

  uninstall quit: "com.infomaniak.meet"

  zap trash: [
    "~/Library/Application Support/Caches/kmeet-electron-updater",
    "~/Library/Application Support/kMeet",
    "~/Library/Logs/kMeet",
    "~/Library/Preferences/com.infomaniak.meet.plist",
  ]

  caveats do
    requires_rosetta
  end
end