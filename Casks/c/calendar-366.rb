cask "calendar-366" do
  version "2.15.3"
  sha256 "7bfb27bb79611ae6a9071ba57acf131e81d6b7a19a92dbbf7d3d3408c5ae7b2c"

  url "https://nspektor.com/downloads/Calendar366_v#{version}.dmg"
  name "Calendar 366 II"
  desc "Menu bar calendar for events and reminders"
  homepage "https://nspektor.com/calendar366/mac"

  livecheck do
    url "https://nspektor.com/downloads/Calendar366IIAsset.xml"
    strategy :sparkle, &:short_version
  end

  depends_on macos: ">= :mojave"

  app "Calendar 366 II.app"

  zap trash: [
    "~/Library/Application Scripts/com.nspektor.macos.Calendar-366-II-Mini",
    "~/Library/Application Support/Calendar 366 II",
    "~/Library/Caches/com.nspektor.macos.Calendar-366-II",
    "~/Library/Preferences/com.nspektor.macos.Calendar-366-II.plist",
  ]
end