cask "djv" do
  version "3.0.0"
  sha256 "c5adbcb42f1c6b36e0031b6de9b7e1b3ffafbcb6b11abf5b4222a2b9320af3c9"

  url "https://ghfast.top/https://github.com/darbyjohnston/DJV/releases/download/#{version}/DJV-#{version}-Darwin-arm64.dmg",
      verified: "github.com/darbyjohnston/DJV/"
  name "DJV"
  desc "Review software for VFX, animation, and film production"
  homepage "https://darbyjohnston.github.io/DJV/"

  livecheck do
    url :url
    strategy :github_latest
  end

  depends_on arch: :arm64

  app "DJV.app"

  zap trash: [
        "~/Documents/DJV/djv.log",
        "~/Library/Preferences/com.djv-sourceforge-net-*.plist",
      ],
      rmdir: "~/Documents/DJV"
end