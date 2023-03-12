cask "airdisplay-client" do
  version "3.2"
  sha256 "a18e1580508c8d7830b22132de01c4ed87ef9cbfcf862690e0ef44c1ad764292"

  url "https://www.avatron.com/updates/software/airdisplay_macclient/admac-web-#{version.no_dots}.zip"
  name "Air Display Client"
  desc "Turn a computer into an extra display for another one"
  homepage "https://avatron.com/applications/air-display/"

  livecheck do
    url "https://avatron.com/updates/software/admacclient-appcast.xml"
    strategy :sparkle, &:short_version
  end

  app "Air Display.app"

  zap trash: [
    "~/Library/Application Support/com.avatron.airdisplaymac.webstore",
    "~/Library/Caches/com.avatron.airdisplaymac.webstore",
    "~/Library/Preferences/com.avatron.airdisplaymac.webstore.plist",
    "~/Library/Saved Application State/com.avatron.airdisplaymac.webstore.savedState",
  ]
end