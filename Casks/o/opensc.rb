cask "opensc" do
  version "0.25.0"
  sha256 "5417186cf88a50931b6186f2c3ade95525b683e55b418eae9d56d728c76d2e51"

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