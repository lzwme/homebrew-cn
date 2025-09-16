cask "customshortcuts" do
  version "1.3"
  sha256 "8bb0dade6f8f0ee8fbb0f3e84c5e8f6fb927a277af5c11f5df4c8be16989e1fa"

  url "https://dl.houdah.com/customShortcuts/updates/cast_assets/CustomShortcuts#{version}.zip"
  name "CustomShortcuts"
  desc "Customise menu item keyboard shortcuts"
  homepage "https://www.houdah.com/customShortcuts/"

  livecheck do
    url "https://www.houdah.com/customShortcuts/updates/cast.xml"
    strategy :sparkle, &:short_version
  end

  auto_updates true

  app "CustomShortcuts.app"

  zap trash: [
    "~/Library/Application Support/com.houdah.CustomShortcuts",
    "~/Library/Caches/com.houdah.CustomShortcuts",
    "~/Library/Preferences/com.houdah.CustomShortcuts.plist",
  ]
end