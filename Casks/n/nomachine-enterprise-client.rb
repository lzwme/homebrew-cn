cask "nomachine-enterprise-client" do
  version "8.15.3_3"
  sha256 "35013a97989e2e9e7d7aef43863c9cfe8e6c49239cc1ea49b5d66162183e0312"

  url "https://download.nomachine.com/download/#{version.major_minor}/MacOSX/nomachine-enterprise-client_#{version}.dmg"
  name "NoMachine Enterprise Client"
  desc "Remote desktop software"
  homepage "https://www.nomachine.com/"

  livecheck do
    url "https://www.nomachine.com/support&destination=downloads&callback=L2Rvd25sb2FkLz9pZD0xNi"
    regex(/nomachine-enterprise-client[._-]v?(\d+(?:\.\d+)*_\d+)\.dmg/i)
  end

  pkg "NoMachine.pkg"

  # A launchctl job ordinarily manages uninstall once the app bundle is removed
  # To ensure it ran, verify if /Library/Application Support/NoMachine/nxuninstall.sh no longer exists
  uninstall launchctl: [
              "com.nomachine.launchconf",
              "com.nomachine.uninstall",
              "com.nomachine.uninstallAgent",
            ],
            pkgutil:   [
              "com.nomachine.*",
              "com.nomachine.nomachine.NoMachine*.pkg",
            ],
            delete:    "/Applications/NoMachine.app"

  zap trash: [
        "/Library/Application Support/NoMachine",
        "~/.nx",
        "~/Library/Preferences/com.nomachine.nxdock.plist",
      ],
      rmdir: "~/Documents/NoMachine"
end