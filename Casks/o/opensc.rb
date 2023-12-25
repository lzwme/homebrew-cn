cask "opensc" do
  version "0.24.0"
  sha256 "96eb53af88f91d25e6e127081bceb7687a8e53a5790914b5a47c6651783a0b44"

  url "https:github.comOpenSCOpenSCreleasesdownload#{version}OpenSC-#{version}.dmg"
  name "OpenSC"
  desc "Smart card libraries and utilities"
  homepage "https:github.comOpenSCOpenSCwiki"

  pkg "OpenSC #{version}.pkg"

  uninstall launchctl: [
              "org.opensc-project.mac.opensc-notify",
              "org.opensc-project.mac.pkcs11-register",
            ],
            script:    {
              executable: "usrlocalbinopensc-uninstall",
              sudo:       true,
            },
            pkgutil:   [
              "org.opensc-project.mac.opensctoken",
              "org.opensc-project.startup",
            ]

  zap trash: "~LibrarySaved Application Stateorg.opensc-project.mac.opensctoken.OpenSCTokenApp.savedState"
end