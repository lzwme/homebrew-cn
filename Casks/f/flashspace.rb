cask "flashspace" do
  version "4.15.68"
  sha256 "20c68f1cb3ee25c1306ce5ae8594db0c5a5a21d8d9011dafe031632ec3575ba4"

  url "https://ghfast.top/https://github.com/wojciech-kulik/FlashSpace/releases/download/v#{version}/FlashSpace.app.zip"
  name "FlashSpace"
  desc "Virtual workspace manager"
  homepage "https://github.com/wojciech-kulik/FlashSpace"

  auto_updates true
  depends_on macos: ">= :sonoma"

  app "FlashSpace.app"
  binary "#{appdir}/FlashSpace.app/Contents/Resources/flashspace"

  uninstall quit: "pl.wojciechkulik.FlashSpace"

  zap trash: [
    "~/Library/Application Scripts/pl.wojciechkulik.FlashSpace",
    "~/Library/Autosave Information/pl.wojciechkulik.FlashSpace.plist",
    "~/Library/Caches/pl.wojciechkulik.FlashSpace",
    "~/Library/HTTPStorages/pl.wojciechkulik.FlashSpace",
    "~/Library/Preferences/FlashSpace.plist",
    "~/Library/Preferences/pl.wojciechkulik.FlashSpace.plist",
    "~/Library/Saved Application State/pl.wojciechkulik.FlashSpace.savedState",
  ]
end