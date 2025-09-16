cask "timelane" do
  version "2.0"
  sha256 "3334fbb6945d1f0cb8f535c399297356037f4fdd5c570fd7a7325f5b4bd8b57a"

  url "https://ghfast.top/https://github.com/icanzilb/Timelane/releases/download/#{version}/Timelane.app-#{version}.zip"
  name "Timelane"
  desc "Profiler for asynchronous code"
  homepage "https://github.com/icanzilb/Timelane"

  livecheck do
    url "https://ghfast.top/https://raw.githubusercontent.com/icanzilb/Timelane/master/appcast/updates.xml"
    strategy :sparkle
  end

  auto_updates true

  app "Timelane.app"

  zap trash: [
    "~/Library/Application Support/com.apple.sharedfilelist/com.apple.LSSharedFileList.ApplicationRecentDocuments/com.underplot.timelane.sfl*",
    "~/Library/HTTPStorages/com.underplot.timelane",
    "~/Library/Preferences/com.underplot.timelane.plist",
    "~/Library/Saved Application State/com.underplot.timelane.savedState",
  ]

  caveats do
    requires_rosetta
  end
end