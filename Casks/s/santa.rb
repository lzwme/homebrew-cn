cask "santa" do
  version "2025.2"
  sha256 "f66bc5fe463687f281c678a5cb52b5c6e505f2979a5b145f8ad82a6d2b497ef3"

  url "https:github.comnorthpolesecsantareleasesdownload#{version}santa-#{version}.dmg"
  name "Santa"
  desc "Binary authorization system"
  homepage "https:github.comnorthpolesecsanta"

  pkg "santa-#{version}.pkg"

  uninstall launchctl: [
              "com.northpolesec.santa",
              "com.northpolesec.santa.bundleservice",
              "com.northpolesec.santa.metricservice",
              "com.northpolesec.santa.syncservice",
              "com.northpolesec.santad",
            ],
            kext:      "com.northpolesec.santa-driver",
            pkgutil:   "com.northpolesec.santa",
            delete:    [
              "ApplicationsSanta.app",
              "usrlocalbinsantactl",
            ]

  # No zap stanza required
end