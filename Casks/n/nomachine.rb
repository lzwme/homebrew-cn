cask "nomachine" do
  version "8.16.1_2"
  sha256 "622e12ab5397b74bfcae3c4de5a91c018ed222244d4e09804af0fc03e9e8e04e"

  url "https://download.nomachine.com/download/#{version.major_minor}/MacOSX/nomachine_#{version}.dmg"
  name "NoMachine"
  desc "Remote desktop software"
  homepage "https://www.nomachine.com/"

  livecheck do
    url "https://www.nomachine.com/support&destination=downloads&callback=L2Rvd25sb2FkLz9pZD03"
    regex(/nomachine[._-]v?(\d+(?:\.\d+)+_\d+)\.dmg/i)
  end

  no_autobump! because: :requires_manual_review

  auto_updates true

  pkg "NoMachine.pkg"

  # A launchctl job ordinarily manages uninstall once the app bundle is removed
  # To ensure it ran, verify if /Library/Application Support/NoMachine/nxuninstall.sh no longer exists
  uninstall launchctl: [
              "com.nomachine.localnxserver",
              "com.nomachine.nxlaunchconf",
              "com.nomachine.nxnode",
              "com.nomachine.nxplayer",
              "com.nomachine.nxrunner",
              "com.nomachine.nxserver",
              "com.nomachine.server",
              "com.nomachine.uninstall",
              "com.nomachine.uninstallAgent",
            ],
            pkgutil:   [
              "com.nomachine.nomachine.NoMachine-*.pkg",
              "com.nomachine.nxnode",
              "com.nomachine.nxplayer",
              "com.nomachine.nxrunner",
              "com.nomachine.nxserver",
            ],
            delete:    "/Applications/NoMachine.app"

  zap trash: [
    "/Library/Application Support/NoMachine",
    "~/Documents/NoMachine",
    "~/Library/Preferences/com.nomachine.nxdock.plist",
  ]
end