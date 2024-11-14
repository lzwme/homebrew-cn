cask "opensc" do
  version "0.26.0"
  sha256 "8f474d55c8b172167014a246035f38ce427207bf90de06ae6cc837ac37cc269c"

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