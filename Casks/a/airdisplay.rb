cask "airdisplay" do
  version "3.4.2"
  sha256 "272d14f33b3a4a16e5e0e1ebb2d519db4e0e3da17f95f77c91455b354bee7ee7"

  url "https://avatron.com/updates/software/airdisplay/ad#{version.no_dots}.zip"
  name "Air Display"
  desc "Utility for using a tablet as a second monitor"
  homepage "https://avatron.com/applications/air-display/"

  no_autobump! because: :requires_manual_review

  disable! date: "2024-09-30", because: :no_longer_available

  depends_on macos: ">= :mojave"

  pkg "Air Display Installer.pkg"

  uninstall pkgutil: [
    "com.avatron.pkg.AirDisplay",
    "com.avatron.pkg.AirDisplayHost2",
  ]
end