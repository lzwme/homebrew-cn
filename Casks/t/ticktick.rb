cask "ticktick" do
  version "6.1.50,401"
  sha256 "9c91b9970310c4adbad9a4d1c5b9091b45f864ce915bfbf45089fb346c1f8e6a"

  url "https://ticktick-download-mac.s3.amazonaws.com/download/mac/TickTick_#{version.csv.first}_#{version.csv.second}.dmg",
      verified: "ticktick-download-mac.s3.amazonaws.com/download/mac/"
  name "TickTick"
  desc "To-do & task list manager"
  homepage "https://www.ticktick.com/home"

  livecheck do
    url "https://pull.ticktick.com/mac/release_note/mac_appcast.xml"
    strategy :sparkle
  end

  auto_updates true
  depends_on macos: ">= :mojave"

  app "TickTick.app"

  zap trash: [
    "~/Library/Application Scripts/com.TickTick.task.mac.*",
    "~/Library/Application Support/com.TickTick.task.mac",
    "~/Library/Caches/com.TickTick.task.mac",
    "~/Library/Caches/TickTick",
    "~/Library/Containers/com.TickTick.task.mac.*",
    "~/Library/Group Containers/75TY9UT8AY.com.TickTick.task.mac",
    "~/Library/Preferences/com.TickTick.task.mac.plist",
    "~/Library/Saved Application State/com.TickTick.task.mac.savedState",
  ]
end