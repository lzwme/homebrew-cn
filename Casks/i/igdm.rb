cask "igdm" do
  version "3.0.4"
  sha256 "fe032a9657267018efc16697d218dbdcda02564f5d42e4b2e21bf68ea9e715c7"

  url "https://ghfast.top/https://github.com/ifedapoolarewaju/igdm/releases/download/v#{version}/IGdm-#{version}.dmg",
      verified: "github.com/ifedapoolarewaju/igdm/"
  name "IG:dm"
  desc "Desktop application for Instagram DMs"
  homepage "https://igdm.me/"

  no_autobump! because: :requires_manual_review

  app "IGdm.app"

  uninstall quit: "com.ifedapoolarewaju.desktop.igdm"

  zap trash: [
    "~/Library/Application Support/IGdm",
    "~/Library/Logs/IGdm",
    "~/Library/Preferences/com.ifedapoolarewaju.desktop.igdm.helper.plist",
    "~/Library/Preferences/com.ifedapoolarewaju.desktop.igdm.plist",
    "~/Library/Saved Application State/com.ifedapoolarewaju.desktop.igdm.savedState",
  ]

  caveats do
    requires_rosetta
  end
end