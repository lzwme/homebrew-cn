cask "vipriser" do
  version "3.8"
  sha256 :no_check

  url "https://onflapp.github.io/blog/releases/vipriser/VipRiser.zip"
  name "VipRiser"
  desc "Produce a PDF from any application that can print"
  homepage "https://onflapp.github.io/blog/pages/VipRiser"

  livecheck do
    url "https://onflapp.github.io/blog/releases/vipriser/appcast.xml"
    strategy :sparkle
  end

  app "VipRiser.app"

  uninstall launchctl: "com.onflapp.VipRiserAgent"

  zap trash: [
    "/var/db/recipts/com.onflapp.vipriser.driver.bom",
    "/var/db/recipts/com.onflapp.vipriser.driver.plist",
    "~/Library/Application Support/com.onflapp.VipRiser",
    "~/Library/Application Support/VipRiser",
    "~/Library/Caches/com.onflapp.VipRiser",
    "~/Library/Caches/metadata/VipRiser",
    "~/Library/Preferences/com.apple.print.custompresets.forprinter.Print_to_VipRiser.plist",
    "~/Library/Preferences/com.apple.print.custompresets.forprinter.VipRiser.plist",
    "~/Library/Preferences/com.onflapp.VipRiser.plist",
  ]
end