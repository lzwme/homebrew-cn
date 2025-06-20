cask "paragon-vmdk-mounter" do
  version "2.4"
  sha256 :no_check

  url "https://dl.paragon-software.com/free/VMDK_MOUNTER_2014.dmg"
  name "Paragon VMDK Mounter"
  desc "Mounts a virtual container by double click"
  homepage "https://www.paragon-software.com/home/vd-mounter-mac-free/"

  no_autobump! because: :requires_manual_review

  disable! date: "2024-12-16", because: :discontinued

  pkg "Paragon VMDK Mounter.pkg"

  uninstall launchctl: "com.paragon-software.vdmounter",
            kext:      "com.paragon-software.kext.VDMounter",
            pkgutil:   "com.paragon-software.VDMounter.pkg"
end