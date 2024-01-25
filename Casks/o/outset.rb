cask "outset" do
  version "4.1.1.21918"
  sha256 "5c38db5fcba9cc91e4dd815395796de083a3d8ff713886544d792858c259884c"

  url "https:github.commacadminsoutsetreleasesdownloadv#{version}Outset-#{version}.pkg"
  name "outset"
  desc "Process packages and scripts during boot, login, or on demand"
  homepage "https:github.commacadminsoutset"

  livecheck do
    url :url
    strategy :github_latest
  end

  pkg "outset-#{version}.pkg"

  uninstall launchctl: [
              "io.macadmins.Outset.boot",
              "io.macadmins.Outset.cleanup",
              "io.macadmins.Outset.login",
              "io.macadmins.Outset.login-privileged",
              "io.macadmins.Outset.login-window",
              "io.macadmins.Outset.on-demand",
            ],
            pkgutil:   "io.macadmins.Outset",
            delete:    "usrlocaloutset"

  zap trash: [
    "LibraryLaunchAgentsio.macadmins.outset.login-window.plist",
    "LibraryLaunchAgentsio.macadmins.outset.login.plist",
    "LibraryLaunchAgentsio.macadmins.outset.on-demand.plist",
    "LibraryLaunchDaemonsio.macadmins.outset.boot.plist",
    "LibraryLaunchDaemonsio.macadmins.outset.cleanup.plist",
    "LibraryLaunchDaemonsio.macadmins.outset.login-privileged.plist",
    "LibraryPreferencesio.macadmins.Outset.plist",
  ]

  caveats do
    files_in_usr_local
  end
end