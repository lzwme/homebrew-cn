cask "airserver" do
  version "7.3"
  sha256 "b272ccf9051ab0df2a524bb5796378755283ad451f1a1c3b1c3fa1488eaf730e"

  url "https://dl.airserver.com/mac/AirServer-#{version}.dmg"
  name "AirServer"
  desc "Screen mirroring receiver"
  homepage "https://www.airserver.com/"

  livecheck do
    url "https://www.airserver.com/downloads/mac/appcast.xml"
    strategy :sparkle
  end

  auto_updates true
  depends_on :macos

  app "AirServer.app"

  zap trash: [
    "~/Library/Caches/com.pratikkumar.airserver-mac",
    "~/Library/Preferences/com.pratikkumar.airserver-mac.AirServer.plist",
    "~/Library/Preferences/com.pratikkumar.airserver-mac.plist",
  ]
end