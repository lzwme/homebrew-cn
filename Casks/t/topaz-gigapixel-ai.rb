cask "topaz-gigapixel-ai" do
  version "8.3.3"
  sha256 "6eddf117071ea070137e6827c1bcc773f053f13307ea1e78eebbad3d79dcd99b"

  url "https://downloads.topazlabs.com/deploy/TopazGigapixelAI/#{version}/TopazGigapixelAI-#{version}.pkg"
  name "Topaz Gigapixel AI"
  desc "AI image upscaler"
  homepage "https://www.topazlabs.com/gigapixel-ai"

  livecheck do
    url "https://topazlabs.com/d/gigapixel/latest/mac/full"
    strategy :header_match
  end

  auto_updates true

  pkg "TopazGigapixelAI-#{version}.pkg"

  uninstall pkgutil: "com.topazlabs.TopazGigapixelAI"

  zap trash: [
    "~/Library/Preferences/com.topaz-labs-llc.Topaz Gigapixel AI.plist",
    "~/Library/Preferences/com.topazlabs.Topaz Gigapixel AI.plist",
    "~/Library/Preferences/com.topazlabs.TopazGigapixelAI.plist",
    "~/Library/Saved Application State/com.topazlabs.TopazGigapixelAI.savedState",
  ]
end