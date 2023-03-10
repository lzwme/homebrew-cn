cask "waltr" do
  version "2.6.27"
  sha256 "5b1ca23244d060c6ca941f96ca78e91fbff5cde34cdf5d9879468fee6e2929f3"

  url "https://shining.softorino.com/shine_uploads/waltr#{version.major}mac_#{version}.dmg"
  name "WALTR"
  desc "Media direct transfer tool for Apple devices"
  homepage "https://softorino.com/w#{version.major}/"

  livecheck do
    url "https://api.softorino.com/v1/app-manager/waltr#{version.major}/mac/updates"
    strategy :sparkle
  end

  app "Waltr #{version.major}.app"

  zap trash: [
    "/Users/Shared/Waltr",
    "/Users/Shared/Waltr #{version.major}",
    "~/Library/Application Support/Waltr",
    "~/Library/Application Support/Waltr #{version.major}",
    "~/Library/Preferences/com.softorino.waltr2.plist",
  ]
end