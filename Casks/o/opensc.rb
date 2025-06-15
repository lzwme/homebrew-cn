cask "opensc" do
  version "0.26.1"
  sha256 "7b66e256cefc7fdf6d9267383ac9e4763e299339aa52c99973f414b8a6a2ee05"

  url "https:github.comOpenSCOpenSCreleasesdownload#{version}OpenSC-#{version}.dmg"
  name "OpenSC"
  desc "Smart card libraries and utilities"
  homepage "https:github.comOpenSCOpenSCwiki"

  no_autobump! because: :requires_manual_review

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