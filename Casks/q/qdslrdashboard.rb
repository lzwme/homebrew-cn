cask "qdslrdashboard" do
  version "3.6.12"
  sha256 "dc009a297d640f548d73beac6f40c6a1b2d5d043750748e2faca74c1f716c236"

  url "https://files.lrtimelapse.com/dslrdashboard/V#{version}/qDslrDashboard_V#{version}_macOS_x64.dmg",
      verified: "files.lrtimelapse.com/dslrdashboard/"
  name "qDslrDashboard"
  desc "Application for controlling Nikon, Canon and Sony cameras"
  homepage "https://dslrdashboard.info/"

  livecheck do
    url "https://dslrdashboard.info/downloads/"
    regex(/href=.*?qdslrdashboard[._-]v?(\d+(?:[.-]\d+)+)[._-]macos/i)
    strategy :page_match do |page, regex|
      match = page.match(regex)
      next if match.blank?

      match[1].tr("-", ".")
    end
  end

  no_autobump! because: :requires_manual_review

  depends_on macos: ">= :mojave"

  app "qDslrDashboard.app"

  zap trash: [
    "~/Library/Application Support/DslrDashboard/qDslrDashboard",
    "~/Library/Saved Application State/info.dslrdashboard.qDslrDashboard.savedState",
  ]

  caveats do
    requires_rosetta
  end
end