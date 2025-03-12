cask "prusaslicer" do
  version "2.9.1"
  sha256 "0b1c73caa9dfb2283559db33ae9bdd01edc77723be50de7aa73ec35352629012"

  url "https://cdn.prusa3d.com/downloads/drivers/prusa3d_mac_#{version.dots_to_underscores}.dmg"
  name "PrusaSlicer"
  desc "G-code generator for 3D printers (RepRap, Makerbot, Ultimaker etc.)"
  homepage "https://www.prusa3d.com/slic3r-prusa-edition/"

  livecheck do
    url "https://cache.prusa3d.com/help/api/v1/prusa3d_downloads"
    strategy :json do |json|
      json["data"]&.map do |item|
        next if item.dig("meta", "type", "value") != "driver"

        item["title"]
      end
    end
  end

  depends_on macos: ">= :sierra"

  app "Original Prusa Drivers/PrusaSlicer.app"

  zap trash: [
    "~/Library/Application Support/PrusaSlicer",
    "~/Library/Preferences/com.prusa3d.slic3r",
    "~/Library/Saved Application State/com.prusa3d.slic3r.savedState",
  ]
end