cask "steermouse" do
  version "5.7.4"
  sha256 "42d0375de8679d02a69b9cdc0788bea1fd9c469f6c55d6cd33b92f78623f7989"

  url "https://plentycom.jp/ctrl/files_sm/SteerMouse#{version}.dmg"
  name "SteerMouse"
  desc "Customise mouse buttons, wheels and cursor speed"
  homepage "https://plentycom.jp/en/steermouse/"

  livecheck do
    url "https://plentycom.jp/en/steermouse/download.php"
    regex(/href=.*?SteerMouse[._-]?v?(\d+(?:\.\d+)+)\.dmg/i)
  end

  depends_on macos: ">= :mojave"

  app "SteerMouse.app"

  zap trash: [
    "~/Library/Application Support/com.apple.sharedfilelist/com.apple.LSSharedFileList.ApplicationRecentDocuments/jp.plentycom.boa.steermouse.sfl*",
    "~/Library/Application Support/SteerMouse & CursorSense",
    "~/Library/Caches/jp.plentycom.app.SteerMouse",
    "~/Library/HTTPStorages/jp.plentycom.app.SteerMouse",
    "~/Library/LaunchAgents/jp.plentycom.boa.SteerMouse.plist",
    "~/Library/Preferences/jp.plentycom.app.SteerMouse.plist",
  ]
end