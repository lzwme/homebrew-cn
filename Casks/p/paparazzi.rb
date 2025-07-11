cask "paparazzi" do
  version "1.0b11"
  sha256 "106c31b4297f3a9671648db75adfbb79c929de3af306b537aa141b7bac668a7c"

  url "https://derailer.org/paparazzi/Paparazzi!%20#{version}.dmg"
  name "Paparazzi!"
  desc "Utility to take screenshots of webpages"
  homepage "https://derailer.org/paparazzi/"

  livecheck do
    url "https://derailer.org/paparazzi/appcast/"
    strategy :sparkle, &:short_version
  end

  no_autobump! because: :requires_manual_review

  app "Paparazzi!.app"

  zap trash: [
    "~/Library/Application Support/Paparazzi!",
    "~/Library/Caches/org.derailer.Paparazzi",
    "~/Library/Cookies/org.derailer.Paparazzi.binarycookies",
    "~/Library/Preferences/org.derailer.Paparazzi.plist",
    "~/Library/Saved Application State/org.derailer.Paparazzi.savedState",
  ]

  caveats do
    requires_rosetta
  end
end