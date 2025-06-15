cask "xstation5" do
  # NOTE: "5" is not a version number, but an intrinsic part of the product name
  version "2.50.0-Build.5"
  sha256 "4794697ccd6286c363b3600ba7a066e217405822e48cd8873bb91b10ffdd0e3e"

  url "https://desktopxstation5.xtb.com/prod/update/mac/xStation5-#{version}-mac.zip"
  name "xStation5"
  desc "Desktop trading platform"
  homepage "https://www.xtb.com/"

  no_autobump! because: :requires_manual_review

  disable! date: "2025-03-17", because: :no_longer_available

  depends_on macos: ">= :high_sierra"

  app "xStation5.app"

  zap trash: [
    "~/Library/Application Support/xStation5",
    "~/Library/Caches/xstation5-updater",
    "~/Library/Logs/xStation5",
    "~/Library/Preferences/xStation5.desktop.x64.plist",
    "~/Library/Saved Application State/xStation5.desktop.x64.savedState",
  ]

  caveats do
    requires_rosetta
  end
end