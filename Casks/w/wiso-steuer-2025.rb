cask "wiso-steuer-2025" do
  # NOTE: "2025" is not a version number, but an intrinsic part of the product name
  version "32.03.2120-RC1"
  sha256 "e6433f21ce6bb60d6bc8cdf87847f1e9d34e624d0982d755b6db9f0245a63947"

  url "https://update.buhl-data.com/Updates/Steuer/2025/Mac/Files/#{version}/SteuerMac2025-#{version.split("-").first}.dmg",
      verified: "update.buhl-data.com/Updates/Steuer/"
  name "WISO Steuer 2025"
  desc "Tax declaration for the fiscal year 2024"
  homepage "https://www.buhl.de/download/wiso-steuer-2025/"

  livecheck do
    url "https://update.buhl-data.com/Updates/Steuer/2025/Mac/Aktuell/appcast-steuer.xml"
    regex(%r{/v?(\d+(?:\.\d+)+[^/]*)/SteuerMac2025[._-]v?(\d+(?:\.\d+)+)\.dmg}i)
    strategy :sparkle do |item, regex|
      match = item.url&.match(regex)
      next if match.blank?

      match[1]
    end
  end

  auto_updates true
  depends_on macos: ">= :catalina"

  # Renamed for consistency: app name differs in Finder to shell
  app "SteuerMac 2025.app", target: "WISO Steuer 2025.app"

  zap trash: [
    "~/Library/Application Support/BuhlData.com/WISOsteuerMac2025",
    "~/Library/Caches/com.BuhlData.WISOsteuerMac2025",
    "~/Library/HTTPStorages/com.BuhlData.WISOsteuerMac2025",
    "~/Library/Preferences/com.buhldata.WISOsteuerMac2025.plist",
    "~/Library/Saved Application State/com.BuhlData.WISOsteuerMac2025.savedState",
    "~/Library/WebKit/com.BuhlData.WISOsteuerMac2025",
  ]
end