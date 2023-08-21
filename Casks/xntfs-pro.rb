cask "xntfs-pro" do
  version "1.2.3"
  sha256 "d3c56f5f2f13f149ddf02f160840e10bb9f405a5838059f9a75134861a19139f"

  url "https://api.7littlemen.com/download/ntfsretail/NTFS%20Pro%20by%20Omi%20Installer.signed.#{version}.pkg",
      verified: "api.7littlemen.com/download/ntfsretail/"
  name "NTFS Pro by Omi"
  name "xNTFS Pro"
  desc "Mount, write and repair NTFS disks"
  homepage "https://okaapps.com/product/1580856488"

  livecheck do
    strategy :sparkle, &:short_version
    url "https://api.7littlemen.com/download/ntfsretail/appcast.xml"
  end

  depends_on macos: ">= :high_sierra"

  pkg "NTFS Pro by Omi Installer.signed.#{version.csv.first}.pkg"

  uninstall     quit:    "com.omni.mac.utility.website.ntfs",
                kext:    "com.omni.ntfs-support.kext",
                pkgutil: "com.omnisoftware.retail.xNTFS"
end