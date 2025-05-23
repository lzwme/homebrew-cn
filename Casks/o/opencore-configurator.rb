cask "opencore-configurator" do
  version "2.78.0.2"
  sha256 :no_check

  url "https://mackie100projects.altervista.org/apps/opencoreconf/download-new-build.php?version=last",
      referer: "https://mackie100projects.altervista.org/"
  name "OpenCore Configurator"
  desc "OpenCore EFI bootloader configuration helper"
  homepage "https://mackie100projects.altervista.org/opencore-configurator/"

  livecheck do
    url "https://mackie100projects.altervista.org/apps/opencoreconf/OCC/update-data-builds.xml"
    strategy :sparkle
  end

  auto_updates true

  app "OpenCore Configurator.app"

  zap trash: [
    "~/Library/Application Support/com.apple.sharedfilelist/com.apple.LSSharedFileList.ApplicationRecentDocuments/org.altervista.mackie100projects.opencore-configurator.sfl*",
    "~/Library/Application Support/org.altervista.mackie100projects.OpenCore-Configurator",
    "~/Library/Caches/org.altervista.mackie100projects.OpenCore-Configurator",
    "~/Library/HTTPStorages/org.altervista.mackie100projects.OpenCore-Configurator",
    "~/Library/Preferences/org.altervista.mackie100projects.OpenCore-Configurator.plist",
  ]

  caveats do
    requires_rosetta
  end
end