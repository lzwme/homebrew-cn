cask "lulu" do
  version "2.5.1"
  sha256 "e9d55acc568c7037d435225c0c44759a10f605886161a60263a632f12806daf2"

  url "https://ghproxy.com/https://github.com/objective-see/LuLu/releases/download/v#{version}/LuLu_#{version}.dmg",
      verified: "github.com/objective-see/LuLu/"
  name "LuLu"
  desc "Open-source firewall to block unknown outgoing connections"
  homepage "https://objective-see.com/products/lulu.html"

  livecheck do
    url :url
    strategy :github_latest
  end

  depends_on macos: ">= :catalina"

  app "LuLu.app"

  uninstall script: {
    executable: "#{staged_path}/LuLu.app/Contents/Resources/LuLu Uninstaller.app/Contents/MacOS/LuLu Uninstaller",
    args:       ["-uninstall"],
    sudo:       true,
  }

  zap trash: [
    "~/Library/Caches/com.objective-see.lulu",
    "~/Library/Caches/com.objective-see.lulu.helper",
    "~/Library/Preferences/com.objective-see.lulu.helper.plist",
    "~/Library/Preferences/com.objective-see.lulu.plist",
  ]
end