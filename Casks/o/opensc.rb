cask "opensc" do
  version "0.25.1"
  sha256 "9679d70db011a68e99360fcd4c5538b0481bd036fb058fc309b999837e63e063"

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