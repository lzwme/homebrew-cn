cask "eset-cyber-security" do
  version "8.2.800.0"
  sha256 :no_check

  url "https://download.eset.com/com/eset/apps/home/eav/mac/latest/eset_cybersecurity.dmg"
  name "ESET Cyber Security"
  desc "Security including web and email protection"
  homepage "https://www.eset.com/"

  livecheck do
    url "https://help.eset.com/latestVersions/"
    regex(%r{ESET\sCyber\sSecurity</p>\n.*/span>\sv?(\d+(?:\.\d+)+)}i)
  end

  depends_on macos: ">= :big_sur"

  pkg "Resources/Installer.pkg"

  uninstall script:  {
              executable: "/Applications/ESET Cyber Security.app/Contents/Helpers/Uninstaller.app/Contents/Scripts/uninstall.sh",
              sudo:       true,
            },
            pkgutil: "com.eset.protection"

  zap trash: "~/Library/Preferences/com.eset.ecs.*.plist"
end