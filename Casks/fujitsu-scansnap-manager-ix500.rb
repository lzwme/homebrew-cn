cask "fujitsu-scansnap-manager-ix500" do
  version :latest
  sha256 :no_check

  url "https://www.fujitsu.com/downloads/IMAGE/driver/ss/mgr/m-ix500/MaciX500ManagerV63L50WW1.dmg"
  name "ScanSnap Manager for Fujitsu ScanSnap iX500"
  homepage "https://www.fujitsu.com/global/support/products/computing/peripheral/scanners/scansnap/software/ix500.html"

  pkg "ScanSnap Manager.pkg"

  uninstall pkgutil: "jp.co.pfu.ScanSnap.*"
end