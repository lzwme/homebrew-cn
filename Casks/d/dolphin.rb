cask "dolphin" do
  version "2503a"
  sha256 "0bd523eaaea17015f95f4c1e3fb180870e9eca38b87821241058dff62bc0d4d3"

  url "https://dl.dolphin-emu.org/releases/#{version}/dolphin-#{version}-universal.dmg"
  name "Dolphin"
  desc "Emulator to play GameCube and Wii games"
  homepage "https://dolphin-emu.org/"

  livecheck do
    url "https://dolphin-emu.org/download/"
    regex(/href=.*?dolphin[._-]v?(\d+(?:\.\d+)*[a-z]?)(?:[._-]universal)?\.dmg/i)
  end

  conflicts_with cask: [
    "dolphin@beta",
    "dolphin@dev",
  ]
  depends_on macos: ">= :catalina"

  app "Dolphin.app"

  zap trash: [
    "~/Library/Application Support/Dolphin",
    "~/Library/Preferences/org.dolphin-emu.dolphin.plist",
  ]
end